/**
 * Monkey-patch fstream.FileWriter to boost the performance of node-tar Extract which always
 * write in 512 byte chunks
 */
var Writer = require('fstream').Writer;
var FileWriter = require('fstream').FileWriter;
var bufStream = require('buffered-stream');

var fs = require("graceful-fs"), EOF = {}

FileWriter.prototype._create = function () {
    var me = this
    if (me._stream) return

    var so = {}
    if (me.props.flags) so.flags = me.props.flags
    so.mode = Writer.filemode
    if (me._old && me._old.blksize) so.bufferSize = me._old.blksize

    me._fstream = fs.createWriteStream(me._path, so);
    me._stream = bufStream(1024*1024); // Set up a buffered stream to aggregate small writes
    me._stream.pipe(me._fstream);

    me._fstream.on("open", function (fd) {
        // console.error("FW open", me._buffer, me._path)
        me.ready = true
        me._buffer.forEach(function (c) {
            if (c === EOF) me._stream.end()
            else me._stream.write(c)
        })
        me.emit("ready")
        // give this a kick just in case it needs it.
        me.emit("drain")
    })

    me._fstream.on("drain", function () { me.emit("drain") })

    me._fstream.on("close", function () {
        // console.error("\n\nFW Stream Close", me._path, me.size)
        me._finish()
    })
}

