package vo
{
	import resources.locale.LocaleManager;

	public class Pack
	{
		private var _id:String;
		private var _index:int;
		private var _price:Number = 0;
		private var _title:String;
		private var _description:String;

		public function Pack(id:String, index:int, price:Number)
		{
			var lm:LocaleManager = LocaleManager.getInstance();
			_id = id;
			_index = index;
			_price = price;
			_title = lm.getString("packs", _id + ".title") || (_id + ".title");
			_description = lm.getString("packs", _id + ".description") || (_id + ".description");
		}

		public function get id():String
		{
			return _id;
		}

		public function get index():int
		{
			return _index;
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
