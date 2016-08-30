package commands
{
	import events.AchievementEvent;

	import robotlegs.bender.extensions.commandCenter.api.ICommand;

	public class GetAchievmentCommand implements ICommand
	{
		[Inject]
		public var event:AchievementEvent;

		public function execute():void
		{
			trace("sdf");
		}
	}
}
