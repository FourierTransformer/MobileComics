-- config.moon
local config = require("lapis.config")

config("development", {
  _name = "development",
  code_cache = "off",
  cached = false,
  port = "8081",
  server_name = "localhost",
  postgres = {
    host = "127.0.0.1",
    user = "FTransformer",
    database = "xkcd"
  }
})

config("production", {
  _name = "production",
  num_workers = 4,
  cached = true,
  code_cache = "on",
  port = "80",
  server_name = "mysweetserver.io",
  postgres = {
    host = "127.0.0.1",
    user = "FTransformer",
    database = "xkcd"
  }
})
