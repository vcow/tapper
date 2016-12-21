package commands
{
	import gears.TriggerBroadcaster;

	import models.Unit;
	import models.UnitInfo;

	import org.puremvc.as3.multicore.interfaces.INotification;

	public class BuyUnitCommand extends CalcProfitCommandBase
	{
		override public function execute(notification:INotification):void
		{
			var unitInfo:UnitInfo = notification.getBody() as UnitInfo;

			if (gameModel.money >= unitInfo.price) {
				var unit:Unit = new Unit(unitInfo, unitInfo.price, unitInfo.perClickProfit || unitInfo.perSecondProfit);
				gameModel.money -= unitInfo.price;

				gameModel.units.push(unit);
				gameModel.sortUnitsByPrice();

				if (unit.info.profit)
					calcProfit(unit.info.profit);

				if (unit.info.action)
					sendNotification(unit.info.action.id, unit.info.action.data);

				gameModel.triggerBroadcaster.broadcast(TriggerBroadcaster.BUY, unit);

				sendNotification(Const.UPDATE_MONEY);
				sendNotification(Const.UPDATE_UNITS_LIST);
			}
		}
	}
}
