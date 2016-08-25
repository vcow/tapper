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

		private var _commonTexture:Texture;

		private static var _instance:AtlasLibrary;

		private var _common:TextureAtlas;

		public function AtlasLibrary()
		{
			if (_instance) throw Error("AtlasLibrary is a static class. Use getInstance() method.");

			_commonTexture = Texture.fromEmbeddedAsset(commonAsset);
			_commonTexture.root.onRestore = onCommonRestore;

			_common = new TextureAtlas(_commonTexture, new XML(new commonDescription()));
		}

		private function onCommonRestore():void
		{
			_commonTexture.root.uploadAtfData(new commonAsset());
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
	}
}
