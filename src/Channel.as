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

		private var _sound:Sound;
		private var _soundChannel:SoundChannel;
		private var _soundTransform:SoundTransform;
		private var _loops:int;
		private var _restoreStartTime:Number = 0;

		public function Channel(type:String)
		{
			_type = type;
		}

		public function get type():String
		{
			return _type;
		}

		public function play(sound:Sound = null, startTime:Number = NaN, loops:int = 0, volume:Number = NaN):void
		{
			if (!_sound && !sound) return;
			if (_soundChannel)
			{
				_soundChannel.removeEventListener(flash.events.Event.SOUND_COMPLETE, onComplete);
				_soundChannel.stop();
			}
			volume = isNaN(volume) ? SoundManager.getInstance().getVolume(type) : volume;
			startTime = isNaN(startTime) ? _restoreStartTime : startTime;
			_restoreStartTime = isNaN(startTime) ? 0 : startTime;
			_sound = sound || _sound;
			_soundTransform = new SoundTransform(volume);
			_soundChannel = _sound.play(startTime, 1, _soundTransform);
			_loops = loops > 0 ? loops : Math.max(_loops, 1);
			_soundChannel.addEventListener(flash.events.Event.SOUND_COMPLETE, onComplete);
		}

		public function pause(sound:Sound = null, startTime:Number = 0, loops:int = 1, volume:Number = NaN):void
		{
			if (!_sound && !sound) return;
			if (_soundChannel)
			{
				_restoreStartTime = _soundChannel.position;
				_soundChannel.removeEventListener(flash.events.Event.SOUND_COMPLETE, onComplete);
				_soundChannel.stop();
				_soundChannel = null;
			}
			else
			{
				_restoreStartTime = 0;
			}
			_sound = sound || _sound;
		}

		public function stop():void
		{
			if (_soundChannel)
			{
				_soundChannel.removeEventListener(flash.events.Event.SOUND_COMPLETE, onComplete);
				_soundChannel.stop();
				_soundChannel = null;
			}
			_sound = null;
			_soundTransform = null;
		}

		public function get isPlayed():Boolean
		{
			return _soundChannel && _loops > 0;
		}

		private function onComplete(event:flash.events.Event):void
		{
			--_loops;
			if (_loops <= 0)
			{
				dispatchEventWith(starling.events.Event.COMPLETE);
			}
			else
			{
				_soundChannel.removeEventListener(flash.events.Event.SOUND_COMPLETE, onComplete);
				_soundChannel.stop();
				_soundChannel = _sound.play(0, 1, _soundTransform);
				_soundChannel.addEventListener(flash.events.Event.SOUND_COMPLETE, onComplete);
			}
		}

		public function set volume(value:Number):void
		{
			if (!_soundTransform || value == _soundTransform.volume) return;
			_soundTransform.volume = value;
			if (_soundChannel) _soundChannel.soundTransform = _soundTransform;
		}

		public function get volume():Number
		{
			return _soundTransform ? _soundTransform.volume : 1.0;
		}
	}
}
