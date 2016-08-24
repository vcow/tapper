package commands
{
	import org.puremvc.as3.multicore.patterns.command.MacroCommand;

	/**
	 * Команда на переключение игры в указанное состояние.
	 */
	public class SwitchToStateCommand extends MacroCommand
	{
		public function SwitchToStateCommand()
		{
			addSubCommand(PrepareToStateCommand);
			addSubCommand(SetStateCommand);
			addSubCommand(CheckPurchasesCommand);
		}
	}
}
