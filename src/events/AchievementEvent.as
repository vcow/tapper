package events
{
	import flash.events.Event;

	import models.AchievementInfo;

	public class AchievementEvent extends Event
	{
		public static const ACHIEVE:String = "achieve";

		public var achievement:AchievementInfo;

		public function AchievementEvent(type:String, achievement:AchievementInfo,
										 bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.achievement = achievement;
		}

		override public function clone():Event
		{
			return new AchievementEvent(type, achievement, bubbles, cancelable);
		}
	}
}
