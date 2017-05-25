package models
{
	import resources.locale.LocaleManager;

	public class LevelInfo
	{
		private var _id:String;
		private var _title:String;
		private var _description:String;
		private var _index:int;

		public function LevelInfo(src:XML)
		{
			var locale:LocaleManager = LocaleManager.getInstance();
			_id = src.@id;
			_index = int(src.@index);
			_title = locale.getString('levels', src.@title) || src.@title;
			_description = locale.getString('levels', src.@description) || src.@description;
		}

		public function get id():String
		{
			return _id;
		}

		public function get index():int
		{
			return _index;
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
