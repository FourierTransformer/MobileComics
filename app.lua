local lapis = require("lapis")
local app = lapis.Application()
local config = require("lapis.config").get()

-- enable etlua and set the base template
app:enable("etlua")
app.layout = require("views.baseLayout")

-- and lapis.db to access the database
local db = require("lapis.db")
local json = require("cjson")
local http = require("lapis.nginx.http")

-- makes the json errors consistent
local function jsonError(titleText, detailText)
    return {
        errors = {
            title = titleText,
            detail = detailText
        }
    }
end

local function getComic(id)
	-- either use the submitted date or today's date
	local query
    if id then
        query = db.select("id, date, image_url, hover_text, title, image_link from comics where id = ?", id)
    else
		query = db.select("id, date, image_url, hover_text, title, image_link from comics where id = (SELECT max(id) from comics) LIMIT 1")
    end

	local id = query[1].id
	local prev_next = db.query([[SELECT id, previous, next
                                from (
                                    select distinct id, lag(id) OVER id_order AS previous, lead(id) OVER id_order AS next
                                    from comics
                                    WINDOW id_order AS (
                                        ORDER BY id asc
                                    )
                                ) AS laggyleader
                                WHERE id = ?]], id)

	local panels = db.select("sequence_no, x, y, width, height from panels where comic_id = ? order by sequence_no", id)

	return (query ~= nil and query[1] ~= nil), {comics = query[1], nav = prev_next[1], panels = panels}
end

local secret = "hello_world"

local function calculate_signature(str)
  return ngx.encode_base64(ngx.hmac_sha1(secret, str))
    :gsub("[+/=]", {["+"] = "-", ["/"] = "_", ["="] = ","})
    :sub(1,12)
end

app:get("/", function(self)
	ok, info = getComic()
	self.today = info.comics
	self.nav = info.nav
	self.title = "xkcd: " .. self.today.title
	self.crop = false
  	return { render = "index" }
end)

app:get("/:id", function(self)
	math.randomseed(os.time())
	ok, info = getComic(self.params.id)
	self.today = info.comics
	self.nav = info.nav
	self.title = "xkcd: " .. self.today.title
	self.panels = info.panels
	self.crop = false
  	return { render = "index" }
end)

app:get("/crop", function(self)
	ok, info = getComic()
	self.today = info.comics
	self.nav = info.nav
	self.title = "xkcd: " .. self.today.title
	self.crop = true
  	return { render = "crop" }
end)

app:get("/crop/:id", function(self)
	math.randomseed(os.time())
	ok, info = getComic(self.params.id)
	self.today = info.comics
	self.nav = info.nav
	self.title = "xkcd: " .. self.today.title
	self.crop = true	
  	return { render = "crop" }
end)

app:post("/crop/:id", function(self)
	ngx.req.read_body()
	local cropJson = ngx.req.get_post_args()["crop"]
	-- print(cropJson)
	local crop = json.decode(cropJson)
	db.update("comics", {num_panels = #crop.toCrop}, {id = self.params.id})
	db.delete("panels", {comic_id = self.params.id})
	if #crop.toCrop > 1 then
		for i, panel in ipairs(crop.toCrop) do
			db.insert("panels", {comic_id = self.params.id, sequence_no = panel.sequence, x = panel.x, y = panel.y, width = panel.width, height = panel.height})
			local cropUrl = panel.width .. "x" .. panel.height .. "+" .. panel.x .. "+" .. panel.y .. "/" .. panel.sequence .. "/" .. crop.image
			local sig = calculate_signature(cropUrl)
			local body, status_code, headers = http.simple("http://127.0.0.1:8081/images/" .. sig .. "/" .. cropUrl)
		end
	end
	return { layout = false, json = self.params}
end)

return app
