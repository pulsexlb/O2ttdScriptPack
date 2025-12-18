import("util.superlib", "SuperLib", 40);
Log <- SuperLib.Log;
Story <- SuperLib.Story;

require("tax.nut");

// 主游戏
class MainClass extends GSController {
	_data_loaded = false;  // 是否完成了存档加载
	tax = null;
	constructor() {}
}

// 开始
function MainClass::Start() {
	GSLog.Info("O2ttd Script Pack Inited!");

	if (!this._data_loaded) {
		this.tax = Tax(null);
		this._data_loaded = true;
	}

	// 存储上一次处理的经济月份
	local last_economy_month = GSDate.GetMonth(GSDate.GetCurrentDate());
	local last_economy_year = GSDate.GetYear(GSDate.GetCurrentDate());

	local last_loop_date = GSDate.GetCurrentDate();

	while (1) {
		local current_date = GSDate.GetCurrentDate();
		if (last_loop_date != null) {
			local month = GSDate.GetMonth(current_date);
			if (month != GSDate.GetMonth(last_loop_date)) {
				this.EndOfMonth();
			}
		}
		last_loop_date = current_date;

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

				Story.ShowMessage(company_id, GSText(GSText.WELCOME_MESSAGE, company_id));

				GSCompany.ChangeBankBalance(company_id, 4000, GSCompany.EXPENSES_OTHER, GSMap.TILE_INVALID);
				break;
			}
		}
	}
}

function MainClass::EndOfMonth() {
	// 收税
	this.tax.TaxQuarterly();
}

function MainClass::Save() {
	GSLog.Info("Saving game...");
	return {tax = this.tax.SaveGameData()};
}

function MainClass::Load(version, data) {
	GSLog.Info("Loading data from savegame made with version " + version + " of the game script");

	if(data.rawin("tax")) {
		local tax_data = data.rawget("tax");
		this.tax = Tax(tax_data);
		GSLog.Info("Found tax data in save file");
	} else {
		this.tax = Tax(null);
		GSLog.Warning("No tax data found - initialising new tax")
	}

	this._data_loaded = true;
}