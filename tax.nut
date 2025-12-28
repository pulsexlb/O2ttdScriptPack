require("general.nut");

// 税收
class Tax {
	quarter = 0;
	next_tax_loop = 2;
	base_rate = null;
	constructor(base_rate, data) {
		if (data) {
			this.quarter = data.quarter;
			this.next_tax_loop = data.next_tax_loop;
			GSLog.Info("Loaded previous tax quarter = " + this.quarter + " next_tax_loop = " + this.next_tax_loop);
		}
		this.base_rate = base_rate.tofloat() / 100.0;
		GSLog.Info("base_Rate" + base_rate + " " + this.base_rate);
	}
}

function Tax::TaxQuarterly() {
	GSLog.Info("Next tax " + this.next_tax_loop);
	if (next_tax_loop == 0) {
		GSLog.Info("Processing tax for quarter " + this.quarter);

		// 获取全部公司平均价值
		local average_value = GetAverageValue(1);

		// 收税
		for (local id = GSCompany.COMPANY_FIRST; id <= GSCompany.COMPANY_LAST; id++) {
			local resolved = GSCompany.ResolveCompanyID(id);
			if (resolved != GSCompany.COMPANY_INVALID && resolved != 0) {
				local income = GSCompany.GetQuarterlyIncome(id, 1);

				if (income > 0) {
					local current_value = GSCompany.GetQuarterlyCompanyValue(id, 1);
					local tax_rate = this.base_rate * current_value / average_value;

					local tax_amount = (income * tax_rate).tointeger();

					GSLog.Info("Company " + id + " base rate: " + this.base_rate + " tax rate: " + tax_rate + ", income: " + income + ", tax: " + tax_amount);

					// 从公司账户扣除税款
					GSCompany.ChangeBankBalance(id, -tax_amount, GSCompany.EXPENSES_OTHER, GSMap.TILE_INVALID);
                    GSCompany.ChangeBankBalance(0, tax_amount, GSCompany.EXPENSES_OTHER, GSMap.TILE_INVALID);
					Story.ShowMessage(id, GSText(GSText.TAX_MESSAGE, income, (tax_rate * 100).tointeger(), tax_amount));
				} else {
					GSLog.Info("Company " + id + " has no income this quarter (" + this.quarter + ")");
				}
			}
		}
		this.quarter += 1;
		this.next_tax_loop = 2;
	} else {
		this.next_tax_loop -= 1;
	}
}

// 返回保存游戏数据
function Tax::SaveGameData() {
	return {
		quarter = this.quarter,
		next_tax_loop = this.next_tax_loop
	};
}
