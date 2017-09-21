package models
{
	/**
	 * Количественное выражение профита. Профит может быть задан как абсолютное значение, так и относительное,
	 * указываемое в процентах (n%).
	 */
	public class RelValue
	{
		public var value:Number;
		public var percentValue:Number;

		public function RelValue(src:String)
		{
			var parts:Array = src.match(/(-?\d+)(%?)/);
			if (parts[2]) percentValue = Number(parts[1]) / 100.0;
			else value = Number(parts[1]);
		}

		/**
		 * Применить профит к исходному значению.
		 * @param value Исходное значение.
		 * @return Возвращает значение с примененным к нему профитом.
		 */
		public function apply(value:Number):Number
		{
			if (!isNaN(this.value)) return this.value + value;
			if (!isNaN(this.percentValue)) return this.percentValue * value + value;
			return value;
		}
	}
}
