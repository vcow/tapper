package commands
{
	import app.AppFacade;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	import proxy.PacksProxy;

	import vo.Pack;

	/**
	 * Проверка совершенных платежей. Проверяет наличие нереализованных платежей (в случае зависания после платежа).
	 */
	public class CheckPurchasesCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var packsProxy:PacksProxy = PacksProxy(AppFacade(facade).retrieveProxy(PacksProxy.NAME));

			switch (notification.getBody() as String)
			{
				case Const.STATE_GAME:
					for each (var p:Pack in packsProxy.packs)
					{
						if (p.isConsumable && p.isPurchased)
						{
							sendNotification(Const.APPLY_PACK, p);
						}
					}
					break;
			}
		}
	}
}
