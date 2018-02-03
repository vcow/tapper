package vo
{
	import models.SkinType;

	public class TopItem
	{
		private var _isUserItem:Boolean;
		private var _name:String = "";
		private var _scores:Number = 0;
		private var _cabinType:String = SkinType.WOOD;
		private var _id:String;

		public function TopItem(rawData:Object, isUserItem:Boolean = false)
		{
			_isUserItem = isUserItem;
			if (rawData)
			{
				_id = rawData.name;
				_name = rawData.user_name || "";
				_scores = Number(rawData.scores || "0");
				_cabinType = rawData.cabin_max || SkinType.WOOD;
				place = rawData.hasOwnProperty("index") ? int(rawData.index) + 1 : 0;
			}
		}

		public function get isUserItem():Boolean
		{
			return _isUserItem;
		}

		public function get name():String
		{
			return _name;
		}

		public function get scores():Number
		{
			return _scores;
		}

		public function get cabinType():String
		{
			return _cabinType;
		}

		public var place:int;

		public function get id():String
		{
			return _id;
		}
	}
}
