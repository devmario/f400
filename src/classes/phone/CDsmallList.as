package classes.phone
{
	import caurina.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;

	public class CDsmallList extends Sprite
	{
		public var cds:Array;
		
		private var n:int;
		
		public var _selectedIndex:int = -1;
		
		public var _selectedItem:Sprite;
		
		public function CDsmallList()
		{
			super();
			
			cds = [];
			
			for(n = 0;n < 5;n++)
			{
				cds[n] = null;
			}
		}
		
		public function set selectedIndex(value:int):void
		{
			var isReverse:Boolean = Wheel.isSmallReverse;
			Wheel.isSmallReverse = false;
			if(_selectedIndex != value)
			{
				if(_selectedItem)
				{
					Tweener.removeTweens(_selectedItem);
					Tweener.addTween(_selectedItem,{x:isReverse ? 67 + 67/2 : -67/2,time:0.5,onComplete:delThis,onCompleteParams:[_selectedIndex]});
				}
				_selectedIndex = value;
				madeThis(value);
				cds[value].x = isReverse ? -67/2 : 67 + 67/2;
				cds[value].rotation = 0;
				Tweener.addTween(cds[value],{x:67/2,time:1,delay:2.5});
				Tweener.addTween(cds[value],{rotation:isReverse ? -3360*2 : 360*2,time:1,delay:2.5});
				_selectedItem = cds[value];
			}
		}
		
		private function delThis(_index:int):void
		{
			if(_index == -1)
				return;
			if(cds[_index])
			{
				Tweener.removeTweens(cds[_index]);
				removeChild(cds[_index]);
				cds[_index] = null;
			}
		}
		
		private function madeThis(_index:int):void
		{
			if(cds[_index])
			{
				delThis(_index);
			}
			cds[_index] = addChild(new Sprite()) as Sprite;
			var bitmap:Bitmap = cds[_index].addChild(new Bitmap(Main.images.cdSmall(_index),PixelSnapping.AUTO,true)) as Bitmap;
			bitmap.scaleX = bitmap.scaleY = 1.4;
			bitmap.x = -bitmap.width/2;
			bitmap.y = -bitmap.height/2;
			cds[_index].y = 67/2;
		}
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
	}
}