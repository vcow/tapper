package mediators
{
	import robotlegs.starling.bundles.mvcs.Mediator;

	public class GameScreenMediator extends Mediator
	{
		public function GameScreenMediator()
		{
			super();
		}

		override public function initialize():void
		{
			trace("sdf");
		}
	}
}
