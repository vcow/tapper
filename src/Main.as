package
{
	import app.AppFacade;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	import proxy.AchievementsProxy;

	import models.GameModel;

	import org.puremvc.as3.multicore.patterns.facade.Facade;

	import resources.LocalesLibrary;
	import resources.locale.LocaleManager;

	import starling.core.Starling;

	import view.MainScreen;

	[SWF(frameRate="60", backgroundColor="#14485e")]
	public class Main extends Sprite
	{
		private var _starling:Starling;

		private var _facade:AppFacade;
		private var _model:GameModel;

		public function Main()
		{
			super();

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			loaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
		}

		protected function onLoadComplete(event:Event):void
		{
			var bundles:Array = []
					.concat(LocalesLibrary.commonBundle)
					.concat(LocalesLibrary.unitsBundle)
					.concat(LocalesLibrary.levelsBundle)
					.concat(LocalesLibrary.achievementsBundle)
					.concat(LocalesLibrary.actionsBundle);

			LocaleManager.getInstance().addRequiredBundles(bundles, onLocalesComplete);
		}

		private function onLocalesComplete(success:Boolean):void
		{
			if (!success)
				throw Error("LocaleManager initialization failed.");

			LocaleManager.getInstance().localeChain = ["ru_RU"];

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
