package models
{
	import resources.ConfigsLibrary;

	public class UnitsModel
	{
		private var _units:Vector.<UnitInfo>;

		public function UnitsModel()
		{
			_units = new Vector.<UnitInfo>();
			var units:XMLList = ConfigsLibrary.units.unit;
			for (var i:int = 0, l:int = units.length(); i < l; i++ ) _units.push(new UnitInfo(units[i]));
			_units.sort(sortByPrice);
		}

		private static function sortByPrice(a:UnitInfo, b:UnitInfo):int
		{
			if (a.price > b.price) return 1;
			else if (a.price < b.price) return -1;
			return 0;
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
