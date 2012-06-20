package {
	import classes.FlashStage;
	import classes.Images;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.text.Font;
	import flash.ui.ContextMenu;

	[SWF(backgroundColor="0xFFFFFF",width="940",height="480")]
	
	public class Main extends Sprite
	{
		[Embed(mimeType='application/x-font',source='../asset/samsungGB.ttf',fontName='samsungGB',unicodeRange="U+0000-U+007A")]
		private var samsungGB:Class;
		
		[Embed(mimeType='application/x-font',source='../asset/samsungPTB.ttf',fontName='samsungPTB',unicodeRange="U+0000-U+007A")]
		private var samsungPTB:Class;
		
		[Embed(mimeType='application/x-font',source='../asset/FUTURAM.TTF',fontName='FUTURAM',unicodeRange="U+0000-U+007A")]
		private var FUTURAM:Class;

		public static const MODE_MAIN:String = "main";
		public static const MODE_FEEL_IT:String = "feel_it";
		public static const MODE_EXPERIENCE:String = "experience_it";
		
		public static const FRAME_RATE:uint = 60;
		public static var images:Images;
		
		public var defaultContextMenu:ContextMenu;
		
		public static var flashStage:FlashStage = new FlashStage();
		private var stageMask:Shape;
		   
		public function Main()
		{
			super();
			
			Font.registerFont(samsungGB);
			Font.registerFont(samsungPTB);
			Font.registerFont(FUTURAM);
			
			Main.images = new Images();
			
			config();
		}
		
		private function config():void
		{
			addChild(flashStage);
			stageMask = addChild(new Shape()) as Shape;
			stageMask.graphics.beginFill(0x000000);
			stageMask.graphics.drawRoundRect(0,0,940,480,5,5);
			stageMask.graphics.endFill();
			flashStage.mask = stageMask;
		}
	}
}
