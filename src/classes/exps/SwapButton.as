package classes.exps
{
	import caurina.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class SwapButton extends Sprite
	{
		public var symbol:Bitmap;
		public var unSymbol:Bitmap;
		
		private var _selected:Boolean = false;
		
		public function SwapButton(_selectedSymbol:BitmapData,_unSelectedSymbol:BitmapData)
		{
			super();
			
			buttonMode = true;
			
			unSymbol = addChild(new Bitmap(_unSelectedSymbol,PixelSnapping.AUTO,true)) as Bitmap;
			symbol = addChild(new Bitmap(_selectedSymbol,PixelSnapping.AUTO,true)) as Bitmap;
			
			symbol.alpha = 0;
			
			addEventListener(MouseEvent.CLICK,click);
		}
		
		public function set selected(value:Boolean):void
		{
			if(_selected != value)
			{
				_selected = value;
				
				Tweener.removeTweens(symbol);
				Tweener.removeTweens(unSymbol);
				
				if(_selected)
				{
					Tweener.addTween(symbol,{alpha:1,time:0.5});
					Tweener.addTween(unSymbol,{alpha:0,time:0.5});
				}
				else
				{
					Tweener.addTween(symbol,{alpha:0,time:0.5});
					Tweener.addTween(unSymbol,{alpha:1,time:0.5});
				}
			}
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		private function click(event:MouseEvent):void
		{
			selected = !selected;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
	}
}