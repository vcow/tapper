package commands
{
	import org.puremvc.as3.multicore.patterns.command.MacroCommand;

	/**
	 * Команда на изменение количества денег.
	 */
	public class UpdateMoneyCommand extends MacroCommand
	{
		public function UpdateMoneyCommand()
		{
			addSubCommand(CheckAchievementsCommand);
			addSubCommand(UpdateUnitsCommand);
		}
	}
}
