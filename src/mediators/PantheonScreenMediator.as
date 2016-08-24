package mediators
{
	import app.AppFacade;

	import com.mesmotronic.ane.AndroidID;

	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import models.GameModel;
	import models.SkinType;

	import net.Statistics;

	import resources.locale.LocaleManager;

	import starling.core.Starling;

	import starling.events.Event;
	import starling.events.EventDispatcher;

	import view.MainScreen;

	import view.PantheonScreen;
	import view.TutorialFrame;

	import vo.MessageBoxData;
	import vo.TopItem;
	import vo.TutorialData;
	import vo.Unit;

	/**
	 * Медиатор Пантеона.
	 */
	public class PantheonScreenMediator extends BindableMediator
	{
		private var _topList:ListCollection;
		private var _connectionIsBusy:Boolean;

		private var _login:String;
		private var _password:String;

		private static const RESPONSE_OK:String = "ok";
		private static const RESPONSE_NOT_REGISTERED:String = "notRegistered";
		private static const RESPONSE_NOT_AUTHENTICATED:String = "notAuthenticated";

		private static const SET_DATA:String = "setData";
		private static const GET_DATA:String = "getData";

		private var _currentRequestType:String;

		private var _lastUserScores:Number = 0;

		public function PantheonScreenMediator(mediatorName:String = null, viewComponent:Object = null)
		{
			super(mediatorName, viewComponent);
		}

		override public function onRegister():void
		{
			var pantheonScreen:PantheonScreen = getViewComponent() as PantheonScreen;
			if (pantheonScreen)
			{
				addListeners(pantheonScreen);

				var gameModel:GameModel = AppFacade(facade).gameModel;
				if (!gameModel.tutorial.pantheonScreen)
				{
					var lm:LocaleManager = LocaleManager.getInstance();
					var tutorialData:TutorialData = new TutorialData("pantheonScreen");
					tutorialData.frames.push(new TutorialFrame(new flash.geom.Rectangle(6, 16, 230, 72),
							lm.getString("common", "tutor.pantheon.exit"), TutorialFrame.RIGHT, 16, new Point(10, 0)));
					tutorialData.frames.push(new TutorialFrame(new flash.geom.Rectangle(6, 118, 230, 72),
							lm.getString("common", "tutor.pantheon.save"), TutorialFrame.RIGHT, 16, new Point(10, 0)));
					tutorialData.frames.push(new TutorialFrame(new flash.geom.Rectangle(48, 365, 96, 130),
							lm.getString("common", "tutor.pantheon.collapse"), TutorialFrame.RIGHT, 20, new Point(10, 0)));

					var onShowTutorial:Function = function (event:Event):void
					{
						if (event)
							event.target.removeEventListener(FeathersEventType.CREATION_COMPLETE, onShowTutorial);

						pantheonScreen.pantheonMenu.expand();
						var mainScreen:MainScreen = Starling.current.root as MainScreen;
						if (mainScreen)
						{
							mainScreen.tutorialScreen.addEventListener("closed", function (event:Event):void
							{
								mainScreen.tutorialScreen.removeEventListener("closed", arguments.callee);
								pantheonScreen.pantheonMenu.collapse(null, false);
							});
						}

						sendNotification(Const.SHOW_TUTORIAL, tutorialData);
					};

					if (pantheonScreen.isCreated)
						onShowTutorial(null);
					else
						pantheonScreen.addEventListener(FeathersEventType.CREATION_COMPLETE, onShowTutorial);
				}
			}
		}

		override public function onRemove():void
		{
			var pantheonScreen:PantheonScreen = getViewComponent() as PantheonScreen;
			if (pantheonScreen)
			{
				removeListeners(pantheonScreen);
			}
		}

		override public function setViewComponent(viewComponent:Object):void
		{
			if (viewComponent == viewComponent) return;

			if (viewComponent)
			{
				removeListeners(viewComponent as EventDispatcher);
			}

			super.setViewComponent(viewComponent);
			if (viewComponent)
			{
				addListeners(viewComponent as EventDispatcher);
			}
		}

		// Прослушивать события представления и соединения.
		private function addListeners(viewScreen:EventDispatcher):void
		{
			var statistics:Statistics = Statistics.getInstance();
			statistics.addEventListener("status", onConnectionStatusChanged);
			statistics.addEventListener("busy", onConnectionBusy);
			onConnectionBusy(null);

			viewScreen.addEventListener("back", onBack);
			viewScreen.addEventListener("setUserData", onSetUserData);
			viewScreen.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			viewScreen.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			if (viewScreen["stage"]) onAddedToStage(null);
		}

		// Не прослушивать события представления и соединения.
		public function removeListeners(viewScreen:EventDispatcher):void
		{
			var statistics:Statistics = Statistics.getInstance();
			statistics.removeEventListener("status", onConnectionStatusChanged);
			statistics.removeEventListener("busy", onConnectionBusy);

			viewScreen.removeEventListener("back", onBack);
			viewScreen.removeEventListener("setUserData", onSetUserData);
			viewScreen.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			viewScreen.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		// Обработчик сообщения от соединения о том, что в настоящий момент соединение занято.
		private function onConnectionBusy(event:Event):void
		{
			var busy:Boolean = Statistics.getInstance().busy;
			if (busy != _connectionIsBusy)
			{
				_connectionIsBusy = busy;
				dispatchEventWith("connectionIsBusyChanged");
			}
		}

		// Обработчик смены статуса соединения - доступно / недоступно
		private function onConnectionStatusChanged(event:Event):void
		{
			dispatchEventWith("pantheonAvailableChanged");
		}

		// Представление добавлено на сцену
		private function onAddedToStage(event:Event):void
		{
			var statistics:Statistics = Statistics.getInstance();
			if (statistics.connected)
			{
				_currentRequestType = GET_DATA;

				// Если соединение доступно, получит текущий рейтинг.
				if (statistics.busy)
				{
					statistics.addEventListener("busy", function (event:Event):void
					{
						if (statistics.busy) return;
						statistics.removeEventListener("busy", arguments.callee);
						getData();
					});
				}
				else
				{
					getData();
				}
			}
			else
			{
				// Если соединение недоступно, выдать предупреждение.
				sendNotification(Const.SHOW_MESSAGE, new MessageBoxData(
						LocaleManager.getInstance().getString("common", "message.connection.error"),
						onMessageClose, Const.ON_OK));
			}
		}

		// Вспомогательная функция, инициирует получение рейтинга.
		private function getData():void
		{
			var statistics:Statistics = Statistics.getInstance();
			if (statistics.busy)
			{
				trace("ERROR: Try to get data with busy connection.");
				return;
			}

			statistics.addEventListener("complete", onGetData);
			statistics.addEventListener("error", onGetData);
			statistics.getData();
		}

		// Вспомогательная функция, возвращает текущее имя игрока в Пантеоне. Если имя неизвестно,
		// открывается диалог с запросом имени у игрока.
		private function getUserName(callback:Function):void
		{
			var screenView:PantheonScreen = viewComponent as PantheonScreen;
			if (screenView)
			{
				screenView.addEventListener("setUserName", function (event:Event):void
				{
					screenView.removeEventListener("setUserName", arguments.callee);
					if (callback != null) callback(event.data);
				});
				screenView.showUserNameForm();
			}
			else
			{
				if (callback != null) callback("");
			}
		}

		// Общий обработчик закрытия окон сообщений об ошибках, просто закрывает Пантеон.
		private function onMessageClose(result:uint):void
		{
			sendNotification(Const.POP);
		}

		// Обработчик получения рейтингов с сервера.
		private function onGetData(event:Event):void
		{
			_currentRequestType = null;

			var statistics:Statistics = Statistics.getInstance();
			statistics.removeEventListener("complete", onGetData);
			statistics.removeEventListener("error", onGetData);

			if (event.type == "error")
			{
				if (_topList)
				{
					_topList = null;
					dispatchEventWith("topListChanged");
				}
				sendNotification(Const.SHOW_MESSAGE, new MessageBoxData(
						LocaleManager.getInstance().getString("common", "message.connection.error"),
						null, Const.ON_OK));
			}
			else
			{
				updateTopList(event.data.leaders as Array, event.data.user);
			}
		}

		// Обработчик закрытия окна Пантеона.
		public function onRemovedFromStage(event:Event):void
		{
//			var statistics:Statistics = Statistics.getInstance();
//			statistics.close();

			_currentRequestType = null;
		}

		/**
		 * Текущий рейтинг игрока.
		 */
		public function get scores():Number
		{
			var model:GameModel = AppFacade(facade).gameModel;
			return model.money;
		}

		// Команда на закрытие Пантеона.
		private function onBack(event:Event):void
		{
			sendNotification(Const.POP);
		}

		// Вспомогательная функция регистрации на сервере игрока с указанным именем.
		private function doRegisterUser(name:String):void
		{
			if (!name || !pantheonAvailable || connectionIsBusy)
			{
				sendNotification(Const.SHOW_MESSAGE, new MessageBoxData(
						LocaleManager.getInstance().getString("common", "message.statistics.error"),
						onMessageClose, Const.ON_OK));
				return;
			}

			var model:GameModel = AppFacade(facade).gameModel;
			model.pantheonUserName = name;

			var statistics:Statistics = Statistics.getInstance();
			statistics.addEventListener("complete", onRegisterComplete);
			statistics.addEventListener("error", onStatisticsError);
			statistics.register(login, password);
		}

		// Генерация на основе id устройства уникальных логина и пароля.
		private function generateLoginPassword():void
		{
			var id:String = AndroidID.isSupported ? AndroidID.ANDROID_ID : generateId();
			if (!id || id.length == 0) throw Error("Can't get device ID.");

			_password = id;
			while (_password.length < Statistics.PASSWORD_MAX_LENGTH) _password += id;
			_login = _password.substr(Statistics.PASSWORD_MAX_LENGTH);
			_password = _password.substr(0, Statistics.PASSWORD_MAX_LENGTH);
			while (_login.length < Statistics.LOGIN_MAX_LENGTH) _login += id;
			_login = _login.substr(0, Statistics.LOGIN_MAX_LENGTH);
		}

		// Обработчик завершения регистрации.
		private function onRegisterComplete(event:Event):void
		{
			var statistics:Statistics = Statistics.getInstance();
			statistics.removeEventListener("complete", onRegisterComplete);
			statistics.removeEventListener("error", onStatisticsError);

			switch (parseResponse(event.data))
			{
				case RESPONSE_OK:
					if (_currentRequestType == SET_DATA)
					{
						_currentRequestType = null;
						onSetUserData(null);
					}
					else
					{
						getData();
					}
					break;
				case RESPONSE_NOT_AUTHENTICATED:
					sendNotification(Const.SHOW_MESSAGE, new MessageBoxData(
							LocaleManager.getInstance().getString("common", "message.statistics.registration_failed"),
							onMessageClose, Const.ON_OK));
					break;
				default:
					sendNotification(Const.SHOW_MESSAGE, new MessageBoxData(
							"data_set: " + event.data.substr(0, 256), onMessageClose, Const.ON_OK));
			}
		}

		// Сохранить текущий результат в Пантеоне.
		private function onSetUserData(event:Event):void
		{
			if (!pantheonAvailable || connectionIsBusy)
			{
				sendNotification(Const.SHOW_MESSAGE, new MessageBoxData(
						LocaleManager.getInstance().getString("common", "message.statistics.error"),
						onMessageClose, Const.ON_OK));
				return;
			}

			var model:GameModel = AppFacade(facade).gameModel;
			if (model.money <= 0)
			{
				// У юзера нулевой балланс, сохранять нечего.
				sendNotification(Const.SHOW_MESSAGE, new MessageBoxData(
						LocaleManager.getInstance().getString("common", "message.statistics.noMoney"),
						null, Const.ON_OK));
				return;
			}

			if (model.pantheonUserName)
			{
				doSetData(true);
			}
			else
			{
				getUserName(function (name:String):void
				{
					if (!name) return;
					model.pantheonUserName = name;
					doSetData(true);
				});
			}
		}

		// Вспомогательная функция сохранения результата на сервере.
		private function doSetData(checkPrevResult:Boolean):void
		{
			var model:GameModel = AppFacade(facade).gameModel;
			if (checkPrevResult)
			{
				// Проверить, не стал ли результат меньше предыдущего, выдать предупреждение.
				if (model.money < _lastUserScores)
				{
					sendNotification(Const.SHOW_MESSAGE, new MessageBoxData(
							LocaleManager.getInstance().getString("common", "message.statistics.isDownshift",
							[_lastUserScores, model.money]),
							function (result:uint):void
							{
								if (result == Const.ON_YES)
								{
									doSetData(false);
								}
							}, Const.ON_YES | Const.ON_NO));
					return;
				}
			}

			if (_currentRequestType) return;
			_currentRequestType = SET_DATA;

			var statistics:Statistics = Statistics.getInstance();

			statistics.addEventListener("complete", onSetDataComplete);
			statistics.addEventListener("error", onStatisticsError);
			statistics.setData(userData, model.money);
		}

		// Обработчик сохранения результата на сервере.
		private function onSetDataComplete(event:Event):void
		{
			var statistics:Statistics = Statistics.getInstance();
			statistics.removeEventListener("complete", onSetDataComplete);
			statistics.removeEventListener("error", onStatisticsError);

			switch (parseResponse(event.data))
			{
				case RESPONSE_OK:
					getData();
					break;
				case RESPONSE_NOT_AUTHENTICATED:
					statistics.addEventListener("complete", onAuthComplete);
					statistics.addEventListener("error", onStatisticsError);
					statistics.auth(login, password);
					break;
				case RESPONSE_NOT_REGISTERED:
					var model:GameModel = AppFacade(facade).gameModel;
					if (model.pantheonUserName)
					{
						doRegisterUser(model.pantheonUserName);
					}
					else
					{
						getUserName(function (name:String):void
						{
							if (!name) return;
							model.pantheonUserName = name;
							doRegisterUser(model.pantheonUserName);
						});
					}
					break;
				default:
					sendNotification(Const.SHOW_MESSAGE, new MessageBoxData(
							"data_set: " + event.data.substr(0, 256), onMessageClose, Const.ON_OK));
			}
		}

		// Обработчик запроса на аутентификацию игрока в Пантеоне.
		private function onAuthComplete(event:Event):void
		{
			var statistics:Statistics = Statistics.getInstance();
			statistics.removeEventListener("complete", onAuthComplete);
			statistics.removeEventListener("error", onStatisticsError);

			switch (parseResponse(event.data))
			{
				case RESPONSE_OK:
					if (_currentRequestType == SET_DATA)
					{
						_currentRequestType = null;
						onSetUserData(null);
					}
					else if (_currentRequestType == GET_DATA)
					{
						getData();
					}
					break;
				case RESPONSE_NOT_REGISTERED:
					var model:GameModel = AppFacade(facade).gameModel;
					if (model.pantheonUserName)
					{
						doRegisterUser(model.pantheonUserName);
					}
					else
					{
						getUserName(function (name:String):void
						{
							if (!name) return;
							model.pantheonUserName = name;
							doRegisterUser(model.pantheonUserName);
						});
					}
					break;
				default:
					sendNotification(Const.SHOW_MESSAGE, new MessageBoxData(
							"data_set: " + event.data.substr(0, 256), onMessageClose, Const.ON_OK));
			}
		}

		// Вспомогательная функция, переводит ответ от сервера в упрощенные значения для дальнейшей обработки.
		private static function parseResponse(response:Object):String
		{
			if (response.hasOwnProperty("error"))
			{
				switch (response.error)
				{
					case "Not registered":
					case "Wrong login password":
						return RESPONSE_NOT_REGISTERED;
					case "Not authenticated":
					case "Already registered":
						return RESPONSE_NOT_AUTHENTICATED;
				}
			}
			return RESPONSE_OK;
		}

		// Общий обработчик получения ошибки от сервера.
		private function onStatisticsError(event:Event):void
		{
			var statistics:Statistics = Statistics.getInstance();
			statistics.removeEventListener("complete", onAuthComplete);
			statistics.removeEventListener("complete", onRegisterComplete);
			statistics.removeEventListener("complete", onSetDataComplete);
			statistics.removeEventListener("error", onStatisticsError);

			sendNotification(Const.SHOW_MESSAGE, new MessageBoxData(
					LocaleManager.getInstance().getString("common", "message.statistics.sendDataFailed"),
					onMessageClose, Const.ON_OK));
		}

		/**
		 * Текущие полученные от сервера данные по игроку.
		 */
		public function get userData():Object
		{
			var model:GameModel = AppFacade(facade).gameModel;
			var units:Vector.<Unit> = model.getActiveUnits();
			return {
				user_name: model.pantheonUserName,
				god: model.addonModel.godMode,
				cabin: model.currentSkin,
				cabin_max: getMaxRoom(model.addonModel.rooms),
				level: model.level,
				taps: model.tapsTotal,
				units_count: units.length,
				best_unit: units.length > 0 ? units[0].info.id : ""
			};
		}

		// Вспомогательная функция, возвращает идентификатор лучшего кабинета, доступного в данный
		// момент игроку. Добавлено для возможной поддержки указания типа кабинета в рейтинге.
		private static function getMaxRoom(rooms:Vector.<String>):String
		{
			var r:String = SkinType.WOOD;
			for each (var room:String in rooms)
			{
				switch (room)
				{
					case SkinType.GOLD:
						r = room;
						break;
					case SkinType.SILVER:
						if (r != SkinType.GOLD) r = room;
						break;
					case SkinType.BRONZE:
						if (r == SkinType.WOOD) r = room;
				}
			}
			return r;
		}

		// Обновить содержимое топ 10.
		private function updateTopList(data:Array, userRecord:Object = null):void
		{
			var top:Vector.<TopItem> = new Vector.<TopItem>();

			for (var i:int = 0, l:int = Math.min(data.length, 10); i < l; ++i)
			{
				var item:TopItem = new TopItem(data[i]);
				item.place = i + 1;
				top.push(item);
			}
			if (userRecord)
			{
				var userItem:TopItem = new TopItem(userRecord, true);

				var model:GameModel = AppFacade(facade).gameModel;
				model.pantheonUserName = userItem.name || model.pantheonUserName;
				_lastUserScores = userItem.scores;

				if (userItem.place > 10)
				{
					this.userItem = userItem;
				}
				else
				{
					this.userItem = null;
					for (i = 0, l = top.length; i < l; ++i)
					{
						item = top[i];
						if (item.id == userItem.id)
						{
							top.removeAt(i);
							top.insertAt(i, userItem);
							break;
						}
					}
				}
			}
			else
			{
				_lastUserScores = 0;
				this.userItem = null;
			}

			top.sort(function (a:TopItem, b:TopItem):int
			{
				if (a.scores > b.scores) return -1;
				if (a.scores < b.scores) return 1;
				// TODO: Добавить другие приоритеты сортировки, если появятся.
				return 0;
			});

			_topList = new ListCollection(top);
			dispatchEventWith("topListChanged");
		}

		/**
		 * Текущий сгенерированный логин игрока.
		 */
		public function get login():String
		{
			if (!_login) generateLoginPassword();
			return _login;
		}

		/**
		 * Текущий сгенерированный пароль игрока.
		 */
		public function get password():String
		{
			if (!_password) generateLoginPassword();
			return _password;
		}

		[Bindable]
		public var userItem:TopItem;

		[Bindable(event="topListChanged")]
		public function get topList():ListCollection
		{
			return _topList;
		}

		[Bindable(event="connectionIsBusyChanged")]
		public function get connectionIsBusy():Boolean
		{
			return _connectionIsBusy;
		}

		[Bindable(event="pantheonAvailableChanged")]
		public function get pantheonAvailable():Boolean
		{
			return Statistics.getInstance().connected;
		}

		private function generateId():String
		{
			return "test_id_17";
		}
	}
}
