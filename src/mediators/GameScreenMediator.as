package mediators
{
	import app.AppFacade;

	import feathers.data.ListCollection;

	import models.GameModel;
	import models.LevelInfo;

	import org.puremvc.as3.multicore.interfaces.INotification;

	import proxy.LevelsProxy;

	import resources.AtlasLibrary;

	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	import view.GameScreenViewBase;

	public class GameScreenMediator extends BindableMediator
	{
		private static var _interests:Array = [Const.UPDATE_MONEY, Const.UPDATE_UNITS_LIST, Const.UPDATE_LEVEL];

		private var _money:Number = 0;
		private var _unitsList:ListCollection;
		private var _currentLevel:LevelInfo;

		private static var _atlasStateIcon:TextureAtlas;
		private static function get atlasStateIcon():TextureAtlas
		{
			if (!_atlasStateIcon)
			{
				_atlasStateIcon = AtlasLibrary.getInstance().manager.getTextureAtlas("states");
			}
			return _atlasStateIcon;
		}

		public function GameScreenMediator(mediatorName:String, viewComponent:Object)
		{
			super(mediatorName, viewComponent);
		}

		override public function listNotificationInterests():Array
		{
			return _interests;
		}

		override public function onRegister():void
		{
			var gameScreen:GameScreenViewBase = getViewComponent() as GameScreenViewBase;
			if (gameScreen)
			{
				gameScreen.addEventListener(GameScreenViewBase.BACK, onBack);
				gameScreen.addEventListener(GameScreenViewBase.SHOP, onShop);
				gameScreen.addEventListener(GameScreenViewBase.TAP, onTap);

				var gameModel:GameModel = AppFacade(facade).gameModel;

				_money = Math.round(gameModel.money);
				dispatchEventWith("moneyChanged");

				_unitsList = new ListCollection(gameModel.getActiveUnits());
				dispatchEventWith("unitsListChanged");

				updateLevel();
			}
		}

		override public function onRemove():void
		{
			var gameScreen:GameScreenViewBase = getViewComponent() as GameScreenViewBase;
			if (gameScreen)
			{
				gameScreen.removeEventListener(GameScreenViewBase.BACK, onBack);
				gameScreen.removeEventListener(GameScreenViewBase.SHOP, onShop);
				gameScreen.removeEventListener(GameScreenViewBase.TAP, onTap);
			}
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
					_unitsList = new ListCollection(gameModel.getActiveUnits());
					dispatchEventWith("unitsListChanged");
					break;
				case Const.UPDATE_LEVEL:
					updateLevel();
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

		[Bindable(event="levelChanged")]
		public function get levelTitle():String
		{
			return _currentLevel ? _currentLevel.title : null;
		}

		[Bindable(event="levelChanged")]
		public function get levelDescription():String
		{
			return _currentLevel ? _currentLevel.description : null;
		}

		[Bindable(event="levelChanged")]
		public function get levelIcon():Texture
		{
			return _currentLevel ? atlasStateIcon.getTexture(_currentLevel.iconId) : null;
		}

		private function updateLevel():void
		{
			var levelsProxy:LevelsProxy = facade.retrieveProxy(LevelsProxy.NAME) as LevelsProxy;
			var level:LevelInfo = levelsProxy.getLevel(AppFacade(facade).gameModel.level);
			if (level != _currentLevel)
			{
				_currentLevel = level;
				dispatchEventWith("levelChanged");
			}
		}

		private function onShop(event:Event):void
		{
			sendNotification(Const.SWITCH_TO, Const.STATE_SHOP);
		}

		private function onTap(event:Event):void
		{
			sendNotification(Const.TAP);
		}

		private function onBack(event:Event):void
		{
			sendNotification(Const.POP_TO_ROOT);
		}
	}
}
