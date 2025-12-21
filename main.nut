import("util.superlib", "SuperLib", 40);
Log <- SuperLib.Log;
Story <- SuperLib.Story;

require("tax.nut");
require("environmental.nut")
require("peaks-and-thoughs.nut")

// 主游戏
class MainClass extends GSController {
	_data_loaded = false; // 是否完成了存档加载
	tax = null;
	environmental = null;
	peaks_and_thoughs = null;
	_tax_base_rate = null;
	_plane_tax_rate = null
	constructor() {}
}

// 开始
function MainClass::Start() {
	GSLog.Info("O2ttd Script Pack Inited!");


	this._tax_base_rate = MainClass.GetSetting("tax-base");
	this._plane_tax_rate = MainClass.GetSetting("environment-plane-tax");
	if (!_data_loaded) {
		// tax
		this.tax = Tax(this._tax_base_rate, null);

		// environmental
		this.environmental = Environmental(this._plane_tax_rate);

		// peaks and thoughs
		local preset_setting = MainClass.GetSetting("peaks-preset");
		local base_rates = MainClass.GetSetting("peaks-base");
		this.peaks_and_thoughs = PeaksAndThoughs(preset_setting, base_rates);

		this._data_loaded = true;
	}

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

		GSController.Sleep(1);
	}
}

function MainClass::HandleEvents() {
	while (GSEventController.IsEventWaiting()) {
		local ev = GSEventController.GetNextEvent();
		if (ev == null) continue;

		local ev_type = ev.GetEventType();
		switch (ev_type) {
			// 公司新建
			case GSEvent.ET_COMPANY_NEW: {
				local company_event = GSEventCompanyNew.Convert(ev);
				local company_id = company_event.GetCompanyID();

				Story.ShowMessage(company_id, GSText(GSText.WELCOME_MESSAGE, company_id, this._tax_base_rate, this._plane_tax_rate));

				GSCompany.ChangeBankBalance(company_id, GetAverageValue(1), GSCompany.EXPENSES_OTHER, GSMap.TILE_INVALID);
				break;
			}
		}
	}
}

function MainClass::EndOfMonth(month) {
	// 收税
	this.tax.TaxQuarterly();
}

function MainClass::EndOfYear(year) {
	// 环保税
	this.environmental.TaxPlaneYearAnnual();

}

function MainClass::EndOfHour(hour) {
	// 动态客流
	this.peaks_and_thoughs.Run(hour);
}

function MainClass::Save() {
	GSLog.Info("Saving game...");
	return {
		tax = this.tax.SaveGameData()
	};
}

function MainClass::Load(version, data) {
	GSLog.Info("Loading data from savegame made with version " + version + " of the game script");

	// tax
	local base_rates = MainClass.GetSetting("tax-base");
	if (data.rawin("tax")) {
		local tax_data = data.rawget("tax");
		this.tax = Tax(base_rates, tax_data);
		GSLog.Info("Found tax data in save file");
	} else {
		this.tax = Tax(base_rates, null);
		GSLog.Warning("No tax data found - initialising new tax")
	}

	// environmental
	local plane_tax_rate = MainClass.GetSetting("environment-plane-tax");
	this.environmental = Environmental(plane_tax_rate);

	// peaks and thoughs
	local preset_setting = MainClass.GetSetting("peaks-preset");
	local base_rates = MainClass.GetSetting("peaks-base");
	this.peaks_and_thoughs = PeaksAndThoughs(preset_setting, base_rates);

	this._data_loaded = true;
}