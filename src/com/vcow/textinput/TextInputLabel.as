package com.vcow.textinput
{
	import feathers.controls.Label;
	import feathers.core.ITextRenderer;

	public class TextInputLabel extends Label
	{
		public function TextInputLabel()
		{
		}

		public function getTextRenderer():ITextRenderer
		{
			return textRenderer;
		}
	}
}
