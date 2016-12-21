package commands
{
	import models.ProfitInfo;
	import models.Unit;

	import org.puremvc.as3.multicore.interfaces.INotification;

	public class GameTickCommand extends CalcProfitCommandBase
	{
		override public function execute(notification:INotification):void
		{
			gameModel.tickCount++;

			var profitList:Vector.<ProfitInfo> = new Vector.<ProfitInfo>();
			for (var i:int = 0, l:int = gameModel.units.length; i < l; i++)
			{
				var unit:Unit = gameModel.units[i];
				if (unit.active)
				{
					unit.tick();
					if (unit.info.perSecondProfit) profitList.push(unit.info.perSecondProfit);
				}
			}

			if (calcProfitList(profitList))
				sendNotification(Const.UPDATE_MONEY);
		}
	}
}
