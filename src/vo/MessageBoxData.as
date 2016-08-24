package vo
{
	public class MessageBoxData
	{
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
