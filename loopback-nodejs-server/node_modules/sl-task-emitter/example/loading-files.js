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

console.log('start');

l.on('progress', function (d) {
  console.log(d);
})

l.load('sample-files', function (err, files) {
  console.log(err || files);
});
