package
{
	import flash.media.Sound;

	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.events.Event;

	public class SoundManager
	{
		public static const MUSIC:String = "music";
		public static const SOUND:String = "sound";

		private static var _instance:SoundManager;

		private var _musicChannel:Channel;
		private var _soundChannels:Vector.<Channel> = new Vector.<Channel>();

		private var _muteMusic:Boolean;
		private var _muteSounds:Boolean;

		private var _musicVolume:Number = 0.5;
		private var _soundVolume:Number = 1.0;

		public function SoundManager()
		{
			if (_instance)
				throw Error("LocaleManager is a singletone, use getInstance() methood.");
		}

		public static function getInstance():SoundManager
		{
			if (!_instance)
				_instance = new SoundManager();
			return _instance;
		}

		public function getVolume(type:String):Number
		{
			switch (type)
			{
				case SOUND: return _soundVolume;
				case MUSIC: return _musicVolume;
			}
			return 1.0;
		}

		public function setVolume(type:String, value:Number):void
		{
			if (isNaN(value) || value < 0) value = 0;
			if (value > 1.0) value = 1.0;
			switch (type)
			{
				case SOUND:
					if (value != _soundVolume)
					{
						for each (var channel:Channel in _soundChannels)
							channel.volume = value;
						_soundVolume = value;
					}
					break;
				case MUSIC:
					if (value != _musicVolume)
					{
						if (_musicChannel) _musicChannel.volume = value;
						_musicVolume = value;
					}
					break;
			}
		}

		public function playMusic(sound:Sound, fade:Boolean = true, randomPosition:Boolean = true):void
		{
			if (_musicChannel)
			{
				Starling.juggler.removeTweens(_musicChannel);
				if (fade && !_muteMusic)
				{
					var tween:Tween = new Tween(_musicChannel, 0.7);
					tween.animate("volume", 0);
					tween.onCompleteArgs = [_musicChannel];
					tween.onComplete = onFadeComplete;
					Starling.juggler.add(tween);
				}
				else
				{
					_musicChannel.stop();
				}
				_musicChannel = null;
			}

			if (sound)
			{
				var position:Number = 0;
				if (randomPosition)
				{
					var sec:Number = Math.floor(sound.length / 1000.0);
					position = Math.floor(sec * Math.random()) * 1000.0;
				}
				_musicChannel = new Channel(MUSIC);
				if (fade && !_muteMusic)
				{
					_musicChannel.play(sound, position, int.MAX_VALUE, 0);
					tween = new Tween(_musicChannel, 0.7);
					tween.animate("volume", _musicVolume);
					Starling.juggler.add(tween);
				}
				else
				{
					if (_muteMusic)
						_musicChannel.pause(sound, position, int.MAX_VALUE, _musicVolume);
					else
						_musicChannel.play(sound, position, int.MAX_VALUE, _musicVolume);
				}
			}
		}

		private static function onFadeComplete(channel:Channel):void
		{
			channel.stop();
		}

		public function set muteMusic(value:Boolean):void
		{
			if (value == _muteMusic) return;
			_muteMusic = value;
			if (_musicChannel)
			{
				if (_muteMusic) _musicChannel.pause();
				else _musicChannel.play();
			}
		}

		public function get muteMusic():Boolean
		{
			return _muteMusic;
		}

		public function set muteSound(value:Boolean):void
		{
			if (value == _muteSounds) return;
			_muteSounds = value;
			if (_muteSounds) stopAllSounds(true);
		}

		public function get muteSound():Boolean
		{
			return _muteSounds;
		}

		public function playSound(sound:Sound):Channel
		{
			if (_muteSounds) return null;
			var channel:Channel = new Channel(SOUND);
			channel.play(sound, 0, 1, _soundVolume);
			channel.addEventListener(Event.COMPLETE, onSoundComplete);
			_soundChannels.push(channel);
			return channel;
		}

		private function onSoundComplete(event:Event):void
		{
			stopSound(Channel(event.target));
		}

		public function stopSound(channel:Channel, dispatchComplete:Boolean = false):void
		{
			var index:int = _soundChannels.indexOf(channel);
			if (index != -1)
			{
				_soundChannels.splice(index, 1);
				channel.removeEventListener(Event.COMPLETE, onSoundComplete);
				channel.stop();
				if (dispatchComplete) channel.dispatchEventWith(Event.COMPLETE);
			}
		}

		public function stopAllSounds(dispatchComplete:Boolean = false):void
		{
			for each (var channel:Channel in _soundChannels) stopSound(channel, dispatchComplete);
		}
	}
}
