local m,s,e

m = Map("firewall",
	translate("uRPF (BCP38)"),
	translate("This function blocks packets with suspect source addresses " ..
		  "from going through the router as per " ..
		  "<a href=\"http://tools.ietf.org/html/bcp38\">BCP 38</a>. " ..
		  "It works for both IPv4 and IPv6. " ..
		  "Note that it costs one extra route lookup per packet, so it " ..
		  "might reduce performance on slow routers")
	)

s = m:section(NamedSection, "urpf", "include", translate("uRPF configuration"))
e = s:option(Flag, "active",
	translate("Enable source-address anti-spoofing protection"))
e.rmempty = false

return m
