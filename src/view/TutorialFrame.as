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
		public var cornerRadius:Number;

		public function TutorialFrame(frame:Rectangle = null, description:String = null,
									  align:String = null, cornerRadius:Number = NaN)
		{
			this.frame = frame;
			this.description = description;
			this.align = align;
			this.cornerRadius = cornerRadius;
		}
	}
}
