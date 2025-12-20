require("general.nut");

class Environmental {
	plane_tax_rate = null;
	constructor(plane_tax_rate) {
		this.plane_tax_rate = plane_tax_rate.tofloat() / 100.0;
	}
}

function Environmental::TaxPlaneYearAnnual() {
	GSLog.Info("Environmental Tax (Plane) Start");

	local company_air_income = {};

	for (local company = GSCompany.COMPANY_FIRST; company <= GSCompany.COMPANY_LAST; company++) {
		local resolved = GSCompany.ResolveCompanyID(company);
		if (resolved != GSCompany.COMPANY_INVALID) {
			local company_mode = GSCompanyMode(company);
			local company_key = company.tostring();
			local air_vehs = GSVehicleList();
			air_vehs.Valuate(function(vehicle_id) {
				if (GSVehicle.GetVehicleType(vehicle_id) == GSVehicle.VT_AIR) {
					return vehicle_id;
				} else {
					return -1;
				}
			});

			foreach(veh in air_vehs) {
				if (!GSVehicle.IsValidVehicle(veh)) {
					continue;
				}
				local actual_owner = GSVehicle.GetOwner(veh);
				local income = GSVehicle.GetProfitLastYear(veh);
				local this_year_income = GSVehicle.GetProfitThisYear(veh);

				GSLog.Info("veh id " + veh + " owner" + company + "actual owner" + actual_owner + "last income " + income + " last " + this_year_income);

				if (company_air_income.rawin(company_key)) {
					local current_income = company_air_income.rawget(company_key);
					company_air_income.rawset(company_key, current_income + income);
				} else {
					company_air_income.rawset(company_key, income);
				}
			}
		}
	}

	foreach(company_key, air_income in company_air_income) {
		local company = company_key.tointeger();
		local tax_rate = this.plane_tax_rate;
		local tax_amount = (air_income * tax_rate).tointeger();
		if (air_income > 0) {
			GSLog.Info("Plane Tax: Company " + company + " tax rate: " + tax_rate + ", income: " + air_income + ", tax: " + tax_amount);
			GSCompany.ChangeBankBalance(company, -tax_amount, GSCompany.EXPENSES_AIRCRAFT_RUN, GSMap.TILE_INVALID);
			Story.ShowMessage(company, GSText(GSText.ENVIRONMENTAL_TAX_MESSAGE, air_income, (tax_rate * 100).tointeger(), tax_amount));
		}
	}
}