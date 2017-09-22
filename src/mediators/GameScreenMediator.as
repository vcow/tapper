package mediators
{
	import app.AppFacade;

	import feathers.data.ListCollection;

	import flash.media.Sound;

	import models.GameModel;
	import models.LevelInfo;

	import org.puremvc.as3.multicore.interfaces.INotification;

	import proxy.LevelsProxy;

	import starling.events.Event;

	import view.GameScreenViewBase;

	/**
	 * Медиатор Кабинета.
	 */
	public class GameScreenMediator extends BindableMediator
	{
		private static var _interests:Array = [Const.UPDATE_MONEY, Const.UPDATE_UNITS_LIST,
			Const.UPDATE_LEVEL, Const.PLAY_GAME_SOUND, Const.UPDATE_GOD_MODE];

		private var _money:Number = 0;
		private var _unitsList:ListCollection;
		private var _currentLevel:LevelInfo;

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

		override public function setViewComponent(viewComponent:Object):void
		{
			if (viewComponent == viewComponent) return;

			if (viewComponent)
			{
				viewComponent.removeEventListener(GameScreenViewBase.BACK, onBack);
				viewComponent.removeEventListener(GameScreenViewBase.SHOP, onShop);
				viewComponent.removeEventListener(GameScreenViewBase.TAP, onTap);
			}

			super.setViewComponent(viewComponent);
			if (viewComponent)
			{
				viewComponent.addEventListener(GameScreenViewBase.BACK, onBack);
				viewComponent.addEventListener(GameScreenViewBase.SHOP, onShop);
				viewComponent.addEventListener(GameScreenViewBase.TAP, onTap);
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
				case Const.PLAY_GAME_SOUND:
					var sound:Sound = notification.getBody() as Sound;
					if (sound)
					{
						var gameScreen:GameScreenViewBase = getViewComponent() as GameScreenViewBase;
						var onPlayGameSound:Function = function (event:Event):void
						{
							if (event)
								event.target.removeEventListener(Event.ADDED_TO_STAGE, onPlayGameSound);
							var soundManager:SoundManager = SoundManager.getInstance();
							soundManager.stopAllSounds(true);
							var musicVolume:Number = soundManager.getVolume(SoundManager.MUSIC);
							soundManager.setVolume(SoundManager.MUSIC, 0);
							var channel:Channel = soundManager.playSound(sound);
							channel.addEventListener(Event.COMPLETE, function (event:Event):void
							{
								channel.removeEventListener(Event.COMPLETE, arguments.callee);
								soundManager.setVolume(SoundManager.MUSIC, musicVolume);
							});
						};
						if (gameScreen.stage) onPlayGameSound(null);
						else gameScreen.addEventListener(Event.ADDED_TO_STAGE, onPlayGameSound);
					}
					break;
				case Const.UPDATE_GOD_MODE:
					dispatchEventWith("godModeChanged");
					break;
			}
		}


		[Bindable(event="moneyChanged")]
		/**
		 * Текущее количество денег.
		 */
		public function get money():Number
		{
			return _money;
		}

		[Bindable(event="unitsListChanged")]
		/**
		 * Текущий список юнитов.
		 */
		public function get unitsList():ListCollection
		{
			return _unitsList;
		}

		[Bindable(event="levelChanged")]
		/**
		 * Подпись текущего уровня игрока.
		 */
		public function get levelTitle():String
		{
			return _currentLevel ? _currentLevel.title : null;
		}

		[Bindable(event="levelChanged")]
		/**
		 * Описание текущего уровня игрока.
		 */
		public function get levelDescription():String
		{
			return _currentLevel ? _currentLevel.description : null;
		}

		[Bindable(event="levelChanged")]
		/**
		 * Идентификатор ассета для текущего уровня игрока.
		 */
		public function get levelAssetId():String
		{
			return _currentLevel ? _currentLevel.assetId : null;
		}

		[Bindable(event="godModeChanged")]
		/**
		 * Режим Бога (0...3)
		 */
		public function get godMode():int
		{
			var gameModel:GameModel = AppFacade(facade).gameModel;
			return gameModel.getGodMode();
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
