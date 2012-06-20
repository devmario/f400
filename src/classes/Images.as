package classes
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.net.URLRequest;
	
	public class Images
	{
		public static var exp_url:Array = [new URLRequest("expit_music.swf")
										  ,new URLRequest("expit_camera.swf")
										  ,new URLRequest("expit_internet.swf")];
		
		public static var exp_bgSound_url:Array = [new URLRequest("music/bgm1.mp3")
										  		  ,new URLRequest("music/bgm2.mp3")
										  		  ,new URLRequest("music/bgm3.mp3")];
										  
		public static var menu_url:URLRequest = new URLRequest("menu.swf");
		
		[Embed(source="../../asset/feelit.swf",symbol="back")]
		private var back:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="logo")]
		private var logo:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="logo_shadow")]
		private var logo_shadow:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="tab_exp")]
		private var tab_exp:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="tab_feel")]
		private var tab_feel:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="balloon")]
		private var balloon:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="phone_front")]
		private var phone_front:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="ui01_back")]
		private var ui01_back:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="ui01_light")]
		private var ui01_light:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="icon_lock")]
		private var icon_lock:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="ui02_back")]
		private var ui02_back:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="icon_list")]
		private var icon_list:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="icon_play")]
		private var icon_play:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="icon_prev")]
		private var icon_prev:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="icon_next")]
		private var icon_next:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="icon_pause")]
		private var icon_pause:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="icon_stop")]
		private var icon_stop:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="qcd_01")]
		private var cd_01:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="qcd_02")]
		private var cd_02:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="qcd_03")]
		private var cd_03:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="qcd_04")]
		private var cd_04:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="qcd_05")]
		private var cd_05:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="earphone_front")]
		private var earphone_front:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="speaker_front")]
		private var speaker_front:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="speaker_front_")]
		private var speaker_front_:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="txt_Slide-it-down")]
		private var txt_Slide_it_down:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="arrow")]
		private var arrow:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="list_up")]
		private var list_up:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="qsmall_cd_01")]
		private var small_cd_01:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="qsmall_cd_02")]
		private var small_cd_02:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="qsmall_cd_03")]
		private var small_cd_03:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="qsmall_cd_04")]
		private var small_cd_04:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="qsmall_cd_05")]
		private var small_cd_05:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="cdm1")]
		private var cdm1:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="cdm2")]
		private var cdm2:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="cdm3")]
		private var cdm3:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="cdm4")] 
		private var cdm4:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="cdm5")]
		private var cdm5:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="icon_pause_exp")]
		private var icon_pause_exp:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="icon_play_exp")]
		private var icon_play_exp:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="logo_exp")]
		private var logo_exp:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="sound_off")]
		private var sound_off:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="sound_on")]
		private var sound_on:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="title_exp")]
		private var title_exp:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="wheel")]
		private var wheel:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="gnb_txt_feel_it_description")]
		private var gnb_txt_feel_it_description:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="gnb_txt_feel_it")]
		private var gnb_txt_feel_it:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="gnb_txt_exp_it_description")]
		private var gnb_txt_exp_it_description:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="gnb_txt_exp_it")]
		private var gnb_txt_exp_it:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="mainSH")]
		private var mainSH:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="listBT")]
		private var listBT:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="big_shadow")]
		private var big_shadow:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="sliderLine")]
		private var sliderLine:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="sliderThumb")]
		private var sliderThumb:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="qqqear")]
		private var qqqear:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="qqqear_left")]
		private var qqqear_left:Class;
		
		[Embed(source="../../asset/feelit.swf",symbol="qqqear_right")]
		private var qqqear_right:Class;
		
		private var images:Array;
		
		private var imagesIndex:String;
		private var displayObject:DisplayObject;
		private var bitmapData:BitmapData;
		
		public function Images()
		{
			super();
			
			images = new Array();
			
			images["back"] = new back(); 
			images["logo"] = new logo();
			images["logo_shadow"] = new logo_shadow();
			images["tab_exp"] = new tab_exp();
			images["tab_feel"] = new tab_feel();
			images["balloon"] = new balloon();
			images["phone_front"] = new phone_front();
			images["ui01_back"] = new ui01_back();
			images["ui01_light"] = new ui01_light();
			images["icon_lock"] = new icon_lock();
			images["ui02_back"] = new ui02_back();
			images["icon_list"] = new icon_list();
			images["icon_play"] = new icon_play();
			images["icon_prev"] = new icon_prev();
			images["icon_next"] = new icon_next();
			images["icon_pause"] = new icon_pause();
			images["icon_stop"] = new icon_stop();
			images["cd_01"] = new cd_01();
			images["cd_02"] = new cd_02();
			images["cd_03"] = new cd_03();
			images["cd_04"] = new cd_04();
			images["cd_05"] = new cd_05();
			images["earphone_front"] = new earphone_front(); 
			images["speaker_front"] = new speaker_front(); 
			images["speaker_front_"] = new speaker_front_(); 
			images["txt_Slide_it_down"] = new txt_Slide_it_down();
			images["arrow"] = new arrow();
			images["list_up"] = new list_up();
			images["small_cd_01"] = new small_cd_01();
			images["small_cd_02"] = new small_cd_02();
			images["small_cd_03"] = new small_cd_03();
			images["small_cd_04"] = new small_cd_04();
			images["small_cd_05"] = new small_cd_05();
			images["cdm1"] = new cdm1();
			images["cdm2"] = new cdm2();
			images["cdm3"] = new cdm3();
			images["cdm4"] = new cdm4();
			images["cdm5"] = new cdm5();
			images["icon_pause_exp"] = new icon_pause_exp();
			images["icon_play_exp"] = new icon_play_exp();
			images["logo_exp"] = new logo_exp();
			images["sound_off"] = new sound_off();
			images["sound_on"] = new sound_on();
			images["title_exp"] = new title_exp();
			images["wheel"] = new wheel();
			images["gnb_txt_feel_it_description"] = new gnb_txt_feel_it_description();
			images["gnb_txt_feel_it"] = new gnb_txt_feel_it();
			images["gnb_txt_exp_it_description"] = new gnb_txt_exp_it_description();
			images["gnb_txt_exp_it"] = new gnb_txt_exp_it();
			images["mainSH"] = new mainSH();
			images["listBT"] = new listBT();
			images["big_shadow"] = new big_shadow();
			images["sliderLine"] = new sliderLine();
			images["sliderThumb"] = new sliderThumb();
			
			images["qqqear"] = new qqqear();
			images["qqqear_left"] = new qqqear_left();
			images["qqqear_right"] = new qqqear_right();
			
			for(imagesIndex in images)
			{
				bitmapData = new BitmapData(images[imagesIndex].width,images[imagesIndex].height,true,0x000000);
				bitmapData.draw(images[imagesIndex],null,null,null,null,true);
				images[imagesIndex] = bitmapData;
			}
		}
		
		public function get _back():BitmapData
		{
			return images["back"];
		}
		 
		public function get _logo():BitmapData
		{
			return images["logo"];
		}
		
		public function get _logo_shadow():BitmapData
		{
			return images["logo_shadow"];
		}
		
		public function get _tab_exp():BitmapData
		{
			return images["tab_exp"];
		}
		
		public function get _tab_feel():BitmapData
		{
			return images["tab_feel"];
		}
		
		public function get _balloon():BitmapData
		{
			return images["balloon"];
		}
		
		public function get _phone_front():BitmapData
		{
			return images["phone_front"];
		}
		
		public function get _ui01_back():BitmapData
		{
			return images["ui01_back"];
		}
		
		public function get _ui01_light():BitmapData
		{
			return images["ui01_light"];
		}
		
		public function get _icon_lock():BitmapData
		{
			return images["icon_lock"];
		}
		
		public function get _ui02_back():BitmapData
		{
			return images["ui02_back"];
		}
		
		public function get _icon_list():BitmapData
		{
			return images["icon_list"];
		}
		
		public function get _icon_play():BitmapData
		{
			return images["icon_play"];
		}
		
		public function get _icon_prev():BitmapData
		{
			return images["icon_prev"];
		}
		
		public function get _icon_next():BitmapData
		{
			return images["icon_next"];
		}
		
		public function get _icon_pause():BitmapData
		{
			return images["icon_pause"];
		}
		
		public function get _icon_stop():BitmapData
		{
			return images["icon_stop"];
		}
		
		public function cd(value:int):BitmapData
		{
			return images["cd_0"+(value+1).toString()];
		}
		
		public function get _earphone_front():BitmapData
		{
			return images["earphone_front"];
		}
		
		public function get _speaker_front():BitmapData
		{
			return images["speaker_front"];
		}
		
		public function get _speaker_front_():BitmapData
		{
			return images["speaker_front_"];
		}
		
		public function get _txt_Slide_it_down():BitmapData
		{
			return images["txt_Slide_it_down"];
		}
		
		public function get _arrow():BitmapData
		{
			return images["arrow"];
		}
		
		public function get _list_up():BitmapData
		{
			return images["list_up"];
		}
		
		public function cdSmall(value:int):BitmapData
		{
			return images["small_cd_0"+(value+1).toString()];
		}
		
		public function cdMs(value:int):BitmapData
		{
			return images["cdm"+(value+1).toString()];
		}
		
		public function get _icon_pause_exp():BitmapData
		{
			return images["icon_pause_exp"];
		}
		
		public function get _icon_play_exp():BitmapData
		{
			return images["icon_play_exp"];
		}
		
		public function get _logo_exp():BitmapData
		{
			return images["logo_exp"];
		}
		
		public function get _sound_off():BitmapData
		{
			return images["sound_off"];
		}
		
		public function get _sound_on():BitmapData
		{
			return images["sound_on"];
		}
		
		public function get _title_exp():BitmapData
		{
			return images["title_exp"];
		}
		
		public function get _wheel():BitmapData
		{
			return images["wheel"];
		}
		
		public function get _gnb_txt_feel_it():BitmapData
		{
			return images["gnb_txt_feel_it"];
		}
		
		public function get _gnb_txt_feel_it_description():BitmapData
		{
			return images["gnb_txt_feel_it_description"];
		}
		
		public function get _gnb_txt_exp_it_description():BitmapData
		{
			return images["gnb_txt_exp_it_description"];
		}
		
		public function get _gnb_txt_exp_it():BitmapData
		{
			return images["gnb_txt_exp_it"];
		}
		
		public function get ___mainSH():BitmapData
		{
			return images["mainSH"];
		}

		public function get ___listBT():BitmapData
		{
			return images["listBT"];
		}
		
		public function get ___big_shadow():BitmapData
		{
			return images["big_shadow"];
		}

		 public function get _sliderLine():BitmapData
		 {
		 	return images["sliderLine"];
		 }
		 
		 public function get _sliderThumb():BitmapData
		 {
		 	return images["sliderThumb"];
		 }
		 public function get _qqqear():BitmapData
		 {
		 	return images["qqqear"];
		 }
		 
		 public function get _qqqear_left():BitmapData
		 {
		 	return images["qqqear_left"];
		 }
		  public function get _qqqear_right():BitmapData
		 {
		 	return images["qqqear_right"];
		 }

		
	}
}