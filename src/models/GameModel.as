package models
{
	public class GameModel
	{
		private var _isActive:Boolean;

		public function GameModel()
		{
		}

		public function set isActive(value:Boolean):void
		{
			if (value == _isActive) return;
			_isActive = value;
		}

		public function get isActive():Boolean
		{
			return _isActive;
		}
	}
}
