package
{
	import app.AppFacade;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.Capabilities;

	import resources.LocalesLibrary;
	import resources.locale.LocaleManager;

	import starling.core.Starling;

	import view.MainScreen;

	[SWF(frameRate="60", backgroundColor="#000000")]
	public class Main extends Sprite
	{
		private var _starling:Starling;

		private var _facade:AppFacade;

		public function Main()
		{
			super();

			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		protected function init(event:Event = null):void
		{
			if (event) removeEventListener(Event.ADDED_TO_STAGE, init);

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			var bundles:Array = []
					.concat(LocalesLibrary.commonBundle)
					.concat(LocalesLibrary.unitsBundle)
					.concat(LocalesLibrary.levelsBundle)
					.concat(LocalesLibrary.achievementsBundle)
					.concat(LocalesLibrary.actionsBundle)
					.concat(LocalesLibrary.packsBundle);

			LocaleManager.getInstance().addRequiredBundles(bundles, onLocalesComplete);
		}

		private function onLocalesComplete(success:Boolean):void
		{
			if (!success)
				throw Error("LocaleManager initialization failed.");

			switch (Capabilities.language)
			{
				case "en":
					LocaleManager.getInstance().localeChain = ["en_US"];
					break;
				default:
					LocaleManager.getInstance().localeChain = ["ru_RU"];
			}

			_starling = new Starling(MainScreen, stage);

			new ScreenDensityScaleFactorManagerEx(_starling, 576, 1024);

			_facade = new AppFacade(AppFacade.NAME);

			_starling.start();
			stage.addEventListener(Event.DEACTIVATE, onStageDeactivate);

			_facade.sendNotification(Const.ACTIVATE);
		}

		protected function onStageDeactivate(event:Event):void
		{
			_facade.sendNotification(Const.DEACTIVATE);

			_starling.stop();
			stage.addEventListener(Event.ACTIVATE, onStageActivate);
		}

		protected function onStageActivate(event:Event):void
		{
			stage.removeEventListener(Event.ACTIVATE, onStageActivate);
			_starling.start();

			_facade.sendNotification(Const.ACTIVATE);
		}
	}
}
