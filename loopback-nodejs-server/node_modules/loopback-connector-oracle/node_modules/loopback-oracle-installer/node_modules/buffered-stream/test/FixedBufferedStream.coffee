
should = require 'should'
stream = require 'stream'
fs = require 'fs'
BufferedStream = if process.env.BF_COV then require '../lib-cov/FixedBufferedStream' else require '../lib/FixedBufferedStream'

file = "/tmp/buffered-stream"

# Create an Input Stream
Input = ->
  @readable = true
  stream.call @
Input.prototype.__proto__ = stream.prototype
Input.prototype.pause = -> 
  @paused = true
Input.prototype.resume = ->
  @paused = false
Input.prototype.end = -> @ended = true && @emit 'end'
Input.prototype.destroySoon = -> @emit 'end' unless @ended
Input.prototype.destroy = -> @emit 'close'
# Create an Output Stream
Output = ->
  @count = 0
  @writable = true
  stream.call @
Output.prototype.__proto__ = stream.prototype
Output.prototype.write = ->
  @count++
  return true if Math.floor(Math.random()*10) is 0
  setTimeout (self) ->
    self.emit 'drain'
  , Math.floor(Math.random()*10), @
  false
Output.prototype.end = ->
  setTimeout (self) ->
    self.emit 'close'
  , 10, @

describe 'fixed buffered stream', ->

  it 'should write utf8 each 100 chars as 1 Ko chuncks', (next) ->
    data = ''
    for i in [0...100000] then data += "#{i} ♥✈☺♬☑♠☎☻♫☒♤☤☹♪♀✩✉☠✔♂★✇♺✖♨❦☁✌♛❁☪☂✏♝❀☭☃☛♞✿☮☼☚♘✾☯☾☝♖✽✝☄☟♟✺☥✂✍♕✵\n"
    buffer = new BufferedStream 3*1024*1024
    out = fs.createWriteStream file
    buffer.on 'error', (err) ->
      next err
    out.on 'error', (err) ->
      next err
    out.on 'close', ->
      fs.readFile file, 'utf8', (err, content) ->
        should.not.exist err
        content.should.eql data
        fs.unlink file, (err) ->
          should.not.exist err
          next()
    buffer.pipe out
    offset = 0
    length = 100
    while offset + length < data.length
      buffer.write data.substr offset, length
      offset += length
    buffer.write data.substr offset
    buffer.end()

  it 'should pipe between file input and output stream', (next) ->
    data = ''
    for i in [0...1000000] then data += "àèêûîô#{i}\n"
    fs.writeFile "#{file}-input", data, 'utf8', (err) ->
      input = fs.createReadStream "#{file}-input", flags: 'r'
      buffer = new BufferedStream 1024*1024
      output = fs.createWriteStream file
      input.pipe(buffer).pipe(output)
      output.on 'close', ->
        fs.readFile file, 'utf8', (err, content) ->
          should.not.exist err
          content.should.eql data
          fs.unlink file, (err) ->
            should.not.exist err
            next()

  it 'should pipe with a small buffer', (next) ->
    data = ''
    for i in [0...1000000] then data += "àèêûîô#{i}\n"
    fs.writeFile "#{file}-input", data, 'utf8', (err) ->
      input = fs.createReadStream "#{file}-input", flags: 'r'
      buffer = new BufferedStream 1024
      output = fs.createWriteStream file
      input.pipe(buffer).pipe(output)
      output.on 'close', ->
        fs.readFile file, 'utf8', (err, content) ->
          should.not.exist err
          content.should.eql data
          fs.unlink file, (err) ->
            should.not.exist err
            next()

  it 'should pipe between custom input and output stream', (next) ->
    start = Date.now()
    count = 0
    input = new Input
    output = new Output
    wait = ->
      setTimeout ->
        if input.paused
        then process.nextTick wait
        else process.nextTick run
      , 1
    run = ->
      input.emit 'data', "#{count++} ♥✈☺♬☑♠☎☻♫☒♤☤☹♪♀✩✉☠✔♂★✇♺✖♨❦☁✌♛❁☪☂✏♝❀☭☃☛♞✿☮☼☚♘✾☯☾☝♖✽✝☄☟♟✺☥✂✍♕✵\n"
      return input.end() if Date.now() - start > 1000
      if input.paused
      then process.nextTick wait
      else process.nextTick run
    output.on 'close', ->
      next()
    input.pipe(new BufferedStream).pipe(output)
    run()







