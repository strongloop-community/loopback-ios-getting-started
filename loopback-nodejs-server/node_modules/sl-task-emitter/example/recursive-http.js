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
  .on('error', function (err) {
    console.error(err);
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
