package vo
{
	import resources.locale.LocaleManager;

	public class Pack
	{
		private var _id:String;

		private var _price:Number = 0;
		private var _title:String;
		private var _description:String;

		public function Pack(id:String)
		{
			var lm:LocaleManager = LocaleManager.getInstance();
			_id = id;
		}

		public function get id():String
		{
			return _id;
		}

		public function get price():Number
		{
			return _price;
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
