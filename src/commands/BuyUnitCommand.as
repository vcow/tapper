package commands
{
	import app.AppFacade;

	import models.GameModel;

	import org.puremvc.as3.multicore.interfaces.INotification;

	import resources.AtlasLibrary;

	import vo.Unit;
	import vo.UnitInfo;

	/**
	 * Покупка юнита в игровом магазине.
	 */
	public class BuyUnitCommand extends CalcProfitCommandBase
	{
		override public function execute(notification:INotification):void
		{
			var unitInfo:UnitInfo = notification.getBody() as UnitInfo;
			var gameModel:GameModel = AppFacade(facade).gameModel;

			if (gameModel.money >= unitInfo.price)
			{
				var unit:Unit = new Unit(unitInfo, unitInfo.price, unitInfo.perClickProfit || unitInfo.perSecondProfit);
				unit.initializeNotifier(multitonKey);
				gameModel.setMoney(gameModel.money - unitInfo.price);

				gameModel.addUnit(unit);
				gameModel.sortUnitsByIndex();

				if (unit.info.profit)
					calcProfit(unit.info.profit);

				if (unit.info.action)
					sendNotification(unit.info.action.id, unit.info.action.data);

				sendNotification(Const.UNIT_PURCHASED, unit);
				sendNotification(Const.UPDATE_MONEY, gameModel.money);
				sendNotification(Const.UPDATE_UNITS_LIST);

				SoundManager.getInstance().playSound(AtlasLibrary.getInstance().manager.getSound("buy"));
			}
		}
	}
}
