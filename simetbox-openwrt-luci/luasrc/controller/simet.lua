module("luci.controller.simet", package.seeall)

function index()
	local fs = require "nixio.fs"
	local simet1_enabled = fs.stat("/usr/bin/simet_client") or nil
	local page

	page = entry({"admin", "simet"}, firstchild(), _("SIMET"), 10)

	page = entry({"admin", "simet", "simet2"}, template("simet/simet2"), translate("SIMET2 Results"), 10)
	page.dependent = false
	page.leaf = true

	page = entry({"admin", "simet", "status"}, template("simet/status"), translate("SIMETBox status"), 20)
	page.dependent = false
	page.leaf = true

	page = entry({"admin", "simet", "sobre"}, template("simet/sobre"), translate("About SIMETBox"), 40)
	page.dependent = false
	page.leaf = true

	page = entry({"admin", "simet", "simet2_config"}, template("simet/simet2_cfg"), translate("SIMET2 Settings"), 30)
	page.dependent = false
	page.leaf = true

	if simet1_enabled ~= nil then
		page = entry({"admin", "simet", "simet"}, template("simet/simet"), translate("SIMET1 Results"), 15)
		page.dependent = false
		page.leaf = true

		page = entry({"admin", "simet", "configuracoes"}, template("simet/configuracoes"), translate("SIMET1 Settings"), 30)
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
	end

	page = entry({"admin", "simet", "simet_auto_upgrade_now"}, call("run_simet_autoupgrade"), nil)
	page.leaf = true

	page = entry({"admin", "simet", "simet_register"}, call("simet_ma_renew_registration"), nil)
	page.leaf = true

	page = entry({"admin", "simet", "simet_engine_status"}, call("simet_ma_get_engine_status"), nil)
	page.leaf = true

	page = entry({"admin", "simet", "simet_start_measurement_run"}, call("simet_ma_start_measuring"), nil)
	page.leaf = true

	page = entry({"admin", "simet", "simet_wan_status"}, call("simet_wan_status"), nil)
	page.leaf = true

	page = entry({"admin", "simet", "simet_get_config"}, call("simet_get_simetma_config"), nil)
	page.leaf = true

	page = entry({"admin", "simet", "simet_set_config"}, call("simet_set_simetma_config"), nil)
	page.leaf = true
end

function simet_get_simetma_config()
	local json = require "luci.json"
	local uci  = require("luci.model.uci").cursor()
	local options = luci.http.formvalue('options',true)

	options = json.decode(options)

	-- FIXME: only for type simet_measurement?
	-- FIXME: what to do when uci:get fails? or "" ?
	for key, value in pairs(options) do
		for key2, value2 in pairs(value) do
			options[key][key2] = uci:get('simet_ma', key, key2)
		end
	end

	luci.http.prepare_content("application/json")
	luci.http.write_json(options)
end

function simet_set_simetma_config()
	local json = require "luci.json"
	local uci  = require("luci.model.uci").cursor()
	local options = luci.http.formvalue('options',false)
	local all_ok = true

	options = json.decode(options)

	-- FIXME: only for type simet_measurement?
	for key, value in pairs(options) do
		for key2, value2 in pairs(value) do
			if not uci:set('simet_ma', key, key2, value2) then
				all_ok = false
			end
		end
	end

	-- FIMXE: split into standard "save" "apply" "cancel" ?
	if all_ok and uci:save("simet_ma") and uci:commit("simet_ma") then
		local result = luci.util.ubus("simet_ma", "refresh_schedule") or {}
		if result ~= nil and result.status == 0 then
			luci.http.status(200)
		else
			luci.http.status(503, "simet engine reports an internal error")
		end
	else
		luci.http.status(503, "configuration update not applied")
	end
end

function get_crontab_options()
	require "simet.simet_utils"
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
	require "simet.crontab_writer"
	require "simet.simet_utils"
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
	require "simet.simet_utils"
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

function simet_ma_renew_registration()
	local result = luci.util.ubus("simet_ma", "renew_registration") or {}
	if result ~= nil and result.status == 0 then
		luci.http.status(204)
	else
		luci.http.status(503, "failed to register agent and renew tokens")
	end
end

function simet_ma_get_engine_status()
	local result = luci.util.ubus("simet_ma", "simet_engine_status") or {}
	if result ~= nil then
		luci.http.prepare_content("application/json")
		luci.http.write_json(result)
	else
		luci.http.status(503, "failed to retrieve SIMET engine status")
	end
end

function simet_wan_status()
	local result = luci.util.ubus("simet_ma", "wan_status") or {}
	if result ~= nil then
		luci.http.prepare_content("application/json")
		luci.http.write_json(result)
	else
		luci.http.status(503, "failed to retrieve wan status")
	end
end

function simet_ma_start_measuring()
	local result = luci.util.ubus("simet_ma", "start_measurement_run") or {}
	if result ~= nil then
		luci.http.prepare_content("application/json")
		luci.http.write_json(result)
	else
		luci.http.status(503, "failed to contact SIMET2 engine")
	end
end

function simet_client_process()
	local result = read_from_bash('ps w | grep run_simet.sh | grep -v grep | grep -v Z')
	luci.http.write(result)
end

