/**
 * Created by Yakov on 23.08.2016.
 */
package config
{
	import mediators.AppMediator;
	import mediators.GameScreenMediator;
	import mediators.StartScreenMediator;

	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;

	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.starling.extensions.mediatorMap.api.IMediatorMap;

	import screen.GameScreen;

	import screen.StartScreen;

	public class ApplicationConfig implements IConfig
	{
		[Inject]
		public var mediatorMap:IMediatorMap;

		[Inject]
		public var eventCommandMap:IEventCommandMap;

		public function ApplicationConfig()
		{
		}

		public function configure():void
		{
			mediatorMap.map(Main).toMediator(AppMediator);
			mediatorMap.map(StartScreen).toMediator(StartScreenMediator);
			mediatorMap.map(GameScreen).toMediator(GameScreenMediator);
		}
	}
}
