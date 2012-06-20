package classes
{
	import caurina.transitions.Tweener;
	
	import classes.phone.CDSelector;
	import classes.phone.ControlButtonPlay;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class FlashStage extends Sprite
	{
		private var modeSelectStage:ModeSelectStage;
		public static var phone:Phone = new Phone();
		private var logo:Logo;
		private var selector:Selector;
		private var exp:Exp_it_player;
		
		private var n:int;
		
		public var sliders:Sprite;
		
		public static var _eq_scale:Number = 0.5;
		public static var _eq_color:Number = 0.5;
		public static var _eq_speed:Number = 0.5;
		public static var _eq_power:Number = 0.5;
		
		private var slider_scale:Slider;
		private var slider_color:Slider;
		private var slider_speed:Slider;
		private var slider_power:Slider;
		
		public static var EQbackSprite:Sprite = new Sprite();
		public static var EQbackShape:Shape = new Shape();
		public static var EQfront:Shape = new Shape();
		
		public var sliderController:SliderController;
		
		private var _mode:String = Main.MODE_MAIN;
		
		private var listBT:Sprite;
		public var firstBorn:FirstBornF400;
		
		public function FlashStage(){
			super();
			addEventListener(Event.ADDED_TO_STAGE,added);
		}
		
		public static function initEQbitmap():void
		{
			
		}
		
		public static var selectorss:CDSelector;
		
		private function added(event:Event):void
		{
			if(!modeSelectStage)
			{
				modeSelectStage = addChild(new ModeSelectStage()) as ModeSelectStage;
				
				addChild(EQbackShape);
				addChild(EQbackSprite);
				
				EQbackSprite.x = stage.stageWidth/2;
				EQbackSprite.y = stage.stageHeight/2;
				
				addChild(phone);
				
				sliderController = addChild(new SliderController(phone)) as SliderController;
				
				addChild(EQfront);
				
				selectorss = addChild(new CDSelector()) as CDSelector;
				
				sliders = addChild(new Sprite()) as Sprite;
				sliders.y = 300;
				
				slider_scale = sliders.addChild(new Slider(0)) as Slider;
				slider_color = sliders.addChild(new Slider(1)) as Slider;
				slider_speed = sliders.addChild(new Slider(2)) as Slider;
				slider_power = sliders.addChild(new Slider(3)) as Slider;
				slider_scale.label = "Scale";
				slider_color.label = "Color";
				slider_speed.label = "Speed";
				slider_power.label = "Power";
				slider_power.x = slider_speed.x = slider_color.x = slider_scale.x = 68;
				slider_scale.y = 370;
				slider_color.y = slider_scale.y + 27;
				slider_speed.y = slider_color.y + 27;
				slider_power.y = slider_speed.y + 27;
				
				
				logo = addChild(new Logo(this)) as Logo;
				
				firstBorn = addChild(new FirstBornF400(this)) as FirstBornF400;
				
				exp = addChild(new Exp_it_player(this)) as Exp_it_player;
				
				selector = addChild(new Selector(this)) as Selector;
				selectorss.x = -500;
				selectorss.y = -50;
				
				sliderController.x = 470;
				sliderController.y = 75;
			}
		}
		
		public function set mode(value:String):void
		{
			if(value != _mode)
			{
				modeSelectStage.mode = value;
				phone.mode = value;
				logo.mode = value;
				selector.mode = value;
				sliderController.feel_exp_mode = value;
				exp.mode = value;
				firstBorn.mode = value;
				
				_mode = value;
				
				Tweener.removeTweens(EQbackSprite);
				Tweener.removeTweens(EQbackShape);
				Tweener.removeTweens(EQfront);
				
				if(_mode == Main.MODE_FEEL_IT || _mode == Main.MODE_MAIN)
				{
					if(phone.playMode == Phone.MODE_PLAY)
					{
						if(phone.phoneScreen.playPhone.playButton.mode != ControlButtonPlay.MODE_PLAY)
							Sprite(phone.phoneScreen.playPhone.playButton).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					}
					Tweener.addTween(EQbackSprite,{alpha:1,time:1,onUpdate:alphaSync,onComplete:alphaComplete});
				}
				else
				{
					Tweener.addTween(EQbackSprite,{alpha:0,time:1,onUpdate:alphaSync});
				}
				if(_mode != Main.MODE_FEEL_IT)
				{
					ssmode = false;
					vvmode = false;
				}
				else
				{
					ssmode = true;
				}
				
			}
		}
		
		public function set ssmode(value:Boolean):void
		{
			if(value)
			{
				Tweener.addTween(selectorss,{x:0,time:1});
			}
			else
			{
				Tweener.addTween(selectorss,{x:-500,time:1});
			}
		}
		
		public function set vvmode(value:Boolean):void
		{
			
				if(value)
				{
					Tweener.addTween(sliders,{y:0,time:1});
				}
				else
				{
					Tweener.addTween(sliders,{y:300,time:1});
				}
		}
		
		public function get mode():String
		{
			return _mode;
		}
		
		private function alphaSync():void
		{
			EQbackShape.alpha = EQfront.alpha = EQbackSprite.alpha;
		}
		
		private function alphaComplete():void
		{
		}
		
	}
}