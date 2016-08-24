package commands
{
	import app.AppFacade;

	import models.GameModel;

	import vo.AchievementInfo;

	import models.ActionReward;
	import models.IReward;
	import models.PopUpReward;
	import models.ProfitReward;

	import org.puremvc.as3.multicore.interfaces.INotification;

	import vo.MessageBoxData;

	/**
	 * Команда на получение ачивки.
	 */
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
					{
						var gameModel:GameModel = AppFacade(facade).gameModel;
						sendNotification(Const.UPDATE_MONEY, gameModel.money);
					}
				}
				else if (reward is PopUpReward)
				{
					sendNotification(Const.SHOW_MESSAGE,
							new MessageBoxData(reward.description, null, Const.ON_OK));
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
