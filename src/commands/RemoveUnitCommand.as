package commands
{
	import events.UnitEvent;

	import robotlegs.bender.extensions.commandCenter.api.ICommand;

	public class RemoveUnitCommand implements ICommand
	{
		[Inject]
		public var event:UnitEvent;

		public function execute():void
		{
		}
	}
}
