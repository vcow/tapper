package commands
{
	import events.UIEvent;

	import flash.events.IEventDispatcher;

	import models.ProfitInfo;
	import models.Unit;

	public class GameTickCommand extends CalcProfitCommandBase
	{
		[Inject]
		public var eventDispatcher:IEventDispatcher;

		override public function execute():void
		{
			gameModel.tickCount++;

			var profitList:Vector.<ProfitInfo> = new Vector.<ProfitInfo>();
			for (var i:int = 0, l:int = gameModel.units.length; i < l; i++) {
				var unit:Unit = gameModel.units[i];
				unit.tick();
				if (unit.info.perSecondProfit) profitList.push(unit.info.perSecondProfit);
			}
			calcProfitList(profitList);
			eventDispatcher.dispatchEvent(new UIEvent(UIEvent.UPDATE_MONEY));
		}
	}
}
