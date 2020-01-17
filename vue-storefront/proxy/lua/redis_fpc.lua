local args, err = ngx.req.get_uri_args()

local cjson = require "cjson"

if err == "truncated" then
    ngx.log(ngx.ERR, "Truncated query args")
    return
end

local redis = require "resty.redis"
local red = redis:new()

red:set_timeout(1000)

local ok, err = red:connect(os.getenv("REDIS_HOST"), os.getenv("REDIS_PORT"))
if not ok then
    ngx.log(ngx.ERR, "Failed to connect to Redis: ", err)
    return
end

local cacheVersion, err = red:get("cache-version")
if not cacheVersion then
    ngx.log(ngx.INFO, "Failed to get cache version: ", err)
    return
end

local count

-- Fetch cache version from VSF and store it in Redis
if cacheVersion == ngx.null then
    ngx.log(ngx.INFO, "Cache version not found, creating it")
    local cacheVersionRes = ngx.location.capture("/_vsf/cache-version.json")
    cacheVersion, count = string.gsub(cacheVersionRes.body, "\"", "")
    red:set("cache-version", cacheVersion, "EX", "60") -- EX 60 = TTL 60 seconds
end

local cacheKey = cacheVersion .. "data:page:" .. ngx.var.request_uri
local cachedContent, err = red:get(cacheKey)
if not cachedContent or cachedContent == ngx.null then
    ngx.log(ngx.INFO, "Failed to get cached content: ", err)
    return
end

local decoded = cjson.decode(cachedContent)
local body = decoded["body"]

red:close()

local headers = decoded["headers"]

for k, v in pairs(headers) do
    ngx.header[k] = v;
end

ngx.header["x-lua-redis-cache"] = "hit"

ngx.say(body)

return ngx.exit(ngx.HTTP_OK)
