package commands
{
	import vo.AchievementInfo;

	import models.ActionReward;
	import models.IReward;
	import models.PopUpReward;
	import models.ProfitReward;

	import org.puremvc.as3.multicore.interfaces.INotification;

	public class GetAchievementCommand extends CalcProfitCommandBase
	{
		override public function execute(notification:INotification):void
		{
			var achievementInfo:AchievementInfo = notification.getBody() as AchievementInfo;

			var rewards:Vector.<IReward> = achievementInfo.rewards;
			for each (var reward:IReward in rewards)
			{
				if (reward is ActionReward)
				{
					var action:ActionReward = ActionReward(reward);
					sendNotification(action.id, action.data);
				}
				else if (reward is ProfitReward)
				{
					if (calcProfit(ProfitReward(reward)))
						sendNotification(Const.UPDATE_MONEY);
				}
				else if (reward is PopUpReward)
				{
					sendNotification(Const.SHOW_POPUP, reward);
				}
				else
				{
					throw Error("Unsupported reward.");
				}
			}
			achievementInfo.receive(new Date().time);
		}
	}
}
