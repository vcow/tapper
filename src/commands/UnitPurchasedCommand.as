package commands
{
	import org.puremvc.as3.multicore.patterns.command.MacroCommand;

	public class UnitPurchasedCommand extends MacroCommand
	{
		public function UnitPurchasedCommand()
		{
			addSubCommand(UpdateUnitsCommand);
		}
	}
}
