package commands
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	import proxy.AchievementsProxy;

	import vo.AchievementInfo;

	/**
	 * Команда на проверку получения ачивки.
	 */
	public class CheckAchievementsCommand extends SimpleCommand
	{
		private static var _isLocked:Boolean;

		override public function execute(notification:INotification):void
		{
			if (_isLocked) return;

			var rewardList:Vector.<AchievementInfo> = new Vector.<AchievementInfo>();
			var achievementsProxy:AchievementsProxy = facade.retrieveProxy(AchievementsProxy.NAME) as AchievementsProxy;
			for (var i:int = 0, l:int = achievementsProxy.achievements.length; i < l; i++)
			{
				var achievement:AchievementInfo = achievementsProxy.achievements[i];
				if (achievement.checkForAward()) rewardList.push(achievement);
			}

			if (rewardList.length > 0)
			{
				_isLocked = true;
				for each (achievement in rewardList)
				{
					sendNotification(Const.ACHIEVE, achievement);
				}
				_isLocked = false;
			}
		}
	}
}
