package com.vcow.textinput
{
	import feathers.controls.text.TextFieldTextRenderer;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class TextInputTextFieldTextRenderer extends TextFieldTextRenderer
	{
		public static const TEXT_SELECT:String = "textSelect";

		private var _bufferPoint:Point = new Point();

		public function TextInputTextFieldTextRenderer()
		{
			addEventListener(TouchEvent.TOUCH, onTouch);
		}

		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			if (!touch) return;

			var location:Point = touch.getLocation(this, _bufferPoint);
			var charIndex:int = this.textField.getCharIndexAtPoint(location.x, location.y);
			dispatchEventWith(TEXT_SELECT, true, {index: charIndex, point: location.clone()});
		}

		public function getCharRect(index:int):Rectangle
		{
			if (index < 0 || index >= this.textField.text.length) return null;
			var rc:Rectangle = this.textField.getCharBoundaries(index);
			var k:Number = this.textField.textHeight / rc.height;
			return new flash.geom.Rectangle(rc.x * k, rc.y * k, rc.width * k, rc.height * k);
		}
	}
}
