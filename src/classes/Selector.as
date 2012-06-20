package classes
{
	import caurina.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Selector extends Sprite
	{
		public var tab_feel:Sprite;
		private var bitmap_tab_feel:Bitmap;
		
		private var show_tab_feel:Number;
		private var hide_tab_feel:Number;
		
		public var tab_exp:Sprite;
		private var bitmap_tab_exp:Bitmap;
		
		private var show_tab_exp:Number;
		private var hide_tab_exp:Number;
		
		private var _mode:String;
		
		private var tabMargin:Number = 3;
		
		private var flashStage:FlashStage;
		
		public function Selector(_flashStage:FlashStage)
		{
			super();
			
			flashStage = _flashStage;
			
			addEventListener(Event.ADDED_TO_STAGE,added);
		}
		
		private function added(event:Event):void
		{
			if(!tab_feel)
			{
				tab_feel = new Sprite();
				bitmap_tab_feel = new Bitmap(Main.images._tab_feel,PixelSnapping.AUTO,true);
				tab_feel.addChild(bitmap_tab_feel);
			
				tab_exp = new Sprite();
				bitmap_tab_exp = new Bitmap(Main.images._tab_exp,PixelSnapping.AUTO,true);
				tab_exp.addChild(bitmap_tab_exp);
			
			
				tab_feel.y = tab_exp.y = 15;
				
				tab_feel.x =hide_tab_feel = -tab_feel.width;
				tab_exp.x = hide_tab_exp = stage.stageWidth;
				
				show_tab_feel = hide_tab_feel + (tab_feel.width-tabMargin);
				show_tab_exp = stage.stageWidth - (tab_exp.width-tabMargin);
				
				addChild(tab_exp);
				addChild(tab_feel);
				
				mode = Main.MODE_MAIN;
				
				tab_exp.addEventListener(MouseEvent.CLICK,click_exp);
				tab_feel.addEventListener(MouseEvent.CLICK,click_feel);
				
				tab_exp.buttonMode = tab_feel.buttonMode = true;
			}
		}
		
		public function set mode(value:String):void
		{
			if(_mode != value)
			{
				_mode = value;
				Tweener.removeTweens(tab_feel);
				Tweener.removeTweens(tab_exp);
				if(_mode == Main.MODE_FEEL_IT)
				{
					Tweener.addTween(tab_feel,{x:hide_tab_feel,time:0.5});
					Tweener.addTween(tab_exp,{x:show_tab_exp,time:0.5,delay:1.5});
				}
				else if(_mode == Main.MODE_EXPERIENCE)
				{
					Tweener.addTween(tab_feel,{x:show_tab_feel,time:0.5,delay:1.5});
					Tweener.addTween(tab_exp,{x:hide_tab_exp,time:0.5});
				}
				else if(_mode == Main.MODE_MAIN)
				{
					Tweener.addTween(tab_feel,{x:hide_tab_feel,time:0.5});
					Tweener.addTween(tab_exp,{x:hide_tab_exp,time:0.5});
				}
				flashStage.mode = value;
			}
		}
		
		public function get mode():String
		{
			return _mode;
		}
		
		private function click_exp(event:MouseEvent):void
		{
			mode = Main.MODE_EXPERIENCE;
		}
		
		private function click_feel(event:MouseEvent):void
		{
			mode = Main.MODE_FEEL_IT;
		}
		
	}
}