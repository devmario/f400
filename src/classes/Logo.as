package classes
{
	import caurina.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Logo extends Sprite
	{
		private var logo:Bitmap;
		private var logo_Mask:Shape;
		
		private var showLogoY:Number;
		private var hideLogoY:Number;
		
		private var logo_shadow:Bitmap;
		private var logo_shadow_Mask:Shape;
		
		private var showLogoShadowY:Number;
		private var hideLogoShadowY:Number;
		
		private var _mode:String;
		
		private var _fs:FlashStage;
		
		public function Logo(fs:FlashStage)
		{
			super();
			_fs = fs;
			addEventListener(Event.ADDED_TO_STAGE,added);
		}
		
		private function added(event:Event):void
		{	
			if(!logo)
			{
				logo = addChild(new Bitmap(Main.images._logo,PixelSnapping.AUTO,true)) as Bitmap;
				logo_Mask = addChild(new Shape()) as Shape;
				logo_Mask.graphics.beginFill(0x000000);
				logo_Mask.graphics.drawRect(0,0,logo.width,logo.height);
				logo_Mask.graphics.endFill();
				logo.mask = logo_Mask;
				
				showLogoY = logo.y;
				hideLogoY = showLogoY + logo.height;
				logo.y = hideLogoY;
				
				buttonMode = true;
			}
			
			if(!logo_shadow)
			{
				logo_shadow = addChild(new Bitmap(Main.images._logo_shadow,PixelSnapping.AUTO,true)) as Bitmap;
				logo_shadow_Mask = addChild(new Shape()) as Shape;
				logo_shadow.y = logo_shadow_Mask.y = logo.height - 3;
				logo_shadow_Mask.graphics.beginFill(0x000000);
				logo_shadow_Mask.graphics.drawRect(0,0,logo_shadow.width,logo_shadow.height);
				logo_shadow_Mask.graphics.endFill();
				logo_shadow.mask = logo_shadow_Mask;
				
				showLogoShadowY = logo_shadow.y;
				hideLogoShadowY = showLogoShadowY - logo_shadow.height;
				logo_shadow.y = hideLogoShadowY;
			}
			
			if(!_mode)
			{
				mode = Main.MODE_FEEL_IT;
				
				x = 43;
				y = 18;
			}
			
			addEventListener(MouseEvent.CLICK,click);
		}
		
		private function click(event:MouseEvent):void
		{
			_fs.mode = Main.MODE_MAIN;
		}
		
		public function set mode(value:String):void
		{
			if(value != _mode)
			{
				Tweener.addTween(logo,{y:value == Main.MODE_FEEL_IT || value == Main.MODE_MAIN?showLogoY:hideLogoY,time:1});
				Tweener.addTween(logo_shadow,{y:value == Main.MODE_FEEL_IT || value == Main.MODE_MAIN?showLogoShadowY:hideLogoY,time:1});
			}
		}
		
		public function get mode():String
		{
			return _mode;
		}
		
	}
}