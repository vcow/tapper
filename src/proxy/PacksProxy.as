package proxy
{
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	import vo.Pack;

	public class PacksProxy extends Proxy
	{
		public static const NAME:String = "packProxy";

		private var _packs:Vector.<Pack>;

		public function PacksProxy()
		{
			super(NAME);
		}

		override public function getData():Object
		{
			return packs;
		}

		public function get packs():Vector.<Pack>
		{
			if (!_packs)
			{
				_packs = new Vector.<Pack>();
				_packs.push(new Pack("qtap.silver_fish", true));
				_packs.push(new Pack("qtap.golden_fish", true));
				_packs.push(new Pack("qtap.silver_fish.pack", true));
				_packs.push(new Pack("qtap.golden_fish.pack", true));
				_packs.push(new Pack("qtap.portal", false));
//				_packs.push(new Pack("qtap.bronze.room"));
//				_packs.push(new Pack("qtap.silver.room"));
//				_packs.push(new Pack("qtap.golden.room"));
			}
			return _packs;
		}
	}
}
