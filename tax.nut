require("general.nut");

// 税收
class Tax {
	base_rate = null;
    max_rate = null;
	constructor(base_rate, max_rate, data) {
		if (data) {
			GSLog.Info("Loaded previous tax");
		}
		this.base_rate = base_rate.tofloat() / 100.0;
        this.max_rate = max_rate.tofloat() / 100.0;
		GSLog.Info("base_Rate" + base_rate + " " + this.base_rate + " max_rate " + max_rate + " " + this.max_rate);
	}
}

function Tax::TaxQuarterly() {
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
                if (tax_rate > this.max_rate) {
                    tax_rate = this.max_rate;
                }

                local tax_amount = (income * tax_rate).tointeger();

                GSLog.Info("Company " + id + " base rate: " + this.base_rate + " tax rate: " + tax_rate + ", income: " + income + ", tax: " + tax_amount + " (current value: " + current_value + ", average value: " + average_value + ")");

                // 从公司账户扣除税款
                GSCompany.ChangeBankBalance(id, -tax_amount, GSCompany.EXPENSES_OTHER, GSMap.TILE_INVALID);
                GSCompany.ChangeBankBalance(0, tax_amount, GSCompany.EXPENSES_OTHER, GSMap.TILE_INVALID);
                Story.ShowMessage(id, GSText(GSText.TAX_MESSAGE, income, (tax_rate * 100).tointeger(), tax_amount));
            } else {
                GSLog.Info("Company " + id + " has no income this quarter");
            }
        }
    }
}

// 返回保存游戏数据
function Tax::SaveGameData() {
	return {};
}
