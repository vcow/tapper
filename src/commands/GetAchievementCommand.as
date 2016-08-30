package commands
{
	import events.AchievementEvent;
	import events.ActionEvent;
	import events.PopUpEvent;

	import flash.events.IEventDispatcher;

	import models.ActionReward;

	import models.IReward;
	import models.PopUpReward;
	import models.ProfitReward;

	public class GetAchievementCommand extends CalcProfitCommandBase
	{
		[Inject]
		public var event:AchievementEvent;

		[Inject]
		public var eventDispatcher:IEventDispatcher;

		override public function execute():void
		{
			var rewards:Vector.<IReward> = event.achievement.rewards;
			for each (var reward:IReward in rewards) {
				if (reward is ActionReward) {
					var action:ActionReward = ActionReward(reward);
					eventDispatcher.dispatchEvent(new ActionEvent(action.id));
				}
				else if (reward is ProfitReward) {
					calcProfit(ProfitReward(reward));
				}
				else if (reward is PopUpReward) {
					var popup:PopUpReward = PopUpReward(reward);
					eventDispatcher.dispatchEvent(new PopUpEvent(PopUpEvent.SHOW, popup.title, popup.description));
				}
				else {
					throw Error("Unsupported reward.");
				}
			}
		}
	}
}
