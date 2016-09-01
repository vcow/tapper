package mediators
{
	import events.SwitchScreenEvent;
	import events.UIEvent;

	import flash.utils.Dictionary;

	import models.GameModel;
	import models.UnitInfo;
	import models.UnitsModel;

	import robotlegs.starling.bundles.mvcs.Mediator;

	import starling.events.Event;

	import view.ShopWidget;

	public class ShopWidgetMediator extends Mediator
	{
		private var _availableUnits:Dictionary;
		private var _lastMoney:Number = 0;

		[Inject]
		public var view:ShopWidget;

		[Inject]
		public var unitsModel:UnitsModel;

		[Inject]
		public var gameModel:GameModel;

		public function ShopWidgetMediator()
		{
			super();
		}

		override public function initialize():void
		{
			addViewListener(ShopWidget.GO_TO_SHOP, onGoToShop);
			addViewListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

			addContextListener(UIEvent.UPDATE_MONEY, onUpdateMoney);
		}

		private function onRemovedFromStage(event:Event):void
		{
			removeViewListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addViewListener(Event.ADDED_TO_STAGE, onAddedToStage);

			removeContextListener(UIEvent.UPDATE_MONEY, onUpdateMoney);
		}

		private function onAddedToStage(event:Event):void
		{
			removeViewListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addViewListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

			addContextListener(UIEvent.UPDATE_MONEY, onUpdateMoney);
		}

		private function onUpdateMoney(event:UIEvent = null):void
		{
			if (_lastMoney > gameModel.money) _availableUnits = null;
			_lastMoney = gameModel.money;

			var availableUnits:Dictionary = new Dictionary(true);
			var newAvailable:Array = [];

			for (var i:int = 0, l:int = unitsModel.units.length; i < l; i++) {
				var unit:UnitInfo = unitsModel.units[i];
				if (unit.price <= _lastMoney) {
					availableUnits[unit] = true;
					if (!_availableUnits || !_availableUnits[unit]) newAvailable.push(unit);
				}
			}
			_availableUnits = availableUnits;

			if (newAvailable.length > 0) {
				newAvailable.sortOn("price");
				ShopWidget(view).data = newAvailable[newAvailable.length - 1];
			}
		}

		private function onGoToShop(event:Event):void
		{
			dispatch(new SwitchScreenEvent(SwitchScreenEvent.SWITCH_TO_SHOP));
		}
	}
}
