package view
{
	public class StringUtils
	{
		public static function divideByDigits(value:Number, separator:String = " ", numDigits:int = 3) : String
		{
			var raw:String = Math.floor(value).toString();
			var l:int = raw.length % numDigits;
			var res:String = raw.substr(0, l);
			while (raw.length > l)
			{
				res += res.length > 0 ? separator : "";
				res += raw.substr(l, numDigits);
				l += numDigits;
			}
			return res;
		}

		public function StringUtils()
		{
			throw Error("StringUtils is a static class.")
		}
	}
}
