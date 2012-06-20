package extra.standard
{
	import classes.FlashStage;
	
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	
	public class Standard
	{
		
		public var index:int;
		private var gr:Graphics;
		
		private var count:Number = 30;
		private var offset:uint=256/count;
		
		private var width:Number = 940;
		private var height:Number = 480;
		
		private var n:int = 0;
		
		private var sin:Function = Math.sin;
		
		public var r:Number = 0;
		public var g:Number = 127;
		public var b:Number = 255;
		
		public var ri:Number = 0.01;
		public var gi:Number = 0.01;
		public var bi:Number = 0.01;
		
		public var rm:Number = 58+40;
		public var gm:Number = 58+40;
		public var bm:Number = 58+40;
		
		public var ra:Number = 197-40;
		public var ga:Number = 197-40;
		public var ba:Number = 197-40;
		
		private var stick:Array;
		
		public function Standard ( _index:int) 
		
		{
			index = _index;
			
		}
		
		public function init():void
		{
			FlashStage.EQbackSprite.x = FlashStage.EQbackShape.x = FlashStage.EQfront.x = 940/2;
			FlashStage.EQbackSprite.y = FlashStage.EQbackShape.y = FlashStage.EQfront.y = 480/2;
			FlashStage.EQbackSprite.graphics.clear();
			FlashStage.EQbackShape.graphics.clear();
			FlashStage.EQfront.graphics.clear();
			while(FlashStage.EQbackSprite.numChildren != 0)
			{
				FlashStage.EQbackSprite.removeChildAt(0);
			}
			gr = FlashStage.EQbackShape.graphics;
			
			stick = [];
			for(n=0;n<count+1;n++)
			{
				var _color:Number = sin(r += ri) * rm + ra << 16 | sin(g += gi) * gm + ga << 8 | sin(b += bi) * bm + ba;
				var _w:Number = width/count;
				stick[n] = {c:_color,w:_w,x:n*_w-width/2,y:0,h:0,vh:0};
			}
			gr.lineStyle(0,0,0);
			FlashStage.EQbackShape.y = 480/2 + 120;
		}
		
		public function unRender():void
		{
			
		}
		
		public function render(byteArray:ByteArray):void
		{
			try{
				ri = gi = bi = 0.01 + 0.05 * FlashStage._eq_color;
			gr.clear();
			SoundMixer.computeSpectrum(byteArray, true);
			var _color:Number = sin(r += ri) * rm + ra << 16 | sin(g += gi) * gm + ga << 8 | sin(b += bi) * bm + ba;
			var _c:uint=0;
			var shift:Number = 1 + FlashStage._eq_speed * 10;
			var power:Number = 0.1 + FlashStage._eq_power * 0.9;
			for (var i:int=0; i<stick.length; i++) {
				var t:Number = byteArray.readFloat();
				var n:Number = Math.pow(t * 50,1.5);
				var gp:Object = stick[_c];
				gp.h = gp.h * 0.95;
				gp.x -= shift;
				if(gp.x<-width/2 - gp.w)
				{
					gp.x = width/2 - Math.abs(gp.x-(-width/2 - gp.w));
					gp.c = _color;
				}
				if(gp.h<n){
					gp.h = n*FlashStage._eq_scale;
				}
				gr.beginFill(gp.c);
				gr.drawRect(gp.x,gp.y,gp.w*power-1,-gp.h);
				gr.endFill();
				var mat:Matrix = new Matrix();
				mat.createGradientBox(gp.w*power-1,100,Math.PI/2,gp.x,gp.y+2);
				gr.beginGradientFill(GradientType.LINEAR,[gp.c,gp.c],[0.5,0],[0x00,0xFF],mat);
				gr.drawRect(gp.x,gp.y+2,gp.w*power-1,gp.h);
				gr.endFill();
				_c++;
			}
			}catch(e:Error){}
		}
		
	}
}