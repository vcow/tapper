package models
{
	import resources.locale.LocaleManager;

	/**
	 * Уровень
	 */
	public class LevelInfo
	{
		private var _id:int;
		private var _assetId:String;
		private var _title:String;
		private var _description:String;

		public function LevelInfo(src:XML)
		{
			var locale:LocaleManager = LocaleManager.getInstance();
			_id = int(src.@id);
			_assetId = src.@asset;
			_title = locale.getString('levels', src.@title) || src.@title;
			_description = locale.getString('levels', src.@description) || src.@description;
		}

		/**
		 * Идентификатор ассета.
		 */
		public function get assetId():String
		{
			return _assetId;
		}

		/**
		 * Идентификатор уровня.
		 */
		public function get id():int
		{
			return _id;
		}

		/**
		 * Заголовок уровня.
		 */
		public function get title():String
		{
			return _title;
		}

		/**
		 * Описание уровня.
		 */
		public function get description():String
		{
			return _description;
		}
	}
}
