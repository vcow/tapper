package commands
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	import vo.Pack;

	/**
	 * Команда на восстановление ранее купленного пака.
	 */
	public class RestorePackCommand extends SimpleCommand
	{
		private var _pack:Pack;

		override public function execute(notification:INotification):void
		{
			_pack = notification.getBody() as Pack;

			_pack.isPurchased = true;
			switch (_pack.id)
			{
				// TODO:
			}
		}
	}
}
