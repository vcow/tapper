package commands
{
	import org.puremvc.as3.multicore.patterns.command.MacroCommand;

	/**
	 * Команда на переключение игры в указанное состояние.
	 */
	public class SwitchToCommand extends MacroCommand
	{
		public function SwitchToCommand()
		{
			addSubCommand(SwitchToStateCommand);
			addSubCommand(PopCommand);
		}
	}
}
