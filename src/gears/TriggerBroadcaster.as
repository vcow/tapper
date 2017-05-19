package gears
{
	import models.GameModel;

	public class TriggerBroadcaster extends Broadcaster
	{
		public static const HAS_GAME_CHANGED:String = "hasGameChanged";
		public static const IS_ACTIVE_CHANGED:String = "isActiveChanged";
		public static const MONEY_CHANGED:String = "moneyChanged";
		public static const TAP:String = "tap";
		public static const BUY:String = "buy";

		public function TriggerBroadcaster(target:* = null)
		{
			super(target);
		}

		public function init(gameModel:GameModel):void
		{
			broadcast(MONEY_CHANGED, gameModel.money);
			broadcast(TAP, gameModel.tapsTotal);
		}
	}
}
