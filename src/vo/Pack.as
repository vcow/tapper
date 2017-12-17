package vo
{
	import resources.AtlasLibrary;
	import resources.locale.LocaleManager;

	import starling.events.EventDispatcher;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Pack extends EventDispatcher
	{
		private var _id:String;
		private var _title:String;
		private var _description:String;
		private var _isConsumable:Boolean;

		private var _iconBig:Texture;
		private var _iconSmall:Texture;

		[Bindable]
		public var  price:String = "0";

		public var isPurchased:Boolean;

		private static var _atlas:TextureAtlas;
		private static function get atlas():TextureAtlas
		{
			if (!_atlas)
			{
				_atlas = AtlasLibrary.getInstance().manager.getTextureAtlas("packs");
			}
			return _atlas;
		}

		public function Pack(id:String, consume:Boolean)
		{
			super();

			var lm:LocaleManager = LocaleManager.getInstance();
			_id = id;
			_isConsumable = consume;
			title = "";
			description = "";
		}

		public function get id():String
		{
			return _id;
		}

		public function get isConsumable():Boolean
		{
			return _isConsumable;
		}

		public function set title(value:String):void
		{
			value = LocaleManager.getInstance().getString("packs", id + ".title") || value;
			if (value == _title) return;
			_title = value;
			dispatchEventWith("titleChanged");
		}

		[Bindable(event="titleChanged")]
		public function get title():String
		{
			return _title;
		}

		public function set description(value:String):void
		{
			value = LocaleManager.getInstance().getString("packs", id + ".description") || value;
			if (value == _description) return;
			_description = value;
			dispatchEventWith("descriptionChanged");
		}

		[Bindable(event="descriptionChanged")]
		public function get description():String
		{
			return _description;
		}

		public function get iconBig():Texture
		{
			if (!_iconBig) _iconBig = atlas.getTexture("big/" + _id);
			return _iconBig;
		}

		public function get iconSmall():Texture
		{
			if (!_iconSmall) _iconSmall = atlas.getTexture("small/" + _id);
			return _iconSmall;
		}
	}
}
