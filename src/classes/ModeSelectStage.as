package classes
{
	import caurina.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;

	public class ModeSelectStage extends Sprite
	{
		public var feelItBG:Bitmap;
		
		private var _mode:String;
		
		public function ModeSelectStage()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,added);
		}
		
		private function added(event:Event):void
		{
			if(!feelItBG)
			{
				feelItBG = addChild(new Bitmap(Main.images._back,PixelSnapping.AUTO,true)) as Bitmap;
			
				mode = Main.MODE_MAIN;
			}
		}
		
		public function set mode(value:String):void
		{
			if(_mode != value)
			{
				_mode = value;
				if(_mode == Main.MODE_FEEL_IT || _mode == Main.MODE_MAIN)
				{
					Tweener.addTween(feelItBG,{alpha:1,time:1});
				}
				else if(_mode == Main.MODE_EXPERIENCE)
				{
					Tweener.addTween(feelItBG,{alpha:0,time:1});
				}
			}
		}
		
		public function get mode():String
		{
			return _mode;
		}
		
	}
}