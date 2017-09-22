package resources
{
	import resources.skin.ButtonStyleProviderBase;
	import resources.skin.BuyPackButtonStyleProvider;
	import resources.skin.CommonButtonStyleProvider;
	import resources.skin.LabelStyleProviderBase;
	import resources.skin.LevelDescriptionStyleProvider;
	import resources.skin.MessageBoxButtonStyleProvider;
	import resources.skin.MoneyLabelStyleProvider;
	import resources.skin.ScrollerStyleProviderBase;
	import resources.skin.SettingsButtonStyleProvider;
	import resources.skin.TitleSettingsButtonStyleProvider;
	import resources.skin.SettingsSliderStyleProvider;
	import resources.skin.SliderStyleProviderBase;
	import resources.skin.WoodenScrollerStyleProvider;
	import resources.skin.WoodenShopButtonStyleHighlightedProvider;
	import resources.skin.WoodenShopButtonStyleNormalProvider;
	import resources.skin.ShopItemDescriptionLabelStyleProvider;
	import resources.skin.ShopScrollerStyleProvider;
	import resources.skin.WoodenShopWidgetLabelStyleProvider;

	/**
	 * Библиотека стилей для элементов UI.
	 */
	public class StylesLibrary
	{
		public static const startScreenButtonStyleProvider:ButtonStyleProviderBase = new CommonButtonStyleProvider();
		public static const titleSettingsButtonStyleProvider:ButtonStyleProviderBase = new TitleSettingsButtonStyleProvider();
		public static const settingsButtonStyleProvider:ButtonStyleProviderBase = new SettingsButtonStyleProvider();

		public static const messageBoxButtonStyleProvider:ButtonStyleProviderBase = new MessageBoxButtonStyleProvider();
		public static const buyPackButtonStyleProvider:ButtonStyleProviderBase = new BuyPackButtonStyleProvider();

		public static const woodenShopButtonStyleNormalProvider:ButtonStyleProviderBase = new WoodenShopButtonStyleNormalProvider();
		public static const woodenShopButtonStyleHighlightedProvider:ButtonStyleProviderBase = new WoodenShopButtonStyleHighlightedProvider();

		public static const moneyLabelStyleProvider:LabelStyleProviderBase = new MoneyLabelStyleProvider();
		public static const woodenShopWidgetLabelStyleProvider:LabelStyleProviderBase = new WoodenShopWidgetLabelStyleProvider();
		public static const levelDescriptionStyleProvider:LabelStyleProviderBase = new LevelDescriptionStyleProvider();
		public static const shopItemDescriptionLabelStyleProvider:LabelStyleProviderBase = new ShopItemDescriptionLabelStyleProvider();

		public static const shopScrollerStyleProvider:ScrollerStyleProviderBase = new ShopScrollerStyleProvider();
		public static const woodenScrollerStyleProvider:ScrollerStyleProviderBase = new WoodenScrollerStyleProvider();

		public static const settingsSliderStyleProvider:SliderStyleProviderBase = new SettingsSliderStyleProvider();

		public function StylesLibrary()
		{
			throw Error("StylesLibrary is a static class.");
		}
	}
}
