package vo
{
	public class MessageBoxData
	{
		public static const OK_BUTTON:uint = 1;
		public static const CANCEL_BUTTON:uint = 2;
		public static const YES_BUTTON:uint = 4;
		public static const NO_BUTTON:uint = 8;

		private var _message:String;
		private var _callback:Function;
		private var _buttons:uint;

		public function MessageBoxData(message:String, callback:Function, buttons:uint = 3)
		{
			_message = message;
			_callback = callback;
			_buttons = buttons;
		}

		public function get message():String
		{
			return _message;
		}

		public function get callback():Function
		{
			return _callback;
		}

		public function get buttons():uint
		{
			return _buttons;
		}
	}
}
