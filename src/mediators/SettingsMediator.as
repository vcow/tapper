package mediators
{
	import app.AppFacade;

	import feathers.data.ListCollection;

	import models.GameModel;

	import org.puremvc.as3.multicore.interfaces.INotification;

	import starling.events.Event;

	import view.SettingsPopup;

	public class SettingsMediator extends BindableMediator
	{
		private static var _interests:Array = [Const.UPDATE_GOD_MODE];

		private var _packList:ListCollection;

		public function SettingsMediator(mediatorName:String = null, viewComponent:Object = null)
		{
			super(mediatorName, viewComponent);
		}

		override public function onRegister():void
		{
			var settingsPopup:SettingsPopup = getViewComponent() as SettingsPopup;
			if (settingsPopup)
			{
				settingsPopup.addEventListener("soundChanged", onSoundChanged);
				settingsPopup.addEventListener("musicChanged", onMusicChanged);
				settingsPopup.addEventListener("soundSwitch", onSoundSwitch);
				settingsPopup.addEventListener("musicSwitch", onMusicSwitch);
				settingsPopup.addEventListener("switchGodMode", onSwitchGodMode);
			}
		}

		override public function onRemove():void
		{
			var settingsPopup:SettingsPopup = getViewComponent() as SettingsPopup;
			if (settingsPopup)
			{
				settingsPopup.removeEventListener("soundChanged", onSoundChanged);
				settingsPopup.removeEventListener("musicChanged", onMusicChanged);
				settingsPopup.removeEventListener("soundSwitch", onSoundSwitch);
				settingsPopup.removeEventListener("musicSwitch", onMusicSwitch);
				settingsPopup.removeEventListener("switchGodMode", onSwitchGodMode);
			}
		}

		override public function setViewComponent(viewComponent:Object):void
		{
			if (viewComponent == viewComponent) return;

			if (viewComponent)
			{

			}

			super.setViewComponent(viewComponent);
			if (viewComponent)
			{

			}
		}

		[Bindable(event="soundOffCChanged")]
		public function get soundOff():Boolean
		{
			return SoundManager.getInstance().muteSound;
		}

		[Bindable(event="musicOffChanged")]
		public function get musicOff():Boolean
		{
			return SoundManager.getInstance().muteMusic;
		}

		[Bindable(event="soundChanged")]
		public function get soundValue():Number
		{
			return SoundManager.getInstance().getVolume(SoundManager.SOUND);
		}

		[Bindable(event="musicChanged")]
		public function get musicValue():Number
		{
			return SoundManager.getInstance().getVolume(SoundManager.MUSIC);
		}

		[Bindable(event="godModeChanged")]
		public function get hasGodMode():Boolean
		{
			var gameModel:GameModel = AppFacade(facade).gameModel;
			return gameModel.getGodMode() != 0;
		}

		[Bindable(event="godModeChanged")]
		public function get godModeOff():Boolean
		{
			var gameModel:GameModel = AppFacade(facade).gameModel;
			return gameModel.godModeOff;
		}

		private static function onSoundChanged(event:Event):void
		{
			SoundManager.getInstance().setVolume(SoundManager.SOUND, Number(event.data));
		}

		private static function onMusicChanged(event:Event):void
		{
			SoundManager.getInstance().setVolume(SoundManager.MUSIC, Number(event.data));
		}

		private static function onSoundSwitch(event:Event):void
		{
			SoundManager.getInstance().muteSound = Boolean(event.data);
		}

		private static function onMusicSwitch(event:Event):void
		{
			SoundManager.getInstance().muteMusic = Boolean(event.data);
		}

		private function onSwitchGodMode(event:Event):void
		{
			var gameModel:GameModel = AppFacade(facade).gameModel;
			if (event.data == gameModel.godModeOff)
			{
				gameModel.godModeOff = !event.data;
				sendNotification(Const.UPDATE_GOD_MODE);
			}
		}

		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case Const.UPDATE_GOD_MODE:
					dispatchEventWith("godModeChanged");
					break;
			}
		}
	}
}
