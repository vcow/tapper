package resources.locale
{
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	import mx.utils.StringUtil;

	public class LocaleManager
	{
		private var _localeChain:Array;

		private var _requiredBundlesReady:Boolean;

		private var bundles:Dictionary;

		private var loadingQueue:Array;

		private var timeoutID:uint;

		private var _verbose:Boolean = false;

		private static var _instance:LocaleManager;

		public function LocaleManager()
		{
			if (_instance)
				throw Error("LocaleManager is a singletone, use getInstance() methood.");

			_localeChain = [];
			_requiredBundlesReady = true;
			bundles = new Dictionary();
			loadingQueue = [];
		}

		public static function getInstance():LocaleManager
		{
			if (!_instance)
				_instance = new LocaleManager();
			return _instance;
		}

		public function addRequiredBundles(bundles:Array, onRequiredComplete:Function = null):void
		{
			_requiredBundlesReady = false;

			// required bundles take precedence in queue (duplicate check done before loading)
			for (var i:int = bundles.length - 1; i >= 0; i--) {
				loadingQueue.unshift({
					"locale": bundles[i].locale,
					"bundleName": bundles[i].bundleName,
					"useLinebreak": bundles[i].useLinebreak,
					"bundle": bundles[i].bundle,
					"onComplete": onComplete
				});
			}

			// set to false if any of the required bundles fails
			var successForAll:Boolean = true;

			// start loading if not already in progress
			if (loadingQueue.length == bundles.length)
				loadBundle();

			function onComplete(locale:String, bundleName:String, success:Boolean):void
			{
				if (onRequiredComplete is Function) {
					// if loading/parsing failed
					if (!success) successForAll = false;

					// abort if other required bundles are still in queue
					var length:uint = loadingQueue.length;
					for (var i:uint = 0; i < length; i++)
						if (loadingQueue[i].onComplete === onComplete) return;

					// invoke responder if all required bundles ready
					if (successForAll) _requiredBundlesReady = true;
					onRequiredComplete(successForAll);
				}
			}
		}

		public function addBundle(locale:String, bundleName:String, bundle:String,
								  useLinebreak:Boolean = false, onComplete:Function = null):void
		{
			// adding bundle to the queue (duplicate check done before loading)
			loadingQueue.push({
				"locale": locale,
				"bundleName": bundleName,
				"useLinebreak": useLinebreak,
				"bundle": bundle,
				"onComplete": onComplete
			});

			// start loading if not already in progress
			if (loadingQueue.length == 1)
				loadBundle();
		}

		private function unqueueFirst(success:Boolean):void
		{
			var identifier:Object = loadingQueue.shift();

			// invoke responder if set
			if (identifier.onComplete is Function)
				identifier.onComplete(identifier.locale, identifier.bundleName, success);

			timeoutID = setTimeout(loadBundle, 1);
		}

		private function loadBundle():void
		{
			if (timeoutID) clearTimeout(timeoutID);

			// abort if loading queue empty
			if (loadingQueue.length < 1) return;

			// get the first object from queue
			var identifier:Object = loadingQueue[0];

			// abort if bundle already available
			if (identifier.locale in bundles
					&& identifier.bundleName in bundles[identifier.locale]) {
				log("loadBundle: Bundle " + identifier.locale + "/" + identifier.bundleName + " is already available.");
				unqueueFirst(true);
				return;
			}

			parseBundle(identifier.locale, identifier.bundleName, identifier.bundle, identifier.useLinebreak);
			unqueueFirst(Boolean(identifier.bundle));
		}

		private function parseBundle(locale:String, bundleName:String,
									 content:String, useLinebreak:Boolean = false):void
		{
			// create the new bundle
			if (!(locale in bundles)) bundles[locale] = new Dictionary();
			bundles[locale][bundleName] = new Dictionary();

			// parsing the input line by line
			var lines:Array = content.split("\n");
			var length:uint = lines.length;
			var pair:Array;
			for (var i:int = 0; i < length; i++) {
				var s:String = lines[i];
				var index:int = s.search("=");
				if (index <= 0) continue;
				pair = [s.substr(0, index), s.substr(index + 1)];
				// parse line breaks in text
				if (useLinebreak) pair[1] = pair[1].split("\\n").join("\n");
				// assign the key/value pair
				bundles[locale][bundleName][StringUtil.trim(pair[0])] = StringUtil.trim(pair[1]);
			}
		}

		public function getString(bundleName:String, resourceName:String, parameters:Array = null):String
		{
			var length:uint = _localeChain.length;
			for (var i:uint = 0; i < length; i++) {
				if (_localeChain[i] in bundles
						&& bundleName in bundles[_localeChain[i]]
						&& resourceName in bundles[_localeChain[i]][bundleName]) {
					var value:String = bundles[_localeChain[i]][bundleName][resourceName];
					if (parameters)
						value = StringUtil.substitute(value, parameters);
					return value;
				}
			}
			log("getString(" + bundleName + ", " + resourceName + "): No matching resource found.");
			return "";
		}

		public function get localeChain():Array
		{
			return _localeChain;
		}

		public function set localeChain(value:Array):void
		{
			_localeChain = value;
		}

		public function get requiredBundlesReady():Boolean
		{
			return _requiredBundlesReady;
		}

		public function get verbose():Boolean
		{
			return _verbose;
		}

		public function set verbose(value:Boolean):void
		{
			_verbose = value;
		}

		private function log(msg:String):void
		{
			if (verbose)
				trace("[LocaleManager] " + msg);
		}
	}
}
