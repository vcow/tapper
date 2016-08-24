package commands
{
	import app.AppFacade;

	import models.GameModel;
	import models.ProfitInfo;
	import vo.Unit;

	import org.puremvc.as3.multicore.interfaces.INotification;

	/**
	 * Команда тика таймера. Рассчитывает профит.
	 */
	public class GameTickCommand extends CalcProfitCommandBase
	{
		override public function execute(notification:INotification):void
		{
			var gameModel:GameModel = AppFacade(facade).gameModel;
			gameModel.tickCount++;

			var profitList:Vector.<ProfitInfo> = new Vector.<ProfitInfo>();
			var units:Vector.<Unit> = gameModel.getUnits();
			for (var i:int = 0, l:int = units.length; i < l; i++)
			{
				var unit:Unit = units[i];
				if (unit.active)
				{
					unit.tick();
					if (unit.info.perSecondProfit) profitList.push(unit.info.perSecondProfit);
				}
			}

			if (calcProfitList(profitList))
				sendNotification(Const.UPDATE_MONEY, gameModel.money);
		}
	}
}
