
fs = require 'fs'
buffered = require '..'

prepare = (callback) ->
  # Prepare an file with content
  data = ''
  for i in [0...1000000]
    data += "#{i} Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n"
  fs.writeFile "#{__dirname}/pipe.in", data, (err) ->
    return console.log err if err
    callback()

run = ->
  # Prepare the pipe
  input = fs.createReadStream "#{__dirname}/pipe.in"
  buffer = buffered 4*1024*1024
  output = fs.createWriteStream "#{__dirname}/pipe.out"
  # Call the pipe
  input.pipe(buffer).pipe(output)
  # See how that worked
  output.on 'error', (err)->
    console.log err
  output.on 'close', ->
    console.log 'done'

prepare run
