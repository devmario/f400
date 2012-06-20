package extra.particle{

	import classes.FlashStage;
	
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;

	public class Particles{
		private var _particles:Array;
		
		private var samples:uint=8;
		private var offset:uint=256/samples;
		
		public var index:int;
		
		private var sin:Function = Math.sin;
		
		public var r:Number = 0;
		public var g:Number = 127;
		public var b:Number = 255;
		
		public var ri:Number = 0.02;
		public var gi:Number = 0.02;
		public var bi:Number = 0.02;
		
		public var rm:Number = 58+40;
		public var gm:Number = 58+40;
		public var bm:Number = 58+40;
		
		public var ra:Number = 197-40;
		public var ga:Number = 197-40;
		public var ba:Number = 197-40;
		
		public function Particles(_index:int) {
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
			var i:uint;
			if(_particles)
			{
				for(i=0; i<samples; i++) {
					_particles[i].speed = 0;
					_particles[i]._particles = [];
				}
			}
			else
			{
				_particles = [];
				for(i=0; i<samples; i++) {
					colors.push(sin(r += ri) * rm + ra << 16 | sin(g += gi) * gm + ga << 8 | sin(b += bi) * bm + ba);
					var pg:SimpleParticleGenerator = new SimpleParticleGenerator(sin(r += ri) * rm + ra << 16 | sin(g += gi) * gm + ga << 8 | sin(b += bi) * bm + ba);
					pg.angleDeg=-90;
					pg.thisY = 250;
					pg.thisX = (5 + i*offset*4 - 470);
					if(i>3)
					{
						pg.AnlgeB=true;
					}
					_particles.push(pg);
				}
			}
		}
		
		public function unRender():void
		{
			
		}
		
		private var colors:Array = [];
		
		public function render(byteArray:ByteArray):void
		{
			try{
				ri = gi = bi = 0.02 + 0.5 * FlashStage._eq_color;
				colors.push(sin(r += ri) * rm + ra << 16 | sin(g += gi) * gm + ga << 8 | sin(b += bi) * bm + ba);
				colors.splice(0,1);
			var i:uint=0;
			var gp:SimpleParticleGenerator;
			for(i=0; i<_particles.length; i++)
			{
				gp = _particles[i];
				gp._color = colors[i];
			}
			FlashStage.EQbackShape.graphics.clear();
			SoundMixer.computeSpectrum(byteArray, true);
			var count:uint=0;
			for (i=0; i<256; i+=offset) {
				var t:Number = byteArray.readFloat();
				var n:Number = Math.pow(t * 8,1.8);
				gp = _particles[count];
				gp.speed=n*2*FlashStage._eq_speed;
				gp.render();
				count++;
			}
			}catch(e:Error){}
		}
	}
}
