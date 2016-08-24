package models
{
	/**
	 * Интерфейс награды
	 */
	public interface IReward
	{
		/**
		 * Заголовок награды.
		 */
		function get title():String;

		/**
		 * Описание награды.
		 */
		function get description():String;
	}
}
