package
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	import starling.events.EventDispatcher;

	[Event(name="complete", type="starling.events.Event")]

	public class Channel extends EventDispatcher
	{
		private var _type:String;

		private var _soundChannel:SoundChannel;
		private var _soundTransform:SoundTransform;
		private var _loops:int;

		public function Channel(type:String)
		{
			_type = type;
		}

		public function get type():String
		{
			return _type;
		}

		public function play(sound:Sound, startTime:Number = 0, loops:int = 1, volume:Number = NaN):void
		{
			if (_soundChannel) throw Error("Channel already played.");
			volume = isNaN(volume) ? SoundManager.getInstance().getVolume(type) : volume;
			_soundTransform = new SoundTransform(volume);
			_soundChannel = sound.play(startTime, loops, _soundTransform);
			_loops = loops;
			if (_loops > 0)
				_soundChannel.addEventListener(flash.events.Event.SOUND_COMPLETE, onComplete);
		}

		public function stop():void
		{
			if (!_soundChannel) throw Error("Can't stop nonexistent sound.");
			if (_loops > 0)
			{
				_soundChannel.removeEventListener(flash.events.Event.SOUND_COMPLETE, onComplete);
				_loops = 0;
			}
			_soundChannel.stop();
			_soundChannel = null;
			_soundTransform = null;
		}

		private function onComplete(event:flash.events.Event):void
		{
			dispatchEventWith(starling.events.Event.COMPLETE);
		}

		public function set volume(value:Number):void
		{
			if (!_soundTransform || value == _soundTransform.volume) return;
			_soundTransform.volume = value;
			_soundChannel.soundTransform = _soundTransform;
		}

		public function get volume():Number
		{
			return _soundTransform ? _soundTransform.volume : 1.0;
		}
	}
}
