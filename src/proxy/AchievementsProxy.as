package proxy
{
	import models.*;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	import vo.AchievementInfo;

	public class AchievementsProxy extends Proxy
	{
		public static const NAME:String = "achievementsProxy";

		private var _achievements:Vector.<AchievementInfo>;

		public function AchievementsProxy(data:Object = null)
		{
			super(NAME, data);
		}

		override public function setData(data:Object):void
		{
			super.setData(data);

			_achievements = new Vector.<AchievementInfo>();
			var src:XML = data as XML;
			if (src)
			{
				var achievements:XMLList = src.achievement;
				for (var i:int = 0, l:int = achievements.length(); i < l; i++)
				{
					var achievementInfo:AchievementInfo = new AchievementInfo(achievements[i]);
					achievementInfo.initializeNotifier(multitonKey);
					_achievements.push(achievementInfo);
				}
			}
		}

		public function get achievements():Vector.<AchievementInfo>
		{
			return _achievements;
		}

		public function getAchievementById(id:String):AchievementInfo
		{
			for (var i:int = 0, l:int = _achievements.length; i < l; i++)
			{
				if (_achievements[i].id == id)
					return _achievements[i];
			}
			return null;
		}
	}
}
