package resources.skin
{
import feathers.controls.ScrollBar;
import feathers.core.IMeasureDisplayObject;
import feathers.core.IValidating;
import feathers.layout.Direction;

public class DirectThumbScrollBar extends ScrollBar
{
	public function DirectThumbScrollBar()
	{
		super();
	}

	override protected function layoutThumb():void
	{
		var range:Number = this._maximum - this._minimum;
		this.thumb.visible = range > 0 && range < Number.POSITIVE_INFINITY && this._isEnabled;
		if(!this.thumb.visible)
		{
			return;
		}

		//this will auto-size the thumb, if needed
		if(this.thumb is IValidating)
		{
			IValidating(this.thumb).validate();
		}

		var contentWidth:Number = this.actualWidth - this._paddingLeft - this._paddingRight;
		var contentHeight:Number = this.actualHeight - this._paddingTop - this._paddingBottom;
		var adjustedPage:Number = this._page;
		if(this._page == 0)
		{
			adjustedPage = this._step;
		}
		if(adjustedPage > range)
		{
			adjustedPage = range;
		}
		if(this._direction == Direction.VERTICAL)
		{
			contentHeight -= (this.decrementButton.height + this.incrementButton.height);
			var thumbMinHeight:Number = this.thumbOriginalHeight;
			if(this.thumb is IMeasureDisplayObject)
			{
				thumbMinHeight = IMeasureDisplayObject(this.thumb).minHeight;
			}
			this.thumb.width = this.thumbOriginalWidth;
			this.thumb.height = this.thumbOriginalHeight; // Math.max(thumbMinHeight, contentHeight * adjustedPage / range);
			var trackScrollableHeight:Number = contentHeight - this.thumb.height;
			this.thumb.x = this._paddingLeft + (this.actualWidth - this._paddingLeft - this._paddingRight - this.thumb.width) / 2;
			this.thumb.y = this.decrementButton.height + this._paddingTop + Math.max(0, Math.min(trackScrollableHeight, trackScrollableHeight * (this._value - this._minimum) / range));
		}
		else //horizontal
		{
			contentWidth -= (this.decrementButton.width + this.decrementButton.width);
			var thumbMinWidth:Number = this.thumbOriginalWidth;
			if(this.thumb is IMeasureDisplayObject)
			{
				thumbMinWidth = IMeasureDisplayObject(this.thumb).minWidth;
			}
			this.thumb.width = Math.max(thumbMinWidth, contentWidth * adjustedPage / range);
			this.thumb.height = this.thumbOriginalHeight;
			var trackScrollableWidth:Number = contentWidth - this.thumb.width;
			this.thumb.x = this.decrementButton.width + this._paddingLeft + Math.max(0, Math.min(trackScrollableWidth, trackScrollableWidth * (this._value - this._minimum) / range));
			this.thumb.y = this._paddingTop + (this.actualHeight - this._paddingTop - this._paddingBottom - this.thumb.height) / 2;
		}
	}
}
}
