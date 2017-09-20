package commands
{
	import org.puremvc.as3.multicore.patterns.command.MacroCommand;

	/**
	 * Команда на смену состояния активности приложения.
	 */
	public class UpdateActivityCommand extends MacroCommand
	{
		public function UpdateActivityCommand()
		{
			addSubCommand(UpdateUnitsCommand);
		}
	}
}
