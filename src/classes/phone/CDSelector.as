package classes.phone
{
	import classes.FlashStage;
	import classes.Phone;
	
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	public class CDSelector extends Sprite
	{
		private var cds:Array = [];
		private var glow:GlowFilter = new GlowFilter(0xfb75ca,0.8,20,20);
		public function CDSelector()
		{
			super();
			for(var n:int = 0;n<5;n++)
			{
				cds[n] = addChild(new Sprite()) as Sprite;
				var bitmap:Bitmap = cds[n].addChild(new Bitmap(Main.images.cdMs(n),PixelSnapping.AUTO,true));
				bitmap.x = -bitmap.width/2;
				bitmap.y = -bitmap.height/2;
				cds[n].addEventListener(MouseEvent.CLICK,click);
				cds[n].addEventListener(MouseEvent.MOUSE_OVER,over);
				cds[n].addEventListener(MouseEvent.MOUSE_OUT,out);
				cds[n].buttonMode = true;
			}
			cds[0].x = 24;
			cds[0].y = 152;
			cds[1].x = 96;
			cds[1].y = 180;
			cds[2].x = 128;
			cds[2].y = 255;
			cds[3].x = 95;
			cds[3].y = 328;
			cds[4].x = 23;
			cds[4].y = 358;
		}
		
		private function over(event:MouseEvent):void
		{
			for(var n:int = 0;n<5;n++)
			{
				if(event.currentTarget == cds[n])
				{
					FlashStage.phone.phoneScreen.lists[n].dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
				}
			}
		}
		
		private function out(event:MouseEvent):void
		{
			for(var n:int = 0;n<5;n++)
			{
				if(event.currentTarget == cds[n])
				{
					FlashStage.phone.phoneScreen.lists[n].dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
				}
			}
		}
		
		private function click(event:Event):void
		{
			for(var n:int = 0;n<5;n++)
			{
				if(event.currentTarget == cds[n])
				{
					FlashStage.phone.phoneScreen.music.selectedIndex = n;
					if(FlashStage.phone.playMode != Phone.MODE_PLAY)
					{
						FlashStage.phone.playMode = Phone.MODE_PLAY;
					}
					else
					{
						FlashStage.phone.onceIncrease();
					}
					FlashStage.phone.phoneScreen.isPlayStatusMode = true;
				}
				else
				{
					cds[n].filters = [];
				}
			}
		}
		
		public function set selectedIndex(value:int):void
		{
			for(var n:int = 0;n<5;n++)
			{
				cds[n].filters = [];
			}
			cds[value].filters = [glow];
		}

	}
}