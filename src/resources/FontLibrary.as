package resources
{
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class FontLibrary
	{
		[Embed(source="fonts/title_button_31.atf", mimeType="application/octet-stream")]
		private static const titleButton31Asset:Class;

		[Embed(source="fonts/title_button_31.fnt", mimeType="application/octet-stream")]
		private static const titleButton31Description:Class;

		[Embed(source="fonts/shop_message.atf", mimeType="application/octet-stream")]
		private static const shopMessageAsset:Class;

		[Embed(source="fonts/shop_message.fnt", mimeType="application/octet-stream")]
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

		[Embed(source="fonts/unit_count_22.atf", mimeType="application/octet-stream")]
		private static const unitCount22Asset:Class;

		[Embed(source="fonts/unit_count_22.fnt", mimeType="application/octet-stream")]
		private static const unitCount22Description:Class;

		[Embed(source="fonts/message_box.fnt", mimeType="application/octet-stream")]
		private static const messageBoxDescription:Class;

		[Embed(source="fonts/message_box.atf", mimeType="application/octet-stream")]
		private static const messageBoxAsset:Class;

		[Embed(source="fonts/message_box_button.fnt", mimeType="application/octet-stream")]
		private static const messageBoxButtonDescription:Class;

		[Embed(source="fonts/message_box_button.atf", mimeType="application/octet-stream")]
		private static const messageBoxButtonAsset:Class;

		private static const TITLE_BUTTON_31:String = "titleButton31";

		private static const SHOP_PRICE_20:String = "shopPrice20";
		private static const SHOP_PRICE_31:String = "shopPrice31";
		private static const SHOP_PRICE_52:String = "shopPrice52";
		private static const SHOP_TITLE_23:String = "shopTitle23";
		private static const UNIT_COUNT_22:String = "unitCount22";

		private static const SHOP_MESSAGE:String = "shopMessage";

		private static const MESSAGE_BOX:String = "messageBox";
		private static const MESSAGE_BOX_BUTTON:String = "messageBoxButton";

		private var _titleButton31Texture:Texture;
		private var _titleButton31Font:BitmapFont;

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
		private var _unitCount22Texture:Texture;
		private var _unitCount22Font:BitmapFont;

		private var _messageBoxTexture:Texture;
		private var _messageBoxFont:BitmapFont;
		private var _messageBoxButtonTexture:Texture;
		private var _messageBoxButtonFont:BitmapFont;

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

		public function get titleButton31():String
		{
			if (!_titleButton31Font) {
				_titleButton31Texture = Texture.fromEmbeddedAsset(titleButton31Asset);
				_titleButton31Texture.root.onRestore = onTitleButton31Restore;
				_titleButton31Font = new BitmapFont(_titleButton31Texture, new XML(new titleButton31Description()));
				TextField.registerBitmapFont(_titleButton31Font, TITLE_BUTTON_31);
			}
			return TITLE_BUTTON_31;
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

		public function get unitCount22():String
		{
			if (!_unitCount22Font) {
				_unitCount22Texture = Texture.fromEmbeddedAsset(unitCount22Asset);
				_unitCount22Texture.root.onRestore = onUnitCount22Restore;
				_unitCount22Font = new BitmapFont(_unitCount22Texture, new XML(new unitCount22Description()));
				TextField.registerBitmapFont(_unitCount22Font, UNIT_COUNT_22);
			}
			return UNIT_COUNT_22;
		}

		public function get messageBox():String
		{
			if (!_messageBoxFont) {
				_messageBoxTexture = Texture.fromEmbeddedAsset(messageBoxAsset);
				_messageBoxTexture.root.onRestore = onMessageBoxRestore;
				_messageBoxFont = new BitmapFont(_messageBoxTexture, new XML(new messageBoxDescription()));
				TextField.registerBitmapFont(_messageBoxFont, MESSAGE_BOX);
			}
			return MESSAGE_BOX;
		}

		public function get messageBoxButton():String
		{
			if (!_messageBoxButtonFont) {
				_messageBoxButtonTexture = Texture.fromEmbeddedAsset(messageBoxButtonAsset);
				_messageBoxButtonTexture.root.onRestore = onMessageBoxButtonRestore;
				_messageBoxButtonFont = new BitmapFont(_messageBoxButtonTexture, new XML(new messageBoxButtonDescription()));
				TextField.registerBitmapFont(_messageBoxButtonFont, MESSAGE_BOX_BUTTON);
			}
			return MESSAGE_BOX_BUTTON;
		}

		private function onTitleButton31Restore():void
		{
			_titleButton31Texture.root.uploadAtfData(new titleButton31Asset());
		}

		private function onShopMessageRestore():void
		{
			_shopMessageTexture.root.uploadAtfData(new shopMessageAsset());
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

		private function onUnitCount22Restore():void
		{
			_unitCount22Texture.root.uploadAtfData(new unitCount22Asset());
		}

		private function onMessageBoxRestore():void
		{
			_messageBoxTexture.root.uploadAtfData(new messageBoxAsset());
		}

		private function onMessageBoxButtonRestore():void
		{
			_messageBoxButtonTexture.root.uploadAtfData(new messageBoxButtonAsset());
		}
	}
}
