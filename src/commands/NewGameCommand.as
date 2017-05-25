package commands
{
	import app.AppFacade;

	import models.GameModel;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	import proxy.AchievementsProxy;

	import vo.AchievementInfo;

	public class NewGameCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var gameModel:GameModel = AppFacade(facade).gameModel;

			gameModel.money = 0;
			gameModel.tapsTotal = 0;
			gameModel.moneyTotal = 0;
			gameModel.tickCount = 0;
			gameModel.level = 0;
			gameModel.units.splice(0, gameModel.units.length);

			var achievementsProxy:AchievementsProxy = facade.retrieveProxy(AchievementsProxy.NAME) as AchievementsProxy;
			for each (var achievement:AchievementInfo in achievementsProxy.achievements) achievement.receive(NaN);

			gameModel.hasCurrentGame = false;

			sendNotification(Const.UPDATE_LEVEL);
			sendNotification(Const.UPDATE_MONEY);
			sendNotification(Const.UPDATE_UNITS_LIST);
		}
	}
}
