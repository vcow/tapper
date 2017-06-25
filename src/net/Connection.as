package net
{
	import air.net.URLMonitor;

	import flash.events.StatusEvent;

	import flash.net.URLRequest;

	import starling.events.EventDispatcher;

	[Event(name="status", type="starling.events.Event")]

	public class Connection extends EventDispatcher
	{
		private static var _instance:Connection;
		private static var _url:String;

		private var _monitor:URLMonitor;
		private var _connected:Boolean;

		public static function getInstance():Connection
		{
			if (!_instance)
			{
				_instance = new Connection("http://127.0.0.1:8000/");
//				_instance = new Connection("http://vcow.pythonanywhere.com/");
			}
			return _instance
		}

		public function Connection(url:String)
		{
			super();
			if (_instance) throw Error("Connection is a singleton, use getInstance.");
			_url = url;
			_monitor = new URLMonitor(new URLRequest(_url));
			_monitor.addEventListener(StatusEvent.STATUS, onStatusChanged);
		}

		private function onStatusChanged(event:StatusEvent):void
		{
			var available:Boolean = event.code == "Service.available";
			if (_connected != available)
			{
				_connected = available;
				dispatchEventWith("status", false, _connected ? "connected" : "disconnected");
			}
		}

		public function startMonitor():void
		{
			_monitor.start();
		}

		public function stopMonitor():void
		{
			_monitor.stop();
			if (_connected)
			{
				_connected = false;
				dispatchEventWith("status", false, "disconnected");
			}
		}

		public function get connecteed():Boolean
		{
			return _connected;
		}
	}
}
