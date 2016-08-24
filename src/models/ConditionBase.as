package models
{
	/**
	 * Базовый класс условия.
	 */
	public class ConditionBase
	{
		protected var _lock:Boolean;
		protected var _reached:Boolean;

		protected var _min:Number;
		protected var _max:Number;

		/**
		 * Условие
		 * @param lock Флаг, указывающий считать условие выполненным, если оно было выполнено однажды.
		 */
		public function ConditionBase(lock:Boolean)
		{
			_lock = lock;
		}

		/**
		 * Проверка значения на соответствие условию.
		 * @param value Проверяемое значение.
		 * @return Если условие выполнено, возвращает <code>true</code>.
		 */
		public function check(value:Number):Boolean
		{
			if (_lock && _reached) return true;
			else if (!isNaN(_min) && value < _min) return false;
			else if (!isNaN(_max) && value > _max) return false;
			_reached = true;
			return true;
		}

		/**
		 * Минимум.
		 */
		public function get min():Number
		{
			return _min;
		}

		/**
		 * Максимум.
		 */
		public function get max():Number
		{
			return _max;
		}

		/**
		 * Сброс условия.
		 */
		public function reset():void
		{
			_reached = false;
		}
	}
}
