# sl-task-emitter
v0.0.1

## Install

    slnode install sl-task-emitter

## Purpose

Perform an unkown number of tasks recursively and in parallel. For example, reading all the files in a nested set of directories. Built in support for [domains](http://nodejs.org/api/domain.html) by inheriting directly from `EventEmitter`.
    
## Example

The following example shows the basic API for a TaskEmitter.

    var TaskEmitter = require('../');
    var request = require('request');
    var results = [];

    var te = new TaskEmitter();

    te
      .task('request', request, 'http://google.com')
      .task('request', request, 'http://yahoo.com')
      .task('request', request, 'http://apple.com')
      .task('request', request, 'http://youtube.com')
      .on('request', function (url, res, body) {
        results.push(Buffer.byteLength(body));
      })
      .on('progress', function (status) {
        console.log(((status.total - status.remaining) / status.total) * 100 + '%', 'complete');
      })
      .on('error', function (err) {
        console.log('error', err);
      })
      .on('done', function () {
        console.log('Total size of all homepages', results.reduce(function (a, b) {
          return a + b;
        }), 'bytes');
      });

The next example highlights how TaskEmitter can be used to simplify recursive asynchronous operations. The following code recursively walks a social network over HTTP. All requests run in parallel.

    var TaskEmitter = require('../');
    var request = require('request');
    var socialNetwork = [];

    var te = new TaskEmitter();

    te
      .task('friends', fetch, 'me')
      .on('friends', function (user, url) {
        if(url !== 'me') {
          socialNetwork.push(user);
        }
    
        user.friendIds.forEach(function (id) {
          this.task('friends', fetch, 'users/' + id)
        }.bind(this));
      })
      .on('done', function () {
        console.log('There are a total of %n people in my network', socialNetwork.length);
      });


    function fetch(url, fn) {
      request({
        url: 'http://my-api.com/' + url,
        json: true,
        method: 'GET'
      }, fn);
    }

## Extending TaskEmitter

`TaskEmitter` is designed to be a base class which can be inherited from and extended by many levels of sub classes. The following example shows a class that inherits from TaskEmitter and provides recursive directory walking and file loading.

    var TaskEmitter = require('../');
    var fs = require('fs');
    var path = require('path');
    var inherits = require('util').inherits;

    function Loader() {
      TaskEmitter.call(this);
  
      this.path = path;
      this.files = {};

      this.on('readdir', function (p, files) {
        files.forEach(function (f) {
          this.task(fs, 'stat', path);
        }.bind(this));
      });

      this.on('stat', function (file, stat) {
        if(stat.isDirectory()) {
          this.task(fs, 'readdir', file);
        } else {
          this.task(fs, 'readFile', file, path.extname(file) === '.txt' ? 'utf-8' : null);
        }
      });

      this.on('readFile', function (path, encoding, data) {
        this.files[path] = data;
      });
    }

    inherits(Loader, TaskEmitter);

    Loader.prototype.load = function (path, fn) {
      if(fn) {
        // error events are handled if a task callback ever is called
        // with a first argument that is not falsy
        this.on('error', fn);
    
        // once all tasks are complete the done event is emitted
        this.on('done', function () {
          fn(null, this.files);
        });
      }
  
      this.task(fs, 'readdir', path);
    }

    // usage
    var l = new Loader();
    
    l.load('sample-files', function (err, files) {
      console.log(err || files);
    });

## API

### taskEmitter.task()

Execute a task and emit an event when it is complete.

You must provide

  - A `scope` (eg. the fs module) and a name of a function on the scope (eg. `'readFile'`).

**Example**

    var fs = require('fs');
    var te = new TaskEmitter();

    te
      .task(fs, 'readFile')
      .on('readFile', ...);
  
or

  - Your task name (eg. 'my-task') and a function that executes the task and takes a conventional node callback (`fn(err, result)`).
  
**Example**

    var te = new TaskEmitter();

    te
      .task('my-task', myTask)
      .on('my-task', ...);
      
    function myTask(fn) {
      // an async task of some sort
      setTimeout(function() {
        // callback
        fn(null, 'my result');
      }, 1000);
    }
    
**Example**

It is safe to execute tasks in the event listener of another task as long as it is in the same tick.

    var te = new TaskEmitter();

    te
      .task(fs, 'stat', '/path/to/file-1')
      .task(fs, 'stat', '/path/to/file-2')
      .task(fs, 'stat', '/path/to/file-3')
      .on('stat', function(err, path, stat) {
        if(stat.isDirectory()) {
          // must add tasks before
          // this function returns
          this.task(fs, 'readdir', path);
        }
      })
      .on('readdir', function(path, files) {
        console.log(files); // path contents
      })
      .on('done', function() {
        console.log('finished!');
      });
    
### taskEmitter.remaining()

Determine how many tasks remain.

**Example**

    var te = new TaskEmitter();

    te
      .task(fs, 'stat', '/path/to/file-1')
      .task(fs, 'stat', '/path/to/file-2')
      .task(fs, 'stat', '/path/to/file-3')
      .on('stat', function(err, path, stat) {
        console.log('%s is a %s', stat.isDirectory() ? 'directory' : 'file');
      })
      .on('done', function() {
        console.log('finished!');
      });
      
    var remaining = te.remaining();
    
    console.log(remaining); // 3

### taskEmitter.stop()

Stop all remaining tasks.

### taskEmitter.reset()

Remove all tasks and listeners.
    
## Events

### <taskName>
  
Emitted when the `<taskName>` has completed.
  
**Example:**

    var te = new TaskEmitter();

    te
      .task('foo', function(arg1, arg2, fn) {
        var err, result = 'foo';
    
        fn(err, result);
      })
      .on('error', ...)
      .on('foo', function(arg1, arg2, result) {
        // ...
      });

**Example using the `fs` module**

    var te = new TaskEmitter();
    
    te
      .task(fs, 'stat', '/path/to/file-1')
      .task(fs, 'stat', '/path/to/file-2')
      .task(fs, 'stat', '/path/to/file-3')
      .on('stat', function(err, path, stat) {
        console.log('%s is a %s', stat.isDirectory() ? 'directory' : 'file');
      })
      .on('done', function() {
        console.log('finished!');
      });

### done

Emitted when all tasks are complete.

### error

Emitted when any error occurs during the running of a `task()`. If this event is not handled an error will be thrown.

### progress

Emitted after a task has been completed.

**Example:**

    te.on('progress', function(status) {
      console.log(status);
    });
    
**Output:**

    {
      remaining: 4,
      total: 8,
      task: 'foo'
    }
