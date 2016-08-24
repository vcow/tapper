package commands
{
	import app.AppFacade;

	import models.GameModel;
	import models.ProfitInfo;

	import org.puremvc.as3.multicore.interfaces.INotification;

	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * Базовый класс для команд, подсчитывающих профит.
	 */
	public class CalcProfitCommandBase extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			throw Error("Override this in child.");
		}

		/**
		 * Расчет профита от нескольких юнитов.
		 * @param list Список профитов.
		 * @param initValue Исходное количество денег.
		 * @return Возвращает <code>true</code>, если профит имеется, иначе <code>false</code>.
		 */
		protected function calcProfitList(list:Vector.<ProfitInfo>, initValue:Number = 0):Boolean
		{
			var inc:Number = initValue;
			var gameModel:GameModel = AppFacade(facade).gameModel;
			var percent:Number = 0;

			for (var i:int = 0, l:int = list.length; i < l; i++)
			{
				var profit:ProfitInfo = list[i];
				if (profit.value.percentValue) percent += profit.value.percentValue;
				else inc += profit.value.value;
			}
			inc += gameModel.money * percent;

			if (inc != 0)
			{
				if (!gameModel.setMoney(gameModel.money + inc))
					sendNotification(Const.OVERFLOW);
				else
					sendNotification(Const.UPDATE_MONEY, gameModel.money);
				return true;
			}
			return false;
		}

		/**
		 * Расчет профита.
		 * @param profit Рассчитываемый профит.
		 * @return Возвращает <code>true</code>, если профит имеется, иначе <code>false</code>.
		 */
		protected function calcProfit(profit:ProfitInfo):Boolean
		{
			var inc:Number = 0;
			var gameModel:GameModel = AppFacade(facade).gameModel;

			if (profit.value.percentValue) inc = gameModel.money * profit.value.percentValue;
			else inc = profit.value.value;

			if (inc != 0)
			{
				if (!gameModel.setMoney(gameModel.money + inc))
					sendNotification(Const.OVERFLOW);
				else
					sendNotification(Const.UPDATE_MONEY, gameModel.money);
				return true;
			}
			return false;
		}
	}
}
