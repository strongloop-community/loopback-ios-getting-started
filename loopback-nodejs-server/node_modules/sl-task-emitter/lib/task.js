/**
 * Expose `Task`.
 */

module.exports = Task;

/**
 * Module dependencies.
 */
 
var EventEmitter = require('events').EventEmitter
  , debug = require('debug')('task')
  , util = require('util')
  , inherits = util.inherits
  , assert = require('assert')
  , fs = require('fs');
  
/**
 * Create a new `Task` with the given `options`.
 *
 * @param {Object} options
 * @return {Task}
 */

function Task(options) {
  options = options || {};
  
  EventEmitter.apply(this, arguments);
  
  assert(options, 'Task requires an options object');
  assert(typeof options === 'object', 'Task requires an options object');
  assert(typeof options.name === 'string', 'Task requires a name');
  assert(typeof options.fn === 'function', 'Task requires a function');
  
  this.options = options;
  options.scope = options.scope || {};
  this.complete = false;
  this.errored = false;
}

/**
 * Inherit from `EventEmitter`.
 */

inherits(Task, EventEmitter);

/**
 * Run the task.
 */
 
Task.prototype.run = function () {
  var opts = this.options;
  var args = [];
  var self = this;
  
  for (var i = 0; i < opts.args.length; i++) {
    args[i] = opts.args[i];
  }
  
  debug('%s - %s', opts.name, args.toString());
    
  // add complete callback
  args[i] = function () {
    self._callback.apply(self, arguments);
  };
  
  try {
    opts.fn.apply(opts.scope, args);
  } catch(e) {
    debug('%s errored!', opts.name);
    this.complete = this.errored = true;
    this.emit('error', e);
  }
}

/*!
 * Internal callback
 */

Task.prototype._callback = function (err) {
  // use diff signature for fs.exists
  if(this.options.scope == fs && this.options.name === 'exists') {
    arguments = [null, err];
    err = null;
  }
  
  
  // if the task has stopped
  // dont callback
  if(this.stopped) {
    return;
  }
  
  var opts = this.options;
  var args = opts.args;
  
  this.complete = true;
  if(err) {
    this.errored = true;
    debug('ERROR - %s - %s - err: %j', opts.name, args.toString(), err);
    this.emit('error', err);
  } else {
    // remove error
    var args = Array.prototype.slice.call(arguments, 1);

    debug('%s - %s - complete', opts.name, opts.args.toString());
    
    // add done to emit the done event
    // and pass along the args
    args.unshift('done');
    
    this.emit.apply(this, args);
  }
}

/**
 * Stop the current task.
 */

Task.prototype.stop = function () {
  this.stopped = true;
  this.cleanup();
}

/**
 * Remove any potential references to callbacks to prevent leaks.
 */

Task.prototype.cleanup = function () {
  if(this.options) {
    delete this.options.fn;
    delete this.options.scope;
    delete this.options;
    this.options = {};
  }
}