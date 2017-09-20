package models
{
	import resources.locale.LocaleManager;

	/**
	 * Награда в виде выполнения некоего внутриигрового сценария.
	 */
	public class ActionReward implements IReward
	{
		private var _id:String;
		private var _name:String;
		private var _description:String;
		private var _data:Object;

		public function ActionReward(src:XML)
		{
			var locale:LocaleManager = LocaleManager.getInstance();
			_id = src.@id;
			_name = locale.getString("actions", src.@name) || src.@name;
			_description = locale.getString("actions", src.@description) || src.@description;

			for each (var item:XML in src.children()) _data = item;
		}

		/**
		 * Идентификатор сценария.
		 */
		public function get id():String
		{
			return _id;
		}

		/**
		 * Название действия.
		 */
		public function get name():String
		{
			return _name;
		}

		/**
		 * Описание действия.
		 */
		public function get description():String
		{
			return _description;
		}

		/**
		 * Дополнительные данные для действия.
		 */
		public function get data():Object
		{
			return _data;
		}

		/**
		 * Название действия (для совместимости с IReward).
		 */
		public function get title():String
		{
			return _name;
		}
	}
}
