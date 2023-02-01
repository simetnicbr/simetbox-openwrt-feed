module("luci.controller.urpf", package.seeall)

function index()
	local e=entry({"admin", "network", "firewall", "urpf"},
		cbi("urpf"),
		_("uRPF (BCP38)"), 50)
	e.dependent = false
	e.leaf=true
end
