var TaskEmitter = require('../');
var fs = require('fs');
var path = require('path');

var te = new TaskEmitter();

te
  .on('readdir', function (dir, files) {
    files.forEach(function (file) {
      te.task(fs, 'stat', path.join(dir, file));
    });
  })
  .on('stat', function (file, stat) {
    console.log(file, stat);
  })
  .once('error', function (err) {
    console.log('error', err);
  })
  .once('done', function () {
    console.log('done.');
  })
  .task(fs, 'readdir', './sample-fools');