package classes
{
	import caurina.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;

	public class FirstBornF400 extends Sprite
	{
		public var arrowButton_left:Sprite;
		public var left_glow:GlowFilter;
		
		public var feel_txt:Bitmap;
		public var feel_description:Bitmap;
		
		public var arrowButton_right:Sprite;
		public var right_glow:GlowFilter;
		
		public var exp_txt:Bitmap;
		public var exp_description:Bitmap;
		
		public var left_form:Sprite;
		public var right_form:Sprite;
		
		public var leftArrow:Bitmap;
		public var rightArrow:Bitmap;
		
		public var marginX:Number = 27;
		public var marginY:Number = 16;
		
		public var formX:Number = 112;
		private var _fs:FlashStage;
		public function FirstBornF400(fs:FlashStage)
		{
			super();
			_fs = fs;
			addEventListener(Event.ADDED,added);
		}
		
		private function added(event:Event):void
		{
			x = stage.stageWidth/2;
			y = stage.stageHeight/2;
			
			removeEventListener(Event.ADDED,added);
			
			left_form = addChild(new Sprite()) as Sprite;
			right_form = addChild(new Sprite()) as Sprite;
			
			feel_txt = left_form.addChild(new Bitmap(Main.images._gnb_txt_feel_it,PixelSnapping.AUTO,true)) as Bitmap;
			feel_description = left_form.addChild(new Bitmap(Main.images._gnb_txt_feel_it_description,PixelSnapping.AUTO,true)) as Bitmap;
			
			exp_txt = right_form.addChild(new Bitmap(Main.images._gnb_txt_exp_it,PixelSnapping.AUTO,true)) as Bitmap;
			exp_description = right_form.addChild(new Bitmap(Main.images._gnb_txt_exp_it_description,PixelSnapping.AUTO,true)) as Bitmap;
			
			arrowButton_left = left_form.addChild(new Sprite()) as Sprite;
			arrowButton_right = right_form.addChild(new Sprite()) as Sprite;
			
			leftArrow = arrowButton_left.addChild(new Bitmap(Main.images._arrow,PixelSnapping.AUTO,true)) as Bitmap;
			rightArrow = arrowButton_right.addChild(new Bitmap(Main.images._arrow,PixelSnapping.AUTO,true)) as Bitmap;
			
			left_glow = new GlowFilter(0xFB75CA,0,10,10);
			right_glow = new GlowFilter(0xFB75CA,0,10,10);
			
			left_form.x = -formX;
			right_form.x = formX;
			
			leftArrow.x = -leftArrow.width/2;
			leftArrow.y = -leftArrow.height/2;
			
			rightArrow.x = -rightArrow.width/2;
			rightArrow.y = -rightArrow.height/2;
			
			leftArrow.alpha = rightArrow.alpha = 0;
			
			arrowButton_left.rotation = 90;
			arrowButton_right.rotation = -90;
			
			Tweener.addTween(leftArrow,{alpha:1,time:1,transition:"linear"});
			Tweener.addTween(rightArrow,{alpha:1,time:1,transition:"linear"});
			
			feel_txt.x = -stage.stageWidth;
			feel_txt.y = -marginY;
			Tweener.addTween(feel_txt,{x:-feel_txt.width - marginX,time:1});
			
			feel_description.x = -stage.stageWidth;
			feel_description.y = feel_txt.y + feel_txt.height;
			Tweener.addTween(feel_description,{x:-feel_description.width - marginX,time:1});
			
			exp_txt.x = stage.stageWidth;
			exp_txt.y = -marginY;
			Tweener.addTween(exp_txt,{x:marginX,time:1});
			
			exp_description.x = stage.stageWidth;
			exp_description.y = exp_txt.y + exp_txt.height;
			Tweener.addTween(exp_description,{x:marginX,time:1});
			
			arrowButton_left.addEventListener(MouseEvent.CLICK,leftClick);
			arrowButton_right.addEventListener(MouseEvent.CLICK,rightClick);
			arrowButton_right.buttonMode = arrowButton_left.buttonMode = true;
		}
		
		private function leftClick(event:MouseEvent):void
		{
			_fs.mode = Main.MODE_FEEL_IT;
		}
		
		private function rightClick(event:MouseEvent):void
		{
			_fs.mode = Main.MODE_EXPERIENCE;
		}
		
		private var _mode:String;
		
		public function set mode(value:String):void
		{
			if(_mode != value)
			{
				_mode = value;
				if(_mode == Main.MODE_MAIN)
				{
					Tweener.addTween(left_form,{x:-formX,time:1});
					Tweener.addTween(right_form,{x:formX,time:1});
				}
				else
				{
					Tweener.addTween(left_form,{x:-formX-stage.stageWidth,time:1});
					Tweener.addTween(right_form,{x:formX+stage.stageWidth,time:1});
				}
				
				
			}
		}
		
		
		
	}
}