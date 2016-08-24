package commands
{
	import org.puremvc.as3.multicore.patterns.command.MacroCommand;

	/**
	 * Команда на смену уровня игрока.
	 */
	public class UpdateLevelCommand extends MacroCommand
	{
		public function UpdateLevelCommand()
		{
			addSubCommand(CheckAchievementsCommand);
		}
	}
}
