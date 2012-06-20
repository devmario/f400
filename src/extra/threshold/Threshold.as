package extra.threshold
{
	import classes.FlashStage;
	
	import flash.display.BitmapData;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	
	public class Threshold
	{
		public var index:int;
		
		public var screen:BitmapData;
		
		private var mergeSource:BitmapData = new BitmapData(150,150,true,0xFFFFFF);
		private var mergeColor:uint = 0xFFFFFFFF;
		private var mergeAlpha:uint = Math.floor(0xFF * 0.5);
		
		public var leftShape:ThresholdImagination = new ThresholdImagination();
		public var rightShape:ThresholdImagination = new ThresholdImagination();
		
		private var spectrum:Array;
		
		private var defaultPoint:Point = new Point();
		
		private var blur:BlurFilter = new BlurFilter(6,6,BitmapFilterQuality.LOW);
		
		private var angle:Number = 0;
		
		public var leftThresholdPer:Number = 1;
		
		public var rightThresholdPer:Number = 1;
		
		public function Threshold(_index:int)
		{
			index = _index;
			
			screen = FlashStage.EQBmpd;
		}
		
		public function init():void
		{
			FlashStage.initEQbitmap();
			FlashStage.EQbackSprite.x = FlashStage.EQbackShape.x = FlashStage.EQfront.x = 940/2;
			FlashStage.EQbackSprite.y = FlashStage.EQbackShape.y = FlashStage.EQfront.y = 480/2;
			FlashStage.EQbackSprite.graphics.clear();
			FlashStage.EQbackShape.graphics.clear();
			FlashStage.EQfront.graphics.clear();
			while(FlashStage.EQbackSprite.numChildren != 0)
			{
				FlashStage.EQbackSprite.removeChildAt(0);
			}
			
			spectrum =[];
			
			for(var i:uint = 0;i<256;i++){
				spectrum[i]=0;
			}
		}
		
		public function unRender():void
		{
			
		}
		
		public function render(byteArray:ByteArray):void
		{
			SoundMixer.computeSpectrum( byteArray, true, 0 );
			
			var value: Number;
			
			var smooth: Number;
			
			var avr:Number = 0;
			
			for( var i: int = 0 ; i < 256 ; i++ )
			{
				value = byteArray.readFloat();
				
				
				if( i == 0 ) smooth = value;
				else smooth += ( value - smooth ) / 8;
				if(i==0){
					leftShape.V = smooth*10;
				}
				avr += smooth;
			}
			
			avr = avr / 256;
			
			angle += 0.05;
			leftShape.point.x = Math.sin(angle) * 50 + 480/2;
			leftShape.point.y = Math.cos(angle) * 50 + 240/2;
			leftShape.render();
			renderEffect();
			renderShape(leftShape);
		}
		
		public function renderEffect():void
		{
			shiftThreshold(screen);
		}
		
		private function shiftThreshold(bmpd:BitmapData):void
		{
			bmpd.applyFilter(bmpd,bmpd.rect,defaultPoint,blur);
			bmpd.merge(mergeSource,mergeSource.rect,defaultPoint,0,0,0,mergeAlpha);
			bmpd.threshold(bmpd, bmpd.rect, defaultPoint, "<", 0x00808080, 0x00FFFFFF, 0x80FFFFFF, true);
		}
		
		public function renderShape(_left:ThresholdImagination):void
		{
			screen.draw(_left,null,null,null,null,false);
		}

	}
}