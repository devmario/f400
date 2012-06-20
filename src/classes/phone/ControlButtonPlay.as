package classes.phone
{
	import caurina.transitions.Tweener;
	
	import classes.FlashStage;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;

	public class ControlButtonPlay extends ControlButton
	{
		public static const MODE_STOP:uint = 0;
		public static const MODE_PLAY:uint = 1;
		public static const MODE_PAUSE:uint = 2;
		
		public var pauseIcon:Bitmap;
		
		private var _mode:uint = ControlButtonPlay.MODE_STOP;
		
		private var _isLightControl:Boolean = true;
		
		public function ControlButtonPlay(playBitmapData:BitmapData,pauseBitmapData:BitmapData)
		{
			super(playBitmapData);
			
			pauseIcon = addChild(new Bitmap(pauseBitmapData,PixelSnapping.AUTO,true)) as Bitmap;
			pauseIcon.x = -pauseIcon.width/2;
			pauseIcon.y = -pauseIcon.height/2;
			
			pauseIcon.alpha = 0;
		}
		
				
		public function set mode(value:uint):void
		{
			if(value != _mode)
			{
				_mode = value;
				switch(_mode)
				{
					case ControlButtonPlay.MODE_STOP:
						Tweener.addTween(FlashStage.phone.wheel.play,{alpha:1,time:1});
						Tweener.addTween(icon,{alpha:1,time:1});
						Tweener.addTween(FlashStage.phone.wheel.pause,{alpha:0,time:1});
						Tweener.addTween(pauseIcon,{alpha:0,time:1}); 
						break;
					case ControlButtonPlay.MODE_PLAY:
						Tweener.addTween(FlashStage.phone.wheel.play,{alpha:0,time:1});
						Tweener.addTween(icon,{alpha:0,time:1});
						Tweener.addTween(FlashStage.phone.wheel.pause,{alpha:1,time:1});
						Tweener.addTween(pauseIcon,{alpha:1,time:1});
						break;
					case ControlButtonPlay.MODE_PAUSE:
						Tweener.addTween(FlashStage.phone.wheel.play,{alpha:1,time:1});
						Tweener.addTween(icon,{alpha:1,time:1});
						Tweener.addTween(FlashStage.phone.wheel.pause,{alpha:0,time:1});
						Tweener.addTween(pauseIcon,{alpha:0,time:1});
						break;
				}
			}
		}
		
		public function get mode():uint
		{
			return _mode;
		}
	}
}