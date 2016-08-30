package models
{
	public class ConditionBase
	{
		protected var _lock:Boolean;
		protected var _reached:Boolean;

		protected var _min:Number;
		protected var _max:Number;

		public function ConditionBase(lock:Boolean)
		{
			_lock = lock;
		}

		public function check(value:Number):Boolean
		{
			if (_lock && _reached) return true;
			else if (!isNaN(_min) && value < _min) return false;
			else if (!isNaN(_max) && value > _max) return false;
			_reached = true;
			return true;
		}

		public function get min():Number
		{
			return _min;
		}

		public function get max():Number
		{
			return _max;
		}
	}
}
