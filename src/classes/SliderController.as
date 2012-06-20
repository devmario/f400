package classes
{
	import caurina.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	public class SliderController extends Sprite
	{
		public var text:Sprite;
		public var button:Sprite;
		
		public var textBMP:Bitmap;
		public var buttonBMP:Bitmap;
		
		public static const MODE_POP:int = 0;
		public static const MODE_NO:int = 1;
		public static const MODE_SLIDE:int = 2;
		
		public var _mode:int = MODE_POP;
		
		public var phone:Phone;
		
		public var _delay:Number = 1.5;
		
		public var glow:GlowFilter;
		
		private var _feel_exp_mode:String = Main.MODE_FEEL_IT;
		
		private var once:Boolean = true;
		
		public function SliderController(_phone:Phone)
		{
			super();
			
			phone = _phone;
			
			text = addChild(new Sprite()) as Sprite;
			button = addChild(new Sprite()) as Sprite;
			
			button.buttonMode = true;
			
			textBMP = text.addChild(new Bitmap(Main.images._txt_Slide_it_down,PixelSnapping.AUTO,true)) as Bitmap;
			buttonBMP = button.addChild(new Bitmap(Main.images._arrow,PixelSnapping.AUTO,true)) as Bitmap;
			
			textBMP.x = -textBMP.width/2;
			textBMP.y = -textBMP.height/2;
			buttonBMP.x = -buttonBMP.width/2;
			buttonBMP.y = -buttonBMP.height/2;
			button.rotation = 180;
			
			text.y = -170;
			button.y = -120;
			button.visible = false;
			button.alpha = 0;
			
			button.addEventListener(MouseEvent.CLICK,click);
			
			glow = new GlowFilter(0xfb75ca,0,20,20);
			
			sh1();
		}
		
		
		private function sh1():void
		{
			Tweener.addTween(glow,{alpha:1,time:0.5,onComplete:sh2,onUpdate:glowUpdate,transition:"linear"});
		}
		
		private function sh2():void
		{
			Tweener.addTween(glow,{alpha:0,time:0.5,onComplete:sh1,onUpdate:glowUpdate,transition:"linear"});
		}
		
		
		public function set feel_exp_mode(value:String):void
		{
			if(_feel_exp_mode != value)
			{
				_feel_exp_mode = value;
				if(_feel_exp_mode == Main.MODE_FEEL_IT)
				{
					Tweener.addTween(this,{x:stage.stageWidth/2,time:1.5});
				}
				else
				{
					Tweener.addTween(this,{x:-stage.stageWidth/2,time:1.5});
				}
			}
		}
		
		public function get feel_exp_mode():String
		{
			return _feel_exp_mode;
		}
		
		private var onceI:int;
		public function set mode(value:int):void
		{
			if(_mode != value)
			{
				_mode = value;
				switch(_mode)
				{	
					case MODE_POP:
						Tweener.addTween(text,{y:-170,time:1,delay:_delay});
						Tweener.addTween(button,{rotation:180,time:1,delay:_delay});
						Tweener.addTween(button,{alpha:0,time:1,onComplete:buttonVisible,delay:_delay});
						Tweener.addTween(button,{y:-120,time:1,delay:_delay});
						break;
					case MODE_NO:
						if(phone.earingMode != Phone.PHONE_MODE_NO)
							phone.earingMode = Phone.PHONE_MODE_SPEAKER;
						button.visible = true;
						Tweener.addTween(text,{y:-120,time:1,delay:_delay});
						Tweener.addTween(button,{rotation:0,time:1,delay:_delay});
						Tweener.addTween(button,{alpha:1,time:1,delay:_delay});
						Tweener.addTween(button,{y:-20,time:1,delay:_delay});
						break;
					case MODE_SLIDE:
						if(phone.earingMode != Phone.PHONE_MODE_NO)
							phone.earingMode = Phone.PHONE_MODE_EARPHONE;
						button.visible = true;
						Tweener.addTween(text,{y:-30,time:1,delay:_delay});
						Tweener.addTween(button,{rotation:180,time:1,delay:_delay});
						Tweener.addTween(button,{alpha:1,time:1,delay:_delay});
						Tweener.addTween(button,{y:0,time:1,delay:_delay});
						if(once)
						{
							onceI = setInterval(ooc,7000);
							once = false;
						}
						break;
				}
				_delay = 0;
			}
		}
		
		private function ooc():void
		{
			clearInterval(onceI);
			if(_mode != MODE_NO)
			{
				Tweener.removeTweens(glow);
				Tweener.addTween(glow,{alpha:0,time:0.5,onUpdate:glowUpdate,transition:"linear"});
				
				button.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				
				button.addEventListener(MouseEvent.MOUSE_OVER,mouseOver);
				button.addEventListener(MouseEvent.MOUSE_OUT,mouseOut);
			}
		}
		public function get mode():int
		{
			return _mode;
		}
		
		private function buttonVisible():void
		{
			button.visible = false;
		}
		
		private function click(event:MouseEvent):void
		{
			clearInterval(onceI);
			Tweener.removeTweens(glow);
			Tweener.addTween(glow,{alpha:0,time:0.5,onUpdate:glowUpdate,transition:"linear"});
			
			button.addEventListener(MouseEvent.MOUSE_OVER,mouseOver);
			button.addEventListener(MouseEvent.MOUSE_OUT,mouseOut);
			once = false;
			if(mode == MODE_SLIDE)
			{
				mode = MODE_NO;
			}
			else if(mode == MODE_NO)
			{
				
				mode = MODE_SLIDE;
			}
		}
		
		private function mouseOver(event:MouseEvent):void
		{
			Tweener.addTween(glow,{alpha:0.8,time:1,onUpdate:glowUpdate});
		}
		
		private function mouseOut(event:MouseEvent):void
		{
			Tweener.addTween(glow,{alpha:0,time:1,onUpdate:glowUpdate});
		}
		
		private function glowUpdate():void
		{
			button.filters = [glow];
		}
		
	}
}