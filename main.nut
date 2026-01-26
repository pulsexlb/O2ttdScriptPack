import("util.superlib", "SuperLib", 40);
Log <- SuperLib.Log;
Story <- SuperLib.Story;

require("tax.nut");
require("environmental.nut")
require("peaks-and-thoughs.nut")
require("team_limit.nut")
require("rvg/main.nut")

// 主游戏
class MainClass extends GSController {
	_data_loaded = false; // 是否完成了存档加载
	tax = null;
	environmental = null;
    team_limit = null;
	peaks_and_thoughs = null;
    rvg = null;
	_tax_base_rate = null;
    _tax_max_rate = null;
	_plane_tax_rate = null;
    _system_set_name = []; // 上个事件处理后由脚本设置的公司名称的公司id列表(防止重复处理)
	constructor() {}
}

// 开始
function MainClass::Start() {
	GSLog.Info("O2ttd Script Pack Inited!");


	this._tax_base_rate = MainClass.GetSetting("tax-base");
    this._tax_max_rate = MainClass.GetSetting("tax-max-rate");
	this._plane_tax_rate = MainClass.GetSetting("environment-plane-tax");
	if (!_data_loaded) {
		// tax
        if (MainClass.GetSetting("tax-enabled")) {this.tax = Tax(this._tax_base_rate, this._tax_max_rate, null);}

		// environmental
        if (MainClass.GetSetting("environment-tax-enabled")) {this.environmental = Environmental(this._plane_tax_rate);}

		// peaks and thoughs
        if (MainClass.GetSetting("peaks-enabled")) {
            local preset_setting = MainClass.GetSetting("peaks-preset");
            local base_rates = MainClass.GetSetting("peaks-base");
            this.peaks_and_thoughs = PeaksAndThoughs(preset_setting, base_rates);
        }

        // team limit
        if (MainClass.GetSetting("teams-enabled")) {this.team_limit = TeamLimit();}

        // rvg
        if (MainClass.GetSetting("rvg-enabled")) {this.rvg = RVG();}

		this._data_loaded = true;
	}

    if (MainClass.GetSetting("rvg-enabled")) {this.rvg.Start();}

	// 存储上一次处理的经济月份
	local last_loop_date = GSDate.GetCurrentDate();
	local last_loop_tick = GSDate.GetCurrentScaledDateTicks();


	while (1) {
		local current_date = GSDate.GetCurrentDate();
		local current_tick = GSDate.GetCurrentScaledDateTicks();
		if (last_loop_date != null) {
			local month = GSDate.GetMonth(current_date);
			local year = GSDate.GetYear(current_date);
			local hour = GSDate.GetHour(current_tick);

			if (month != GSDate.GetMonth(last_loop_date)) {
				this.EndOfMonth(month);
			}
			if (year != GSDate.GetYear(last_loop_date)) {
				this.EndOfYear(year);
			}
			if (hour != GSDate.GetHour(last_loop_tick)) {
				this.EndOfHour(hour);
			}
		}
		last_loop_date = current_date;
		last_loop_tick = current_tick

		this.HandleEvents();
        
        if (MainClass.GetSetting("teams-enabled")) {this.team_limit.Run();}
        if (MainClass.GetSetting("rvg-enabled")) {this.rvg.Run();}

		GSController.Sleep(1);
	}
}

