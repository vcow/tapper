package commands
{
	import models.GameModel;
	import models.ProfitInfo;

	import org.puremvc.as3.multicore.core.Model;

	import org.puremvc.as3.multicore.interfaces.INotification;

	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class CalcProfitCommandBase extends SimpleCommand
	{
		private var _gameModel:GameModel;

		protected function get gameModel():GameModel
		{
			if (!_gameModel) _gameModel = Model.getInstance(GameModel.NAME) as GameModel;
			return _gameModel;
		}

		override public function execute(notification:INotification):void
		{
			throw Error("Override this in child.");
		}

		protected function calcProfitList(list:Vector.<ProfitInfo>, initValue:Number = 0):Boolean
		{
			var inc:Number = initValue;
			var percent:Number = 0;
			for (var i:int = 0, l:int = list.length; i < l; i++) {
				var profit:ProfitInfo = list[i];
				if (profit.value.percentValue) percent += profit.value.percentValue;
				else inc += profit.value.value;
			}
			inc += gameModel.money * percent;

			if (inc != 0) {
				gameModel.money += inc;
				gameModel.moneyTotal += inc;
				return true;
			}
			return false;
		}

		protected function calcProfit(profit:ProfitInfo):Boolean
		{
			var inc:Number = 0;
			if (profit.value.percentValue) inc = gameModel.money * profit.value.percentValue;
			else inc = profit.value.value;

			if (inc != 0) {
				gameModel.money += inc;
				gameModel.moneyTotal += inc;
				return true;
			}
			return false;
		}
	}
}
