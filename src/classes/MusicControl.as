package classes
{
	import caurina.transitions.Tweener;
	
	import classes.phone.ControlButtonPlay;
	import classes.phone.Wheel;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	public class MusicControl
	{
		private var n:int;
		
		private var sound:Sound;
		private var soundChannel:SoundChannel;
		public var soundTransform:SoundTransform;
		
		private var urls:Array;
		
		private var timer:Timer;
		
		private var soundBytes:ByteArray;
		private var _spectrum:Array;
		private var _maxSpectrum:Array;
		
		private var _selectedIndex:int = 0;
		private var _time:Date;
		private var _totalTime:Date;
		private var _playPer:Number;
		
		private var _songName:String;
		private var _artist:String;
		private var _album:String;
		
		public var _isPlay:Boolean = false;
		private var _isBuffering:Boolean;
		
		private var _position:Number = 0;
		
		private var phoneScreen:PhoneScreen;
		
		private var extra_totalLength:Number;
		private var extra_length:Number;
		
		public var EQ:Equalizer;
		
		
		public function MusicControl(_urls:Array,_phoneScreen:PhoneScreen)
		{
			super();
			phoneScreen = _phoneScreen;
			urls = _urls;
			config();
		}
		
		private function config():void
		{
			sound = new Sound();
			soundTransform = new SoundTransform(0.3);
			
			EQ = new Equalizer();
			
			timer = new Timer(1000/Main.FRAME_RATE);
			timer.addEventListener(TimerEvent.TIMER,onEnterFrame);
			timer.start();
			
			_spectrum = new Array(256);
			_maxSpectrum = new Array(256);
			
			soundConfig();
		}
		
		private function soundConfig():void
		{
			sound.addEventListener(Event.COMPLETE,soundComplete);
			sound.addEventListener(Event.ID3,soundID3);
			sound.addEventListener(Event.OPEN,soundOpen);
			sound.addEventListener(IOErrorEvent.IO_ERROR,soundIO_Error);
			sound.addEventListener(ProgressEvent.PROGRESS,soundProgress);
		}
		
		public function next():int
		{
			var _index:int = _selectedIndex + 1;
			if(_index > urls.length - 1)
			{
				_index = 0;
			}
			return pauseAndPlay(_index);
		}
		
		public function pre():int
		{
			Wheel.isSmallReverse = true;
			Wheel.isLargeReverse = true;
			var _index:int = _selectedIndex - 1;
			if(_index < 0)
			{
				_index = urls.length - 1;
			}
			return pauseAndPlay(_index);
		}
		
		public function pauseAndPlay(value:int = 0):int
		{
			EQ.mode = value;
			
			Phone(phoneScreen.parent).CDs.selectedIndex = value;
			Phone(phoneScreen.parent).phoneScreen.playPhone.list.selectedIndex = value;
			
			var returnMode:int;
			if(value != _selectedIndex)
			{
				if(sound)
				{
					//sound.close();
				}
				_selectedIndex = value;
				if(_isPlay)
				{
					soundChannel.stop();
				}
				
				_position = 0;
				
				extra_length = _position;
				extra_totalLength = NaN;
				
				sound = new Sound();
				soundConfig();
				sound.load(urls[_selectedIndex]);
				soundChannel = sound.play(_position,1,soundTransform);
				soundChannel.addEventListener(Event.SOUND_COMPLETE,soundChanelComplete);
				_isPlay = true;
				returnMode = ControlButtonPlay.MODE_PLAY;
			}
			else
			{
				if(soundChannel)
				{
					if(_isPlay)
					{
						_position = soundChannel.position;
						soundChannel.stop();
						returnMode = ControlButtonPlay.MODE_PAUSE;
					}
					else
					{
						soundChannel = sound.play(_position,1,soundTransform);
						soundChannel.addEventListener(Event.SOUND_COMPLETE,soundChanelComplete);
						returnMode = ControlButtonPlay.MODE_PLAY;
					}
					_isPlay = !_isPlay;
				}
				else
				{
					_position = 0;
					
					extra_length = _position;
					extra_totalLength = NaN;
					
					sound.load(urls[_selectedIndex]);
					soundChannel = sound.play(_position,1,soundTransform);
					soundChannel.addEventListener(Event.SOUND_COMPLETE,soundChanelComplete);
					_isPlay = true;
					returnMode = ControlButtonPlay.MODE_PLAY;
				}
			}
			phoneScreen.alignList();
			return returnMode;
		}
		
		public function stop():int
		{
			_isPlay = false;
			if(soundChannel)
				soundChannel.stop();
			_position = 0;
			phoneScreen.playPhone.length = "00:00";
			phoneScreen.playPhone.playBarSet = 0;
			phoneScreen.lists[selectedIndex].lengthText = milliToString(phoneScreen.playLength[selectedIndex]);
			return ControlButtonPlay.MODE_STOP;
		}
		
		public function set selectedIndex(value:int):void
		{
			_selectedIndex = -1;
			pauseAndPlay(value);
		}
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function set time(value:Date):void
		{
			
		}
		
		public function get time():Date
		{
			return _time;
		}
		
		public function get totalTime():Date
		{
			return _totalTime;
		}
		
		public function set playPer(value:Number):void
		{
			
		}
		
		public function get playPer():Number
		{
			return _playPer;
		}
		
		public function get songName():String
		{
			return songName;
		}
		
		public function get artist():String
		{
			return _artist;
		}
		
		public function get album():String
		{
			return _album;
		}
		
		public function set volume(value:Number):void
		{
			soundTransform.volume = value;
		}
		
		public function get volume():Number
		{
			return soundTransform.volume;
		}
		
		public function spectrum(value:int):Number
		{
			return _spectrum[value];
		}
		
		public function maxSpectrum(value:int):Number
		{
			return _maxSpectrum[value];
		}
		
		private function soundComplete(event:Event):void
		{
			extra_totalLength = sound.length;
			phoneScreen.playPhone.totalLength = milliToString(extra_totalLength);
		}
		
		public static function milliToString(value:Number):String
		{
			var totalTime:Number = value/1000;
			var m:String = Math.floor(totalTime/60).toString();
			var s:String = Math.floor(totalTime%60).toString();
			var sliceLength:int;
			var i:int;
			if(m.length<2)
			{
				sliceLength = 2 - m.length;
				for(i = 0;i < sliceLength;i++)
				{
					m = "0" + m;
				}
			}
			if(s.length<2)
			{
				sliceLength = 2 - s.length;
				for(i = 0;i < sliceLength;i++)
				{
					s = "0" + s;
				}
			}
			return m + ":" + s;
		}
		
		private function soundChanelComplete(event:Event):void
		{
			next();
			Phone(phoneScreen.parent).onceIncrease();
		}
		
		private function soundID3(event:Event):void
		{
			_album = sound.id3.album;
			phoneScreen.playPhone.artist = _artist = sound.id3.artist;
			phoneScreen.playPhone.songName = _songName = sound.id3.songName;
		}
		
		private function soundOpen(event:Event):void
		{
		}
		
		private function soundIO_Error(event:IOErrorEvent):void
		{
			
		}
		
		private function soundProgress(event:ProgressEvent):void
		{
		}
		
		private function onEnterFrame(event:TimerEvent):void
		{
			EQ.render();
			if(soundChannel && !isNaN(extra_totalLength))
			{
				extra_length = soundChannel.position;
				if(selectedIndex != -1 && _isPlay)
				{
					phoneScreen.playPhone.length = milliToString(extra_length);
					phoneScreen.playPhone.playBarSet = extra_length/extra_totalLength;
					phoneScreen.lists[selectedIndex].lengthText = milliToString(extra_totalLength - extra_length);
				}
			}
			else
			{
				phoneScreen.playPhone.length = "00:00";
				phoneScreen.playPhone.playBarSet = 0;
				for(n = 0;n < phoneScreen.lists.length;n++)
				{
					phoneScreen.lists[n].lengthText = milliToString(phoneScreen.playLength[n]);
				}
			}
			if(soundChannel)
			{
				soundChannel.soundTransform = soundTransform;
			}
		}
		
		public function _volume(value:Number):void
		{
			Tweener.addTween(soundTransform,{volume:value,time:1,transition:"linear"});
		}
		
	}
}