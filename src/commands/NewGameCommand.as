package commands
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class NewGameCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			throw Error("Write me");
		}
	}
}