function MainClass::HandleEvents() {
	while (GSEventController.IsEventWaiting()) {
		local ev = GSEventController.GetNextEvent();
		if (ev == null) continue;

        // 发送给rvg
        if (MainClass.GetSetting("rvg-enabled")) {this.rvg.HandleEvents(ev);}

		local ev_type = ev.GetEventType();

		switch (ev_type) {
			// 公司新建
			case GSEvent.ET_COMPANY_NEW: {
				local company_event = GSEventCompanyNew.Convert(ev);
				local company_id = company_event.GetCompanyID();

                if (company_id != 0){
                    local team_number = company_id % 2 + 1
                    Story.ShowMessage(company_id, GSText(GSText.WELCOME_MESSAGE, company_id, team_number,
                                    GSText(GSText.SCRIPT_INTRODUCE_NEW_TAX, this._tax_base_rate),
                                    GSText(GSText.SCRIPT_INTRODUCE_ENVIRONMENTALISM, this._plane_tax_rate),
                                    GSText(GSText.SCRIPT_INTRODUCE_TEAMS_INFRASTRUCTURE_SHARING),
                                    GSText(GSText.SCRIPT_INTRODUCE_OTHER_MATTERS)));
                    GSCompany.ChangeBankBalance(company_id, GetAverageValue(1), GSCompany.EXPENSES_OTHER, GSMap.TILE_INVALID);

                    if (MainClass.GetSetting("teams-enabled")) {
                        local company_mode = GSCompanyMode(company_id);
                        local name = GSCompany.GetName(company_id);
                        GSCompany.SetName("[Team " + team_number + "]" + name);
                        if (!(company_id in this._system_set_name)){
                            _system_set_name.push(company_id);
                        }
                    }

                } else {
                    GSCompany.ChangeBankBalance(company_id, 10000000, GSCompany.EXPENSES_OTHER, GSMap.TILE_INVALID);
                }

				break;
			}
            // 公司更名
            case GSEvent.ET_COMPANY_RENAMED: {
                local company_event = GSEventCompanyRenamed.Convert(ev);
                local company_id = company_event.GetCompanyID();
                local idx = GetArrayIndex(this._system_set_name, company_id);
                if (idx != null) {
                    this._system_set_name.remove(idx);
                    return;
                }
                local company_new_name = company_event.GetNewName();
                local company_mode = GSCompanyMode(company_id);
                if (company_id != 0){
                    if (MainClass.GetSetting("teams-enabled")) {
                        local team_number = company_id % 2 + 1
                        GSCompany.SetName("[Team " + team_number + "]" + company_new_name);
                        if (!(company_id in this._system_set_name)){
                            _system_set_name.push(company_id);
                        }
                    }
                }
                break;
            }
		}
	}
}

function MainClass::EndOfMonth(month) {
	// 收税
	if (MainClass.GetSetting("tax-enabled")) {this.tax.TaxQuarterly();}
}

function MainClass::EndOfYear(year) {
	// 环保税
    if (MainClass.GetSetting("environment-tax-enabled")) { this.environmental.TaxPlaneYearAnnual(); }

}

function MainClass::EndOfHour(hour) {
	// 动态客流
    if (MainClass.GetSetting("peaks-enabled")) {this.peaks_and_thoughs.Run(hour);}
}

function MainClass::Save() {
	GSLog.Info("Saving game...");
    local rvg = {};
    if (MainClass.GetSetting("rvg-enabled")) {
        rvg = this.rvg.Save();
    }
    local tax = {};
    if (MainClass.GetSetting("tax-enabled")) {
        tax = this.tax.SaveGameData();
    }
	return {
		tax = tax
        rvg = rvg
	};
}

function MainClass::Load(version, data) {
	GSLog.Info("Loading data from savegame made with version " + version + " of the game script");

	// tax
    if (MainClass.GetSetting("tax-enabled")) {
        local base_rates = MainClass.GetSetting("tax-base");
        local max_rates = MainClass.GetSetting("tax-max-rate");
        if (data.rawin("tax")) {
            local tax_data = data.rawget("tax");
            this.tax = Tax(base_rates, max_rates, tax_data);
            GSLog.Info("Found tax data in save file");
        } else {
            this.tax = Tax(base_rates, null);
            GSLog.Warning("No tax data found - initialising new tax")
        }
    }

	// environmental
    if (MainClass.GetSetting("environment-tax-enabled")) {
        local plane_tax_rate = MainClass.GetSetting("environment-plane-tax");
        this.environmental = Environmental(plane_tax_rate);
    }

	// peaks and thoughs
    if (MainClass.GetSetting("peaks-enabled")) {
        local preset_setting = MainClass.GetSetting("peaks-preset");
        local base_rates = MainClass.GetSetting("peaks-base");
        this.peaks_and_thoughs = PeaksAndThoughs(preset_setting, base_rates);
    }

    // team limit
    if (MainClass.GetSetting("teams-enabled")) {this.team_limit = TeamLimit();}

    // rvg
    if (MainClass.GetSetting("rvg-enabled")) {
        this.rvg = RVG();
        local rvg_data = data.rawget("rvg");
        this.rvg.Load(version, rvg_data);
    }

	this._data_loaded = true;
}
