local imageInfo = require("xkcd-images")
local dateInfo = require("date-info")
local json = require("cjson")

local pgmoon = require("pgmoon")

local pg = pgmoon.new({
  host = "127.0.0.1",
  database = "xkcd",
})

assert(pg:connect())

-- explode(seperator, string)
local function explode(d,p)
  local t, ll
  t={}
  ll=0
  if(#p == 1) then return {p} end
    while true do
      l=string.find(p,d,ll,true) -- find the next d in the string
      if l~=nil then -- if "not not" found then..
        table.insert(t, string.sub(p,ll,l-1)) -- Save it in our array.
        ll=l+1 -- save just after where we found it for searching next time.
      else
        table.insert(t, string.sub(p,ll)) -- Save what's left in our array.
        break -- Break at end, as it should be, according to the lua manual.
      end
    end
  return t
end

function unescape(str)
  str = string.gsub( str, '&lt;', '<' )
  str = string.gsub( str, '&gt;', '>' )
  str = string.gsub( str, '&quot;', '"' )
  str = string.gsub( str, '&apos;', "'" )
  str = string.gsub( str, '&#(%d+);', function(n) return string.char(n) end )
  str = string.gsub( str, '&#x(%d+);', function(n) return string.char(tonumber(n,16)) end )
  str = string.gsub( str, '&amp;', '&' ) -- Be sure to do this after all others
  return str
end

for i=1, 1624 do
	local v = imageInfo[i]
	if v then
		local newDate = explode("-",dateInfo[i].date)
		v.date = newDate[1] .. "-" .. string.format("%02d", tonumber(newDate[2])) .. "-" .. string.format("%02d", tonumber(newDate[3]))
		

		local insert

		if v.href then
			insert = [[insert into comics (id, date, image_url, hover_text, title, image_link) VALUES (]] .. i .. [[,]] .. pg:escape_literal(v.date) .. [[,]] .. pg:escape_literal(v.src) ..[[,]] .. pg:escape_literal(unescape(v.title)) .. [[,]] .. pg:escape_literal(unescape(v.alt)) .. [[,]] .. pg:escape_literal(unescape(v.href)) .. [[)]]
		else 
			insert = [[insert into comics (id, date, image_url, hover_text, title) VALUES (]] .. i .. [[,]] .. pg:escape_literal(v.date) .. [[,]] .. pg:escape_literal(v.src) ..[[,]] .. pg:escape_literal(unescape(v.title)) .. [[,]] .. pg:escape_literal(unescape(v.alt)) .. [[)]]
		end

		pg:query(insert);
		-- print(insert)
	end

end



