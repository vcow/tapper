package config
{
	import mediators.MainScreenMediator;
	import mediators.GameScreenMediator;
	import mediators.ShopListItemMediator;
	import mediators.ShopScreenMediator;
	import mediators.ShopWidgetMediator;
	import mediators.StartScreenMediator;
	import mediators.UnitListItemMediator;

	import view.MainScreen;

	import view.GameScreen;
	import view.ShopListItemRenderer;
	import view.ShopScreen;
	import view.ShopWidget;

	import view.StartScreen;
	import view.UnitListItemRenderer;

	public class ApplicationConfig implements IConfig
	{
		public function ApplicationConfig()
		{
		}

		public function configure():void
		{
			mediatorMap.map(GameScreen).toMediator(GameScreenMediator);
			mediatorMap.map(ShopScreen).toMediator(ShopScreenMediator);
			mediatorMap.map(ShopListItemRenderer).toMediator(ShopListItemMediator);
			mediatorMap.map(UnitListItemRenderer).toMediator(UnitListItemMediator);
			mediatorMap.map(ShopWidget).toMediator(ShopWidgetMediator);

		}
	}
}
