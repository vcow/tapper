package commands
{
	import models.GameModel;
	import models.ProfitInfo;

	import robotlegs.bender.extensions.commandCenter.api.ICommand;

	public class CalcProfitCommandBase implements ICommand
	{
		[Inject]
		public var gameModel:GameModel;

		public function execute():void
		{
			throw Error("Override this in child.");
		}

		protected function calcProfitList(list:Vector.<ProfitInfo>, initValue:Number = 0):void
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
			}
		}

		protected function calcProfit(profit:ProfitInfo):void
		{
			var inc:Number = 0;
			if (profit.value.percentValue) inc = gameModel.money * profit.value.percentValue;
			else inc = profit.value.value;

			gameModel.money += inc;
			gameModel.moneyTotal += inc;
		}
	}
}
