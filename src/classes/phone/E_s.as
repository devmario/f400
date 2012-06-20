package classes.phone
{
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;

	public class E_s extends Sprite
	{
		public var left:Sprite = new Sprite();
		public var right:Sprite = new Sprite();
		private var bytes:ByteArray = new ByteArray();
		public function E_s()
		{
			super();
			
			addChild(new Bitmap(Main.images._qqqear,PixelSnapping.AUTO,true));
			addChild(left);
			addChild(right);
			
			var bitmap:Bitmap;
			
			bitmap = left.addChild(new Bitmap(Main.images._qqqear_left,PixelSnapping.AUTO,true)) as Bitmap;
			left.x = 33;
			left.y = 370;
			bitmap.x = -25.5;
			bitmap.y = -33;
			
			bitmap = right.addChild(new Bitmap(Main.images._qqqear_right,PixelSnapping.AUTO,true)) as Bitmap;
			
			bitmap.x = -14.9;
			bitmap.y = -40;
			
			right.x = 107;
			right.y = 320.9;
			addEventListener(Event.ENTER_FRAME,render);
		}
		private function render(event:Event):void
		{
			SoundMixer.computeSpectrum(bytes,true);
			right.scaleX = right.scaleY = left.scaleX = left.scaleY = bytes.readFloat()*0.1 + 1;
		}
	}
}