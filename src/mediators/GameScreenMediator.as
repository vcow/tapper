package mediators
{
	import app.AppFacade;

	import feathers.data.ListCollection;

	import models.GameModel;
	import models.LevelInfo;
	import models.SkinType;

	import org.puremvc.as3.multicore.interfaces.INotification;

	import proxy.LevelsProxy;

	import starling.events.Event;

	import view.GameScreen;

	public class GameScreenMediator extends BindableMediator
	{
		private static var _interests:Array = [Const.UPDATE_MONEY, Const.UPDATE_UNITS_LIST,
			Const.UPDATE_LEVEL, Const.SET_SKIN_BRONZE];

		private var _view:GameScreen;

		private var _money:Number = 0;
		private var _unitsList:ListCollection;
		private var _levelDescription:String;

		public function GameScreenMediator(mediatorName:String, viewComponent:Object)
		{
			super(mediatorName, viewComponent);
		}

		override public function setViewComponent(viewComponent:Object):void
		{
			super.setViewComponent(viewComponent);
			_view = viewComponent as GameScreen;
		}

		override public function listNotificationInterests():Array
		{
			return _interests;
		}

		override public function onRegister():void
		{
			_view.addEventListener(GameScreen.BACK, onBack);
			_view.addEventListener(GameScreen.SHOP, onShop);
			_view.addEventListener(GameScreen.TAP, onTap);

			var gameModel:GameModel = AppFacade(facade).gameModel;

			_money = Math.round(gameModel.money);
			dispatchEventWith("moneyChanged");

			_unitsList = new ListCollection(gameModel.activeUnits);
			dispatchEventWith("unitsListChanged");

			_levelDescription = getLevelDescription();
			dispatchEventWith("levelDescriptionChanged");

			_view.setSkin(gameModel.currentSkin);
			sendNotification(Const.START_GAME);
		}

		override public function onRemove():void
		{
			_view.removeEventListener(GameScreen.BACK, onBack);
			_view.removeEventListener(GameScreen.SHOP, onShop);
			_view.removeEventListener(GameScreen.TAP, onTap);

			sendNotification(Const.STOP_GAME);
		}

		override public function handleNotification(notification:INotification):void
		{
			var gameModel:GameModel = AppFacade(facade).gameModel;
			switch (notification.getName())
			{
				case Const.UPDATE_MONEY:
					_money = Math.round(gameModel.money);
					dispatchEventWith("moneyChanged");
					break;
				case Const.UPDATE_UNITS_LIST:
					_unitsList = new ListCollection(gameModel.activeUnits);
					dispatchEventWith("unitsListChanged");
					break;
				case Const.UPDATE_LEVEL:
					_levelDescription = getLevelDescription();
					dispatchEventWith("levelDescriptionChanged");
					break;
				case Const.SET_SKIN_BRONZE:
					_view.setSkin(SkinType.BRONZE);
					break;
			}
		}

		[Bindable(event="moneyChanged")]
		public function get money():Number
		{
			return _money;
		}

		[Bindable(event="unitsListChanged")]
		public function get unitsList():ListCollection
		{
			return _unitsList;
		}

		[Bindable(event="levelDescriptionChanged")]
		public function get levelDescription():String
		{
			return _levelDescription;
		}

		private function getLevelDescription():String
		{
			var levelsProxy:LevelsProxy = facade.retrieveProxy(LevelsProxy.NAME) as LevelsProxy;
			var level:LevelInfo = levelsProxy.getLevelById(AppFacade(facade).gameModel.level.toString());
			if (level)
				return level.description || "";
			return "";
		}

		private function onShop(event:Event):void
		{
			sendNotification(Const.SWITCH_TO_SHOP);
		}

		private function onTap(event:Event):void
		{
			sendNotification(Const.TAP);
		}

		private function onBack(event:Event):void
		{
			sendNotification(Const.POP);
		}
	}
}
