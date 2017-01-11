package mediators
{
	import starling.events.Event;

	import view.StartScreen;

	public class StartScreenMediator extends BindableMediator
	{
		public function StartScreenMediator(mediatorName:String, viewComponent:Object)
		{
			super(mediatorName, viewComponent);
		}

		override public function onRegister():void
		{
			var startScreen:StartScreen = getViewComponent() as StartScreen;
			if (startScreen)
			{
				startScreen.addEventListener(StartScreen.START, onStart);
			}
		}

		override public function onRemove():void
		{
			var startScreen:StartScreen = getViewComponent() as StartScreen;
			if (startScreen)
			{
				startScreen.removeEventListener(StartScreen.START, onStart);
			}
		}

		private function onStart(event:Event):void
		{
			sendNotification(Const.SWITCH_TO, Const.STATE_GAME);
		}
	}
}
