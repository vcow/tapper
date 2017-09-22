package models
{
	import app.AppFacade;

	import org.puremvc.as3.multicore.patterns.facade.Facade;

	import proxy.UnitsProxy;

	import vo.UnitInfo;

	/**
	 * Условие на покупку юзером юнита определенного уровня.
	 */
	public class TopCondition extends ConditionBase
	{
		private var _unitIndex:int = -1;
		private var _rawUnitIndex:String;

		private var _gameModel:GameModel;

		public function TopCondition(src:XML)
		{
			super(true);

			if (src.hasOwnProperty("@min")) _min = Number(src.@min);
			if (src.hasOwnProperty("@max")) _max = Number(src.@max);
			if (src.children().length() > 0)
				_rawUnitIndex = src.children()[0];
			else
				throw Error("Index or unit id must be specified for Top condition.");

			_gameModel = AppFacade(Facade.getInstance(AppFacade.NAME)).gameModel;
		}

		public function get unitIndex():int
		{
			if (_unitIndex < 0)
			{
				var unitsProxy:UnitsProxy = UnitsProxy(AppFacade(Facade.getInstance(AppFacade.NAME)).retrieveProxy(UnitsProxy.NAME));
				var unitInfo:UnitInfo = unitsProxy.getUnitById(_rawUnitIndex);
				_unitIndex = unitInfo ? unitInfo.index : int(_rawUnitIndex);
			}
			return _unitIndex;
		}

		override public function check(value:Number):Boolean
		{
			if (_lock && _reached) return true;
			if (_gameModel.topUnitIndex < unitIndex) return false;
			var unitsCount:int;
			for (var i:int = unitIndex; i <= _gameModel.topUnitIndex; i++)
				unitsCount += _gameModel.getUnitsCountByIndex(i);
			return super.check(unitsCount);
		}
	}
}
