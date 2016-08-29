package commands
{
	import models.ProfitInfo;
	import models.Unit;

	public class GameTapCommand extends CalcProfitCommandBase
	{
		override public function execute():void
		{
			gameModel.tapsTotal++;

			var profitList:Vector.<ProfitInfo> = new Vector.<ProfitInfo>();
			for (var i:int = 0, l:int = gameModel.units.length; i < l; i++) {
				var unit:Unit = gameModel.units[i];
				unit.tap();
				if (unit.info.perClickProfit) profitList.push(unit.info.perClickProfit);
			}
			calcProfitList(profitList, 1);
		}
	}
}
