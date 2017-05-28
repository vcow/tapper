package commands
{
	import org.puremvc.as3.multicore.patterns.command.MacroCommand;

	public class UpdateLevelCommand extends MacroCommand
	{
		public function UpdateLevelCommand()
		{
			addSubCommand(CheckAchievementsCommand);
		}
	}
}
