package models
{
	import resources.ConfigsLibrary;

	public class ActionInfo
	{
		private var _id:String;
		private var _name:String;
		private var _description:String;

		public function ActionInfo(id:String)
		{
			_id = id;
			for each (var a:XML in ConfigsLibrary.actions.action.(@id == _id)) {
				_name = a.@name;
				_description = a.@description;
			}
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
