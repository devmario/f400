package classes
{
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Slider extends Sprite
	{
		private var _label:String;
		
		private var _currentValue:Number;
		
		private var _minValue:Number;
		private var _maxValue:Number;
		
		private var textField:TextField;
		private var textFormat:TextFormat;
		
		private var slider:Bitmap;
		private var thumb:Sprite;
		private var thumbBmp:Bitmap;
		
		private var minThumbX:Number;
		private var maxThumbX:Number;
		
		public var index:int;
		
		public function Slider(_index:int)
		{
			super();
			index = _index;
			init();
			eventConfig();
		}
		
		private function init():void
		{
			textField = addChild(new TextField()) as TextField;
			textFormat = new TextFormat("FUTURAM",11,0x4C4C4C);
			label = "Label";
			slider = addChild(new Bitmap(Main.images._sliderLine,PixelSnapping.AUTO,true)) as Bitmap;
			slider.y = -slider.height/2;
			minThumbX = slider.x;
			maxThumbX = slider.x + slider.width;
			thumb = addChild(new Sprite()) as Sprite;
			thumbBmp = thumb.addChild(new Bitmap(Main.images._sliderThumb,PixelSnapping.AUTO,true)) as Bitmap;
			thumbBmp.x = -thumbBmp.width/2;
			thumbBmp.y = -thumbBmp.height/2;
			thumb.x = maxThumbX/2;
			thumb.buttonMode = true;
		}
		
		private function eventConfig():void
		{
			thumb.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
		}
		
		private function mouseDown(event:MouseEvent):void
		{
			addThumbEvent();
		}
		
		private function mouseMove(event:MouseEvent):void
		{
			if(mouseX < minThumbX)
			{
				thumb.x = minThumbX;
			}
			else if(mouseX > maxThumbX)
			{
				thumb.x = maxThumbX;
			}
			else
			{
				thumb.x = mouseX;
			}
			var per:Number = (thumb.x - minThumbX) / (maxThumbX - minThumbX);
			switch(index)
			{
				case 0:
					FlashStage._eq_scale = per;
					break;
				case 1:
					FlashStage._eq_color = per;
					break;
				case 2:
					FlashStage._eq_speed = per;
					break;
				case 3:
					FlashStage._eq_power = per;
					break;
			}
		}
		
		private function mouseUp(event:MouseEvent):void
		{
			removeThumbEvent();
		}
		
		private function mouseLeave(event:Event):void
		{
			removeThumbEvent();
		}
		
		private function addThumbEvent():void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
			stage.addEventListener(Event.MOUSE_LEAVE,mouseLeave);
		}
		
		private function removeThumbEvent():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUp);
			stage.removeEventListener(Event.MOUSE_LEAVE,mouseLeave);
		}
		
		public function get label():String
		{
			return _label;
		}
		
		public function set label(value:String):void
		{
			if(_label != value)
			{
				_label = value;
				textField.embedFonts = true;
				textField.width = 0;
				textField.autoSize = TextFieldAutoSize.RIGHT;
				textField.text = _label;
				textField.setTextFormat(textFormat);
				textField.selectable = false;
				textField.y = -textField.height/2;
				textField.x = -10 -textField.width;
			}
		}
		
		public function get minValue():Number
		{
			return _minValue;
		}
		
		public function set minValue(value:Number):void
		{
			if(_minValue != value)
			{
				_minValue = value;
			}
		}
		
		public function get maxValue():Number
		{
			return _maxValue;
		}
		
		public function set maxValue(value:Number):void
		{
			if(_maxValue != value)
			{
				_maxValue = value;
			}
		}
		
		public function get currentValue():Number
		{
			return _currentValue;
		}
		
		public function set currentValue(value:Number):void
		{
			if(_currentValue != value)
			{
				_currentValue = value;
			}
		}
		
	}
}