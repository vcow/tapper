package commands
{
	import events.UIEvent;

	import flash.events.IEventDispatcher;

	import models.ProfitInfo;
	import models.Unit;

	public class GameTapCommand extends CalcProfitCommandBase
	{
		[Inject]
		public var eventDispatcher:IEventDispatcher;

		override public function execute():void
		{
			gameModel.tapsTotal++;

			var profitList:Vector.<ProfitInfo> = new Vector.<ProfitInfo>();
			for (var i:int = 0, l:int = gameModel.units.length; i < l; i++) {
				var unit:Unit = gameModel.units[i];
				if (unit.active) {
					unit.tap();
					if (unit.info.perClickProfit) profitList.push(unit.info.perClickProfit);
				}
			}

			if (calcProfitList(profitList, 1)) {
				eventDispatcher.dispatchEvent(new UIEvent(UIEvent.UPDATE_MONEY));
			}
		}
	}
}
