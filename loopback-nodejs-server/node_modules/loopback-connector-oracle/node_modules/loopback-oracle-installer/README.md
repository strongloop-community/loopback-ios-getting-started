# loopback-oracle-installer

LoopBack Oracle Installer is module that downloads/extracts the prebuilt LoopBack Oracle installable bundle into parent
module's node_modules folder and sets up the environment for Oracle instant client.

## Standalone use

1. First ensure that you run the make/build.sh from the `loopback-oracle-builder` and the package (gzipped tarball) is
   built correctly and uploaded to a publicly available site.

2. Make sure the loopback-oracle-builder and the loopback-oracle-installer projects are siblings within the same directory
hierarchy. This is only required if you want to test w/ the locally built gzipped tarball.

3. To run/test a local install, run:

        cd loopback-oracle-installer
        npm install

4. For production release, make sure you have the LOOPBACK_ORACLE_URL appropriately. For example:

        export LOOPBACK_ORACLE_URL=http://7e9918db41dd01dbf98e-ec15952f71452bc0809d79c86f5751b6.r22.cf1.rackcdn.com
        or
        export LOOPBACK_ORACLE_URL=/Users/rfeng/Projects/loopback/loopback-oracle-builder/build/MacOSX

   and then run:

       npm install loopback-oracle-installer

## Use as a dependency for loopback-connector-oracle

The loopback-oracle-installer module can be used as a dependency for loopback-connector-oracle module. It can be
declared in package.json as follows:

           "dependencies": {
             "loopback-oracle-installer": "git+ssh://git@github.com:strongloop/loopback-oracle-installer.git",
             ...
           },
           "config": {
             "oracleUrl": "http://7e9918db41dd01dbf98e-ec15952f71452bc0809d79c86f5751b6.r22.cf1.rackcdn.com"
           },

During `npm install` of the loopback-connector-oracle module, it will detect the local platform and download the
corresponding prebuilt [`oracle` module[(https://github.com/strongloop/node-oracle) and Oracle instant client into
the node_modules folderas illustrated below.

        loopback-connector-oracle
            +--- node_modules
               +-- oracle
               +-- instantclient
