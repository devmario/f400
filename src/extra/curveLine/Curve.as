package extra.curveLine{
	
	import classes.FlashStage;
	
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.errors.EOFError;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;

	public class Curve
	
	{
		
		// data members
		private var nAmp:int;
		private var myPoints:Array;
		private var arrayMidpoints:Array;
		private var colors:Array;
		private var ratios:Array;
		private var alphas:Array;
		private var matrix:Matrix;
		private var blendArray:Array;
		private var blendStyle:String;
		
		// graphic members
		private var myCurve:Graphics;
		private var myPoint:Point;
		private var displace:Matrix;
		private var mouseDown:Boolean;
		
		public var index:int;
		
		
		public var r:Number = 0;
		public var g:Number = 127;
		public var b:Number = 255;
		
		public var ri:Number = 0.03;
		public var gi:Number = 0.03;
		public var bi:Number = 0.03;
		
		public var rm:Number = 58+40;
		public var gm:Number = 58+40;
		public var bm:Number = 58+40;
		
		public var ra:Number = 197-40;
		public var ga:Number = 197-40;
		public var ba:Number = 197-40;
		
		public var colorss:Array;
		
		public var ww:Array;
		
		public var bg:Graphics;
		
		public function Curve ( _index:int ) {
			
			index = _index;
			
			
			
			////////////////////////////////// GRAPHICS STUFF
			// our bitmap screen, where the curves are drawn
			
			// default blendMode
			
			// screen is blurred !!
			// using multiple of 2 increases performance by 40%
			
			// colorTransformation
			
			
			// add it to the displayList
			
			// DATA STUFF
			// byteArray to hold frequencies
			
			//rotate it	
			//displace.scale (.5, .5);
			
			blendArray = ['layer', 'multiply', 'screen', 'lighten', 'darken',
						  'difference', 'add', 'subtract', 'invert', 'alpha', 'erase', 
						  'overlay', 'hardlight' ];
			
			// points holder
			myPoints = new Array();
			
			colorss = [];
			ww =[];
			
			// midpoints holder
			arrayMidpoints = new Array();
			
			// set the wavin' amplitude
			
			// the curve to draw the spectrum
			
			// the point
			myPoint = new Point ( 0, 0 );
			
			colors = [0x990000, 0x00FF00];
			alphas = [100, 100];
			ratios = [80, 255];
			matrix = new Matrix();
			matrix.createGradientBox ( 940, 1, 0, 0, 0);
			
			for(var t:int=0;t<32;t++)
			{
				colorss[t] = Math.sin(r += ri) * rm + ra << 16 | Math.sin(g += gi) * gm + ga << 8 | Math.sin(b += bi) * bm + ba;
				ww[t] = 1;
			}
			
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
			FlashStage.EQbackSprite.x = FlashStage.EQbackShape.x = 0;
			FlashStage.EQbackSprite.y = FlashStage.EQbackShape.y = 480/2 + 120;
			myCurve = FlashStage.EQbackShape.graphics;
			bg = FlashStage.EQbackSprite.graphics;
			bg.lineStyle(0);
		}
		
		public function unRender():void
		{
			
		}
		
		public function render ( bytesArray:ByteArray ):void {
			
			try {
			bg.clear();
			colorss.push(Math.sin(r += ri) * rm + ra << 16 | Math.sin(g += gi) * gm + ga << 8 | Math.sin(b += bi) * bm + ba);
			colorss.splice(0,1);
			
			// clear each frame
			myCurve.clear();
			myCurve.beginFill(colorss[0]);
			var mat:Matrix = new Matrix();
			mat.createGradientBox(640,100,Math.PI/2,0,0);
			bg.beginGradientFill(GradientType.LINEAR,[colorss[0],colorss[20]],[0.5,0],[0x00,0xFF],mat);
			// apply gradient to the line
			
			// generate the ByteArray
			SoundMixer.computeSpectrum ( bytesArray, mouseDown );
			
			// 32 loops to draw 32 points, and get 32 frequencies
			// in the wole byteArray ( 16 * 128 = 2048 )
			// a float (32bit) = 4 bytes so 512 float = 512 * 4 = 2048
			
			var i:int = 32;
			
				while ( --i > -1 ) {
															
					// change the position of the pointer
					bytesArray.position = i * 64;
					// get frequency
					var offset:Number = bytesArray.readFloat()*600;
					
					// create a point object
					// y is related to the offset
					if(myPoints[i])
					{
						var offsetLast:Number = myPoints[i].y;
						if(offset > offsetLast)
						{
							offset = offsetLast;
						}
					}
					var myObj:Object = { x : ( 35 * i )-35, y : (offset)};		
					
					// push each points 
					myPoints[i] = myObj;
	
					myPoints[i].y = myPoints[i].y*0.98;
				}
				
			
			
			// now generate a mid-point array
			// to make those mid-points the curve anchor points
			for (var j:int = 1; j< myPoints.length; j++ ) {
				
				var midPointX:Number = ( myPoints[j].x + myPoints[j-1].x )/2
				var midPointY:Number = ( myPoints[j].y + myPoints[j-1].y )/2
				
				var midPointsObj:Object = { x : midPointX, y : midPointY };
				
				arrayMidpoints[j-1] = midPointsObj;

			}
			
			//myScreen.colorTransform (myScreen.rect, myColorTrans);
			
			//myCurve.graphics.beginGradientFill  ('linear', colors, alphas, ratios, matrix, 'pad', 'linearRGB', 0.9);
			
			myCurve.moveTo ( arrayMidpoints[0].x, arrayMidpoints[0].y );
			
			bg.moveTo(arrayMidpoints[0].x, -arrayMidpoints[0].y+2);
			
			// make the curve start at the first mid-point location
			
			// then draw the curve
			for (var k:int = 1; k< myPoints.length-1; k++ ) {

			
				//myCurve.lineStyle (1,colorss[k]);
				myCurve.curveTo ( myPoints[k].x, myPoints[k].y, arrayMidpoints[k].x, arrayMidpoints[k].y );
				bg.curveTo(myPoints[k].x, -myPoints[k].y+2, arrayMidpoints[k].x, -arrayMidpoints[k].y+2 );
				
			}
			
			myCurve.lineTo(myPoints[k].x,0);
			myCurve.lineTo(0,0);
			
			bg.lineTo(myPoints[k].x,2);
			bg.lineTo(0,2);
			
			} catch ( err:Error ) {
				
				trace("you've gone too far")
				
			}
			
			
		}
		
		// INTERFACE IMPLEMENTATION
		
		
	}
}