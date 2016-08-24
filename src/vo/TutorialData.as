package vo
{
	import view.TutorialFrame;

	public class TutorialData
	{
		public var key:String;
		public var frames:Vector.<TutorialFrame> = new Vector.<TutorialFrame>();

		public function TutorialData(key:String, frames:Vector.<TutorialFrame> = null)
		{
			this.key = key;
			if (frames) this.frames = frames;
		}
	}
}
