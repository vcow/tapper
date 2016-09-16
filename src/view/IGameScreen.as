package view
{
	import feathers.data.ListCollection;

	public interface IGameScreen
	{
		function set money(value:Number):void;

		function set unitsList(value:ListCollection):void;

		function set levelDescription(value:String):void;
	}
}
