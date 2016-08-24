package commands
{
	import app.AppFacade;

	import models.GameModel;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	import proxy.AchievementsProxy;

	import vo.AchievementInfo;

	/**
	 * Команда на старт новой игры.
	 */
	public class NewGameCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var gameModel:GameModel = AppFacade(facade).gameModel;

			gameModel.setMoney(gameModel.startBonus);
			gameModel.startBonus = 0;
			gameModel.tapsTotal = 0;
			gameModel.tickCount = 0;
			gameModel.level = 0;
			gameModel.clearUnits();

			var achievementsProxy:AchievementsProxy = facade.retrieveProxy(AchievementsProxy.NAME) as AchievementsProxy;
			for each (var achievement:AchievementInfo in achievementsProxy.achievements) achievement.receive(NaN);

			if (gameModel.hasCurrentGame)
			{
				gameModel.hasCurrentGame = false;
				sendNotification(Const.UPDATE_CURRENT_GAME, false);
			}

			sendNotification(Const.UPDATE_TAPS, gameModel.tapsTotal);
			sendNotification(Const.UPDATE_LEVEL, gameModel.level);
			sendNotification(Const.UPDATE_MONEY, gameModel.money);
			sendNotification(Const.UPDATE_MULTIPLIER, gameModel.addonModel.multiplier);
			sendNotification(Const.UPDATE_UNITS_LIST);
		}
	}
}
