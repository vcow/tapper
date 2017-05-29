package
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.getDefinitionByName;

	[SWF(frameRate="60", backgroundColor="#000000")]
	public class Preloader extends MovieClip
	{
		public function Preloader()
		{
			super();

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			loaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			loaderInfo.addEventListener(Event.COMPLETE, onComplete);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		}

		private function onProgress(event:ProgressEvent):void
		{
			if (event.bytesTotal == 0) return;
			var ratio:Number = event.bytesLoaded / event.bytesTotal;
			drawProgress(ratio);
		}

		private function onComplete(event:Event):void
		{
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			loaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);

			startup();
		}

		private function onIOError(event:IOErrorEvent):void
		{
		}

		private function onSecurityError(event:SecurityErrorEvent):void
		{
		}

		private function startup():void
		{
			graphics.clear();
			gotoAndStop(2);
			var mainClass:Class = getDefinitionByName("Main") as Class;
			var mainInstance:DisplayObject = addChild(new mainClass() as DisplayObject);
		}

		private function drawProgress(ratio:Number):void
		{
			const barWidth:int = 200;
			const barHeight:int = 6;
			var progressWidth:int = ratio * barWidth;
			var barX:int = .5 * (stage.stageWidth - barWidth);
			var barY:int = .5 * (stage.stageHeight - barHeight);

			graphics.clear();

			graphics.beginFill(0x666666, 1);
			graphics.drawRect(barX - 1, barY - 1, barWidth + 2, barHeight + 2);
			graphics.endFill();

			graphics.beginFill(0xaaaaaa, 1);
			graphics.drawRect(barX, barY, progressWidth, barHeight);
			graphics.endFill();
		}
	}
}
