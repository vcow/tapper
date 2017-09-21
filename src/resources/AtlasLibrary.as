package resources
{
	import starling.utils.AssetManager;

	/**
	 * Библиотека графических ресурсов.
	 */
	public class AtlasLibrary
	{
		private static var _instance:AtlasLibrary;
		private var _manager:AssetManager;

		public function AtlasLibrary()
		{
			if (_instance) throw Error("AtlasLibrary is a static class. Use getInstance() method.");
			_manager = new AssetManager();
		}

		/**
		 * Менеджер ресурсов.
		 */
		public function get manager():AssetManager
		{
			return _manager;
		}

		public static function getInstance():AtlasLibrary
		{
			if (!_instance) _instance = new AtlasLibrary();
			return _instance;
		}
	}
}
