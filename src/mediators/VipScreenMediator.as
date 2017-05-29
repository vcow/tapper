package mediators
{
	import app.AppFacade;

	import feathers.data.ListCollection;

	import proxy.PacksProxy;

	import starling.events.Event;

	import view.VipScreen;

	import vo.Pack;

	public class VipScreenMediator extends BindableMediator
	{
		private var _packList:ListCollection;

		public function VipScreenMediator(mediatorName:String = null, viewComponent:Object = null)
		{
			super(mediatorName, viewComponent);
		}

		override public function onRegister():void
		{
			var vipScreen:VipScreen = getViewComponent() as VipScreen;
			if (vipScreen)
			{
				vipScreen.addEventListener("back", onBack);
				vipScreen.addEventListener("buyPack", onBuyPack);

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
				vipScreen.removeEventListener("back", onBack);
				vipScreen.removeEventListener("buyPack", onBuyPack);
			}
		}

		private function onBack(event:Event):void
		{
			sendNotification(Const.POP);
		}

		private function onBuyPack(event:Event):void
		{
			var pack:Pack = event.data as Pack;
			if (pack)
			{
				sendNotification(Const.BUY_PACK, pack);
			}
		}

		public function get packList():ListCollection
		{
			if (!_packList)
			{
				var packsProxy:PacksProxy = PacksProxy(facade.retrieveProxy(PacksProxy.NAME));
				_packList = new ListCollection(packsProxy.packs);
			}
			return _packList;
		}
	}
}
