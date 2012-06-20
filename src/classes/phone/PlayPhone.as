package classes.phone
{
	import classes.Phone;
	import classes.PhoneScreen;
	
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class PlayPhone extends Sprite
	{
		private var back:Bitmap;
		
		private var listUp:Bitmap;
		public var list:CDsmallList;
		private var listMask:Shape;
		
		private var playBar:Shape;
		private var playBarColor:Number = 0xFCFE34;
		private var bufferingBar:Shape;
		private var bufferingBarColor:Number = 0xFCFE34;
		
		public var listButton:ControlButton;
		public var playButton:ControlButtonPlay;
		public var prevButton:ControlButton;
		public var nextButton:ControlButton;
		public var stopButton:ControlButton;
		
		private var _songNameText:TextField;
		private var _artistText:TextField;
		private var _lengthText:TextField;
		private var _totalLengthText:TextField;
		
		private var _textFormat:TextFormat;
		
		public function PlayPhone()
		{
			super();
			
			back = addChild(new Bitmap(Main.images._ui02_back,PixelSnapping.AUTO,true)) as Bitmap;
			bufferingBar = addChild(new Shape()) as Shape;
			playBar = addChild(new Shape()) as Shape;
			bufferingBar.x = playBar.x = 17;
			bufferingBar.y = playBar.y = 163;
			
			listButton = addChild(new ControlButton(Main.images._icon_list)) as ControlButton;
			playButton = addChild(new ControlButtonPlay(Main.images._icon_play,Main.images._icon_pause)) as ControlButtonPlay;
			prevButton = addChild(new ControlButton(Main.images._icon_prev)) as ControlButton;
			nextButton = addChild(new ControlButton(Main.images._icon_next)) as ControlButton;
			stopButton = addChild(new ControlButton(Main.images._icon_stop)) as ControlButton;
			
			stopButton.x = playButton.x = listButton.x = 82+5;
			prevButton.x = 61+5;
			nextButton.x = 97+10;
			listButton.y = 170+10
			prevButton.y = nextButton.y = playButton.y = 185+10;
			stopButton.y = 200+10;
			
			listButton.addEventListener(MouseEvent.CLICK,listClick);
			stopButton.addEventListener(MouseEvent.CLICK,stopClick);
			prevButton.addEventListener(MouseEvent.CLICK,prevClick);
			nextButton.addEventListener(MouseEvent.CLICK,nextClick);
			playButton.addEventListener(MouseEvent.CLICK,playClick);
			
			_songNameText = addChild(new TextField()) as TextField;
			_artistText = addChild(new TextField()) as TextField;
			_lengthText = addChild(new TextField()) as TextField;
			_totalLengthText = addChild(new TextField()) as TextField;
			
			list = addChild(new CDsmallList()) as CDsmallList;
			listMask = addChild(new Shape()) as Shape;
			listUp = addChild(new Bitmap(Main.images._list_up,PixelSnapping.AUTO,true)) as Bitmap;
			
			listMask.graphics.beginFill(0);
			listMask.graphics.drawRect(0,0,67,67);
			list.mask = listMask;
			
			listMask.x = list.x = listUp.x = 53;
			listMask.y = list.y = listUp.y = 30;
			
			_songNameText.autoSize = _artistText.autoSize = _lengthText.autoSize = TextFieldAutoSize.LEFT;
			_totalLengthText.autoSize = TextFieldAutoSize.RIGHT;
			
			_songNameText.selectable = _artistText.selectable = _lengthText.selectable = _totalLengthText.selectable = false;
			
			_artistText.alpha = 0.3;
			_totalLengthText.alpha = 0.1;
			
			_artistText.x = _songNameText.x = 4;
			_songNameText.y = 117;
			_artistText.y = 132;
			_lengthText.x = 6;
			_totalLengthText.y = _lengthText.y = 168;
			_totalLengthText.x = 164;
			
			_textFormat = new TextFormat("samsungGB");
			
			var upNoClick:Sprite = new Sprite();
			addChild(upNoClick);
			upNoClick.graphics.beginFill(0,0);
			upNoClick.graphics.drawRect(0,0,width,height);
		}
		
		public function set playBarSet(value:Number):void
		{
			playBar.graphics.clear();
			playBar.graphics.beginFill(0xE5F650);
			playBar.graphics.drawRect(0,0,150*value,4);
			playBar.graphics.endFill();
		}
		
		public function set songName(value:String):void
		{
			if(value != _songNameText.text)
			{
				_songNameText.text = value;
				_songNameText.embedFonts = true;
				
				_textFormat.size = 13;
				_textFormat.color = 0xFFFFFF;
				
				_songNameText.setTextFormat(_textFormat);
			}
		}
		
		public function get songName():String
		{
			return _songNameText.text;
		}
		
		public function set artist(value:String):void
		{
			if(value != _artistText.text)
			{
				_artistText.text = value;
				_artistText.embedFonts = true;
				
				_textFormat.size = 11;
				_textFormat.color = 0xFFFFFF;
				
				_artistText.setTextFormat(_textFormat);
			}
		}
		
		public function get artist():String
		{
			return _artistText.text;
		}
		
		public function set length(value:String):void
		{
			if(value != _lengthText.text)
			{
				_lengthText.text = value;
				_lengthText.embedFonts = true;
				
				_textFormat.size = 13;
				_textFormat.color = 0xF0F858;
				
				_lengthText.setTextFormat(_textFormat);
			}
		}
		
		public function get length():String
		{
			return _lengthText.text;
		}
		
		public function set totalLength(value:String):void
		{
			if(value != _totalLengthText.text)
			{
				_totalLengthText.text = value;
				_totalLengthText.embedFonts = true;
				
				_textFormat.size = 13;
				_textFormat.color = 0xFFFFFF;
				
				_totalLengthText.setTextFormat(_textFormat);
			}
		}
		
		public function get totalLength():String
		{
			return _totalLengthText.text;
		}
		
		private function listClick(event:MouseEvent):void
		{
			Phone(parent.parent).playMode = Phone.MODE_LIST;
			PhoneScreen(parent).isPlayStatusMode = false;
		}
		
		private function stopClick(event:MouseEvent):void
		{
			playButton.mode = PhoneScreen(parent).music.stop();
		}
		
		private function prevClick(event:MouseEvent):void
		{
			Phone(parent.parent).onceIncrease();
			playButton.mode = PhoneScreen(parent).music.pre();
		}
		
		private function nextClick(event:MouseEvent):void
		{
			Phone(parent.parent).onceIncrease();
			playButton.mode = PhoneScreen(parent).music.next();
		}
		
		private function playClick(event:MouseEvent):void
		{
			playButton.mode = PhoneScreen(parent).music.pauseAndPlay(PhoneScreen(parent).music.selectedIndex);
		}
		
	}
}