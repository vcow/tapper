package config
{
	import commands.StartGameCommand;
	import commands.StopGameCommand;

	import events.GameStateEvent;

	import mediators.ApplicationMediator;
	import mediators.GameScreenMediator;
	import mediators.StartScreenMediator;

	import models.GameModel;

	import resources.locale.LocaleManager;

	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;

	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.starling.extensions.mediatorMap.api.IMediatorMap;

	import view.Application;

	import view.GameScreen;

	import view.StartScreen;

	public class ApplicationConfig implements IConfig
	{
		[Inject]
		public var injector:IInjector;

		[Inject]
		public var mediatorMap:IMediatorMap;

		[Inject]
		public var eventCommandMap:IEventCommandMap;

		public function ApplicationConfig()
		{
		}

		public function configure():void
		{
			injector.map(GameModel).toSingleton(GameModel);

			mediatorMap.map(Application).toMediator(ApplicationMediator);
			mediatorMap.map(StartScreen).toMediator(StartScreenMediator);
			mediatorMap.map(GameScreen).toMediator(GameScreenMediator);

			eventCommandMap.map(GameStateEvent.START_GAME, GameStateEvent).toCommand(StartGameCommand);
			eventCommandMap.map(GameStateEvent.STOP_GAME, GameStateEvent).toCommand(StopGameCommand);
		}
	}
}
