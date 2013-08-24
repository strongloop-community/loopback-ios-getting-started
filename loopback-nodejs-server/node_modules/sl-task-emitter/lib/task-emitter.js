/**
 * Expose `TaskEmitter`.
 */

module.exports = TaskEmitter;

/**
 * Module dependencies.
 */
 
var EventEmitter = require('events').EventEmitter
  , debug = require('debug')('task-emitter')
  , util = require('util')
  , inherits = util.inherits
  , assert = require('assert')
  , Task = require('./task')
  
/**
 * Create a new `TaskEmitter`.
 *
 * @return {TaskEmitter}
 */

function TaskEmitter() {
  EventEmitter.apply(this, arguments);
  this.tasks = [];
}

/**
 * Inherit from `EventEmitter`.
 */

inherits(TaskEmitter, EventEmitter);

/**
 * Execute a task and emit an event when it is complete.
 */

TaskEmitter.prototype.task = function (name, fn) {
  var scope;
  var tasks = this.tasks;
  var args = Array.prototype.slice.call(arguments, 2);
    
  if(typeof name !== 'string') {
    scope = name;
    name = fn;
    fn = scope[name];
  }
  
  if(this.complete) {
    throw new Error('Could not start task ' + name + '. Cannot add tasks after a TaskEmitter emits the done event.');
  }
  
  var task = name instanceof Task ? name : new Task({name: name, scope: scope, args: args, fn: fn});
  
  task.once('done', function () {
    var args = [task.options.name];
    var taskArgs = task.options.args;
    var taskName = task.options.name;
    var doneArgs = arguments;
    var i;
    
    for(i = 0; i < taskArgs.length; i++) {
      args.push(taskArgs[i]);
    }
    
    for(i = 0; i < doneArgs.length; i++) {
      args.push(doneArgs[i]);
    }
    
    this.emit.apply(this, args);
    
    task.cleanup();
    
    // do any pending tasks remain
    // after a complete tick?
    process.nextTick(function () {
      var remaining = this.remaining();
      this.emit('progress', {remaining: remaining, total: this.tasks.length, task: taskName});
      
      if(!(remaining || this.complete)) {
        this.complete = true;
        this.emit('done');
      }
    }.bind(this));
  }.bind(this));
  
  task.once('error', function (err) {
    // stop all pending tasks
    this.stop();
    // emit the error
    this.emit('error', err);
  }.bind(this));
  
  tasks.push(task);
  
  task.run();
  
  return this;
}

/**
 * Stop all remaining tasks.
 *
 * @return {Number}
 */

TaskEmitter.prototype.stop = function () {
  this
    .tasks
    .forEach(function (t) {
      t.stop();
    });
}

/**
 * Determine how many tasks remain.
 *
 * @return {Number}
 */

TaskEmitter.prototype.remaining = function () {
  return this
    .tasks
    .map(function (t) {
      return t.complete ? 0 : 1;
    })
    .reduce(function (a, b) {
      return a + b;
    }, 0);
}

/**
 * Remove all tasks and reset all state.
 *
 * @return {Number}
 */

TaskEmitter.prototype.reset = function () {
  this.tasks = [];
  this.complete = false;
  this.removeAllListeners();
}