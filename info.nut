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
            name = "peaks-enabled",
            description = "Global: Enable PeaksAndThoughs",
            easy_value = 1,
            medium_value = 1,
            hard_value = 1,
            custom_value = 1,
            flags = CONFIG_BOOLEAN
        });
        AddSetting({
            name = "tax-enabled",
            description = "Global: Enable Tax",
            easy_value = 1,
            medium_value = 1,
            hard_value = 1,
            custom_value = 1,
            flags = CONFIG_BOOLEAN
        });
        AddSetting({
            name = "environment-tax-enabled",
            description = "Global: Enable Environmental Plane Tax",
            easy_value = 1,
            medium_value = 1,
            hard_value = 1,
            custom_value = 1,
            flags = CONFIG_BOOLEAN
        });
        AddSetting({
            name = "rvg-enabled",
            description = "Global: Enable RVG",
            easy_value = 1,
            medium_value = 1,
            hard_value = 1,
            custom_value = 1,
            flags = CONFIG_BOOLEAN
        });
        AddSetting({
            name = "teams-enabled",
            description = "Global: Enable Team Limit",
            easy_value = 1,
            medium_value = 1,
            hard_value = 1,
            custom_value = 1,
            flags = CONFIG_BOOLEAN
        });

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
			easy_value = 15,
			medium_value = 25,
			hard_value = 30,
			custom_value = 25,
			flags = CONFIG_INGAME,
			min_value = 0,
			max_value = 100
		});

		AddSetting({
			name = "environment-plane-tax",
			description = "Environmental: Plane tax rate(%)(set 0 to disable)",
			easy_value = 50,
			medium_value = 65,
			hard_value = 80,
			custom_value = 75,
			flags = CONFIG_INGAME,
			min_value = 0,
			max_value = 100
		});

        // RVG
        AddSetting({ name = "town_info_mode",
                description = "RVG: Town info display mode",
                easy_value = 1,
                medium_value = 1,
                hard_value = 1,
                custom_value = 1,
                flags = CONFIG_INGAME, min_value = 1, max_value = 5 });
        AddLabels("town_info_mode", {
                    _1 = "Automatic",
                    _2 = "Category deliveries",
                    _3 = "Cargo list",
                    _4 = "Combined",
                    _5 = "Full cargo list" });

        AddSetting({ name = "goal_scale_factor",
                description = "RVG: Difficulty level (easy = 60, normal = 100, hard = 140)",
                easy_value = 60,
                medium_value = 100,
                hard_value = 140,
                custom_value = 100,
                flags = CONFIG_INGAME, min_value = 1, max_value = 50000, step_size = 20 });

        AddSetting({ name = "use_town_sign",
                description = "RVG: Show growth rate text under town names",
                easy_value = 1,
                medium_value = 1,
                hard_value = 1,
                custom_value = 1,
                flags = CONFIG_BOOLEAN | CONFIG_INGAME });

        AddSetting({ name = "eternal_love",
                description = "RVG: Eternal love from towns",
                easy_value = 1,
                medium_value = 3,
                hard_value = 0,
                custom_value = 0,
                flags = CONFIG_INGAME, min_value = 0, max_value = 3 });
        AddLabels("eternal_love", { _0 = "Off",
                    _1 = "Outstanding",
                    _2 = "Good",
                    _3 = "Poor" });

        AddSetting({
                name = "cargo_6_category",
                description = "RVG: Cargo: Use 6 cargo categories for supported economies",
                easy_value = 1,
                medium_value = 1,
                hard_value = 1,
                custom_value = 1,
                flags = CONFIG_BOOLEAN | CONFIG_INGAME });

        AddSetting({ name = "cargo_randomization",
                description = "RVG: Randomization: Type",
                easy_value = 1,
                medium_value = 7,
                hard_value = 10,
                custom_value = 10,
                flags = CONFIG_INGAME, min_value = 1, max_value = 15 });
        AddLabels("cargo_randomization", {
                    _1 = "None",
                    _2 = "Industry descending",
                    _3 = "Industry ascending",
                    _4 = "1 per category",
                    _5 = "2 per category",
                    _6 = "3 per category",
                    _7 = "5 per category",
                    _8 = "7 per category",
                    _9 = "1-2 per category",
                    _10 = "1-3 per category",
                    _11 = "2-3 per category",
                    _12 = "3-5 per category",
                    _13 = "3-7 per category",
                    _14 = "Descending",
                    _15 = "Ascending" });

        AddSetting({ name = "near_cargo_probability",
                    description = "RVG: Randomization: Probability to use nearby cargo types [%]",
                    easy_value = 100,
                    medium_value = 50,
                    hard_value = 0,
                    custom_value = 50,
                    flags = CONFIG_INGAME, min_value = 0, max_value = 100, step_size = 10});

        AddSetting({ name = "display_cargo",
                description = "RVG: Randomization: Show town cargos from start",
                easy_value = 1,
                medium_value = 0,
                hard_value = 0,
                custom_value = 0,
                flags = CONFIG_BOOLEAN | CONFIG_INGAME});

        AddSetting({ name = "raw_industry_density",
                description = "RVG: Industry stabilizer: Raw industry density",
                easy_value = 0,
                medium_value = 0,
                hard_value = 0,
                custom_value = 0,
                flags = CONFIG_INGAME, min_value = 0, max_value = 5});
        AddLabels("raw_industry_density", {
                    _0 = "Funding only",
                    _1 = "Minimal",
                    _2 = "Very Low",
                    _3 = "Low",
                    _4 = "Normal",
                    _5 = "High" });

        AddSetting({
            name = "limit_min_transport",
            description = "RVG: Limit Growth: Minimum percentage of transported cargo from town",
            easy_value = 40,
            medium_value = 50,
            hard_value = 65,
            custom_value = 50,
            flags = CONFIG_INGAME, min_value = 0, max_value = 100, step_size = 5});

        AddSetting({
            name = "town_size_threshold",
            description = "RVG: Limit Growth: Minimum size of town before the limit rules kicks in",
            easy_value = 800,
            medium_value = 550,
            hard_value = 350,
            custom_value = 350,
            flags = CONFIG_INGAME, min_value = 0, max_value = 50000, step_size = 25});

        AddSetting({
            name = "limiter_delay",
            description = "RVG: Limit Growth: Stop growth after set amount of months",
            easy_value = 3,
            medium_value = 1,
            hard_value = 0,
            custom_value = 1,
            flags = CONFIG_INGAME, min_value = 0, max_value = 12, step_size = 1});

        AddSetting({
            name = "subsidies_type",
            description = "RVG: Subsidies: Create subsidies for contributed towns",
            easy_value = 1,
            medium_value = 1,
            hard_value = 1,
            custom_value = 1,
            flags = CONFIG_INGAME, min_value = 0, max_value = 3});
        AddLabels("subsidies_type", {
                _0 = "None",
                _1 = "All",
                _2 = "Passenger",
                _3 = "Cargo"});

        AddSetting({
            name = "category_1_min_pop",
            description = "RVG: Category 1: Minimum population demand (-1 = default)",
            easy_value = -1,
            medium_value = -1,
            hard_value = -1,
            custom_value = -1,
            flags = CONFIG_INGAME, min_value = -1, max_value = 100000, step_size = 100});

        AddSetting({
            name = "category_2_min_pop",
            description = "RVG: Category 2: Minimum population demand (-1 = default)",
            easy_value = -1,
            medium_value = -1,
            hard_value = -1,
            custom_value = -1,
            flags = CONFIG_INGAME, min_value = -1, max_value = 100000, step_size = 100});

        AddSetting({
            name = "category_3_min_pop",
            description = "RVG: Category 3: Minimum population demand (-1 = default)",
            easy_value = -1,
            medium_value = -1,
            hard_value = -1,
            custom_value = -1,
            flags = CONFIG_INGAME, min_value = -1, max_value = 100000, step_size = 100});

        AddSetting({
            name = "category_4_min_pop",
            description = "RVG: Category 4: Minimum population demand (-1 = default)",
            easy_value = -1,
            medium_value = -1,
            hard_value = -1,
            custom_value = -1,
            flags = CONFIG_INGAME, min_value = -1, max_value = 100000, step_size = 100});

        AddSetting({
            name = "category_5_min_pop",
            description = "RVG: Category 5: Minimum population demand (-1 = default)",
            easy_value = -1,
            medium_value = -1,
            hard_value = -1,
            custom_value = -1,
            flags = CONFIG_INGAME, min_value = -1, max_value = 100000, step_size = 100});

        AddSetting({
            name = "category_6_min_pop",
            description = "RVG: Category 6: Minimum population demand (-1 = default)",
            easy_value = -1,
            medium_value = -1,
            hard_value = -1,
            custom_value = -1,
            flags = CONFIG_INGAME, min_value = -1, max_value = 100000, step_size = 100});

        AddSetting({ name = "town_growth_factor",
                description = "RVG: Expert: town growth factor",
                easy_value = 50,
                medium_value = 100,
                hard_value = 200,
                custom_value = 100,
                flags = CONFIG_INGAME, min_value = 20, max_value = 50000, step_size = 20 });

        AddSetting({ name = "supply_impacting_part",
                description = "RVG: Expert: minimum fulfilled percentage for TGR growth",
                easy_value = 30,
                medium_value = 50,
                hard_value = 70,
                custom_value = 50,
                flags = CONFIG_INGAME, min_value = 0, max_value = 100, step_size = 5 });

        AddSetting({ name = "exponentiality_factor",
                description = "RVG: Expert: TGR growth exponentiality factor",
                easy_value = 3,
                medium_value = 3,
                hard_value = 3,
                custom_value = 3,
                flags = CONFIG_INGAME, min_value = 1, max_value = 5 });

        AddSetting({ name = "lowest_town_growth_rate",
                description = "RVG: Expert: slowest TGR if requirements are not met",
                easy_value = 365,
                medium_value = 550,
                hard_value = 880,
                custom_value = 550,
                flags = CONFIG_INGAME, min_value = 0, max_value = 880, step_size = 10 });

        AddSetting({ name = "allow_0_days_growth",
                description = "RVG: Expert: allow 0 days growth",
                easy_value = 0,
                medium_value = 0,
                hard_value = 0,
                custom_value = 0,
                flags = CONFIG_BOOLEAN | CONFIG_INGAME});

        AddSetting({ name = "log_level",
                description = "Debug: Log level (higher = print more)",
                easy_value = 1,
                medium_value = 1,
                hard_value = 1,
                custom_value = 1,
                flags = CONFIG_INGAME, min_value = 1, max_value = 3 });
        AddLabels("log_level", { _1 = "1: Info", _2 = "2: Cargo", _3 = "3: Debug" });
	}
}

RegisterGS(FMainClass());
