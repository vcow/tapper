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

		private static const ARIAL_16:String = "arial16";
		private static const ARIAL_30:String = "arial30";

		private var _arial16Texture:Texture;
		private var _arial16Font:BitmapFont;
		private var _arial30Texture:Texture;
		private var _arial30Font:BitmapFont;

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
				_arial16Texture = Texture.fromAtfData(new arial16Asset());
				_arial16Texture.root.onRestore = onArial16Restore;
				_arial16Font = new BitmapFont(_arial16Texture, new XML(new arial16Description()));
				TextField.registerBitmapFont(_arial16Font, ARIAL_16);
			}
			return ARIAL_16;
		}

		public function get arial30():String
		{
			if (!_arial30Font) {
				_arial30Texture = Texture.fromAtfData(new arial30Asset());
				_arial30Texture.root.onRestore = onArial30Restore;
				_arial30Font = new BitmapFont(_arial30Texture, new XML(new arial30Description()));
				TextField.registerBitmapFont(_arial30Font, ARIAL_30);
			}
			return ARIAL_30;
		}

		private function onArial16Restore():void
		{
			_arial16Texture.root.uploadAtfData(new arial16Asset());
		}

		private function onArial30Restore():void
		{
			_arial16Texture.root.uploadAtfData(new arial30Asset());
		}
	}
}
