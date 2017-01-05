package proxy
{
	import models.*;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	import vo.UnitInfo;

	public class UnitsProxy extends Proxy
	{
		public static const NAME:String = "unitsProxy";

		private var _units:Vector.<UnitInfo>;

		public function UnitsProxy(data:Object = null)
		{
			super(NAME, data);
		}

		override public function setData(data:Object):void
		{
			super.setData(data);

			_units = new Vector.<UnitInfo>();
			var src:XML = data as XML;
			if (src)
			{
				var units:XMLList = src.unit;
				for (var i:int = 0, l:int = units.length(); i < l; i++)
				{
					var unitInfo:UnitInfo = new UnitInfo(units[i]);
					unitInfo.initializeNotifier(multitonKey);
					_units.push(unitInfo);
				}
			}
		}

		public function get units():Vector.<UnitInfo>
		{
			return _units;
		}

		public function getUnitById(id:String):UnitInfo
		{
			for (var i:int = 0, l:int = _units.length; i < l; i++)
			{
				if (_units[i].id == id)
					return _units[i];
			}
			return null;
		}
	}
}
