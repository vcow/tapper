package models
{
	import gears.TriggerBroadcaster;

	import resources.ConfigsLibrary;

	import robotlegs.bender.framework.api.IInjector;

	public class AchievementsModel
	{
		private var _achievements:Vector.<AchievementInfo>;

		[Inject]
		public var injector:IInjector;

		[Inject]
		public var triggerBroadcaster:TriggerBroadcaster;

		[Inject]
		public var gameModel:GameModel;

		[PostConstruct]
		public function postConstruct():void
		{
			for each (var achievement:AchievementInfo in achievements) injector.injectInto(achievement);
			triggerBroadcaster.init(gameModel);
		}

		public function AchievementsModel()
		{
			_achievements = new Vector.<AchievementInfo>();
			var achievements:XMLList = ConfigsLibrary.achievements.achievement;
			for (var i:int = 0, l:int = achievements.length(); i < l; i++) _achievements.push(new AchievementInfo(achievements[i]));
		}

		public function get achievements():Vector.<AchievementInfo>
		{
			return _achievements;
		}

		public function getAchievementById(id:String):AchievementInfo
		{
			for (var i:int = 0, l:int = _achievements.length; i < l; i++) {
				if (_achievements[i].id == id) return _achievements[i];
			}
			return null;
		}
	}
}
