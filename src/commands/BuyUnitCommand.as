package commands
{
	import events.BuyUnitEvent;
	import events.UIEvent;

	import flash.events.IEventDispatcher;

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

		override public function execute():void
		{
			if (gameModel.money >= event.unit.price) {
				var unit:Unit = new Unit(event.unit);
				gameModel.money -= unit.info.price;

				if (unit.info.perClickProfit || unit.info.perSecondProfit) {
					injector.injectInto(unit);
					gameModel.units.push(unit);
					gameModel.units.sort(sortByPrice);

					eventDispatcher.dispatchEvent(new UIEvent(UIEvent.UPDATE_MONEY));
					eventDispatcher.dispatchEvent(new UIEvent(UIEvent.UPDATE_UNITS_LIST));
				}

				if (unit.info.profit) {
					calcProfit(unit.info.profit);
				}

				if (unit.info.action) {
					// TODO:
				}
			}
		}

		private static function sortByPrice(a:Unit, b:Unit):int
		{
			if (a.info.price < b.info.price) return 1;
			else if (a.info.price > b.info.price) return -1;
			return 0;
		}
	}
}
