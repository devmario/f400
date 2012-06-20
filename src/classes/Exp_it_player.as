package classes
{
	import caurina.transitions.Tweener;
	
	import classes.exps.SwapButton;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;

	public class Exp_it_player extends Sprite
	{
		private var container:Sprite;
		private var containerMask:Shape;
		
		private var loader:Loader;
		private var content:MovieClip;
		private var _mode:String = Main.MODE_FEEL_IT;
		
		private var menu:Loader;
		private var menuContent:MovieClip;
		
		public var maskWidth:Number=0;
		
		public var loadedFrame:Number = 0;
		private var logoButton:Sprite;
		private var logo:Bitmap;
		private var title:Bitmap;
		
		private var playControl:SwapButton;
		private var soundControl:SwapButton;
		
		private var controlShape:Shape;
		private var bufferingShape:Shape;
		private var playShape:Shape;
		private var playButton:Shape;
		
		private var controlArea:Sprite;
		
		private var playBarWidth:Number = 830;
		
		private var _selectedIndex:int = 0;
		
		private var _isPlay:Boolean = true;
		
		private var exp_bgSound:Sound;
		
		private var sound_position:Number = 0;
		
		public var BGsoundTransform:SoundTransform;
		public var BGsoundChannel:SoundChannel;
		
		public var playBarRadius:Number = 2.5;
		
		private var fs:FlashStage;
		
		public function Exp_it_player(_fs:FlashStage)
		{
			super();
			fs = _fs;
			addEventListener(Event.ADDED_TO_STAGE,added);
		}
		
		private function added(event:Event):void
		{
			if(!container)
			{
				container = addChild(new Sprite()) as Sprite;
				container.graphics.beginFill(0x000000);
				container.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
				
				loader = container.addChild(new Loader()) as Loader;
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loaderComplete);
				loader.contentLoaderInfo.addEventListener(Event.INIT,loaderInit);
				loader.contentLoaderInfo.addEventListener(Event.OPEN,loaderOpen);
				loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS,loaderHTTP);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,loaderIO);
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,loaderProgress);
				logoButton = container.addChild(new Sprite()) as Sprite;
				logoButton.buttonMode = true;
				logo = logoButton.addChild(new Bitmap(Main.images._logo_exp,PixelSnapping.AUTO,true)) as Bitmap;
				title = container.addChild(new Bitmap(Main.images._title_exp,PixelSnapping.AUTO,true)) as Bitmap;
				
				logo.x = -16;
				logo.y = 361;
				
				title.x = 28;
				title.y = 435;
				title.alpha = 0.5;
				
				playControl = container.addChild(new SwapButton(Main.images._icon_play_exp,Main.images._icon_pause_exp)) as SwapButton;
				soundControl = container.addChild(new SwapButton(Main.images._sound_on,Main.images._sound_off)) as SwapButton;
				
				playControl.addEventListener(Event.CHANGE,playSwap);
				
				playControl.x = 29;
				playControl.y = 453;
				
				soundControl.x = 898;
				soundControl.y = 452;
				
				controlShape = container.addChild(new Shape()) as Shape;
				bufferingShape = container.addChild(new Shape()) as Shape;
				playShape = container.addChild(new Shape()) as Shape;
				playButton = container.addChild(new Shape()) as Shape;
				controlArea = container.addChild(new Sprite()) as Sprite;
				
				controlShape.graphics.beginFill(0x333333);
				controlShape.graphics.drawRect(0,0,playBarWidth,1);
				
				playButton.graphics.beginFill(0xF777D0);
				playButton.graphics.drawCircle(0,0,2.5);
				
				controlArea.x = playButton.x = playShape.x = bufferingShape.x = controlShape.x = 53;
				controlArea.y = playButton.y = playShape.y = bufferingShape.y = controlShape.y = 457;
				
				controlArea.buttonMode = true;
				
				menu = container.addChild(new Loader()) as Loader;
				menu.load(Images.menu_url);
				menu.contentLoaderInfo.addEventListener(Event.COMPLETE,menuLoadComplete);
				menu.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,menuIO);
				
				menu.x = 140;
				menu.y = 405;
				
				containerMask = addChild(new Shape()) as Shape;
				container.mask = containerMask;
				
				addEventListener(Event.ENTER_FRAME,onEnterFrame);
				
				controlArea.addEventListener(MouseEvent.MOUSE_DOWN,controlAreaDown);
				
				exp_bgSound = new Sound();
				BGsoundTransform = new SoundTransform(0);
				
				logoButton.addEventListener(MouseEvent.CLICK,goMain);
			}
		}
		
		private function goMain(event:MouseEvent):void
		{
			fs.mode = Main.MODE_MAIN;
		}
		
		private function playSwap(event:Event):void
		{
			if(content)
			{
				if(_isPlay)
				{
					content.stop();
					if(BGsoundChannel)
					{
						sound_position = BGsoundChannel.position;
						BGsoundChannel.stop();
					}
				}
				else
				{
					content.play();
					if(exp_bgSound)
					{
						BGsoundChannel = exp_bgSound.play(sound_position,int.MAX_VALUE,BGsoundTransform);
					}
				}
				_isPlay = !_isPlay;
			}
		}
		
		private function controlAreaDown(event:MouseEvent):void
		{
			if(content)
			{
				controlArea.addEventListener(Event.ENTER_FRAME,controlAreaMove);
				controlArea.addEventListener(MouseEvent.MOUSE_UP,controlAreaUp);
				stage.addEventListener(MouseEvent.MOUSE_UP,controlAreaUp);
				stage.addEventListener(Event.MOUSE_LEAVE,controlAreaUp);
			}
		}
		
		private function controlAreaUp(event:Event):void
		{
			if(content)
			{
				controlArea.removeEventListener(Event.ENTER_FRAME,controlAreaMove);
				controlArea.removeEventListener(MouseEvent.MOUSE_UP,controlAreaUp);
				stage.removeEventListener(MouseEvent.MOUSE_UP,controlAreaUp);
				stage.removeEventListener(Event.MOUSE_LEAVE,controlAreaUp);
				moveFrame();
			}
		}
		
		private function controlAreaMove(event:Event):void
		{
			if(content)
			{
				var frame:Number;
				if(controlArea.mouseX > 0 && controlArea.mouseX < controlArea.width)
				{
					frame = controlArea.mouseX/playBarWidth * content.totalFrames;
					frame = Math.round(frame);
					if(frame <= 0 )
					{
						frame = 1;
					}
					else if(frame >= content.framesLoaded-1)
					{
						frame = content.framesLoaded-1;
					}
				}
				else if(controlArea.mouseX <= 0)
				{
					frame = 1;
				}
				else if(controlArea.mouseX >= controlArea.width)
				{
					frame = content.framesLoaded-1;
				}
				if(_isPlay)
				{
					content.gotoAndPlay(frame);
				}
				else
				{
					content.gotoAndStop(frame);
				}
			}
		}
		
		private function moveFrame():void
		{
			if(content)
			{
				var frame:Number;
				if(controlArea.mouseX > 0 && controlArea.mouseX < controlArea.width)
				{
					frame = controlArea.mouseX/playBarWidth * content.totalFrames;
					frame = Math.round(frame);
					if(frame <= 0 )
					{
						frame = 1;
					}
					else if(frame >= content.framesLoaded-1)
					{
						frame = content.framesLoaded-1;
					}
				}
				else if(controlArea.mouseX <= 0)
				{
					frame = 1;
				}
				else if(controlArea.mouseX >= controlArea.width)
				{
					frame = content.framesLoaded-1;
				}
				if(_isPlay)
				{
					content.gotoAndPlay(frame);
				}
				else
				{
					content.gotoAndStop(frame);
				}
			}
		}
		
		public function set mode(value:String):void
		{
			if(value != _mode)
			{
				_mode = value;
				if(mode == Main.MODE_FEEL_IT || mode == Main.MODE_MAIN)
				{
					Tweener.addTween(this,{maskWidth:0,time:1.5,onUpdate:drawMask,onComplete:modeFeelComplete});
					if(content)
					{
						content.stop();
					}
					if(BGsoundChannel)
						BGsoundChannel.stop();
				}
				else if(mode == Main.MODE_EXPERIENCE)
				{
					Tweener.addTween(this,{maskWidth:-stage.stageWidth,time:1.5,onUpdate:drawMask,onComplete:modeExpComplete});
					if(!content)
					{
						_selectedIndex = 0;
						menuContent.selectedIndex = 0;
						_isPlay = true;
						if(BGsoundChannel)
							BGsoundChannel.stop();
						loader.load(Images.exp_url[_selectedIndex]);
						if(exp_bgSound.bytesLoaded < exp_bgSound.bytesTotal)
							exp_bgSound.close();
						exp_bgSound = null;
						playControl.selected = false;
						soundControl.selected = false;
						scO = true;
					}
				}
			}
		}
		
		private function fade():void
		{
			BGsoundChannel.soundTransform = BGsoundTransform;
		}
		
		public function get mode():String
		{
			return _mode;
		}
		
		private function modeExpComplete():void
		{
			if(content)
			{
				
			}
		}
		
		private function modeFeelComplete():void
		{
			try{
				content = null;
				loader.close();
				loader.unload();
				bufferingShape.graphics.clear();
				playShape.graphics.clear();
				controlArea.graphics.clear();
				playButton.x = 53;
			}
			catch(error:Error){}
		}
		
		private function drawMask():void
		{
			var g:Graphics = containerMask.graphics;
			containerMask.graphics.clear();
			g.beginFill(0x000000);
			g.drawRect(stage.stageWidth,0,maskWidth,stage.stageHeight);
		}
		
		private function loaderComplete(event:Event):void
		{
		}
		
		private function loaderInit(event:Event):void
		{
			content = loader.content as MovieClip;
			if(_isPlay)
			{
				content.play();
				
			}
			else
			{
				content.stop();
			}
		}
		
		private function loaderOpen(event:Event):void
		{
			
		}
		
		private function loaderHTTP(event:HTTPStatusEvent):void
		{
			
		}
		
		private function loaderIO(event:IOErrorEvent):void
		{
			
		}
		
		private function menuIO(event:IOErrorEvent):void
		{
			
		}
		
		private function loaderProgress(event:ProgressEvent):void
		{
			
		}
		
		private function menuLoadComplete(event:Event):void
		{
			menuContent = MovieClip(menu.content).content;
			menuContent.addEventListener(Event.CHANGE,selected);
		}
		
		private function selected(event:Event):void
		{
			if(_selectedIndex != menuContent.selectedIndex)
			{
				content.stop();
				content = null;
				loader.unload();
				bufferingShape.graphics.clear();
				playShape.graphics.clear();
				controlArea.graphics.clear();
				playButton.x = 53;
				_selectedIndex = menuContent.selectedIndex;
				loader.load(Images.exp_url[_selectedIndex]);
				if(exp_bgSound)
				{
					if(exp_bgSound.bytesLoaded < exp_bgSound.bytesTotal)
						exp_bgSound.close();
				}
				if(BGsoundChannel)
					BGsoundChannel.stop();
				if(_selectedIndex != 0){
					exp_bgSound = new Sound();
					exp_bgSound.load(Images.exp_bgSound_url[_selectedIndex]);
					BGsoundChannel = exp_bgSound.play(0,int.MAX_VALUE,BGsoundTransform);
				}else{
					exp_bgSound = null;
					scO = true;
				}
				
				
				
			}
		}
		private var scO:Boolean = true;
		private function onEnterFrame(event:Event):void
		{
			if(BGsoundTransform)
			{
				if(!soundControl.selected)
				{
					if(content)
					{
						if(_selectedIndex == 0 && content.currentFrame < 850)
						{
							if(content.currentFrame > (850-240))
							{
								BGsoundTransform.volume = 0.5 - (content.currentFrame - (850-240))/480;
							}
							else
							{
								BGsoundTransform.volume = 0.5;
							}
						}
						else
						{
							if(_selectedIndex == 0)
							{
								if(content.currentFrame < 850+120)
								{
									BGsoundTransform.volume = 1-(content.currentFrame - 850)/240;
								}
								else
								{
									BGsoundTransform.volume = 0.5;
								}
							}
							else
							{
								BGsoundTransform.volume = 0.5;
							}
						}
					}
					else
					{
						BGsoundTransform.volume = 0.5;
					}
				}
				else
				{
					BGsoundTransform.volume = 0;
				}
				if(BGsoundChannel)
					BGsoundChannel.soundTransform = BGsoundTransform;
			}
			
			if(content)
			{
				if(_selectedIndex == 0 && content.currentFrame > 850)
				{
					if(!scO)
					{
						scO = true;
						if(exp_bgSound)
						{
							if(exp_bgSound.bytesLoaded < exp_bgSound.bytesTotal)
								exp_bgSound.close();
							if(BGsoundChannel)
								BGsoundChannel.stop();
						}
						exp_bgSound = null;
						exp_bgSound = new Sound();
						exp_bgSound.load(Images.exp_bgSound_url[_selectedIndex]);
						BGsoundChannel = exp_bgSound.play(0,int.MAX_VALUE,BGsoundTransform);
					}
				}
				else if(_selectedIndex == 0 && content.currentFrame <= 850)
				{
					if(scO)
					{
						scO = false;
						if(exp_bgSound)
						{
							if(exp_bgSound.bytesLoaded < exp_bgSound.bytesTotal)
								exp_bgSound.close();
							if(BGsoundChannel)
								BGsoundChannel.stop();
						}
						exp_bgSound = null;
						exp_bgSound = new Sound();
						exp_bgSound.load(new URLRequest("music/bgm0.mp3"));
						BGsoundChannel = exp_bgSound.play(0,int.MAX_VALUE,BGsoundTransform);
					}
				}
				loadedFrame = content.framesLoaded / content.totalFrames;
				
				var bufferingX:Number = playBarWidth*loadedFrame;
				
				bufferingShape.graphics.clear();
				bufferingShape.graphics.beginFill(0x999999);
				bufferingShape.graphics.drawRect(0,0,bufferingX,1);
				
				var playCurrentX:Number = playBarWidth*(content.currentFrame/content.totalFrames);
				
				playShape.graphics.clear();
				playShape.graphics.beginFill(0xF777D0);
				playShape.graphics.drawRect(0,0,playCurrentX,1);
				
				playButton.x = controlShape.x+playCurrentX;
				
				controlArea.graphics.clear();
				controlArea.graphics.beginFill(0x000000,0);
				controlArea.graphics.drawRect(0,-10,bufferingX,20);
				
				if(content.currentFrame == content.totalFrames)
				{
					_selectedIndex++;
					if(_selectedIndex > 2)
					{
						_selectedIndex = 0;
					}
					menuContent.selectedIndex = _selectedIndex;
					content.stop();
					content = null;
					loader.unload();
					bufferingShape.graphics.clear();
					playShape.graphics.clear();
					controlArea.graphics.clear();
					playButton.x = 53;
					_selectedIndex = menuContent.selectedIndex;
					loader.load(Images.exp_url[_selectedIndex]);
					if(BGsoundChannel)
						BGsoundChannel.stop();
					if(exp_bgSound.bytesLoaded < exp_bgSound.bytesTotal)
						exp_bgSound.close();
					if(_selectedIndex != 0){
						exp_bgSound = new Sound();
						exp_bgSound.load(Images.exp_bgSound_url[_selectedIndex]);
						BGsoundChannel = exp_bgSound.play(0,int.MAX_VALUE,BGsoundTransform);
					}else{
						exp_bgSound = null;
						scO = true;
					}
				}
			}
		}
		
	}
}