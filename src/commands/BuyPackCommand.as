package commands
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	import proxy.UnitsProxy;

	import vo.AchievementInfo;

	import vo.Pack;
	import vo.UnitInfo;

	public class BuyPackCommand extends SimpleCommand
	{
		private var _pack:Pack;

		override public function execute(notification:INotification):void
		{
			_pack = notification.getBody() as Pack;

			// TODO:
			applyPack();
		}

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
				default:
					throw Error("Unsupported pack " + _pack.id + ".");
			}
		}
	}
}
