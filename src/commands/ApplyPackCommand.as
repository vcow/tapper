package commands
{
	import app.AppFacade;

	import models.GameModel;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	import proxy.UnitsProxy;

	import resources.locale.LocaleManager;

	import vo.AchievementInfo;
	import vo.MessageBoxData;

	import vo.Pack;
	import vo.UnitInfo;

	public class ApplyPackCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var pack:Pack = notification.getBody() as Pack;
			var gameModel:GameModel = AppFacade(facade).gameModel;

			if (pack.isConsumable)
			{
				pack.isPurchased = false;
			}

			switch (pack.id)
			{
				case "qtap.silver_fish":
					// Серебряная рыбка, профит выдается сразу в виде ачивки
					var achievementData:XML =
							<achievement id="silver_fish_achievement">
								<rewards>
									<p value="100%"/>
								</rewards>
							</achievement>;
					var achievement:AchievementInfo = new AchievementInfo(achievementData);
					achievement.initializeNotifier(multitonKey);
					sendNotification(Const.ACHIEVE, achievement);
					sendNotification(Const.SHOW_MESSAGE, new MessageBoxData(
							LocaleManager.getInstance().getString("common", "message.x2"), null, Const.ON_OK));
					break;
				case "qtap.golden_fish":
					// Золотая рыбка, профит выдается сразу в виде ачивки
					achievementData =
							<achievement id="golden_fish_achievement">
								<rewards>
									<p value="200%"/>
								</rewards>
							</achievement>;
					achievement = new AchievementInfo(achievementData);
					achievement.initializeNotifier(multitonKey);
					sendNotification(Const.ACHIEVE, achievement);
					sendNotification(Const.SHOW_MESSAGE, new MessageBoxData(
							LocaleManager.getInstance().getString("common", "message.x3"), null, Const.ON_OK));
					break;
				case "qtap.silver_fish.pack":
					// Аквариум серебряных рыбок, добавляется в виде лимитированного юнита
					var unitInfo:UnitInfo = UnitsProxy(facade.retrieveProxy(UnitsProxy.NAME)).getUnitById("silver_fish");
					sendNotification(Const.BUY, unitInfo);
					break;
				case "qtap.golden_fish.pack":
					// Аквариум золотых рыбок, добавляется в виде лимитированного юнита
					unitInfo = UnitsProxy(facade.retrieveProxy(UnitsProxy.NAME)).getUnitById("golden_fish");
					sendNotification(Const.BUY, unitInfo);
					break;
				case "qtap.portal":
					// Портал добавляет мультипликатор юнитов в дополнениях
					gameModel.addonModel.multiplier += 1;
					sendNotification(Const.UPDATE_MULTIPLIER, gameModel.addonModel.multiplier);
					sendNotification(Const.SAVE_ADDONS);
					sendNotification(Const.SHOW_MESSAGE, new MessageBoxData(
							LocaleManager.getInstance().getString("common", "message.portal"), null, Const.ON_OK));
					break;
				default:
					throw Error("Unsupported pack " + pack.id + ".");
			}
		}
	}
}
