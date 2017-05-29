package models
{
	import resources.locale.LocaleManager;

	public class LevelInfo
	{
		private var _id:int;
		private var _iconId:String;
		private var _title:String;
		private var _description:String;

		public function LevelInfo(src:XML)
		{
			var locale:LocaleManager = LocaleManager.getInstance();
			_id = int(src.@id);
			_iconId = src.@icon;
			_title = locale.getString('levels', src.@title) || src.@title;
			_description = locale.getString('levels', src.@description) || src.@description;
		}

		public function get iconId():String
		{
			return _iconId;
		}

		public function get id():int
		{
			return _id;
		}

		public function get title():String
		{
			return _title;
		}

		public function get description():String
		{
			return _description;
		}
	}
}
