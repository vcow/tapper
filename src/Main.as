package
{
import config.ApplicationConfig;

import events.GameEvent;

import feathers.utils.ScreenDensityScaleFactorManager;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.IEventDispatcher;

import resources.LocalesLibrary;
import resources.locale.LocaleManager;

import robotlegs.bender.framework.impl.Context;
import robotlegs.starling.bundles.mvcs.StarlingBundle;
import robotlegs.starling.extensions.contextView.ContextView;
import robotlegs.starling.extensions.viewProcessorMap.ViewProcessorMapExtension;

import starling.core.Starling;

import view.MainScreen;

[SWF(frameRate="60", backgroundColor="#14485e")]
	public class Main extends Sprite
	{
		private var _starling:Starling;
		private var _context:Context;

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

			new ScreenDensityScaleFactorManager(_starling);

			_context = new Context();
			_context.install(StarlingBundle, ViewProcessorMapExtension)
					.configure(ApplicationConfig, new ContextView(_starling))
					.initialize(onInitialized);
		}

		private function onInitialized():void
		{
			_starling.start();
			stage.addEventListener(Event.DEACTIVATE, onStageDeactivate);

			var eventDispatcher:IEventDispatcher = _context.injector.getInstance(IEventDispatcher);
			if (eventDispatcher) eventDispatcher.dispatchEvent(new GameEvent(GameEvent.ACTIVATE));
		}

		protected function onStageDeactivate(event:Event):void
		{
			var eventDispatcher:IEventDispatcher = _context.injector.getInstance(IEventDispatcher);
			if (eventDispatcher) eventDispatcher.dispatchEvent(new GameEvent(GameEvent.DEACTIVATE));

			_starling.stop();
			stage.addEventListener(Event.ACTIVATE, onStageActivate);
		}

		protected function onStageActivate(event:Event):void
		{
			stage.removeEventListener(Event.ACTIVATE, onStageActivate);
			_starling.start();

			var eventDispatcher:IEventDispatcher = _context.injector.getInstance(IEventDispatcher);
			if (eventDispatcher) eventDispatcher.dispatchEvent(new GameEvent(GameEvent.ACTIVATE));
		}
	}
}
