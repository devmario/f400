package classes.phone
{
	import caurina.transitions.Tweener;
	
	import classes.FlashStage;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;

	public class ControlButton extends Sprite
	{
		public var icon:Bitmap;
		
		protected var colorTransform:ColorTransform;
		
		protected var rSelected:Number = 0xFF;
		protected var gSelected:Number = 0xFF;
		protected var bSelected:Number = 0xFF;
		
		protected var rDeSelected:Number = 0xCF;
		protected var gDeSelected:Number = 0x70;
		protected var bDeSelected:Number = 0xB2;
		
		public var r:Number = rDeSelected;
		public var g:Number = gDeSelected;
		public var b:Number = bDeSelected;
		
		protected var isDown:Boolean = false;
		
		protected var glow:GlowFilter;
		
		public function ControlButton(bitmapData:BitmapData)
		{
			super();
			
			icon = addChild(new Bitmap(bitmapData,PixelSnapping.AUTO,true)) as Bitmap;
			icon.x = -icon.width/2;
			icon.y = -icon.height/2;
			
			colorTransform = new ColorTransform();
			colorRGB();
			
			glow = new GlowFilter(0xFFFFFF,0.5);
			filters = [glow];
			
			addEventListener(MouseEvent.MOUSE_OVER,mouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,mouseOut);
			addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			addEventListener(MouseEvent.MOUSE_UP,mouseUp);
		}
		
		protected function mouseOver(event:MouseEvent):void
		{
			Tweener.addTween(this,{r:rSelected,time:0.5});
			Tweener.addTween(this,{g:gSelected,time:0.5});
			Tweener.addTween(this,{b:bSelected,time:0.5,onUpdate:colorRGB});
		}
		
		protected function mouseOut(event:MouseEvent):void
		{
			if(isDown)
			{
				y--;
				isDown = false;
			}
			Tweener.addTween(this,{r:rDeSelected,time:0.5});
			Tweener.addTween(this,{g:gDeSelected,time:0.5});
			Tweener.addTween(this,{b:bDeSelected,time:0.5,onUpdate:colorRGB});
		}
		
		protected function mouseDown(event:MouseEvent):void
		{
			y++;
			isDown = true;
		}
		
		protected function mouseUp(event:MouseEvent):void
		{
			if(isDown)
			{
				y--;
				isDown = false;
			}
		}
		
		protected function colorRGB():void
		{
			colorTransform.color = r<<16 | g<<8 | b;
			transform.colorTransform = colorTransform;
		}
		
	}
}