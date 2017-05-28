package mediators
{
	import view.VipScreen;

	public class VipScreenMediator extends BindableMediator
	{
		public function VipScreenMediator(mediatorName:String = null, viewComponent:Object = null)
		{
			super(mediatorName, viewComponent);
		}

		override public function onRegister():void
		{
			var vipScreen:VipScreen = getViewComponent() as VipScreen;
			if (vipScreen)
			{
//				vipScreen.addEventListener(ShopScreen.BACK, onBack);
//				vipScreen.addEventListener(ShopScreen.UNIT_PURCHASED, onBuyUnit);
//
//				var gameModel:GameModel = AppFacade(facade).gameModel;
//
//				_money = Math.round(gameModel.money);
//				dispatchEventWith("moneyChanged");
//
//				var unitsProxy:UnitsProxy = facade.retrieveProxy(UnitsProxy.NAME) as UnitsProxy;
//				_unitsList = new ListCollection(unitsProxy.units);
//				dispatchEventWith("unitsListChanged");
			}
		}

		override public function onRemove():void
		{
			var vipScreen:VipScreen = getViewComponent() as VipScreen;
			if (vipScreen)
			{
//				vipScreen.removeEventListener(ShopScreen.BACK, onBack);
//				vipScreen.removeEventListener(ShopScreen.UNIT_PURCHASED, onBuyUnit);
			}
		}
	}
}
