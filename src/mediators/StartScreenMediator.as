package mediators
{
	import starling.events.Event;

	import view.StartScreen;

	public class StartScreenMediator extends BindableMediator
	{
		private var _view:StartScreen;

		public function StartScreenMediator(mediatorName:String, viewComponent:Object)
		{
			super(mediatorName, viewComponent);
		}

		override public function setViewComponent(viewComponent:Object):void
		{
			super.setViewComponent(viewComponent);
			_view = viewComponent as StartScreen;
		}

		override public function onRegister():void
		{
			_view.addEventListener(StartScreen.START, onStart);
		}

		override public function onRemove():void
		{
			_view.removeEventListener(StartScreen.START, onStart);
		}

		private function onStart(event:Event):void
		{
			sendNotification(Const.SWITCH_TO_GAME);
		}
	}
}
