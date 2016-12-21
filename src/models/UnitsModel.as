package models
{
	import org.puremvc.as3.multicore.core.Model;

	import resources.ConfigsLibrary;

	public class UnitsModel extends Model
	{
		public static const NAME:String = "unitsModel";

		private var _units:Vector.<UnitInfo>;

		public function UnitsModel(key:String)
		{
			super(key);
		}

		override protected function initializeModel():void
		{
			_units = new Vector.<UnitInfo>();
			var units:XMLList = ConfigsLibrary.units.unit;
			for (var i:int = 0, l:int = units.length(); i < l; i++) _units.push(new UnitInfo(units[i]));
		}

		public function get units():Vector.<UnitInfo>
		{
			return _units;
		}

		public function getUnitById(id:String):UnitInfo
		{
			for (var i:int = 0, l:int = _units.length; i < l; i++)
			{
				if (_units[i].id == id) return _units[i];
			}
			return null;
		}
	}
}
