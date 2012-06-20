package classes.phone
{
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	
	public class Speaker extends Sprite
	{
		public var speaker:Sprite = new Sprite();
		private var bytes:ByteArray = new ByteArray();
		public function Speaker()
		{
			super();
			addChild(new Bitmap(Main.images._speaker_front,PixelSnapping.AUTO,true)) as Bitmap;
			speaker.x = width/2;
			speaker.y = height/2;
			addChild(speaker);
			var bitmap:Bitmap = speaker.addChild(new Bitmap(Main.images._speaker_front_,PixelSnapping.AUTO,true)) as Bitmap;
			bitmap.x = -bitmap.width/2;
			bitmap.y = -bitmap.height/2;
			addEventListener(Event.ENTER_FRAME,render);
		}
		private function render(event:Event):void
		{
			SoundMixer.computeSpectrum(bytes,true);
			speaker.scaleX = speaker.scaleY = bytes.readFloat()*0.1 + 1;
		}

	}
}