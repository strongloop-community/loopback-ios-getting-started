/**
 * This is a workaround to node-tar which writes in chunks of 512 bytes by monkey-patching the fs api
 */
require('./fstream-patch');

var zlib = require('zlib');
var tar = require('tar');
var fs = require('fs');
var path = require('path');
var request = require('request');

var info = require('./detect.js');

module.exports = function (url, dest, cb) {
    var targz = 'loopback-oracle-' + info.platform + '-' + info.arch + '-' + info.version + '.tar.gz';
    if (!url) {
        url = path.join(__dirname, '../../loopback-oracle-builder/build', info.platform, targz);
    } else {
        url = url +'/' + targz;
    }
    console.log('Downloading/Extracting ' + url);
    if (!dest) {
        dest = './node_modules';
    }
    var gunzip = zlib.createGunzip({chunkSize: 1024*1024});
    var src = null;
    if (url.indexOf('http://') === 0 || url.indexOf('https://') === 0) {
        src = request.get(url);
    } else {
        src = fs.createReadStream(url);
    }
    src.pipe(gunzip).pipe(tar.Extract({ path: dest }))
        .on('end', function () {
            console.log(url + ' is now extracted to ' + dest);
            cb && cb();
        }).on('error', function (error) {
            cb && cb(error);
        });
}

if (require.main === module) {
    module.exports(process.argv[2], process.argv[3]);
}
