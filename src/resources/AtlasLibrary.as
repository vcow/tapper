package resources
{
	import flash.utils.ByteArray;

	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;

	public class AtlasLibrary
	{
		[Embed(source="graphics/title.atf", mimeType="application/octet-stream")]
		private static const titleAsset:Class;

		[Embed(source="graphics/title.xml", mimeType="application/octet-stream")]
		private static const titleDescription:Class;

		[Embed(source="graphics/globe.atf", mimeType="application/octet-stream")]
		private static const globeAsset:Class;

		[Embed(source="graphics/globe.xml", mimeType="application/octet-stream")]
		private static const globeDescription:Class;

		private var _titleTexture:Texture;
		private var _globeTexture:Texture;

		private static var _instance:AtlasLibrary;

		private var _title:TextureAtlas;
		private var _globe:TextureAtlas;

		private var _manager:AssetManager;

		public function AtlasLibrary()
		{
			if (_instance) throw Error("AtlasLibrary is a static class. Use getInstance() method.");

			_titleTexture = Texture.fromAtfData(new titleAsset() as ByteArray);
			_titleTexture.root.onRestore = onTitleRestore;
			_globeTexture = Texture.fromAtfData(new globeAsset() as ByteArray);
			_globeTexture.root.onRestore = onGlobeRestore;

			_manager = new AssetManager();

			_title = new TextureAtlas(_titleTexture, new XML(new titleDescription()));
			_globe = new TextureAtlas(_globeTexture, new XML(new globeDescription()));
		}

		public function get manager():AssetManager
		{
			return _manager;
		}

		private function onTitleRestore():void
		{
			_titleTexture.root.uploadAtfData(new titleAsset() as ByteArray);
		}

		private function onGlobeRestore():void
		{
			_globeTexture.root.uploadAtfData(new globeAsset() as ByteArray);
		}

		public static function getInstance():AtlasLibrary
		{
			if (!_instance) _instance = new AtlasLibrary();
			return _instance;
		}

		public function get title():TextureAtlas
		{
			return _title;
		}

		public function get globe():TextureAtlas
		{
			return _globe;
		}
	}
}
