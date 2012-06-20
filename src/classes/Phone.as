package classes
{
	import caurina.transitions.Tweener;
	
	import classes.phone.CDpan;
	import classes.phone.E_s;
	import classes.phone.Speaker;
	import classes.phone.Wheel;
	
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;

	public class Phone extends Sprite
	{
		public static const MODE_SELECT:uint = 0;
		public static const MODE_LIST:uint = 1;
		public static const MODE_PLAY:uint = 2;
		public static const MODE_SHUTDOWN:uint = 3;
		
		public static const PHONE_MODE_NO:uint = 0;
		public static const PHONE_MODE_EARPHONE:uint = 1;
		public static const PHONE_MODE_SPEAKER:uint = 2;
		
		public var CDs:CDpan;
		
		private var _playMode:uint = Phone.MODE_SELECT;
		
		private var phone_front:Bitmap;
		public var speaker_front:Speaker;
		public var earphone_front:E_s;
		
		public var phoneScreen:PhoneScreen;
		private var phoneScreenMask:Shape;
		
		private var balloon:Bitmap;
		public var balloonContainer:Sprite;
		
		private var _mode:String;
		
		private var showThisX:Number;
		private var hideThisX:Number;
		
		private var defaultY:Number;
		private var playModeY:Number;
		
		private var _earingMode:int = PHONE_MODE_NO;
		public var extra_earingMode:int = PHONE_MODE_EARPHONE;
		
		private var _earingDelay:Number = 0;
		
		public var maskScale:Number = 0;
		
		public var wheel:Wheel;
		
		public var shsh:Bitmap;
		
		public function Phone()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,added);
		}
		
		private function added(event:Event):void
		{
			if(!phone_front)
			{
				shsh = addChild(new Bitmap(Main.images.___big_shadow,"auto",true)) as Bitmap;
				
				earphone_front = addChild(new E_s()) as E_s;
				speaker_front = addChild(new Speaker()) as Speaker;
				
				phone_front = addChild(new Bitmap(Main.images._phone_front,PixelSnapping.AUTO,true)) as Bitmap;
				
				
				wheel = addChild(new Wheel()) as Wheel;
				wheel.x = phone_front.width/2;
				wheel.y = 430;
				
				speaker_front.y = 0;
				earphone_front.x = -235;
				earphone_front.y = 70;
				earphone_front.alpha = 0;
				
				phoneScreen = addChild(new PhoneScreen()) as PhoneScreen;
				
				phoneScreenMask = addChild(new Shape()) as Shape;
				
				phoneScreen.mask = phoneScreenMask;
				
				phoneScreenMask.x = phoneScreen.x = phone_front.width/2;
				phoneScreenMask.y = phoneScreen.y = 89 + 227/2;
				
				hideThisX = x = -stage.stageWidth;
				showThisX = stage.stageWidth/2 - phone_front.width/2;
				defaultY = y = 49;
				playModeY = 75;
				
				balloonContainer = addChild(new Sprite()) as Sprite;
				balloon = balloonContainer.addChild(new Bitmap(Main.images._balloon,PixelSnapping.AUTO,true)) as Bitmap;
				balloon.x = -30;
				balloon.y = -balloon.height+5;
				balloonContainer.x = phone_front.width - 40;
				balloonContainer.y = 60;
				
				balloonContainer.scaleX = balloonContainer.scaleY = 0;
				
				CDs = addChildAt(new CDpan(this),0) as CDpan;
				CDs.x = phone_front.width / 2;
				CDs.y = phone_front.height / 2 - CDs.radius;
				
				
				shsh.x = phone_front.x - 25;
				shsh.y = phone_front.y + phone_front.height - 50;
				
				mode = Main.MODE_MAIN;
				wheel.visible = false;
				
			}
		}
		
		public function set earingMode(value:int):void
		{
			if(value != _earingMode)
			{ 
				_earingMode = value;
				switch(_earingMode)
				{
					case Phone.PHONE_MODE_NO:
						FlashStage(parent).vvmode = false;
						Tweener.addTween(earphone_front,{alpha:0,time:1,delay:_earingDelay});
						Tweener.addTween(speaker_front,{y:0,time:1,delay:_earingDelay});
						Tweener.addTween(this,{y:defaultY,time:1,delay:_earingDelay});
						break;
					case Phone.PHONE_MODE_EARPHONE:
						FlashStage(parent).vvmode = true;
						phoneScreen.music._volume(0.2);
						Tweener.addTween(earphone_front,{alpha:1,time:1,delay:_earingDelay});
						Tweener.addTween(speaker_front,{y:0,time:1,delay:_earingDelay});
						Tweener.addTween(this,{y:playModeY,time:1,delay:_earingDelay});
						break;
					case Phone.PHONE_MODE_SPEAKER:
						FlashStage(parent).vvmode = true;
						phoneScreen.music._volume(1);
						Tweener.addTween(earphone_front,{alpha:0,time:1,delay:_earingDelay});
						Tweener.addTween(speaker_front,{y:-70,time:1,delay:_earingDelay});
						Tweener.addTween(this,{y:playModeY+25,time:1,delay:_earingDelay});
						break;
				}
				wheel.visible = value != Phone.PHONE_MODE_NO;
			}
			_earingDelay = 0;
		}
		
		private function maskW():void
		{
			phoneScreenMask.graphics.clear();
			phoneScreenMask.graphics.beginFill(0x000000);
			phoneScreenMask.graphics.drawRoundRect(-172/2*maskScale,-229/2*maskScale,172*maskScale,229*maskScale,15,15);
			phoneScreenMask.graphics.endFill();
		}
		
		public function get earingMode():int
		{
			return _earingMode;
		}
		
		public function set mode(value:String):void
		{
			if(value != _mode)
			{
				_mode = value;
				Tweener.removeTweens(this);
				if(_mode == Main.MODE_FEEL_IT)
				{
					earingMode = PHONE_MODE_EARPHONE;
					if(playMode != MODE_PLAY)
					{
						showBalloon();
						Tweener.addTween(this,{y:defaultY,time:1.5});
						Tweener.addTween(this,{scaleX:1,time:1.5,onUpdate:phoneScaleSync});
					}
					else
					{
						Tweener.addTween(this,{y:playModeY+(earingMode == PHONE_MODE_EARPHONE?0:25),time:1.5});
						Tweener.addTween(this,{scaleX:0.652,time:1.5,onUpdate:phoneScaleSync});
					}
					Tweener.addTween(this,{maskScale:1,time:0.3,onUpdate:maskW});
					Tweener.addTween(shsh,{alpha:0,time:1});
					phoneScreen.isPlayStatusMode = false;
					playMode = MODE_LIST;
				}
				else if(_mode == Main.MODE_EXPERIENCE)
				{
					Tweener.addTween(this,{maskScale:0,time:0.3,onUpdate:maskW});
					Tweener.addTween(this,{y:stage.stageHeight/2,time:1.5});
					Tweener.addTween(this,{scaleX:0,time:1.5,onUpdate:phoneScaleSync});
					phoneScreen.music.stop();
					wheel.mode = false;
				}
				else if(_mode == Main.MODE_MAIN)
				{
					earingMode = PHONE_MODE_NO;
					balloonComplete();
					Tweener.addTween(this,{maskScale:0,time:0.3,onUpdate:maskW});
					Tweener.addTween(this,{y:defaultY+50,time:1.5});
					Tweener.addTween(this,{scaleX:0.56,time:1.5,onUpdate:phoneScaleSync});
					Tweener.addTween(shsh,{alpha:1,time:1});
					phoneScreen.music.stop();
					wheel.mode = false;
				}
			}
		}
		
		public function get mode():String
		{
			return _mode;
		}
		
		public function set playMode(value:uint):void
		{
			if(value != _playMode)
			{
				_playMode = value;
				switch(_playMode)
				{
					case Phone.MODE_SELECT:
						wheel.mode = false;
						if(extra_earingMode != PHONE_MODE_NO)
							extra_earingMode = _earingMode;
						earingMode = PHONE_MODE_NO;
						FlashStage(parent).sliderController.mode = SliderController.MODE_POP;
						increase();
						break;
					case Phone.MODE_LIST:
						wheel.mode = false;
						if(extra_earingMode != PHONE_MODE_NO)
							extra_earingMode = _earingMode;
						earingMode = PHONE_MODE_NO;
						FlashStage(parent).sliderController.mode = SliderController.MODE_POP;
						increase();
						break;
					case Phone.MODE_PLAY:
						wheel.mode = true;
						FlashStage(parent).sliderController._delay = 1.5;
						if(extra_earingMode == PHONE_MODE_EARPHONE)
						{
							FlashStage(parent).sliderController.mode = SliderController.MODE_SLIDE;
						}
						else
						{
							FlashStage(parent).sliderController.mode = SliderController.MODE_NO;
						}
						_earingDelay = 1.5;
						earingMode = extra_earingMode;
						decrease();
						break;
					case Phone.MODE_SHUTDOWN:
						wheel.mode = false;
						if(extra_earingMode != PHONE_MODE_NO)
							extra_earingMode = _earingMode;
						earingMode = PHONE_MODE_NO;
						FlashStage(parent).sliderController.mode = SliderController.MODE_POP;
						break;
				}
			}
		}
		
		public function get playMode():uint
		{
			return _playMode;
		}
		
		public function onceIncrease():void
		{
			if(_playMode == MODE_PLAY)
			{
				if(extra_earingMode != PHONE_MODE_NO)
					extra_earingMode = _earingMode;
				earingMode = PHONE_MODE_NO;
				FlashStage(parent).sliderController.mode = SliderController.MODE_POP;
				Tweener.addTween(this,{y:defaultY,time:1});
				Tweener.addTween(this,{scaleX:1,time:1,onUpdate:phoneFrontScale,onComplete:onceDecrease});
			}
		}
		
		private function onceDecrease():void
		{
			Tweener.addTween(this,{y:playModeY,time:3,delay:1});
			Tweener.addTween(this,{scaleX:0.652,time:3,delay:1,onUpdate:phoneFrontScale});
			FlashStage(parent).sliderController._delay = 1.5;
			if(extra_earingMode == PHONE_MODE_EARPHONE)
			{
				FlashStage(parent).sliderController.mode = SliderController.MODE_SLIDE;
			}
			else
			{
				FlashStage(parent).sliderController.mode = SliderController.MODE_NO;
			}
			_earingDelay = 1.5;
			earingMode = extra_earingMode;
		}
		
		private function increase():void
		{
			Tweener.addTween(this,{y:defaultY,time:1});
			Tweener.addTween(this,{scaleX:1,time:1,onUpdate:phoneFrontScale});
			showBalloon();
		}
		
		private function decrease():void
		{
			Tweener.addTween(this,{y:playModeY+(earingMode == PHONE_MODE_EARPHONE?0:25),time:3,delay:1});
			Tweener.addTween(this,{scaleX:0.652,time:3,delay:1,onUpdate:phoneFrontScale});
			balloonComplete();
		}
		
		private function phoneFrontScale():void
		{
			scaleY = scaleX;
			phoneScreen.x = phone_front.width/2;
			x = showThisX = stage.stageWidth/2 - phone_front.width*scaleX/2;
		}
		
		private function phoneScaleSync():void
		{
			scaleY = scaleX;
			phoneScreen.x = phone_front.width/2;
			showThisX = x = stage.stageWidth/2 - phone_front.width*scaleX/2;
		}
		
		
		private function showBalloon():void
		{
			Tweener.addTween(balloonContainer,{scaleX:1,time:1,transition:"easeOutElastic",onUpdate:balloonScale,delay:1});
		}
		
		private function balloonScale():void
		{
			balloonContainer.scaleY = balloonContainer.scaleX;
		}
		
		private function balloonComplete():void
		{
			Tweener.addTween(balloonContainer,{scaleX:0,time:0.3,onUpdate:balloonScale});
		}
	}
}