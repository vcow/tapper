package commands
{
	import org.puremvc.as3.multicore.patterns.command.MacroCommand;

	/**
	 * Команда на покупку юнита в игровом магазине.
	 */
	public class UnitPurchasedCommand extends MacroCommand
	{
		public function UnitPurchasedCommand()
		{
			addSubCommand(UpdateUnitsCommand);
		}
	}
}
