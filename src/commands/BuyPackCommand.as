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

	/**
	 * Команда на покупку пака в магазине.
	 */
	public class BuyPackCommand extends SimpleCommand
	{
		private var _pack:Pack;

		override public function execute(notification:INotification):void
		{
			_pack = notification.getBody() as Pack;

			// TODO:
			applyPack();
		}

		/**
		 * Пак успешно куплен.
		 */
		private function applyPack():void
		{
			switch (_pack.id)
			{
				case "silver_fish":
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
					sendNotification(Const.SWITCH_TO, Const.STATE_GAME);
					sendNotification(Const.SHOW_MESSAGE, new MessageBoxData(
							LocaleManager.getInstance().getString("common", "message.x2"), null, Const.ON_OK));
					break;
				case "golden_fish":
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
					sendNotification(Const.SWITCH_TO, Const.STATE_GAME);
					sendNotification(Const.SHOW_MESSAGE, new MessageBoxData(
							LocaleManager.getInstance().getString("common", "message.x3"), null, Const.ON_OK));
					break;
				case "silver_fish_pack":
					// Аквариум серебряных рыбок, добавляется в виде лимитированного юнита
					var unitInfo:UnitInfo = UnitsProxy(facade.retrieveProxy(UnitsProxy.NAME)).getUnitById("silver_fish");
					sendNotification(Const.BUY, unitInfo);
					sendNotification(Const.SWITCH_TO, Const.STATE_GAME);
					break;
				case "golden_fish_pack":
					// Аквариум золотых рыбок, добавляется в виде лимитированного юнита
					unitInfo = UnitsProxy(facade.retrieveProxy(UnitsProxy.NAME)).getUnitById("golden_fish");
					sendNotification(Const.BUY, unitInfo);
					sendNotification(Const.SWITCH_TO, Const.STATE_GAME);
					break;
				case "portal":
					// Портал добавляет мультипликатор юнитов в дополнениях
					var gameModel:GameModel = AppFacade(facade).gameModel;
					gameModel.addonModel.multiplier += 1;
					sendNotification(Const.UPDATE_MULTIPLIER, gameModel.addonModel.multiplier);
					sendNotification(Const.SAVE_ADDONS);
					break;
				default:
					throw Error("Unsupported pack " + _pack.id + ".");
			}
		}
	}
}
