module("luci.controller.simet", package.seeall)

require('simet.crontab_writer')
require('simet.simet_utils')

function index()
	require('simet.simet_utils')

	local env = luci.http.getenv()
	local user_data = read_uci_section('personal_data', 'user_data')
	local page

	page = entry({"admin", "simet"}, firstchild(), _("SIMET"), 10)

	page = entry({"admin", "simet", "simet"}, template("simet/simet"), translate("SIMET Results"), 10)
	page.dependent = false
	if not user_data then
		page.sysauth = false
	end
	page.leaf = true

	page = entry({"admin", "simet", "configuracoes"}, template("simet/configuracoes"), translate("Settings"), 30)
	page.dependent = false
	page.leaf = true

	page = entry({"admin", "simet", "sobre"}, template("simet/sobre"), translate("About SIMETBox"), 40)
	page.dependent = false
	page.leaf = true

	page = entry({"admin", "simet", "getcrontaboptions"}, call("get_crontab_options"), nil)
	page.leaf = true

	page = entry({"admin", "simet", "setcrontaboptions"}, call("set_crontab_options"), nil)
	page.leaf = true

	page = entry({"admin", "simet", "run_simet_client"}, call("run_simet_client"), nil)
	page.leaf = true

	page = entry({"admin", "simet", "simet_client_process"}, call("simet_client_process"), nil)
	page.leaf = true

	page = entry({"admin", "simet", "simet_auto_upgrade_now"}, call("run_simet_autoupgrade"), nil)
	page.leaf = true
end

function get_crontab_options()
	local options = luci.http.formvalue('options',true)

	options = json_decode(options)

	for key, value in pairs(options) do
		for key2, value2 in pairs(value) do
			options[key][key2] = read_uci_option('simet_cron', key, key2)
		end
	end


	luci.http.prepare_content("application/json")
	luci.http.write(json_encode(options))
end

function set_crontab_options()
	local options = luci.http.formvalue('options',false)

	options = json_decode(options)

	for key, value in pairs(options) do
		for key2, value2 in pairs(value) do
			write_uci_option('simet_cron', key, key2, value2)
		end
	end

	commit_uci_config('simet_cron')

	generate_crontab()
	luci.http.status(200)

end

function run_simet_client()
	local result = read_from_bash('run_simet.sh')
	luci.http.write(result)
end

function run_simet_autoupgrade()
	local result = luci.util.ubus("auto_upgrade", "trigger") or {}
	if #result > 0 then
		luci.http.prepare_content("application/json")
		luci.http.write_json(result)
	else
		luci.http.status(503, "auto_upgrade non-functional")
	end
end

function simet_client_process()
	local result = read_from_bash('ps w | grep run_simet.sh | grep -v grep | grep -v Z')
	luci.http.write(result)
end

