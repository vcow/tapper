package commands
{
	import events.ActionEvent;
	import events.BuyUnitEvent;
	import events.UIEvent;

	import flash.events.IEventDispatcher;

	import gears.TriggerBroadcaster;

	import models.Unit;

	import robotlegs.bender.framework.api.IInjector;

	public class BuyUnitCommand extends CalcProfitCommandBase
	{
		[Inject]
		public var event:BuyUnitEvent;

		[Inject]
		public var eventDispatcher:IEventDispatcher;

		[Inject]
		public var injector:IInjector;

		[Inject]
		public var triggerBroadcaster:TriggerBroadcaster;

		override public function execute():void
		{
			if (gameModel.money >= event.unit.price) {
				var unit:Unit = new Unit(event.unit, event.unit.price,
						event.unit.perClickProfit || event.unit.perSecondProfit);
				gameModel.money -= event.unit.price;

				injector.injectInto(unit);
				gameModel.units.push(unit);
				gameModel.units.sort(sortByPrice);

				if (unit.info.profit) {
					calcProfit(unit.info.profit);
				}

				if (unit.info.action) {
					eventDispatcher.dispatchEvent(new ActionEvent(unit.info.action.id));
				}

				triggerBroadcaster.broadcast(TriggerBroadcaster.BUY, event.unit);

				eventDispatcher.dispatchEvent(new UIEvent(UIEvent.UPDATE_MONEY));
				eventDispatcher.dispatchEvent(new UIEvent(UIEvent.UPDATE_UNITS_LIST));
			}
		}

		private static function sortByPrice(a:Unit, b:Unit):int
		{
			if (a.buyPrice < b.buyPrice) return 1;
			else if (a.buyPrice > b.buyPrice) return -1;
			return 0;
		}
	}
}
