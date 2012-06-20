package classes
{
	import extra.curveLine.Curve;
	import extra.espera.Espera;
	import extra.imagination.Imagination;
	import extra.particle.Particles;
	import extra.rippleDot.RippleDot;
	import extra.standard.Standard;
	
	import flash.utils.ByteArray;
	
	public class Equalizer
	{
		public var byte:ByteArray;
		
		public static const MODE_NO:int = -1;
		public static const MODE_ESPERA:int = 0;
		public static const MODE_DELICATENOTE:int = 1;
		public static const MODE_IMAGINATION:int = 2;
		public static const MODE_KALEIDOSCOPE:int = 3;
		public static const MODE_TAIL:int = 4;
		
		public var _mode:int = MODE_NO;
		
		public var n:int;
		
		public var equalizers:Array;
		
		public var selectEQ:Object;
		
		public function Equalizer()
		{
			super();
			
			byte = new ByteArray();
			
			equalizers = [];
			equalizers[0] = new Particles(0);
			equalizers[1] = new RippleDot(1);
			equalizers[2] = new Standard(2);
			equalizers[3] = new Espera(3);
			equalizers[4] = new Imagination(4);
			
			mode = -1;
		}
		
		public function set mode(value:int):void
		{
			if(_mode != value)
			{
				if(selectEQ)
					selectEQ.unRender();
				_mode = value;
				if(_mode != -1)
				{
					selectEQ = equalizers[value];
					selectEQ.init();
				}
				else
				{
					selectEQ = null;
				}
				byte = new ByteArray();
			}
		}
		
		public function get mode():int
		{
			return _mode;
		}
		
		public function render():void
		{
			if(_mode != MODE_NO)
			{
				if(_mode != -1)
				{
					if(selectEQ is Espera)
						selectEQ.render(FlashStage.EQbackSprite,FlashStage.EQfront,byte);
					else if(selectEQ is Particles)
						selectEQ.render(byte);
					else if(selectEQ is Standard)
						selectEQ.render(byte);
					else if(selectEQ is RippleDot)
						selectEQ.render(byte);
					else
						selectEQ.render(FlashStage.EQbackSprite,FlashStage.EQbackShape,byte);
				}
			}
		}
		
	}
}