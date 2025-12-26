// 获取当前全部公司的平均市值
function GetAverageValue(quarter) {
	local value_sum = 0;
	local company_num_sum = 0;
	for (local id = GSCompany.COMPANY_FIRST; id <= GSCompany.COMPANY_LAST; id++) {
		local resolved = GSCompany.ResolveCompanyID(id);
		if (resolved != GSCompany.COMPANY_INVALID && resolved != 0) {  // 公司0特殊不计入
			value_sum += GSCompany.GetQuarterlyCompanyValue(id, quarter);
			company_num_sum += 1;
		}
	}
	return value_sum / company_num_sum;
}
