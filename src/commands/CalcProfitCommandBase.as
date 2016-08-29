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

		}

		protected function calcProfit(profit:ProfitInfo):void
		{

		}
	}
}
