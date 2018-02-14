package net
{
	import air.net.URLMonitor;

	import com.adobe.crypto.MD5;
	import com.sociodox.utils.Base64;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestDefaults;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;

	import mx.utils.StringUtil;

	import starling.events.EventDispatcher;

	[Event(name="status", type="starling.events.Event")]
	[Event(name="error", type="starling.events.Event")]
	[Event(name="busy", type="starling.events.Event")]
	[Event(name="complete", type="starling.events.Event")]

	/**
	 * Соединение с сервером статистики.
	 */
	public class Statistics extends EventDispatcher
	{
		private static var _instance:Statistics;
		private static var _url:String;

		private var _monitor:URLMonitor;
		private var _connected:Boolean;

		private var _loaders:Vector.<URLLoader> = new Vector.<URLLoader>();

		public static const LOGIN_MAX_LENGTH:int = 12;
		public static const PASSWORD_MAX_LENGTH:int = 50;

		public static function getInstance():Statistics
		{
			if (!_instance)
			{
//				_instance = new Statistics("http://127.0.0.1:8000/");
				_instance = new Statistics("http://vcow.pythonanywhere.com/");
			}
			return _instance
		}

		public function Statistics(url:String)
		{
			super();
			if (_instance) throw Error("Statistics is a singleton, use getInstance.");

			URLRequestDefaults.authenticate = false;
			URLRequestDefaults.cacheResponse = false;
			URLRequestDefaults.useCache = false;

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

		/**
		 * Старт мониторинга подключения к серверу статистики.
		 */
		public function startMonitor():void
		{
			_monitor.start();
		}

		/**
		 * Остановка мониторинга подключения к серверу статистики.
		 */
		public function stopMonitor():void
		{
			_monitor.stop();
			if (_connected)
			{
				_connected = false;
				dispatchEventWith("status", false, "disconnected");
			}
		}

		/**
		 * Флаг указывает наличие / отсутствие подключения к серверу статистики.
		 */
		public function get connected():Boolean
		{
			return _connected;
		}

		/**
		 * Флаг указывает на наличие / отсутствие необработанных запросов к серверу статистики.
		 */
		public function get busy():Boolean
		{
			return _loaders.length > 0;
		}

		/**
		 * Получить данные статистики.
		 */
		public function getData():void
		{
			send(_url + "data/get/", null);
		}

		/**
		 * Разлогиниться.
		 */
		public function close():void
		{
			send(_url + "data/close/", null);
		}

		/**
		 * Зарегистрировать нового игрока на сервере статистики.
		 * @param login Логин.
		 * @param password Пароль.
		 */
		public function register(login:String, password:String):void
		{
			var variables:URLVariables = new URLVariables();
			variables.username = StringUtil.trim(login).slice(0, LOGIN_MAX_LENGTH);
			variables.password = password.slice(0, PASSWORD_MAX_LENGTH);
			send(_url + "data/register/", variables);
		}

		/**
		 * Аутентификация на сервере статистики.
		 * @param login Логин.
		 * @param password Пароль.
		 */
		public function auth(login:String, password:String):void
		{
			var variables:URLVariables = new URLVariables();
			variables.username = StringUtil.trim(login).slice(0, LOGIN_MAX_LENGTH);
			variables.password = password.slice(0, PASSWORD_MAX_LENGTH);
			send(_url + "data/auth/", variables);
		}

		/**
		 * Передать новые данные для игрока на сервер статистики.
		 * @param data Данные.
		 * @param scores Новое количество набранных денег.
		 */
		public function setData(data:Object, scores:Number):void
		{
			var scoresText:String = (isNaN(scores) ? 0 : Math.floor(scores)).toString();
			var variables:URLVariables = new URLVariables();
			data.scores = encode(scoresText);
			variables.data = JSON.stringify(data);
			send(_url + "data/set/", variables);
		}

		private static function encode(msg:String):String
		{
			var buffer1:ByteArray = new ByteArray();
			buffer1.writeUTFBytes(msg);
			var l:int = buffer1.length % 4;
			if (l > 0)
			{
				l = 4 - l;
				for (var i:int = 0; i < l; i++)
				{
					buffer1.writeByte(0);
				}
			}
			buffer1.position = 0;
			var buffer2:ByteArray = new ByteArray();
			while (buffer1.bytesAvailable)
			{
				var chunk:uint = buffer1.readUnsignedInt() ^ 0xe6eeefe0;
				buffer2.writeUnsignedInt(chunk);
			}
			buffer2.position = 0;
			var md5:String = MD5.hash(msg);
			buffer1.clear();
			buffer1.writeUTFBytes(md5);
			buffer1.writeInt(msg.length);
			buffer1.writeBytes(buffer2);
			buffer1.position = 0;
			return Base64.encode(buffer1);
		}

		private function send(url:String, data:URLVariables):void
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			loader.addEventListener(Event.COMPLETE, onComplete);
			var request:URLRequest = new URLRequest(url);
			request.data = data;
			loader.load(request);
			var isBusy:Boolean = _loaders.length > 0;
			_loaders.push(loader);
			if (!isBusy)
			{
				dispatchEventWith("busy", false, true);
			}
		}

		private function removeLoader(loader:URLLoader):URLLoader
		{
			var index:int = _loaders.indexOf(loader);
			if (index != -1)
			{
				_loaders.splice(index, 1);
				loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
				loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
				loader.removeEventListener(Event.COMPLETE, onComplete);
				if (_loaders.length == 0)
				{
					dispatchEventWith("busy", false, false);
				}
			}
			return loader;
		}

		private function onError(event:Event):void
		{
			removeLoader(event.target as URLLoader);
			dispatchEventWith("error", false, event["text"]);
			trace(event["text"]);
		}

		private function onComplete(event:Event):void
		{
			var loader:URLLoader = removeLoader(event.target as URLLoader);
			var data:String = String(loader.data);
			try {
				processResponse(JSON.parse(data));
			}
			catch (e:Error) {
				processResponse({error: "unexpected"});
			}
		}

		private function processResponse(response:Object):void
		{
			dispatchEventWith("complete", false, response);
		}
	}
}
