express = require 'express'
tmp = require 'tmp'
fs = require 'fs'
{spawn} = require 'child_process'

app = express.createServer()
app.use express.logger()
app.use express.bodyParser()
app.use require('connect-assets')()

app.get '/', (req, res) ->
  res.render 'index.jade'

app.post '/echo', (req, res) ->
  res.send output: req.body.input

gmshToThree = require './gmshToThree'
app.post '/mesh/gmsh', (req, res, next) ->
  tmp.file (err, inputPath) ->
    if err
      next err
      return
    fs.writeFile inputPath, req.body.input, (err) ->
      if err
        next err
        return
      tmp.file (err, outputPath) ->
        if err
          next err
          return
        gmsh = spawn 'gmsh-2.6.1-Linux/bin/gmsh',
          ['-3', inputPath, '-o', outputPath, '-format', 'msh']
        logs = ""
        gmsh.stdout.on 'data', (data) -> logs += data
        gmsh.stderr.on 'data', (data) -> logs += data
        gmsh.on 'exit', (code) ->
          if code != 0
            next "Gmsh exited with code #{code}" 
            return
          fs.unlink inputPath, (err) -> console.log err if err
          fs.readFile outputPath, "UTF-8", (err, data) ->
            console.log err if err
            res.send output: gmshToThree(data), logs: logs
            fs.unlink outputPath, (err) -> console.log err if err

port = process.env.PORT || 5000
app.listen port, ->
  console.log "Listening on " + port

