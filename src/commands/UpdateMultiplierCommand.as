package commands
{
	import org.puremvc.as3.multicore.patterns.command.MacroCommand;

	public class UpdateMultiplierCommand extends MacroCommand
	{
		public function UpdateMultiplierCommand()
		{
			addSubCommand(UpdateUnitsCommand);
		}
	}
}
