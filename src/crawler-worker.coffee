##
# crawler-worker
# https://github.com/yi/novasrv
#
# Copyright (c) 2013 yi
# Licensed under the NA license.
##

_ = require "underscore"
p = require "commander"
kue = require 'kue'
redis = require 'redis'
logger = require 'dev-logger'
fs = require "fs"
path = require "path"
mkdirp = require "mkdirp"

## 更新外部配置
p.version('0.0.1')
  .option('-p, --port <n>', 'redis server port')
  .option('-h, --host [VALUE]', 'redis server host')
  .option('-g, --gameserver-id [VALUE]', 'game server id, for which this crawler is working')
  .option('-o, --output [PATH]', 'file output path')
  .parse(process.argv)

p.port = parseInt(p.port) || 6379
p.host = p.host || "localhost"

logger.isDebug = true

unless _.isString(p.gameserverId) and p.gameserverId.length > 0
  console.error "ERROR [crawler-worker::init] missing server id"
  process.exit(1)
  return

unless fs.existsSync(p.output)
  console.error "ERROR [crawler-worker::init] non-exist output path (-o):#{p.output}"
  process.exit(1)
  return

kue.redis.createClient = ->
  #console.log "[crawler-worker::kue::createClient] host:#{p.host}, port:#{p.port}"
  client = redis.createClient(p.port, p.host)
  return client

jobs = kue.createQueue()

# monitor job queue
jobs.process "#{p.gameserverId}-write-html", (job, done) ->
  console.log "[crawler-worker::on::write-html]"

  # NOTE:
  #   job structure:
  #   job:
  #     data:
  #       subpath : String
  #       filename : String
  #       content : String
  # ty 2013-10-18

  data = job.data
  subpath = data.subpath
  filename = data.filename
  content = data.content

  # validate the job
  unless _.isString(filename) and filename.length > 0
    err = "bad job.filename: #{filename}"
    logger.warn "[crawler-worker::on::write-html] #{err}"
    done err
    return

  unless _.isString(content) and content.length > 0
    err = "bad job.content: #{content}"
    logger.warn "[crawler-worker::on::write-html] #{err}"
    done err
    return

  if subpath?
    outputPath = path.join p.output, subpath
    try
      mkdirp.sync outputPath
    catch err
      err = "fail to create directory. error:#{err}"
      logger.warn "[crawler-worker::on::write-html] #{err}"
      done err
      return

  outputPath = path.join(outputPath || p.output, filename)
  console.log "[crawler-worker::on::write-html] write to #{outputPath}"

  fs.writeFile outputPath, content, (err)->
    if err?
      err = "fail to write content, error:#{err}"
      logger.warn "[crawler-worker::on::write-html] #{err}"
      done err
      return

    done()

    # remove the job when it completed
    #job.remove (err)->
      #if err?
        #logger.warn "[crawler-worker::on::write-html] #{err}"

    return


console.log "======================== Starting NovaCrawler::Worker ========================"
console.log "Listen to: #{p.host}:#{p.port}, games server id:#{p.gameserverId}, base output to:#{p.output}"


