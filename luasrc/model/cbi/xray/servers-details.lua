-- Copyright (C) 2016-2017 Jian Chang <aa65535@live.com>
-- Copyright (C) 2020-2022 honwen <https://github.com/honwen>
-- Licensed to the public under the GNU General Public License v3.

local m, s, o
local xray = "xray"
local sid = arg[1]
local protocols = {
	"vless",
}
local securitys = {
	"xtls-splice",
	"xtls-direct",
	"tls",
	"quic",
}

m = Map(xray, "%s - %s" %{translate("Xray"), translate("Edit Server")})
m.redirect = luci.dispatcher.build_url("admin/services/xray/servers")
m.sid = sid
m.template = "xray/servers-details"

if m.uci:get(xray, sid) ~= "servers" then
	luci.http.redirect(m.redirect)
	return
end

-- [[ Edit Server ]]--
s = m:section(NamedSection, sid, "servers")
s.anonymous = true
s.addremove = false

o = s:option(Value, "alias", translate("Alias(optional)"))
o.rmempty = true

o = s:option(Value, "server", translate("Server Address"))
o.datatype = "host"
o.rmempty = false

o = s:option(Value, "server_port", translate("Server Port"))
o.datatype = "port"
o.rmempty = false

o = s:option(Value, "server_name", translate("Server Name"))
o.datatype = "host"
o.rmempty = true

o = s:option(Value, "id", translate("ID"))
o.password = true

o = s:option(ListValue, "protocol", translate("Protocol"))
for _, v in ipairs(protocols) do o:value(v, v:upper()) end
o.default = 'vless'
o.rmempty = false

o = s:option(ListValue, "security", translate("Security"))
for _, v in ipairs(securitys) do o:value(v, v:upper()) end
o.default = 'xtls-splice'
o.rmempty = false

return m
