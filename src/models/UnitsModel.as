package models
{
	import resources.ConfigsLibrary;

	import robotlegs.bender.framework.api.IInjector;

	public class UnitsModel
	{
		private var _units:Vector.<UnitInfo>;

		[Inject]
		public var injector:IInjector;

		[PostConstruct]
		public function postConstruct():void
		{
			for each (var unit:UnitInfo in _units) injector.injectInto(unit);
		}

		public function UnitsModel()
		{
			_units = new Vector.<UnitInfo>();
			var units:XMLList = ConfigsLibrary.units.unit;
			for (var i:int = 0, l:int = units.length(); i < l; i++ ) _units.push(new UnitInfo(units[i]));
		}

		public function get units():Vector.<UnitInfo>
		{
			return _units;
		}

		public function getUnitById(id:String):UnitInfo
		{
			for (var i:int = 0, l:int = _units.length; i < l; i++) {
				if (_units[i].id == id) return _units[i];
			}
			return null;
		}
	}
}
