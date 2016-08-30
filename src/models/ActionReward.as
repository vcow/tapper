package models
{
	import resources.locale.LocaleManager;

	public class ActionReward implements IReward
	{
		private var _id:String;
		private var _name:String;
		private var _description:String;

		public function ActionReward(src:XML)
		{
			var locale:LocaleManager = LocaleManager.getInstance();
			_id = src.@id;
			_name = locale.getString("actions", src.@name) || src.@name;
			_description = locale.getString("actions", src.@description) || src.@description;
		}

		public function get id():String
		{
			return _id;
		}

		public function get name():String
		{
			return _name;
		}

		public function get description():String
		{
			return _description;
		}
	}
}
