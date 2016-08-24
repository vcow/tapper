package view
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class TutorialFrame
	{
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		public static const TOP:String = "top";
		public static const BOTTOM:String = "bottom";

		public var frame:Rectangle;
		public var description:String;
		public var textAlign:String;
		public var cornerRadius:Number;
		public var textOffset:Point;

		public function TutorialFrame(frame:Rectangle = null, description:String = null,
									  textAlign:String = null, cornerRadius:Number = NaN,
									  textOffset:Point = null)
		{
			this.frame = frame;
			this.description = description;
			this.textAlign = textAlign;
			this.cornerRadius = cornerRadius;
			this.textOffset = textOffset;
		}
	}
}
