# crawler-worker

the worker side of nova-crawler

## Install
Install the module with:

```bash
rm -rf worker/log/crawler-worker.log  && mkdir -p ./worker && wget -O - -o /dev/null https://github.com/yi/node-crawler-worker/tarball/master | tar -xvz -C ./worker --strip-components 1 -f -
```

Launch with forever
```bash
./forever-start-crawler.sh && tail -fn 1000 worker/log/crawler-worker.log 
```

## 命令行参数

* -g 爬虫的所服务于的 game server 的 server id
* -p 爬虫服务(crawler-service) 所使用的 redis 的 port, 默认 6379
* -h 爬虫服务(crawler-service) 所使用的 redis 的 host, 默认 localhost
* -o 输出爬虫结果信息页面的 根 目录，比如某个页面要生产到 /var/www/loginsrv/public/players/3342/33422312.html 那么根目录就是 `/var/www/loginsrv/public/players/`

## License
Copyright (c) 2013 yi
Licensed under the NA license.
