package extra.espera
{
	import classes.FlashStage;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;

	public class Espera
	{
		
		private var count:uint = 400;
		
		private var stars:Array = new Array();
		
		private var camera:Object = {x:0,y:0,z:0};
		
		public var spectrum:Array = new Array(256);
		
		public var FL:Number = 600;
		
		public var _theta:Number = 1;
		
		public var _xs:Number = 1;
		
		public var _ys:Number = 1;
		
		public var _zs:Number = 1;
		
		public var minRadio:Number = 350;
		
		public var radioUp:Number = 200;
		
		public var _spectrumMinus:Number = 0.03;
		
		public var _spectrumPer:Number = 0.2;
		
		public var _spectrumScale:Number = 0.25;
		
		public var _minSpectrumScale:Number = 0;
		
		public var _spectrumPow:Number = 2.9;
		
		public var _colorV:Number = 82;
		
		public var radioSpeed:Number = 0.18;
		
		public var _largo:Number = 0.05;
		
		public var _phi:Number = 0.2;
		
		public var _phi2:Number = 0.1;
		
		private var particleRadius:Number = 50;
		
		
		private var radio:Number = minRadio+radioUp;
		
		public var index:int;

		public function Espera(_index:int)
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
			
			for(var i:uint = 0;i<count;i++){
				spectrum[i]=0;
				var local_z:Number=Math.random()*radio*2-radio;
				stars[i] = {phi:Math.random()*99999999+99999999,
							largo:Math.random(),
							theta:Math.asin(local_z/radio),
							x:0,
							y:0,
							z:local_z,
							_x:0,
							_y:0,
							_z:0,
							_scale:0,
							_alpha:0,
							spectrum:0};
			}
			
			minRadio = 600;
		}
		
		public function unRender():void
		{
			
		}
		
		public function render(backShape:Sprite,frontShape:Shape,byteArray:ByteArray):void
		{
			try{
				_spectrumPow = 1.5 + 4*FlashStage._eq_power;
			radioUp = 50 + 250 * FlashStage._eq_scale;
			_phi = 0.1 + 0.5 * FlashStage._eq_speed;
			_phi2 = 0.05 + 0.25 * FlashStage._eq_speed;
			var i:int;
			SoundMixer.computeSpectrum(byteArray,true,0);
			var value:Number;
			var smooth:Number;
			for(i=0;i<256;i++)
			{
				value = byteArray.readFloat();
				if(i == 0)smooth = value;
				else smooth += (value - smooth ) / 8;
				spectrum[i] = smooth;
			}
			draw(backShape,frontShape);
			}catch(e:Error){}
		}
		
		private var maxRotate:Number=0.05;
		private var mouseNum:Number=1000;
		private function draw(backShape:Sprite,frontShape:Shape):void{
			camera.x -= 0.06 * FlashStage._eq_speed;
			camera.y -= 0.06 * FlashStage._eq_speed;
			renderXYZ();
			drawStep(backShape,frontShape);
		}
		
		private var perxc:Number = 0;
		private var perxs:Number = 0;
		private var peryc:Number = 0;
		private var perys:Number = 0; 
		
		private function drawStep(backShape:Sprite,frontShape:Shape):void{
			
			minRadio = FlashStage.phone.scaleX * 350;
			
			backShape.graphics.clear();
			frontShape.graphics.clear();
			
			var graphics:Graphics = backShape.graphics;
			
			var copy:Array=[];
			for(var j:uint = 0;j<stars.length;j++){
				copy[j] = stars[j];
			}
			copy.sortOn("_z",Array.NUMERIC | Array.DESCENDING);
			
			var swaps:Boolean = true;
			
			var perCol:Number = _colorV * FlashStage._eq_color;
			
			var sinCol:Number = (122-perCol);
			var centerCol:Number = 123+perCol;
			for(var i:uint = 0;i<stars.length;i++){
					var r:uint = Math.sin(copy[i].x/radio)*sinCol+centerCol;
					var g:uint = Math.sin(copy[i].y/radio)*sinCol+centerCol;
					var b:uint = Math.sin(copy[i].z/radio)*sinCol+centerCol;
					var color:uint = r << 16 | g << 8 | b;
					graphics.beginFill(color,(copy[i]._alpha-1)+.5);
					var particleRadius:Number = particleRadius*copy[i]._scale > 0 ? particleRadius*copy[i]._scale : 0;
					graphics.drawCircle(copy[i]._x,copy[i]._y,particleRadius);
					
					if(copy[i]._alpha-1>0 && swaps){
						swaps=false;
						graphics = frontShape.graphics;
					}
			}
		}
		
		private function renderXYZ():void{ 
			var sx:Number = Math.sin(camera.x);
			var cx:Number = Math.cos(camera.x);
			var sy:Number = Math.sin(camera.y);
			var cy:Number = Math.cos(camera.y);
			var sz:Number = Math.sin(camera.z);
			var cz:Number = Math.cos(camera.z);
			var i:int = stars.length;
			var xy:Number,xz:Number,yx:Number,yz:Number,zx:Number,zy:Number,scaleRatio:Number;
			radio += (minRadio+spectrum[1]*radioUp-radio)*radioSpeed;
			while (i--){
				if(spectrum[uint(i*_spectrumPer)] > stars[i].spectrum){
					stars[i].spectrum = spectrum[uint(i*_spectrumPer)];
				}else{
					stars[i].spectrum -=_spectrumMinus;
				}
				stars[i].phi += _phi2*((radio-minRadio)/radioUp)-stars[i].spectrum*_phi*((radio-minRadio)/radioUp);
				stars[i].x = radio * Math.cos(stars[i].theta * _theta) * Math.cos(stars[i].phi) * ((stars[i].largo * _largo) + (1-_largo)) * _xs;
   				stars[i].y = radio * Math.cos(stars[i].theta * _theta) * Math.sin(stars[i].phi) * ((stars[i].largo * _largo) + (1-_largo)) * _ys;
   				stars[i].z = radio * Math.sin(stars[i].theta * _theta) * ((stars[i].largo * _largo) + (1-_largo))  * _zs;
				
				xy = cx*stars[i].y - sx*stars[i].z;
				xz = sx*stars[i].y + cx*stars[i].z;
				
				yz = cy*xz - sy*stars[i].x;
				yx = sy*xz + cy*stars[i].x;
				
				zx = cz*yx - sz*xy;
				zy = sz*yx + cz*xy;
				
				scaleRatio = FL/(FL + yz);
				
				stars[i]._x = zx*scaleRatio;
				stars[i]._y = zy*scaleRatio;
				stars[i]._z = yz;
				stars[i]._scale = Math.pow(_spectrumPow,(_minSpectrumScale+(scaleRatio*stars[i].spectrum)*_spectrumScale))-1;
				stars[i]._alpha= scaleRatio;
			}
		}
		
	}
}