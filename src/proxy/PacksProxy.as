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
				addPack("silver_fish", 15);
				addPack("golden_fish", 30);
				addPack("silver_fish_pack", 35);
				addPack("golden_fish_pack", 50);
				addPack("portal", 25);
			}
			return _packs;
		}

		private function addPack(id:String, price:Number):void
		{
			var pack:Pack = new Pack(id, _packs.length, price);
			_packs.push(pack);
		}
	}
}
