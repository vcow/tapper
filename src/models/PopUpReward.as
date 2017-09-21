package models
{
	import app.AppFacade;

	import org.puremvc.as3.multicore.patterns.facade.Facade;

	import resources.locale.LocaleManager;

	/**
	 * Награда в виде всплывающего окна.
	 */
	public class PopUpReward implements IReward
	{
		private var _title:String;
		private var _description:String;

		public var facade:AppFacade;

		public function PopUpReward(src:XML)
		{
			facade = Facade.getInstance(AppFacade.NAME) as AppFacade;

			var locale:LocaleManager = LocaleManager.getInstance();
			_title = locale.getString("actions", src.@title) || src.@title;
			_description = locale.getString("actions", src.@description) || src.@description;
		}

		/**
		 * Заголовок окна.
		 */
		public function get title():String
		{
			return facade.gameModel.applyEnvVariables(_title);
		}

		/**
		 * Текст сообщения.
		 */
		public function get description():String
		{
			return facade.gameModel.applyEnvVariables(_description);
		}
	}
}
