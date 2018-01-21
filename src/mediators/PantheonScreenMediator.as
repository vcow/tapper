package mediators
{
	import app.AppFacade;

	import com.mesmotronic.ane.AndroidID;

	import feathers.data.ListCollection;

	import models.GameModel;

	import net.Statistics;

	import resources.locale.LocaleManager;

	import starling.events.Event;
	import starling.events.EventDispatcher;

	import view.PantheonScreen;

	import vo.MessageBoxData;

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

		private function addListeners(viewScreen:EventDispatcher):void
		{
			var statistics:Statistics = Statistics.getInstance();
			statistics.addEventListener("status", onConnectionStatusChanged);
			statistics.addEventListener("busy", onConnectionBusy);
			onConnectionBusy(null);

			viewScreen.addEventListener("back", onBack);
			viewScreen.addEventListener("registerUser", onRegisterUser);
			viewScreen.addEventListener("setUserData", onSetUserData);
			viewScreen.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			viewScreen.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			if (viewScreen["stage"]) onAddedToStage(null);
		}

		public function removeListeners(viewScreen:EventDispatcher):void
		{
			var statistics:Statistics = Statistics.getInstance();
			statistics.removeEventListener("status", onConnectionStatusChanged);
			statistics.removeEventListener("busy", onConnectionBusy);

			viewScreen.removeEventListener("back", onBack);
			viewScreen.removeEventListener("registerUser", onRegisterUser);
			viewScreen.removeEventListener("setUserData", onSetUserData);
			viewScreen.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			viewScreen.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		private function onConnectionBusy(event:Event):void
		{
			var busy:Boolean = Statistics.getInstance().busy;
			if (busy != _connectionIsBusy)
			{
				_connectionIsBusy = busy;
				dispatchEventWith("connectionIsBusyChanged");
			}
		}

		private function onConnectionStatusChanged(event:Event):void
		{
			dispatchEventWith("pantheonAvailableChanged");
		}

		private function onAddedToStage(event:Event):void
		{
			var statistics:Statistics = Statistics.getInstance();
			if (statistics.connected)
			{
				_currentRequestType = GET_DATA;

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
				sendNotification(Const.SHOW_MESSAGE, new MessageBoxData(
						LocaleManager.getInstance().getString("common", "message.connection.error"),
						onMessageClose, MessageBoxData.OK_BUTTON));
			}
		}

		private function getData():void
		{
			var statistics:Statistics = Statistics.getInstance();
			if (statistics.busy)
			{
				trace("ERROR: Try to get data with busy connection.");
				return;
			}

			statistics.addEventListener("error", onGetData);
			statistics.addEventListener("complete", onGetData);
			statistics.getData();
		}

		private function showRegisterForm():void
		{
			var screenView:PantheonScreen = viewComponent as PantheonScreen;
			if (screenView) screenView.showRegisterForm();
		}

		private function onMessageClose(result:uint):void
		{
			sendNotification(Const.POP);
		}

		private function onGetData(event:Event):void
		{
			_currentRequestType = null;

			var statistics:Statistics = Statistics.getInstance();
			statistics.removeEventListener("error", onGetData);
			statistics.removeEventListener("complete", onGetData);

			if (event.type == "error")
			{
				if (_topList)
				{
					_topList = null;
					dispatchEventWith("topListChanged");
				}
				sendNotification(Const.SHOW_MESSAGE, new MessageBoxData(
						LocaleManager.getInstance().getString("common", "message.connection.error"),
						null, MessageBoxData.OK_BUTTON));
			}
			else
			{
				// TODO:
			}
		}

		public function onRemovedFromStage(event:Event):void
		{
			var statistics:Statistics = Statistics.getInstance();
			statistics.close();

			_currentRequestType = null;
		}

		private function onBack(event:Event):void
		{
			sendNotification(Const.POP);
		}

		private function onRegisterUser(event:Event):void
		{

		}

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

		private function onSetUserData(event:Event):void
		{
			if (!pantheonAvailable || connectionIsBusy)
			{
				sendNotification(Const.SHOW_MESSAGE, new MessageBoxData(
						LocaleManager.getInstance().getString("common", "message.statistics.error"),
						onMessageClose, Const.ON_OK));
				return;
			}

			if (_currentRequestType) return;
			_currentRequestType = SET_DATA;

			var gameModel:GameModel = AppFacade(facade).gameModel;
			var statistics:Statistics = Statistics.getInstance();

			statistics.addEventListener("complete", onSetDataComplete);
			statistics.addEventListener("error", onStatisticsError);
			statistics.setData(userData, gameModel.money);
		}

		private function onSetDataComplete(event:Event):void
		{
			var statistics:Statistics = Statistics.getInstance();
			statistics.removeEventListener("complete", onSetDataComplete);

			switch (parseResponse(event.data))
			{
				case RESPONSE_OK:
					getData();
					break;
				case RESPONSE_NOT_AUTHENTICATED:
					statistics.addEventListener("complete", onAuthComplete);
					statistics.auth(login, password);
					break;
				case RESPONSE_NOT_REGISTERED:
					showRegisterForm();
					break;
				default:
					sendNotification(Const.SHOW_MESSAGE, new MessageBoxData(
							"data_set: " + event.data.substr(0, 256), onMessageClose, Const.ON_OK));
			}
		}

		private function onAuthComplete(event:Event):void
		{
			var statistics:Statistics = Statistics.getInstance();
			statistics.removeEventListener("complete", onAuthComplete);

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
					showRegisterForm();
					break;
				default:
					sendNotification(Const.SHOW_MESSAGE, new MessageBoxData(
							"data_set: " + event.data.substr(0, 256), onMessageClose, Const.ON_OK));
			}
		}

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
						return RESPONSE_NOT_AUTHENTICATED;
				}
			}
			return RESPONSE_OK;
		}

		private function onStatisticsError(event:Event):void
		{
			var statistics:Statistics = Statistics.getInstance();
			statistics.removeEventListener("error", onSetDataComplete);

			sendNotification(Const.SHOW_MESSAGE, new MessageBoxData(
					LocaleManager.getInstance().getString("common", "message.statistics.sendDataFailed"),
					onMessageClose, Const.ON_OK));
		}

		public function get userData():Object
		{
			return {};
		}

		public function get login():String
		{
			if (!_login) generateLoginPassword();
			return _login;
		}

		public function get password():String
		{
			if (!_password) generateLoginPassword();
			return _password;
		}

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
			return "123456789ABCDEF";
		}
	}
}
