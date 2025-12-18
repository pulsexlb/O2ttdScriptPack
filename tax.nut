// 税收
class Tax {
	quarter = 0;
	next_tax_loop = 2;
	constructor(data) {
		if (data) {
			this.quarter = data.quarter;
			this.next_tax_loop = data.next_tax_loop;
			GSLog.Info("Loaded previous tax quarter = " + this.quarter + " next_tax_loop = " + this.next_tax_loop);
		}
	}
}

function Tax::TaxQuarterly() {
	GSLog.Info("Next tax " + this.next_tax_loop);
	if (next_tax_loop == 0) {
		GSLog.Info("Processing tax for quarter " + this.quarter);

		// 获取全部公司平均价值
		local value_sum = 0;
		local company_num_sum = 0;
		for (local id = GSCompany.COMPANY_FIRST; id <= GSCompany.COMPANY_LAST; id++) {
			local resolved = GSCompany.ResolveCompanyID(id);
			if (resolved != GSCompany.COMPANY_INVALID) {
				local val = value_sum;
				value_sum = val + GSCompany.GetQuarterlyCompanyValue(id, 1);
				local com = company_num_sum;
				company_num_sum = com + 1;
			}
		}
		local average_value = value_sum / company_num_sum;

		// 收税
		local basic_tax_rate = 0.25; // 25%基本税率
		for (local id = GSCompany.COMPANY_FIRST; id <= GSCompany.COMPANY_LAST; id++) {
			local resolved = GSCompany.ResolveCompanyID(id);
			if (resolved != GSCompany.COMPANY_INVALID) {
				local income = GSCompany.GetQuarterlyIncome(id, 1);

				if (income > 0) {
					local current_value = GSCompany.GetQuarterlyCompanyValue(id, 1);
					local tax_rate = basic_tax_rate * current_value / average_value;

					local tax_amount = (income * tax_rate).tointeger();

					GSLog.Info("Company " + id + " tax rate: " + tax_rate + ", income: " + income + ", tax: " + tax_amount);

					// 从公司账户扣除税款
					GSCompany.ChangeBankBalance(id, -tax_amount, GSCompany.EXPENSES_OTHER, GSMap.TILE_INVALID);
					Story.ShowMessage(id, GSText(GSText.TAX_MESSAGE, income, (tax_rate * 100).tointeger(), tax_amount));
				} else {
					GSLog.Info("Company " + id + " has no income this quarter (" + this.quarter + ")");
				}
			}
		}
		local next_quarter = this.quarter + 1;
		this.quarter = next_quarter;
		this.next_tax_loop = 2;
	} else {
		local next_loop = this.next_tax_loop;
		this.next_tax_loop = next_loop - 1;
	}
}

// 返回保存游戏数据
function Tax::SaveGameData() {
	return {
		quarter = this.quarter,
		next_tax_loop = this.next_tax_loop
	};
}