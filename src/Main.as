package
{
	import facade.AppFacade;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	import models.AchievementsModel;

	import models.GameModel;
	import models.LevelsModel;

	import models.UnitsModel;

	import org.puremvc.as3.multicore.patterns.facade.Facade;

	import resources.LocalesLibrary;
	import resources.locale.LocaleManager;

	import starling.core.Starling;

	import view.MainScreen;

	[SWF(frameRate="60", backgroundColor="#14485e")]
	public class Main extends Sprite
	{
		private var _starling:Starling;

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

			initialize();

			_starling.start();
			stage.addEventListener(Event.DEACTIVATE, onStageDeactivate);

			Facade.getInstance(AppFacade.NAME).sendNotification(Const.ACTIVATE);
		}

		protected function initialize():void
		{
			new AppFacade(AppFacade.NAME);
			new UnitsModel(UnitsModel.NAME);
			new LevelsModel(LevelsModel.NAME);
			new AchievementsModel(AchievementsModel.NAME);
			new GameModel(GameModel.NAME);
		}

		protected function onStageDeactivate(event:Event):void
		{
			Facade.getInstance(AppFacade.NAME).sendNotification(Const.DEACTIVATE);

			_starling.stop();
			stage.addEventListener(Event.ACTIVATE, onStageActivate);
		}

		protected function onStageActivate(event:Event):void
		{
			stage.removeEventListener(Event.ACTIVATE, onStageActivate);
			_starling.start();

			Facade.getInstance(AppFacade.NAME).sendNotification(Const.ACTIVATE);
		}
	}
}
