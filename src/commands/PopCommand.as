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
			var currentState:String;
			switch (notification.getName())
			{
				case Const.POP:
					currentState = _stack.length > 1 ? _stack.pop() : _stack[0];
					break;
				case Const.POP_TO_ROOT:
					currentState = _stack[0];
					if (_stack.length > 1) _stack.slice(1, _stack.length - 1);
					break;
				case Const.SWITCH_TO:
					if (!_lockStack)
					{
						_stack.push(notification.getBody() as String);
					}
					return;
			}

			var gameModel:GameModel = AppFacade(facade).gameModel;
			if (gameModel.currentState != currentState)
				throw Error("Screen stack is broken.");

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
