package view
{
	import flash.geom.Rectangle;

	public class TutorialFrame
	{
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		public static const TOP:String = "top";
		public static const BOTTOM:String = "bottom";

		public var frame:Rectangle;
		public var description:String;
		public var align:String;

		public function TutorialFrame(frame:Rectangle, description:String, align:String)
		{
			this.frame = frame;
			this.description = description;
			this.align = align;
		}
	}
}
