package commands
{
	import org.puremvc.as3.multicore.patterns.command.MacroCommand;

	public class UpdateActivityCommand extends MacroCommand
	{
		public function UpdateActivityCommand()
		{
			addSubCommand(UpdateUnitsCommand);
		}
	}
}
