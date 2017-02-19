package resources
{
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

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

		[Embed(source="graphics/units_big.atf", mimeType="application/octet-stream")]
		private static const unitsBigAsset:Class;

		[Embed(source="graphics/units_big.xml", mimeType="application/octet-stream")]
		private static const unitsBigDescription:Class;

		[Embed(source="graphics/units_small.atf", mimeType="application/octet-stream")]
		private static const unitsSmallAsset:Class;

		[Embed(source="graphics/units_small.xml", mimeType="application/octet-stream")]
		private static const unitsSmallDescription:Class;

		[Embed(source="graphics/shop.atf", mimeType="application/octet-stream")]
		private static const shopAsset:Class;

		[Embed(source="graphics/shop.xml", mimeType="application/octet-stream")]
		private static const shopDescription:Class;

		private var _titleTexture:Texture;
		private var _globeTexture:Texture;
		private var _commonTexture:Texture;
		private var _shopTexture:Texture;
		private var _woodenTexture:Texture;

		private var _noiseAnimTexture:Texture;

		private var _unitsBigTexture:Texture;
		private var _unitsSmallTexture:Texture;

		private static var _instance:AtlasLibrary;

		private var _title:TextureAtlas;
		private var _globe:TextureAtlas;
		private var _common:TextureAtlas;
		private var _shop:TextureAtlas;
		private var _wooden:TextureAtlas;
		private var _noiseAnim:TextureAtlas;
		private var _unitsBig:TextureAtlas;
		private var _unitsSmall:TextureAtlas;

		public function AtlasLibrary()
		{
			if (_instance) throw Error("AtlasLibrary is a static class. Use getInstance() method.");

			_titleTexture = Texture.fromEmbeddedAsset(titleAsset);
			_titleTexture.root.onRestore = onTitleRestore;
			_globeTexture = Texture.fromEmbeddedAsset(globeAsset);
			_globeTexture.root.onRestore = onGlobeRestore;
			_commonTexture = Texture.fromEmbeddedAsset(commonAsset);
			_commonTexture.root.onRestore = onCommonRestore;
			_shopTexture = Texture.fromEmbeddedAsset(shopAsset);
			_shopTexture.root.onRestore = onShopRestore;
			_woodenTexture = Texture.fromEmbeddedAsset(woodenAsset);
			_woodenTexture.root.onRestore = onWoodenRestore;

			_noiseAnimTexture = Texture.fromEmbeddedAsset(noiseAnimAsset);
			_noiseAnimTexture.root.onRestore = onNoiseAnimRestore;

			_unitsBigTexture = Texture.fromEmbeddedAsset(unitsBigAsset);
			_unitsBigTexture.root.onRestore = onUnitsBigRestore;
			_unitsSmallTexture = Texture.fromEmbeddedAsset(unitsSmallAsset);
			_unitsSmallTexture.root.onRestore = onUnitsSmallRestore;

			_title = new TextureAtlas(_titleTexture, new XML(new titleDescription()));
			_globe = new TextureAtlas(_globeTexture, new XML(new globeDescription()));
			_common = new TextureAtlas(_commonTexture, new XML(new commonDescription()));
			_shop = new TextureAtlas(_shopTexture, new XML(new shopDescription()));
			_wooden = new TextureAtlas(_woodenTexture, new XML(new woodenDescription()));

			_noiseAnim = new TextureAtlas(_noiseAnimTexture, new XML(new noiseAnimDescription()));

			_unitsBig = new TextureAtlas(_unitsBigTexture, new XML(new unitsBigDescription()));
			_unitsSmall = new TextureAtlas(_unitsSmallTexture, new XML(new unitsSmallDescription()));
		}

		private function onTitleRestore():void
		{
			_titleTexture.root.uploadAtfData(new titleAsset());
		}

		private function onGlobeRestore():void
		{
			_globeTexture.root.uploadAtfData(new globeAsset());
		}

		private function onCommonRestore():void
		{
			_commonTexture.root.uploadAtfData(new commonAsset());
		}

		private function onShopRestore():void
		{
			_shopTexture.root.uploadAtfData(new shopAsset());
		}

		private function onWoodenRestore():void
		{
			_woodenTexture.root.uploadAtfData(new woodenAsset());
		}

		private function onNoiseAnimRestore():void
		{
			_noiseAnimTexture.root.uploadAtfData(new noiseAnimAsset());
		}

		private function onUnitsBigRestore():void
		{
			_unitsBigTexture.root.uploadAtfData(new unitsBigAsset());
		}

		private function onUnitsSmallRestore():void
		{
			_unitsSmallTexture.root.uploadAtfData(new unitsSmallAsset());
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

		public function get common():TextureAtlas
		{
			return _common;
		}

		public function get shop():TextureAtlas
		{
			return _shop;
		}

		public function get wooden():TextureAtlas
		{
			return _wooden;
		}

		public function get noiseAnim():TextureAtlas
		{
			return _noiseAnim;
		}

		public function get unitsBig():TextureAtlas
		{
			return _unitsBig;
		}

		public function get unitsSmall():TextureAtlas
		{
			return _unitsSmall;
		}
	}
}
