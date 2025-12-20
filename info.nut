class FMainClass extends GSInfo {
	function GetAuthor() {
		return "PulseX";
	}
	function GetName() {
		return "O2ttd Script Pack";
	}
	function GetDescription() {
		return "Some modify for openttd";
	}
	function GetVersion() {
		return 1;
	}
	function GetDate() {
		return "2025.11.13";
	}
	function CreateInstance() {
		return "MainClass";
	}
	function GetShortName() {
		return "O2SP";
	}
	function GetAPIVersion() {
		return "15";
	}
	function GetURL() {
		return "";
	}

	function GetSettings() {
		AddSetting({
			name = "peaks-preset",
			description = "PeaksAndThoughs: Preset",
			easy_value = 2,
			medium_value = 2,
			hard_value = 2,
			custom_value = 2,
			flags = CONFIG_INGAME,
			min_value = 1,
			max_value = 5
		});
		AddLabels("peaks-preset", {
			_1 = "Hyperpeak",
			_2 = "Equal peaks",
			_3 = "Japan",
			_4 = "UK",
			_5 = "No peaks"
		});
		AddSetting({
			name = "peaks-base",
			description = "PeaksAndThoughs: Passenger rate offset",
			easy_value = 1,
			medium_value = 1,
			hard_value = 1,
			custom_value = 1,
			flags = CONFIG_INGAME,
			min_value = -4,
			max_value = 6
		});
		AddSetting({
			name = "tax-base",
			description = "Tax: Base tax rate(%)(set 0 to disable)",
			easy_value = 1,
			medium_value = 1,
			hard_value = 1,
			custom_value = 1,
			flags = CONFIG_INGAME,
			min_value = 0,
			max_value = 100
		});
		AddSetting({
			name = "environment-plane-tax",
			description = "Environmental: Plane tax rate(%)(set 0 to disable)",
			easy_value = 1,
			medium_value = 1,
			hard_value = 1,
			custom_value = 1,
			flags = CONFIG_INGAME,
			min_value = 0,
			max_value = 100
		});
	}
}

RegisterGS(FMainClass());