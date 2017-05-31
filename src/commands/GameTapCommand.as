package commands
{
	import app.AppFacade;

	import flash.utils.getTimer;

	import models.GameModel;
	import models.ProfitInfo;
	import vo.Unit;

	import org.puremvc.as3.multicore.interfaces.INotification;

	public class GameTapCommand extends CalcProfitCommandBase
	{
		override public function execute(notification:INotification):void
		{
			var gameModel:GameModel = AppFacade(facade).gameModel;
			if (!gameModel.isStarted)
				sendNotification(Const.START_GAME);
			else
				gameModel.lastActivityTimestamp = getTimer();

			gameModel.tapsTotal++;
			sendNotification(Const.UPDATE_TAPS, gameModel.tapsTotal);

			var profitList:Vector.<ProfitInfo> = new Vector.<ProfitInfo>();
			var units:Vector.<Unit> = gameModel.getUnits();
			for (var i:int = 0, l:int = units.length; i < l; i++)
			{
				var unit:Unit = units[i];
				if (unit.active)
				{
					unit.tap();
					if (unit.info.perClickProfit) profitList.push(unit.info.perClickProfit);
				}
			}

			if (calcProfitList(profitList, 1))
				sendNotification(Const.UPDATE_MONEY, gameModel.money);
		}
	}
}
