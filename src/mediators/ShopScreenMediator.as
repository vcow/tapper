package mediators
{
	import events.BuyUnitEvent;
	import events.SwitchScreenEvent;
	import events.UIEvent;

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

			addContextListener(UIEvent.UPDATE_MONEY, onUpdateMoney);

			onUpdateMoney();
			ShopScreen(view).unitsList = new ListCollection(unitsModel.units);
		}

		private function onUpdateMoney(event:UIEvent = null):void
		{
			ShopScreen(view).money = Math.round(gameModel.money);

			if (event) {
				ShopScreen(view).scrollToLastAvailable();
			}
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
			var unit:UnitInfo = event.data as UnitInfo;
			if (unit) {
				if (unit.price >= 0) ShopScreen(view).buyUnit(unit, unit.price <= gameModel.money);
			}
		}

		private function onBack(event:Event):void
		{
			dispatch(new SwitchScreenEvent(SwitchScreenEvent.POP));
		}
	}
}
