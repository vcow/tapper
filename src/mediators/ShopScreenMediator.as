package mediators
{
	import events.BuyUnitEvent;
	import events.SwitchScreenEvent;

	import feathers.data.ListCollection;

	import models.GameModel;
	import models.UnitInfo;
	import models.UnitsModel;

	import robotlegs.starling.bundles.mvcs.Mediator;

	import starling.events.Event;

	import view.ShopScreen;

	public class ShopScreenMediator extends Mediator
	{
		[Inject]
		public var gameModel:GameModel;

		[Inject]
		public var unitsModel:UnitsModel;

		[Inject]
		public var view:ShopScreen;

		public function ShopScreenMediator()
		{
			super();
		}

		override public function initialize():void
		{
			addViewListener(ShopScreen.BACK, onBack);
			addViewListener(ShopScreen.SELECT_UNIT, onSelectUnit);
			addViewListener(ShopScreen.BUY_UNIT, onBuyUnit);

			var listData:Array = [];
			for (var i:int = 0, l:int = unitsModel.units.length; i < l; i++) {
				var unit:UnitInfo = unitsModel.units[i];
				listData.push({
					data: unit,
					available: unit.price <= gameModel.money
				});
			}

			ShopScreen(view).money = gameModel.money;
			ShopScreen(view).unitsList = new ListCollection(listData);
		}

		private function onBuyUnit(event:Event):void
		{
			var unit:UnitInfo = event.data as UnitInfo;
			if (unit) {
				dispatch(new BuyUnitEvent(BuyUnitEvent.BUY, unit));
			}
		}

		private function onSelectUnit(event:Event):void
		{
			var unit:UnitInfo = event.data.data as UnitInfo;
			if (unit) {
				ShopScreen(view).buyUnit(unit, event.data.available);
			}
		}

		private function onBack(event:Event):void
		{
			dispatch(new SwitchScreenEvent(SwitchScreenEvent.POP));
		}
	}
}
