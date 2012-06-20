package classes.phone
{
	import caurina.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class ListPhone extends Sprite
	{
		private var container:Sprite;
		private var containerMask:Shape;
		
		private var buttonArea:Sprite;
		
		private var songName:TextField;
		public var playLength:TextField;
		
		private var songNameFormat:TextFormat;
		private var playLengthFormat:TextFormat;
		
		private var graphicSelectAlpha:Number = 1;
		private var graphicSelectHeight:Number = 52;
		private var graphicDeSelectAlpha:Number = 0;
		private var graphicDeSelectHeight:Number = 26;
		
		public var graphicAlpha:Number = graphicDeSelectAlpha;
		public var graphicHeight:Number = graphicDeSelectHeight;
		
		private var _selected:Boolean = false;
		
		public var index:int;
		
		private var rSelected:Number = 0xE0;
		private var gSelected:Number = 0xF4;
		private var bSelected:Number = 0x50;
		
		private var rDeSelected:Number = 0xFF;
		private var gDeSelected:Number = 0xFF;
		private var bDeSelected:Number = 0xFF;
		
		public var r:Number = rDeSelected;
		public var g:Number = gDeSelected;
		public var b:Number = bDeSelected;
		
		private var colorTransform:ColorTransform;
		
		public var icon:Bitmap;
		
		private var _isPlay:Boolean = false;
		
		public function ListPhone(_index:int)
		{
			super();
			
			buttonMode = true;
			
			index = _index;
			
			container = addChild(new Sprite()) as Sprite;
			containerMask = addChild(new Shape()) as Shape;
			container.mask = containerMask;
			
			songName = container.addChild(new TextField()) as TextField;
			songName.y = 5;
			
			playLength = container.addChild(new TextField()) as TextField;
			
			playLength.selectable = songName.selectable = false;
			playLength.autoSize = songName.autoSize = TextFieldAutoSize.LEFT;
			
			songNameFormat = new TextFormat("samsungGB",13,0xFFFFFF);
			playLengthFormat = new TextFormat("samsungPTB",11,0xFFFFFF);
			
			icon = container.addChild(new Bitmap(Main.images._icon_lock.clone(),PixelSnapping.AUTO,true)) as Bitmap;
			icon.x = 147;
			icon.y = graphicDeSelectHeight;
			
			songName.x = playLength.x = 5;
			
			colorTransform = new ColorTransform();
			
			buttonArea = addChild(new Sprite()) as Sprite;
			
			draw();
		}
		
		public function set songText(value:String):void
		{
			songName.text = value;
			songName.embedFonts = true;
			songName.setTextFormat(songNameFormat);
			align();
		}
		
		public function get songText():String
		{
			return songName.text;
		}
		
		public function set lengthText(value:String):void
		{
			playLength.text = value;
			playLength.embedFonts = true;
			playLength.setTextFormat(playLengthFormat);
		}
		
		public function get lengthText():String
		{
			return playLength.text;
		}
		
		private function align():void
		{
			playLength.y = 27;
			draw();
		}
		
		public function set selected(value:Boolean):void
		{
			if(value != _selected)
			{
				_selected = value;
				if(_selected)
				{
					Tweener.addTween(playLength,{y:graphicDeSelectHeight+2,time:0.5});
					Tweener.addTween(this,{graphicHeight:graphicSelectHeight,time:0.5});
					Tweener.addTween(this,{graphicAlpha:graphicSelectAlpha,time:0.5,onUpdate:draw});
				}
				else
				{
					Tweener.addTween(playLength,{y:graphicSelectHeight+2,time:0.5});
					Tweener.addTween(this,{graphicHeight:graphicDeSelectHeight,time:0.5});
					Tweener.addTween(this,{graphicAlpha:graphicDeSelectAlpha,time:0.5,onUpdate:draw});
				}
			}
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set isPlay(value:Boolean):void
		{
			if(_isPlay != value)
			{
				_isPlay = value;
				if(_isPlay)
				{
					Tweener.addTween(this,{r:rSelected,time:0.5});
					Tweener.addTween(this,{g:gSelected,time:0.5});
					Tweener.addTween(this,{b:bSelected,time:0.5,onUpdate:colorRGB});
				}
				else
				{
					Tweener.addTween(this,{r:rDeSelected,time:0.5});
					Tweener.addTween(this,{g:gDeSelected,time:0.5});
					Tweener.addTween(this,{b:bDeSelected,time:0.5,onUpdate:colorRGB});
				}
			}
		}
		
		public function get isPlay():Boolean
		{
			return _isPlay;
		}
		
		private function draw():void
		{
			container.graphics.clear();
			container.graphics.beginFill(0x551339,graphicAlpha);
			container.graphics.drawRect(0,0,167,graphicHeight);
			container.graphics.endFill();
			
			containerMask.graphics.clear();
			containerMask.graphics.beginFill(0x000000);
			containerMask.graphics.drawRect(0,0,167,graphicHeight);
			containerMask.graphics.endFill();
			
			buttonArea.graphics.clear();
			buttonArea.graphics.beginFill(0x000000,0);
			buttonArea.graphics.drawRect(0,0,167,graphicHeight);
			buttonArea.graphics.endFill();
			
			icon.y = playLength.y + 2;
		}
		
		private function colorRGB():void
		{
			colorTransform.color = r<<16 | g<<8 | b;
			songName.transform.colorTransform = colorTransform;
			playLength.transform.colorTransform = colorTransform;
		}

	}
}