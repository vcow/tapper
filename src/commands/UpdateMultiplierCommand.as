package commands
{
	import org.puremvc.as3.multicore.patterns.command.MacroCommand;

	/**
	 * Команда на изменение мультипликатора уникальных юнитов в игровом магазине.
	 */
	public class UpdateMultiplierCommand extends MacroCommand
	{
		public function UpdateMultiplierCommand()
		{
			addSubCommand(UpdateUnitsCommand);
		}
	}
}
