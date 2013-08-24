var pkg = require('../package.json');

var platforms = {
    darwin: 'MacOSX',
    linux: 'Linux',
    win32: 'Windows'
}

var archs = {
    ia32: 'x86',
    x64: 'x64'
}

module.exports = {
  version: pkg.version,
  platform: platforms[process.platform] || process.platform,
  arch: archs[process.arch] || process.arch
};

if(require.main === module) {
  console.log(module.exports);
}
