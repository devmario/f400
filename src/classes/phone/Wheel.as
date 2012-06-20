package classes.phone
{
	import caurina.transitions.Tweener;
	
	import classes.FlashStage;
	import classes.Phone;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	public class Wheel extends Sprite
	{
		[Embed(source="../../../asset/feelit.swf",symbol="V_icon_list")]
		private var V_icon_list:Class;
		public var sprite_list:Sprite = new Sprite();
		
		[Embed(source="../../../asset/feelit.swf",symbol="V_icon_rew")]
		private var V_icon_rew:Class;
		public var sprite_rew:Sprite = new Sprite();
		
		[Embed(source="../../../asset/feelit.swf",symbol="V_icon_ff")]
		private var V_icon_ff:Class;
		public var sprite_ff:Sprite = new Sprite();
		
		[Embed(source="../../../asset/feelit.swf",symbol="V_icon_stop")]
		private var V_icon_stop:Class;
		public var sprite_stop:Sprite = new Sprite();
		
		[Embed(source="../../../asset/feelit.swf",symbol="V_icon_pause")]
		private var V_icon_pause:Class;
		
		[Embed(source="../../../asset/feelit.swf",symbol="V_icon_play")]
		private var V_icon_play:Class;
		
		public var sprite_play_pause:Sprite = new Sprite();
		
		public var play:DisplayObject;
		public var pause:DisplayObject;
		
		
		
		private var wheel:Bitmap;
		private var container:Sprite;
		
		public var glow:GlowFilter;
		
		public static var isSmallReverse:Boolean = false;
		public static var isLargeReverse:Boolean = false;
		
		public function Wheel()
		{
			super();
			
			container = addChild(new Sprite()) as Sprite;
			
			wheel = container.addChild(new Bitmap(Main.images._wheel,PixelSnapping.AUTO,true)) as Bitmap;
			wheel.x = -wheel.width / 2;
			wheel.y = -wheel.height / 2;
			
			glow = new GlowFilter(0xfb75ca,0,20,20);
			
			configButtonEvent(container.addChild(sprite_ff) as Sprite);
			configButtonEvent(container.addChild(sprite_list) as Sprite);
			configButtonEvent(container.addChild(sprite_play_pause) as Sprite);
			configButtonEvent(container.addChild(sprite_rew) as Sprite);
			configButtonEvent(container.addChild(sprite_stop) as Sprite);
			
			sprite_list.y = -47;
			sprite_list.x = -1;
			sprite_rew.x = -51-1;
			sprite_ff.x = 51-1;
			sprite_stop.y = 47;
			sprite_stop.x = -2;
			sprite_play_pause.x = -1;
			
			var display:DisplayObject = sprite_ff.addChild(new V_icon_ff());
			display = sprite_list.addChild(new V_icon_list());
			pause = sprite_play_pause.addChild(new V_icon_pause());
			play = sprite_play_pause.addChild(new V_icon_play());
			display = sprite_rew.addChild(new V_icon_rew());
			display = sprite_stop.addChild(new V_icon_stop());
			
			addEventListener(MouseEvent.MOUSE_OVER,mouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,mouseOut);
			
			shade();
		}
		
		private function shade():void
		{
			Tweener.addTween(glow,{alpha:0.8,time:1,onUpdate:aglowUpdate,onComplete:inshade});
		}
		
		private function inshade():void
		{
			
			Tweener.addTween(glow,{alpha:0,time:1,onUpdate:aglowUpdate,onComplete:shade});
		}
		
		private function aglowUpdate():void
		{
			container.filters = [glow];
		}
		
		private function configButtonEvent(target:Sprite):void
		{
			target.buttonMode = true;
			target.alpha = 0;
			target.addEventListener(MouseEvent.CLICK,buttonClick);
			target.addEventListener(MouseEvent.MOUSE_OVER,mov);
			target.addEventListener(MouseEvent.MOUSE_OUT,mou);
		}
		
		private function buttonClick(event:MouseEvent):void
		{
			var target:Sprite = event.currentTarget as Sprite;
			if(target == sprite_ff)
			{
				FlashStage.phone.phoneScreen.playPhone.nextButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
			else if(target == sprite_list)
			{
				FlashStage.phone.phoneScreen.playPhone.listButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
			else if(target == sprite_play_pause)
			{
				FlashStage.phone.phoneScreen.playPhone.playButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
			else if(target == sprite_rew)
			{
				FlashStage.phone.phoneScreen.playPhone.prevButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
			else if(target == sprite_stop)
			{
				FlashStage.phone.phoneScreen.playPhone.stopButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}
		
		private function mov(event:MouseEvent):void
		{
			var target:Sprite = event.currentTarget as Sprite;
			if(target == sprite_ff)
			{
				FlashStage.phone.phoneScreen.playPhone.nextButton.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
			}
			else if(target == sprite_list)
			{
				FlashStage.phone.phoneScreen.playPhone.listButton.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
			}
			else if(target == sprite_play_pause)
			{
				FlashStage.phone.phoneScreen.playPhone.playButton.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
			}
			else if(target == sprite_rew)
			{
				FlashStage.phone.phoneScreen.playPhone.prevButton.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
			}
			else if(target == sprite_stop)
			{
				FlashStage.phone.phoneScreen.playPhone.stopButton.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
			}
		}
		
		private function mou(event:MouseEvent):void
		{
			var target:Sprite = event.currentTarget as Sprite;
			if(target == sprite_ff)
			{
				FlashStage.phone.phoneScreen.playPhone.nextButton.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
			}
			else if(target == sprite_list)
			{
				FlashStage.phone.phoneScreen.playPhone.listButton.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
			}
			else if(target == sprite_play_pause)
			{
				FlashStage.phone.phoneScreen.playPhone.playButton.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
			}
			else if(target == sprite_rew)
			{
				FlashStage.phone.phoneScreen.playPhone.prevButton.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
			}
			else if(target == sprite_stop)
			{
				FlashStage.phone.phoneScreen.playPhone.stopButton.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
			}
		}
		
		private function glowTarget(target:Sprite,targetGlow:GlowFilter):void
		{
			target.filters = [targetGlow];
		}
		
		private function mouseOver(event:MouseEvent):void
		{
			Tweener.addTween(sprite_ff,{alpha:1,time:1,onUpdate:glowUpdate});
		}
		
		private function mouseOut(event:MouseEvent):void
		{
			
			Tweener.addTween(sprite_ff,{alpha:0,time:1,onUpdate:glowUpdate});
		}
		
		private function glowUpdate():void
		{
			sprite_list.alpha = sprite_play_pause.alpha = sprite_rew.alpha = sprite_stop.alpha = sprite_ff.alpha;
		}
		
		private var _mode:Boolean;
		public function set mode(value:Boolean):void
		{
			if(_mode != value)
			{
				_mode = value;
				if(_mode)
				{
					
				}
				else
				{
					
				}
			}
		}
		
		public function click(event:MouseEvent):void
		{
			FlashStage.phone.playMode = Phone.MODE_LIST;
			FlashStage.phone.phoneScreen.isPlayStatusMode = false;
		}
		

		
	}
}