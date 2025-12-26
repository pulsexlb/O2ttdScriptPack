class TeamLimit {
    constructor() {}
}

function TeamLimit::Run() {
    for (local company = GSCompany.COMPANY_FIRST; company <= GSCompany.COMPANY_LAST; company++) {
		local resolved = GSCompany.ResolveCompanyID(company);
		if (resolved != GSCompany.COMPANY_INVALID) {
            
			local company_mode = GSCompanyMode(company);
			local vehs = GSVehicleList();

			vehs.Valuate(function(vehicle_id) {
				return vehicle_id;
			});
			
			foreach(veh in vehs) {
				if (!GSVehicle.IsValidVehicle(veh)) {
					continue;
				}
				if (GSOrder.IsGotoStationOrder(veh, GSOrder.ORDER_CURRENT)) {
                    local order_destination = GSOrder.GetOrderDestination(veh, GSOrder.ORDER_CURRENT);
                    local destination_owner = GSTile.GetOwner(order_destination);
                    if (GSCompany.ResolveCompanyID(destination_owner) != GSCompany.COMPANY_INVALID) {
                        if (destination_owner % 2 != company % 2 && destination_owner != 0) {
                            // 不同团队，删除
                            GSLog.Info("TeamLimit: Removed vehicle " + veh + " name " + GSVehicle.GetName(veh)+ " owned by company " + company + " trying to go to station owned by company " + destination_owner + " remove order " + GSOrder.ORDER_CURRENT.tointeger());
                            GSOrder.RemoveOrder(veh, GSOrder.ORDER_CURRENT);
                            // GSNews.Create(GSNews.NT_ADVICE, GSText(GSText.NOT_SAME_TEAM_ORDER).AddParam(GSVehicle.GetName(veh)), company, GSNews.NR_TILE, order_destination);
                            // TODO: 我希望在这里展示信息，但是似乎这样不会创建消息
                        }
                    }
                }
			}
		}
	}
}
