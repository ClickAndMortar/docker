local cjson = require "cjson"
local redis = require "resty.redis"

function trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function explode(separator, s)
    local t, ll
    t = {}
    ll = 0
    if (#s == 1) then
        return { trim(s) }
    end
    while true do
        local l = string.find(s, separator, ll, true)
        if l ~= nil then
            table.insert(t, trim(string.sub(s, ll, l - 1)))
            ll = l + 1
        else
            table.insert(t, trim(string.sub(s, ll)))
            break
        end
    end
    return t
end

local args, err = ngx.req.get_uri_args()
if err == "truncated" then
    ngx.log(ngx.ERR, "Truncated query args")
    return
end

-- Do not process static assets
local match, _ = ngx.re.match(ngx.var.uri, "\\.(css|json|js|xml|jpe?g|png|gif|svg|eot|woff|woff2|ttf|otf)$")
if match ~= nil then
    return
end

-- Check if requested app is VSF or VSF API based on request URI
local match = string.match(ngx.var.request_uri, "^/api")
local api = false
if match ~= nil then
    api = true
end

-- Remove unnecessary query params to increase cache hit
local argsToRemove = { "gclid", "utm", "utm_source", "utm_medium", "utm_campaign", "utm_term", "utm_content" }

local envArgsToRemove = os.getenv("VSF_CACHE_REMOVE_QS_ARGS")

if envArgsToRemove ~= nil and string.match(envArgsToRemove, '^[a-z0-9_,-]+$') ~= nil then
    local envArgsToRemoveArray = explode(",", envArgsToRemove)

    for _, argToRemove in pairs(envArgsToRemoveArray) do
        table.insert(argsToRemove, argToRemove)
    end
end

for _, argToRemove in pairs(argsToRemove) do
    if args[argToRemove] ~= nil then
        args[argToRemove] = nil
    end
end

ngx.req.set_uri_args(args)
-- End QS params removal

local red = redis:new()

red:set_timeout(1000)

local ok, err = red:connect(os.getenv("REDIS_HOST"), os.getenv("REDIS_PORT"))
if not ok then
    ngx.log(ngx.ERR, "Failed to connect to Redis: ", err)
    return
end

local app = "vsf"
if api then
    app = "vsf-api"
end
local cacheVersionKey = "cache-version-" .. app
local cacheVersion, err = red:get(cacheVersionKey)
if not cacheVersion then
    ngx.log(ngx.INFO, "Failed to get cache version: ", err)
    return
end

local count

-- Fetch cache version from VSF and store it in Redis
if cacheVersion == ngx.null then
    local location = "_vsf"
    if api then
        location = location .. "_api"
    end
    ngx.log(ngx.INFO, "Cache version not found, creating it")
    local cacheVersionRes = ngx.location.capture("/" .. location .. "/cache-version.json")
    cacheVersion, count = string.gsub(cacheVersionRes.body, "\"", "")
    red:set(cacheVersionKey, cacheVersion, "EX", "60") -- EX 60 = TTL 60 seconds
end

-- Using ngx.var.uri and ngx.var.args because ngx.var.request_uri is unchanged by ngx.req.set_uri_args
local cacheUri = ngx.var.uri
if ngx.var.args ~= nil and ngx.var.args ~= '' then
    cacheUri = cacheUri .. '?' .. ngx.var.args
end
local cacheKey = cacheVersion .. "data:page:" .. cacheUri
if api then
    cacheKey = "data:api:" .. cacheUri
end
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

ngx.header["x-vs-cache"] = "hit"
ngx.header["x-lua-redis-cache"] = "hit"

ngx.say(body)

return ngx.exit(ngx.HTTP_OK)
