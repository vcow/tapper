package
{
	import config.ApplicationConfig;

	import feathers.utils.ScreenDensityScaleFactorManager;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	import resources.LocalesLibrary;

	import resources.locale.LocaleManager;

	import robotlegs.bender.framework.impl.Context;
	import robotlegs.starling.bundles.mvcs.StarlingBundle;
	import robotlegs.starling.extensions.viewProcessorMap.ViewProcessorMapExtension;
	import robotlegs.starling.extensions.contextView.ContextView;

	import starling.core.Starling;

	import view.Application;

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
					.concat(LocalesLibrary.unitsBundle);

			LocaleManager.getInstance().addRequiredBundles(bundles, onLocalesComplete);
		}

		private function onLocalesComplete(success:Boolean):void
		{
			if (!success)
				throw Error("LocaleManager initialization failed.");

			LocaleManager.getInstance().localeChain = ["en_US"];

			_starling = new Starling(Application, stage);

			new ScreenDensityScaleFactorManager(_starling);

			var context:Context = new Context();
			context.install(StarlingBundle, ViewProcessorMapExtension)
					.configure(ApplicationConfig, new ContextView(_starling))
					.initialize(onInitialized);
		}

		private function onInitialized():void
		{
			_starling.start();
			stage.addEventListener(Event.DEACTIVATE, onStageDeactivate);
		}

		protected function onStageDeactivate(event:Event):void
		{
			_starling.stop();
			stage.addEventListener(Event.ACTIVATE, onStageActivate);
		}

		protected function onStageActivate(event:Event):void
		{
			stage.removeEventListener(Event.ACTIVATE, onStageActivate);
			_starling.start();
		}
	}
}
