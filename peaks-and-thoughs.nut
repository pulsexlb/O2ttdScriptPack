class PeaksAndThoughs {
	time_rates = null;
	base_rates = null;
	constructor(preset_setting, base_rates) {
		switch (preset_setting) {
			case 1:
				GSLog.Info("Preset: Hyper peak");
				this.time_rates = [-1.69, -2.80, -5.32, -5.32, -5.32, -2.42, -0.97, 0.00, 1.70, 0.64, 0.15, 0.00, 0.00, 0.00, 0.00, 0.20, 0.68, 1.14, 1.32, 1.14, 0.38, 0.00, -1.00, -1.30];
				break;
			case 2:
				GSLog.Info("Preset: Equal peaks");
				this.time_rates = [-1.44, -2.58, -5.39, -5.39, -5.39, -2.59, -1.15, 0.79, 1.52, 0.52, 0.07, -0.07, -0.07, -0.07, -0.07, 0.16, 0.37, 0.97, 1.39, 1.21, 0.49, 0.14, -0.75, -1.05];
				break;
			case 3:
				GSLog.Info("Preset: Japan");
				this.time_rates = [-0.83, -2.07, -5.63, -5.63, -5.63, -2.32, -0.43, 1.13, 1.86, 0.30, -0.31, -0.31, -0.31, -0.31, -0.31, -0.31, 0.07, 0.61, 1.01, 0.87, 0.64, 0.42, 0.15, -0.17];
				break;
			case 4:
				GSLog.Info("Preset: UK");
				this.time_rates = [-4.76, -6.03, -6.41, -6.44, -5.31, -3.24, -1.41, 0.26, 1.72, 0.87, 0.63, 0.63, 0.63, 0.55, 0.57, 1.61, 0.91, 0.76, 0.56, -0.04, -0.76, -1.44, -1.85, -2.28];
				break;
			case 5:
				GSLog.Info("Preset: No peaks");
				this.time_rates = [-5.28, -5.28, -5.28, -5.28, -5.28, -5.28, -5.28, 0.72, 0.72, 0.72, 0.72, 0.72, 0.72, 0.72, 0.72, 0.72, 0.72, 0.72, 0.72, 0.72, 0.72, 0.72, -5.28, -5.28];
				break;
			default:
				GSLog.Error("Failed to recognise preset");
		}
		this.base_rates = base_rates;
	}
}

function PeaksAndThoughs::Run(current_time) {
	if (current_time >= 24) {
		GSLog.Warning("GetHour returned " + current_time);
		GSLog.Info("Hours set to 0");
		current_time = 0
	}

	local prod_rate = (this.time_rates[current_time] + this.base_rates) * 10

	if (prod_rate > 80) {
		GSLog.Info("Production rate capped at 8");
		prod_rate = 80;
	}
	if (prod_rate < -80) {
		GSLog.Info("Production rate capped at -8");
		prod_rate = -80;
	}

	GSLog.Info("Time is " + current_time);
	GSLog.Info("Production rate set to " + prod_rate);

	GSGameSettings.SetValue("economy.town_cargo_scale_factor", prod_rate.tointeger());
}
