package resources
{
	import flash.utils.ByteArray;

	/**
	 * Библиотека локализаций.
	 */
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

		[Embed(source="locale/en_US/levels.properties", mimeType="application/octet-stream")]
		private static const levels_en_US:Class;

		[Embed(source="locale/ru_RU/levels.properties", mimeType="application/octet-stream")]
		private static const levels_ru_RU:Class;

		[Embed(source="locale/en_US/achievements.properties", mimeType="application/octet-stream")]
		private static const achievements_en_US:Class;

		[Embed(source="locale/ru_RU/achievements.properties", mimeType="application/octet-stream")]
		private static const achievements_ru_RU:Class;

		[Embed(source="locale/en_US/actions.properties", mimeType="application/octet-stream")]
		private static const actions_en_US:Class;

		[Embed(source="locale/ru_RU/actions.properties", mimeType="application/octet-stream")]
		private static const actions_ru_RU:Class;

		[Embed(source="locale/en_US/packs.properties", mimeType="application/octet-stream")]
		private static const packs_en_US:Class;

		[Embed(source="locale/ru_RU/packs.properties", mimeType="application/octet-stream")]
		private static const packs_ru_RU:Class;

		public static const commonBundle:Array = [
			{ locale: "en_US", bundleName: "common", useLinebreak: true, bundle: ByteArray(new common_en_US()).toString() },
			{ locale: "ru_RU", bundleName: "common", useLinebreak: true, bundle: ByteArray(new common_ru_RU()).toString() }
		];

		public static const unitsBundle:Array = [
			{ locale: "en_US", bundleName: "units", useLinebreak: true, bundle: ByteArray(new units_en_US()).toString() },
			{ locale: "ru_RU", bundleName: "units", useLinebreak: true, bundle: ByteArray(new units_ru_RU()).toString() }
		];

		public static const levelsBundle:Array = [
			{ locale: "en_US", bundleName: "levels", useLinebreak: true, bundle: ByteArray(new levels_en_US()).toString() },
			{ locale: "ru_RU", bundleName: "levels", useLinebreak: true, bundle: ByteArray(new levels_ru_RU()).toString() }
		];

		public static const achievementsBundle:Array = [
			{ locale: "en_US", bundleName: "achievements", useLinebreak: true, bundle: ByteArray(new achievements_en_US()).toString() },
			{ locale: "ru_RU", bundleName: "achievements", useLinebreak: true, bundle: ByteArray(new achievements_ru_RU()).toString() }
		];

		public static const actionsBundle:Array = [
			{ locale: "en_US", bundleName: "actions", useLinebreak: true, bundle: ByteArray(new actions_en_US()).toString() },
			{ locale: "ru_RU", bundleName: "actions", useLinebreak: true, bundle: ByteArray(new actions_ru_RU()).toString() }
		];

		public static const packsBundle:Array = [
			{ locale: "en_US", bundleName: "packs", useLinebreak: true, bundle: ByteArray(new packs_en_US()).toString() },
			{ locale: "ru_RU", bundleName: "packs", useLinebreak: true, bundle: ByteArray(new packs_ru_RU()).toString() }
		];

		public function LocalesLibrary()
		{
			throw Error("LocaleLibrary is a static class.");
		}
	}
}
