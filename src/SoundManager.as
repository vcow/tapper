package
{
	import flash.media.Sound;

	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.events.Event;

	public class SoundManager
	{
		private static const MUSIC:String = "music";
		private static const SOUND:String = "sound";

		private static var _instance:SoundManager;

		private var _musicChannel:Channel;
		private var _soundChannels:Vector.<Channel> = new Vector.<Channel>();

		private var _musicVolume:Number = 1.0;
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

		public function playMusic(sound:Sound, fade:Boolean = true, randomPosition:Boolean = true):void
		{
			if (_musicChannel)
			{
				Starling.juggler.removeTweens(_musicChannel);
				if (fade)
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
				if (fade)
				{
					_musicChannel.play(sound, position, int.MAX_VALUE, 0);
					tween = new Tween(_musicChannel, 0.7);
					tween.animate("volume", getVolume(MUSIC));
					Starling.juggler.add(tween);
				}
				else
				{
					_musicChannel.play(sound, position, int.MAX_VALUE);
				}
			}
		}

		private static function onFadeComplete(channel:Channel):void
		{
			channel.stop();
		}

		public function playSound(sound:Sound, exclusive:Boolean = false):Channel
		{
			if (exclusive)
			{
				for each (var channel:Channel in _soundChannels) channel.stop();
				_soundChannels.length = 0;
			}

			channel = new Channel(SOUND);
			channel.play(sound, 0, 1, getVolume(SOUND));
			channel.addEventListener(Event.COMPLETE, onSoundComplete);
			_soundChannels.push(channel);
			return channel;
		}

		private function onSoundComplete(event:Event):void
		{
			var channel:Channel = Channel(event.target);
			channel.removeEventListener(Event.COMPLETE, onSoundComplete);
			stopChannel(channel);
		}

		public function stopChannel(channel:Channel):void
		{
			var index:int = _soundChannels.indexOf(channel);
			if (index != -1)
			{
				_soundChannels.splice(index, 1);
				channel.stop();
			}
		}
	}
}
