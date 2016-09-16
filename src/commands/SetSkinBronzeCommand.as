package commands
{
	import events.SwitchScreenEvent;

	import flash.events.IEventDispatcher;

	import models.GameModel;
	import models.SkinType;

	import robotlegs.bender.extensions.commandCenter.api.ICommand;

	public class SetSkinBronzeCommand implements ICommand
	{
		[Inject]
		public var gameModel:GameModel;

		[Inject]
		public var eventDispatcher:IEventDispatcher;

		public function execute():void
		{
			if (gameModel.currentSkin != SkinType.BRONZE) {
				gameModel.currentSkin = SkinType.BRONZE;
				eventDispatcher.dispatchEvent(new SwitchScreenEvent(SwitchScreenEvent.SWITCH_TO_GAME));
			}
		}
	}
}
