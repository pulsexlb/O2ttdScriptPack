class FMainClass extends GSInfo {
	function GetAuthor() { return "PulseX"; }
	function GetName() { return "O2ttd Script Pack"; }
	function GetDescription() { return "Some modify for openttd"; }
	function GetVersion() { return 1; }
	function GetDate() { return "2025.11.13"; }
	function CreateInstance() { return "MainClass"; }
	function GetShortName()	{ return "O2SP"; }
	function GetAPIVersion() { return "15"; }
	function GetURL() { return ""; }

	function GetSettings() {}
}

RegisterGS(FMainClass());
