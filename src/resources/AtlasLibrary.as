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

		[Embed(source="graphics/noise_anim.atf", mimeType="application/octet-stream")]
		private static const noiseAnimAsset:Class;

		[Embed(source="graphics/noise_anim.xml", mimeType="application/octet-stream")]
		private static const noiseAnimDescription:Class;

		private var _commonTexture:Texture;
		private var _woodenTexture:Texture;

		private var _noiseAnimTexture:Texture;

		private static var _instance:AtlasLibrary;

		private var _common:TextureAtlas;
		private var _wooden:TextureAtlas;
		private var _noiseAnim:TextureAtlas;

		public function AtlasLibrary()
		{
			if (_instance) throw Error("AtlasLibrary is a static class. Use getInstance() method.");

			_commonTexture = Texture.fromEmbeddedAsset(commonAsset);
			_commonTexture.root.onRestore = onCommonRestore;
			_woodenTexture = Texture.fromEmbeddedAsset(woodenAsset);
			_woodenTexture.root.onRestore = onWoodenRestore;

			_noiseAnimTexture = Texture.fromEmbeddedAsset(noiseAnimAsset);
			_noiseAnimTexture.root.onRestore = onNoiseAnimRestore;

			_common = new TextureAtlas(_commonTexture, new XML(new commonDescription()));
			_wooden = new TextureAtlas(_woodenTexture, new XML(new woodenDescription()));

			_noiseAnim = new TextureAtlas(_noiseAnimTexture, new XML(new noiseAnimDescription()));
		}

		private function onCommonRestore():void
		{
			_commonTexture.root.uploadAtfData(new commonAsset());
		}

		private function onWoodenRestore():void
		{
			_woodenTexture.root.uploadAtfData(new woodenAsset());
		}

		private function onNoiseAnimRestore():void
		{
			_noiseAnimTexture.root.uploadAtfData(new noiseAnimAsset());
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

		public function get noiseAnim():TextureAtlas
		{
			return _noiseAnim;
		}
	}
}
