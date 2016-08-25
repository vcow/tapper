package resources
{
	import flash.utils.ByteArray;

	public class LocalesLibrary
	{
		[Embed(source="locale/en_US/common.properties", mimeType="application/octet-stream")]
		private static const common_en_US:Class;

		[Embed(source="locale/ru_RU/common.properties", mimeType="application/octet-stream")]
		private static const common_ru_RU:Class;

		[Embed(source="locale/en_US/units.properties", mimeType="application/octet-stream")]
		private static const units_en_US:Class;

		[Embed(source="locale/ru_RU/units.properties", mimeType="application/octet-stream")]
		private static const units_ru_RU:Class;

		public static const commonBundle:Array = [
			{ locale: "en_US", bundleName: "common", useLinebreak: true, bundle: ByteArray(new common_en_US()).toString() },
			{ locale: "ru_RU", bundleName: "common", useLinebreak: true, bundle: ByteArray(new common_ru_RU()).toString() }
		];

		public static const unitsBundle:Array = [
			{ locale: "en_US", bundleName: "units", useLinebreak: true, bundle: ByteArray(new units_en_US()).toString() },
			{ locale: "ru_RU", bundleName: "units", useLinebreak: true, bundle: ByteArray(new units_ru_RU()).toString() }
		];

		public function LocalesLibrary()
		{
			throw Error("LocaleLibrary is a static class.");
		}
	}
}
