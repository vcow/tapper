package commands
{
	import org.puremvc.as3.multicore.patterns.command.MacroCommand;

	/**
	 * Команда на нажатие кнопки "Действовать".
	 */
	public class UpdateTapsCommand extends MacroCommand
	{
		public function UpdateTapsCommand()
		{
			addSubCommand(CheckAchievementsCommand);
		}
	}
}
