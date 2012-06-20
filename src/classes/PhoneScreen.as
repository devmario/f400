package classes
{
	import caurina.transitions.Tweener;
	
	import classes.phone.ControlButtonPlay;
	import classes.phone.ListPhone;
	import classes.phone.PlayPhone;
	
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;

	public class PhoneScreen extends Sprite
	{		
		private var back:Bitmap;
		private var light:Bitmap;
		
		public var music:MusicControl;
		
		private var dir:String;
		private var urls:Array;
		private var urlsStrings:Array = ["runjustrun.mp3",
								         "22thspring.mp3",
								         "sentimentalism.mp3",
								         "southbeach.mp3",
								         "beforeyougo.mp3"];
								         
		public var playLength:Array = [66000,
								       50000,
								       110000,
								       36000,
								       35000];
		
		private var n:uint;
		
		public var lists:Array;
		
		public var _extraSelectedIndex:int = 0;
		
		public var playPhone:PlayPhone;
		
		public var slideX:Number = 0;
		private var sx:Number = 0;
		private var dx:Number = 0;
		
		private var _isPlayStatusMode:Boolean = false;
		
		private var originX:Array = [];
		
		public function PhoneScreen()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,added);
		}
		
		private function added(event:Event):void
		{
			if(!back)
			{
				back = addChild(new Bitmap(Main.images._ui01_back,PixelSnapping.AUTO,true)) as Bitmap;
				back.x = -back.width / 2;
				
				lists = [];
				urls = [];
				dir = "music/";
				
				for(n = 0;n < urlsStrings.length;n++)
				{
					urls.push(new URLRequest(dir + urlsStrings[n]));
					var list:ListPhone = addChild(new ListPhone(n)) as ListPhone;
					list.songText = urlsStrings[n].slice(0,urlsStrings[n].length-4);
					list.lengthText = MusicControl.milliToString(playLength[n]);
					list.x = -86;
					if(n != 0)
					{
						list.y = -67 + n * 25;
					}
					else
					{
						list.y = -67;
					}
					list.addEventListener(MouseEvent.MOUSE_OVER,mouseOverList);
					list.addEventListener(MouseEvent.MOUSE_OUT,mouseOutList);
					list.addEventListener(MouseEvent.CLICK,mouseClickList);
					lists[n] = list;
				}
				lists[0].selected = true;
				lists[0].isPlay = true;
				addEventListener(Event.ENTER_FRAME,onEnterFrame);
				
				music = new MusicControl(urls,this);
				
				
				playPhone = addChild(new PlayPhone()) as PlayPhone;
				
				light = addChild(new Bitmap(Main.images._ui01_light,PixelSnapping.AUTO,true)) as Bitmap;
				light.x = back.x;
				light.y = back.y = -back.height / 2;
				
				playPhone.x = back.x + back.width - 2;
				playPhone.y = back.y;
				
				originX[0] = back.x;
				for(n = 0;n < lists.length;n++){
					list = lists[n];
					originX[1+n] = list.x;
				}
				originX[lists.length + 1] = playPhone.x;
			}
		}
		
		private function mouseOverList(event:MouseEvent):void
		{
			var target:ListPhone = ListPhone(event.currentTarget);
			FlashStage.selectorss.selectedIndex = target.index;
			if(target.index != _extraSelectedIndex)
			{
				_extraSelectedIndex = target.index;
				for(n = 0;n < urlsStrings.length;n++)
				{
					var list:ListPhone = lists[n];
					if(list.selected)
					{
						list.selected = false;
					}
				}
				target.selected = true;
			}
		}
		
		private function mouseOutList(event:MouseEvent):void
		{
			alignList();
		}
		
		public function alignList():void
		{
			for(n = 0;n < urlsStrings.length;n++)
			{
				var list:ListPhone = lists[n];
				if(list.index == music.selectedIndex)
				{
					if(!list.isPlay)
						list.isPlay = true;
					if(!list.selected)
					{
						list.selected = true;
					}
					_extraSelectedIndex = list.index;
					FlashStage.selectorss.selectedIndex = list.index;
				}
				else
				{
					if(list.isPlay)
						list.isPlay = false;
					if(list.selected)
					{
						list.selected = false;
					}
				}
			}
		}
		
		private function mouseClickList(event:MouseEvent):void
		{
			var target:ListPhone = ListPhone(event.currentTarget);
			isPlayStatusMode = true;
			if(!music._isPlay || music.selectedIndex != target.index)
				music.selectedIndex = target.index;
			if(!target.isPlay)
				target.isPlay = true;
			Phone(parent).playMode = Phone.MODE_PLAY;
			playPhone.playButton.mode = ControlButtonPlay.MODE_PLAY;
		}
		
		private function onEnterFrame(event:Event):void
		{
			for(n = 1;n < urlsStrings.length;n++)
			{
				lists[n].y = lists[n-1].y + lists[n-1].graphicHeight;
			}
		}
		
		public function set isPlayStatusMode(value:Boolean):void
		{
			if(_isPlayStatusMode != value)
			{
				_isPlayStatusMode = value;
				if(_isPlayStatusMode)
				{
					Tweener.addTween(this,{slideX:-back.width,time:1,delay:0.5,onUpdate:slide});
				}
				else
				{
					Tweener.addTween(this,{slideX:0,time:1,onUpdate:slide});
				}
			}
		}
		
		public function get isPlayStatusMode():Boolean
		{
			return _isPlayStatusMode;
		}
		
		private function slide():void
		{
			back.x = originX[0] + slideX;
			for(n = 0;n < lists.length;n++){
				var list:ListPhone = lists[n];
				list.x = originX[1+n] + slideX;
			}
			playPhone.x = originX[lists.length + 1] + slideX;
		}
		
	}
}