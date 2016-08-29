package commands
{
	import models.ProfitInfo;
	import models.Unit;

	public class GameTickCommand extends CalcProfitCommandBase
	{
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
		}
	}
}
