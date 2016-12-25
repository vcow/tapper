package resources
{
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class FontLibrary
	{
		[Embed(source="fonts/arial_16.atf", mimeType="application/octet-stream")]
		private static const arial16Asset:Class;

		[Embed(source="fonts/arial_16.fnt", mimeType="application/octet-stream")]
		private static const arial16Description:Class;

		[Embed(source="fonts/arial_30.atf", mimeType="application/octet-stream")]
		private static const arial30Asset:Class;

		[Embed(source="fonts/arial_30.fnt", mimeType="application/octet-stream")]
		private static const arial30Description:Class;

		[Embed(source="fonts/arial_26.atf", mimeType="application/octet-stream")]
		private static const arial26Asset:Class;

		[Embed(source="fonts/arial_26.fnt", mimeType="application/octet-stream")]
		private static const arial26Description:Class;

		[Embed(source="fonts/shop_message/shop_message.atf", mimeType="application/octet-stream")]
		private static const shopMessageAsset:Class;

		[Embed(source="fonts/shop_message/shop_message.fnt", mimeType="application/octet-stream")]
		private static const shopMessageDescription:Class;

		[Embed(source="fonts/shop_price_20.atf", mimeType="application/octet-stream")]
		private static const shopPrice20Asset:Class;

		[Embed(source="fonts/shop_price_20.fnt", mimeType="application/octet-stream")]
		private static const shopPrice20Description:Class;

		[Embed(source="fonts/shop_price_31.atf", mimeType="application/octet-stream")]
		private static const shopPrice31Asset:Class;

		[Embed(source="fonts/shop_price_31.fnt", mimeType="application/octet-stream")]
		private static const shopPrice31Description:Class;

		[Embed(source="fonts/shop_price_52.atf", mimeType="application/octet-stream")]
		private static const shopPrice52Asset:Class;

		[Embed(source="fonts/shop_price_52.fnt", mimeType="application/octet-stream")]
		private static const shopPrice52Description:Class;

		[Embed(source="fonts/shop_title_23.atf", mimeType="application/octet-stream")]
		private static const shopTitle23Asset:Class;

		[Embed(source="fonts/shop_title_23.fnt", mimeType="application/octet-stream")]
		private static const shopTitle23Description:Class;

		private static const ARIAL_16:String = "arial16";
		private static const ARIAL_30:String = "arial30";
		private static const ARIAL_26:String = "arial26";
		private static const SHOP_PRICE_20:String = "shopPrice20";
		private static const SHOP_PRICE_31:String = "shopPrice31";
		private static const SHOP_PRICE_52:String = "shopPrice52";
		private static const SHOP_TITLE_23:String = "shopTitle23";

		private static const SHOP_MESSAGE:String = "shopMessage";

		private var _arial16Texture:Texture;
		private var _arial16Font:BitmapFont;
		private var _arial30Texture:Texture;
		private var _arial30Font:BitmapFont;
		private var _arial26Texture:Texture;
		private var _arial26Font:BitmapFont;

		private var _shopMessageTexture:Texture;
		private var _shopMessageFont:BitmapFont;

		private var _shopPrice20Texture:Texture;
		private var _shopPrice20Font:BitmapFont;
		private var _shopPrice31Texture:Texture;
		private var _shopPrice31Font:BitmapFont;
		private var _shopPrice52Texture:Texture;
		private var _shopPrice52Font:BitmapFont;
		private var _shopTitle23Texture:Texture;
		private var _shopTitle23Font:BitmapFont;

		private static var _instance:FontLibrary;

		public function FontLibrary()
		{
			if (_instance) throw Error("FontLibrary is a static class. Use getInstance() method.");
		}

		public static function getInstance():FontLibrary
		{
			if (!_instance) _instance = new FontLibrary();
			return _instance;
		}

		public function get arial16():String
		{
			if (!_arial16Font) {
				_arial16Texture = Texture.fromEmbeddedAsset(arial16Asset);
				_arial16Texture.root.onRestore = onArial16Restore;
				_arial16Font = new BitmapFont(_arial16Texture, new XML(new arial16Description()));
				TextField.registerBitmapFont(_arial16Font, ARIAL_16);
			}
			return ARIAL_16;
		}

		public function get arial30():String
		{
			if (!_arial30Font) {
				_arial30Texture = Texture.fromEmbeddedAsset(arial30Asset);
				_arial30Texture.root.onRestore = onArial30Restore;
				_arial30Font = new BitmapFont(_arial30Texture, new XML(new arial30Description()));
				TextField.registerBitmapFont(_arial30Font, ARIAL_30);
			}
			return ARIAL_30;
		}

		public function get arial26():String
		{
			if (!_arial26Font) {
				_arial26Texture = Texture.fromEmbeddedAsset(arial26Asset);
				_arial26Texture.root.onRestore = onarial26Restore;
				_arial26Font = new BitmapFont(_arial26Texture, new XML(new arial26Description()));
				TextField.registerBitmapFont(_arial26Font, ARIAL_26);
			}
			return ARIAL_26;
		}

		public function get shopMessage():String
		{
			if (!_shopMessageFont) {
				_shopMessageTexture = Texture.fromEmbeddedAsset(shopMessageAsset);
				_shopMessageTexture.root.onRestore = onShopMessageRestore;
				_shopMessageFont = new BitmapFont(_shopMessageTexture, new XML(new shopMessageDescription()));
				TextField.registerBitmapFont(_shopMessageFont, SHOP_MESSAGE);
			}
			return SHOP_MESSAGE;
		}

		public function get shopPrice20():String
		{
			if (!_shopPrice20Font) {
				_shopPrice20Texture = Texture.fromEmbeddedAsset(shopPrice20Asset);
				_shopPrice20Texture.root.onRestore = onShopPrice20Restore;
				_shopPrice20Font = new BitmapFont(_shopPrice20Texture, new XML(new shopPrice20Description()));
				TextField.registerBitmapFont(_shopPrice20Font, SHOP_PRICE_20);
			}
			return SHOP_PRICE_20;
		}

		public function get shopPrice31():String
		{
			if (!_shopPrice31Font) {
				_shopPrice31Texture = Texture.fromEmbeddedAsset(shopPrice31Asset);
				_shopPrice31Texture.root.onRestore = onShopPrice31Restore;
				_shopPrice31Font = new BitmapFont(_shopPrice31Texture, new XML(new shopPrice31Description()));
				TextField.registerBitmapFont(_shopPrice31Font, SHOP_PRICE_31);
			}
			return SHOP_PRICE_31;
		}

		public function get shopPrice52():String
		{
			if (!_shopPrice52Font) {
				_shopPrice52Texture = Texture.fromEmbeddedAsset(shopPrice52Asset);
				_shopPrice52Texture.root.onRestore = onShopPrice52Restore;
				_shopPrice52Font = new BitmapFont(_shopPrice52Texture, new XML(new shopPrice52Description()));
				TextField.registerBitmapFont(_shopPrice52Font, SHOP_PRICE_52);
			}
			return SHOP_PRICE_52;
		}

		public function get shopTitle23():String
		{
			if (!_shopTitle23Font) {
				_shopTitle23Texture = Texture.fromEmbeddedAsset(shopTitle23Asset);
				_shopTitle23Texture.root.onRestore = onShopTitle23Restore;
				_shopTitle23Font = new BitmapFont(_shopTitle23Texture, new XML(new shopTitle23Description()));
				TextField.registerBitmapFont(_shopTitle23Font, SHOP_TITLE_23);
			}
			return SHOP_TITLE_23;
		}

		private function onArial16Restore():void
		{
			_arial16Texture.root.uploadAtfData(new arial16Asset());
		}

		private function onArial30Restore():void
		{
			_arial16Texture.root.uploadAtfData(new arial30Asset());
		}

		private function onarial26Restore():void
		{
			_arial16Texture.root.uploadAtfData(new arial26Asset());
		}

		private function onShopMessageRestore():void
		{
			_arial16Texture.root.uploadAtfData(new shopMessageAsset());
		}

		private function onShopPrice20Restore():void
		{
			_shopPrice20Texture.root.uploadAtfData(new shopPrice20Asset());
		}

		private function onShopPrice31Restore():void
		{
			_shopPrice31Texture.root.uploadAtfData(new shopPrice31Asset());
		}

		private function onShopPrice52Restore():void
		{
			_shopPrice52Texture.root.uploadAtfData(new shopPrice52Asset());
		}

		private function onShopTitle23Restore():void
		{
			_shopTitle23Texture.root.uploadAtfData(new shopTitle23Asset());
		}
	}
}
