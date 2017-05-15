package resources
{
	import resources.skin.ButtonStyleProviderBase;
	import resources.skin.CommonButtonStyleProvider;
	import resources.skin.LabelStyleProviderBase;
	import resources.skin.LevelDescriptionStyleProvider;
	import resources.skin.MessageBoxButtonStyleProvider;
	import resources.skin.MoneyLabelStyleProvider;
	import resources.skin.ScrollerStyleProviderBase;
	import resources.skin.WoodenScrollerStyleProvider;
	import resources.skin.WoodenShopButtonStyleHighlightedProvider;
	import resources.skin.WoodenShopButtonStyleNormalProvider;
	import resources.skin.ShopItemDescriptionLabelStyleProvider;
	import resources.skin.ShopScrollerStyleProvider;
	import resources.skin.WoodenShopWidgetLabelStyleProvider;

	public class StylesLibrary
	{
		public static const startScreenButtonStyleProvider:ButtonStyleProviderBase = new CommonButtonStyleProvider();

		public static const messageBoxButtonStyleProvider:ButtonStyleProviderBase = new MessageBoxButtonStyleProvider();

		public static const woodenShopButtonStyleNormalProvider:ButtonStyleProviderBase = new WoodenShopButtonStyleNormalProvider();
		public static const woodenShopButtonStyleHighlightedProvider:ButtonStyleProviderBase = new WoodenShopButtonStyleHighlightedProvider();

		public static const moneyLabelStyleProvider:LabelStyleProviderBase = new MoneyLabelStyleProvider();
		public static const woodenShopWidgetLabelStyleProvider:LabelStyleProviderBase = new WoodenShopWidgetLabelStyleProvider();
		public static const levelDescriptionStyleProvider:LabelStyleProviderBase = new LevelDescriptionStyleProvider();
		public static const shopItemDescriptionLabelStyleProvider:LabelStyleProviderBase = new ShopItemDescriptionLabelStyleProvider();

		public static const shopScrollerStyleProvider:ScrollerStyleProviderBase = new ShopScrollerStyleProvider();
		public static const woodenScrollerStyleProvider:ScrollerStyleProviderBase = new WoodenScrollerStyleProvider();

		public function StylesLibrary()
		{
			throw Error("StylesLibrary is a static class.");
		}
	}
}
