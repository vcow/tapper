package mediators
{
	import feathers.data.ListCollection;

	import net.Connection;

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
			var connection:Connection = Connection.getInstance();
			connection.addEventListener("status", onConnectionStatusChanged);
			connection.addEventListener("busy", onConnectionBusy);
			onConnectionBusy(null);

			viewScreen.addEventListener("back", onBack);
			viewScreen.addEventListener("authenticate", onAuthenticate);
			viewScreen.addEventListener("registerUser", onRegisterUser);
			viewScreen.addEventListener("setUserData", onSetUserData);
			viewScreen.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			viewScreen.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			if (viewScreen["stage"]) onAddedToStage(null);
		}

		public function removeListeners(viewScreen:EventDispatcher):void
		{
			var connection:Connection = Connection.getInstance();
			connection.removeEventListener("status", onConnectionStatusChanged);
			connection.removeEventListener("busy", onConnectionBusy);

			viewScreen.removeEventListener("back", onBack);
			viewScreen.removeEventListener("authenticate", onAuthenticate);
			viewScreen.removeEventListener("registerUser", onRegisterUser);
			viewScreen.removeEventListener("setUserData", onSetUserData);
			viewScreen.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			viewScreen.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		private function onConnectionBusy(event:Event):void
		{
			var busy:Boolean = Connection.getInstance().busy;
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
			var connection:Connection = Connection.getInstance();
			if (connection.connected)
			{
				var getData:Function = function (event:Event):void
				{
					if (!connection.busy)
					{
						if (event)
							connection.removeEventListener("busy", arguments.callee);
						connection.addEventListener("error", onGetData);
						connection.addEventListener("complete", onGetData);
						connection.getData();
					}
				};
				if (connection.busy)
				{
					connection.addEventListener("busy", getData);
				}
				else
				{
					getData(null);
				}
			}
			else
			{
				sendNotification(Const.SHOW_MESSAGE, new MessageBoxData(
						LocaleManager.getInstance().getString("common", "message.connection.error"),
						onMessageClose, MessageBoxData.OK_BUTTON));
			}
		}

		private function onMessageClose(result:uint):void
		{
			sendNotification(Const.POP);
		}

		private function onGetData(event:Event):void
		{
			var connection:Connection = Connection.getInstance();
			connection.removeEventListener("error", onGetData);
			connection.removeEventListener("complete", onGetData);

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

		}

		private function onBack(event:Event):void
		{
			sendNotification(Const.POP);
		}

		private function onAuthenticate(event:Event):void
		{

		}

		private function onRegisterUser(event:Event):void
		{

		}

		private function onSetUserData(event:Event):void
		{

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
			return Connection.getInstance().connected;
		}
	}
}
