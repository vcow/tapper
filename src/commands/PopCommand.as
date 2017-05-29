package commands
{
	import app.AppFacade;

	import models.GameModel;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class PopCommand extends SimpleCommand
	{
		private static const _stack:Vector.<String> = new <String>[Const.STATE_START];
		private static var _lockStack:Boolean;

		override public function execute(notification:INotification):void
		{
			switch (notification.getName())
			{
				case Const.POP:
					if (_stack.length > 1) _stack.pop();
					break;
				case Const.POP_TO_ROOT:
					if (_stack.length > 1) _stack.splice(1, _stack.length - 1);
					break;
				case Const.SWITCH_TO:
					if (!_lockStack)
					{
						_stack.push(notification.getBody() as String);
					}
					return;
			}

			var gameModel:GameModel = AppFacade(facade).gameModel;
			var prevState:String = _stack[_stack.length - 1];
			if (gameModel.currentState != prevState)
			{
				_lockStack = true;
				sendNotification(Const.SWITCH_TO, prevState);
				_lockStack = false;
			}
		}
	}
}
