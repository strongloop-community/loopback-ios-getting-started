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