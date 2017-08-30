package vo
{
	import resources.locale.LocaleManager;

	import starling.events.EventDispatcher;

	public class Pack extends EventDispatcher
	{
		private var _id:String;
		private var _title:String;
		private var _description:String;

		[Bindable]
		public var  price:String = "0";

		public function Pack(id:String)
		{
			super();

			var lm:LocaleManager = LocaleManager.getInstance();
			_id = id;
			title = "";
			description = "";
		}

		public function get id():String
		{
			return _id;
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
	}
}
