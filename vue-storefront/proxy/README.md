# Vue StoreFront proxy

[OpenResty](http://openresty.org/) based reverse proxy serving cached pages from Redis without [Vue StoreFront](https://www.vuestorefront.io/) calls, using LUA.

For every `GET` request, this proxy does the following:

* Fetch cache version from VSF (if not already cached, cache in Redis otherwise)
* Fetch full page cache from Redis
  * If available, return it (including headers)
  * If not available, default to proxying VSF (which will then cache the page in Redis)

This allows achieving much better performances without needing to query VSF Node.js app.

## Usage

Following environment variables **must** be set:

* `VSF_BACKEND_HOST`: hostname (without HTTP or port) of VSF backend
* `VSF_BACKEND_PORT`: port of VSF backend (ie. `3000`)
* `REDIS_HOST`: hostname of Redis instance
* `REDIS_PORT`: hostname of Redis instance (ie. `6379`)

## Requirements

The following patch in VSF code is required to expose the cache version:

`core/scripts/server.[js|ts]`
```js
...

const fs = require('fs')

function cacheVersion (req, res) {
  res.send(fs.readFileSync(resolve('core/build/cache-version.json')))
}

app.get('/cache-version.json', cacheVersion)

...
```

## Enhancements

* [ ] Allow exluding query string params from cache key (ie. Google Analytics tracking `utm_*`) trough an environment variable

## License

VSF Proxy source code is completely free and released under the [MIT License](https://github.com/ClickAndMortar/Docker/blob/master/LICENSE).
