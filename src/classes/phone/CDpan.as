package classes.phone
{
	import caurina.transitions.Tweener;
	
	import classes.Phone;
	
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.Sprite;

	public class CDpan extends Sprite
	{
		private var n:int;
		
		private var phone:Phone;
		
		
		
		public var container:Sprite;
		private var containerMask:Shape;
		
		public var CDs:Array;
		public var CDs_bitmap:Array;
		
		
		
		public var reverse_container:Sprite;
		private var reverse_containerMask:Shape;
		
		public var reverse_CDs:Array;
		public var reverse_CDs_bitmap:Array;
		
		
		
		public var radius:Number = 500;
		
		public var theta:Number = 0;
		
		private var _selectedIndex:int = -1;
		private var length:int;
		
		private var _play:Boolean = false;
		
		private var radian:Number = Math.PI * 2;
		
		private var rollIndex:int = 0;
		
		
		public var _selectedItem:Sprite;
		
		public var _selectedReverse:Boolean = false;
		
		public function CDpan(_phone:Phone)
		{
			super();
			
			phone = _phone;
			
			container = addChild(new Sprite()) as Sprite;
			containerMask = addChild(new Shape()) as Shape;
			
			containerMask.graphics.beginFill(0);
			containerMask.graphics.drawRect(0,-radius*2,radius*2,radius*4);
			containerMask.graphics.endFill();
			
			container.mask = containerMask;
			
			CDs = [];
			CDs_bitmap = [];
			
			reverse_container = addChild(new Sprite()) as Sprite;
			reverse_containerMask = addChild(new Shape()) as Shape;
			
			reverse_containerMask.graphics.beginFill(0);
			reverse_containerMask.graphics.drawRect(-radius*2,-radius*2,radius*2,radius*4);
			reverse_containerMask.graphics.endFill();
			
			reverse_container.mask = reverse_containerMask;
			
			reverse_CDs = [];
			reverse_CDs_bitmap = [];
			
			for(n = 0;n < 5;n++)
			{
				CDs[n] = null;
				reverse_CDs[n] = null;
			}
		}
		
		public function set selectedIndex(value:int):void
		{
			var isReverse:Boolean = Wheel.isLargeReverse;
			Wheel.isLargeReverse = false;
			if(_selectedIndex != value)
			{
				if(_selectedItem)
				{
					Tweener.removeTweens(_selectedItem);
					Tweener.addTween(_selectedItem,{rotation:_selectedReverse ? -120 : 120,time:0.5,onComplete:delThis,onCompleteParams:[_selectedIndex,_selectedReverse]});
				}
				_selectedReverse = isReverse;
				_selectedIndex = value;
				madeThis(value,isReverse);
				if(isReverse)
				{
					reverse_CDs[value].rotation = 20;
				}
				else
				{
					CDs[value].rotation = -20;
				}
				Tweener.addTween(isReverse ? reverse_CDs[value] : CDs[value],{rotation:isReverse ? -55 : 55,time:1});
				Tweener.addTween(isReverse ? reverse_CDs[value] : CDs[value],{rotation:isReverse ? -95 : 95,time:1,delay:2.5});
				Tweener.addTween(isReverse ? reverse_CDs_bitmap[value] : CDs_bitmap[value],{rotation:isReverse ? -360*2 : 360*2,time:2.5,delay:1,transition:"easeInCubic"});
				_selectedItem = isReverse ? reverse_CDs[value] : CDs[value];
			}
		}
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		private function madeThis(_index:int,_isReverse:Boolean):void
		{
			var bitmap:Bitmap;
			if(_isReverse)
			{
				if(reverse_CDs[_index])
				{
					delThis(_index,_isReverse);
				}
				reverse_CDs[_index] = reverse_container.addChild(new Sprite()) as Sprite;
				reverse_CDs_bitmap[_index] = reverse_CDs[_index].addChild(new Sprite()) as Sprite;
				bitmap = reverse_CDs_bitmap[_index].addChild(new Bitmap(Main.images.cd(_index),PixelSnapping.AUTO,true)) as Bitmap;
				reverse_CDs_bitmap[_index].x = -radius;
				reverse_CDs_bitmap[_index].y = 0;
				bitmap.x = -bitmap.width/2;
				bitmap.y = -bitmap.height/2;
			}
			else
			{
				if(CDs[_index])
				{
					delThis(_index,_isReverse);
				}
				CDs[_index] = container.addChild(new Sprite()) as Sprite;
				CDs_bitmap[_index] = CDs[_index].addChild(new Sprite()) as Sprite;
				bitmap = CDs_bitmap[_index].addChild(new Bitmap(Main.images.cd(_index),PixelSnapping.AUTO,true)) as Bitmap;
				CDs_bitmap[_index].x = radius;
				CDs_bitmap[_index].y = 0;
				bitmap.x = -bitmap.width/2;
				bitmap.y = -bitmap.height/2;
			}
		}
		
		private function delThis(_index:int,_isReverse:Boolean):void
		{
			if(_index == -1)
				return;
			if(_isReverse)
			{
				if(reverse_CDs[_index])
				{
					Tweener.removeTweens(reverse_CDs[_index]);
					Tweener.removeTweens(reverse_CDs_bitmap[_index]);
					reverse_container.removeChild(reverse_CDs[_index]);
					reverse_CDs[_index].removeChild(reverse_CDs_bitmap[_index]);
					reverse_CDs[_index] = null;
					reverse_CDs_bitmap[_index] = null;
				}
			}
			else
			{
				if(CDs[_index])
				{
					Tweener.removeTweens(CDs[_index]);
					Tweener.removeTweens(CDs_bitmap[_index]);
					container.removeChild(CDs[_index]);
					CDs[_index].removeChild(CDs_bitmap[_index]);
					CDs[_index] = null;
					CDs_bitmap[_index] = null;
				}
			}
		}
		
	}
}