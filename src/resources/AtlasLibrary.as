package resources
{
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class AtlasLibrary
	{
		[Embed(source="graphics/common.atf", mimeType="application/octet-stream")]
		private static const commonAsset:Class;

		[Embed(source="graphics/common.xml", mimeType="application/octet-stream")]
		private static const commonDescription:Class;

		[Embed(source="graphics/wooden.atf", mimeType="application/octet-stream")]
		private static const woodenAsset:Class;

		[Embed(source="graphics/wooden.xml", mimeType="application/octet-stream")]
		private static const woodenDescription:Class;

		private var _commonTexture:Texture;
		private var _woodenTexture:Texture;

		private static var _instance:AtlasLibrary;

		private var _common:TextureAtlas;
		private var _wooden:TextureAtlas;

		public function AtlasLibrary()
		{
			if (_instance) throw Error("AtlasLibrary is a static class. Use getInstance() method.");

			_commonTexture = Texture.fromEmbeddedAsset(commonAsset);
			_commonTexture.root.onRestore = onCommonRestore;

			_woodenTexture = Texture.fromEmbeddedAsset(woodenAsset);
			_woodenTexture.root.onRestore = onWoodenRestore;

			_common = new TextureAtlas(_commonTexture, new XML(new commonDescription()));
			_wooden = new TextureAtlas(_woodenTexture, new XML(new woodenDescription()));
		}

		private function onCommonRestore():void
		{
			_commonTexture.root.uploadAtfData(new commonAsset());
		}

		private function onWoodenRestore():void
		{
			_woodenTexture.root.uploadAtfData(new woodenAsset());
		}

		public static function getInstance():AtlasLibrary
		{
			if (!_instance) _instance = new AtlasLibrary();
			return _instance;
		}

		public function get common():TextureAtlas
		{
			return _common;
		}

		public function get wooden():TextureAtlas
		{
			return _wooden;
		}
	}
}
