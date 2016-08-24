package commands
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	import proxy.UnitsProxy;

	import vo.UnitInfo;

	/**
	 * Команда на обновление юнитов.
	 */
	public class UpdateUnitsCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var unitsProxy:UnitsProxy = facade.retrieveProxy(UnitsProxy.NAME) as UnitsProxy;
			for (var i:int = 0, l:int = unitsProxy.units.length; i < l; i++)
			{
				var unitInfo:UnitInfo = unitsProxy.units[i];
				unitInfo.updateUnitWith(notification);
			}
		}
	}
}
