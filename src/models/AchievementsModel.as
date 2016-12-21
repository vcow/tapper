package models
{
	import org.puremvc.as3.multicore.core.Model;

	import resources.ConfigsLibrary;

	public class AchievementsModel extends Model
	{
		public static const NAME:String = "achievementsModel";

		private var _achievements:Vector.<AchievementInfo>;

		public function AchievementsModel(key:String)
		{
			super(key);
		}

		override protected function initializeModel():void
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
