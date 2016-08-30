package gears
{
	import models.GameModel;

	public class TriggerBroadcaster extends Broadcaster
	{
		public static const MONEY:String = "money";
		public static const TAP:String = "tap";
		public static const BUY:String = "buy";

		public function TriggerBroadcaster(target:* = null)
		{
			super(target);
		}

		public function init(gameModel:GameModel):void
		{
			broadcast(MONEY, gameModel.money);
			broadcast(TAP, gameModel.tapsTotal);
		}
	}
}
