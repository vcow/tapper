package models
{
	import resources.locale.LocaleManager;

	public class PopUpReward implements IReward
	{
		private var _title:String;
		private var _description:String;

		[Inject]
		public var gameModel:GameModel;

		public function PopUpReward(src:XML)
		{
			var locale:LocaleManager = LocaleManager.getInstance();
			_title = locale.getString("actions", src.@title) || src.@title;
			_description = locale.getString("actions", src.@description) || src.@description;
		}

		public function get title():String
		{
			return gameModel.applyEnvVariables(_title);
		}

		public function get description():String
		{
			return gameModel.applyEnvVariables(_description);
		}
	}
}
