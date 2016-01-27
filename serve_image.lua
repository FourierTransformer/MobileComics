local sig, size, sequence, path, ext =
  ngx.var.sig, ngx.var.size, ngx.var.sequence, ngx.var.path, ngx.var.ext

local secret = "hello_world" -- signature secret key
local images_dir = "static/images/" -- where images come from
local cache_dir = "static/mobile/" -- where images are cached

local function return_not_found(msg)
  ngx.status = ngx.HTTP_NOT_FOUND
  ngx.header["Content-type"] = "text/html"
  ngx.say(msg or "not found")
  ngx.exit(0)
end

local function calculate_signature(str)
  return ngx.encode_base64(ngx.hmac_sha1(secret, str))
    :gsub("[+/=]", {["+"] = "-", ["/"] = "_", ["="] = ","})
    :sub(1,12)
end

if calculate_signature(size .. "/" .. sequence .. "/" .. path) ~= sig then
  return_not_found("invalid signature")
end

local source_fname = images_dir .. path

-- make sure the file exists
local file = io.open(source_fname, "r")

if not file then
  return_not_found()
end

file:close()

if (tonumber(sequence) > 10) then
  local output = io.popen("mkdir -p " .. cache_dir .. "/" .. sequence)
  output:close()
end

local dest_fname = cache_dir .. "/" .. sequence .. "/" .. path

-- resize the image
local magick = require("magick")
magick.thumb(source_fname, size, dest_fname)

ngx.say("hi")
