package extra.rippleDot
{
	import classes.FlashStage;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	
	public class RippleDot
	{
		public var index:int;
		
		private var i:int;
		
		private var colors:Array = [];
		
		private var dots:Array = [];
		
		private var myPoints:Array = [];
		private var arrayMidpoints:Array = [];
		
		public var r:Number = 0;
		public var g:Number = 127;
		public var b:Number = 255;
		
		public var ri:Number = 0.05;
		public var gi:Number = 0.05;
		public var bi:Number = 0.05;
		
		public var rm:Number = 58+40;
		public var gm:Number = 58+40;
		public var bm:Number = 58+40;
		
		public var ra:Number = 197-40;
		public var ga:Number = 197-40;
		public var ba:Number = 197-40;
		
		private var curveSize:Number;
		
		private var curve:Sprite;
		private var dot:Shape;
		
		private var hexSize:Number = 20;
		private var hexWidth:Number;
		private var hexHeight:Number;
		private var hexHeightHarf:Number;
		private var hexLine:Number = 1;
		private var hexBoxSize:Number = hexSize - hexLine;
		private var hexHarfSize:Number = hexSize * 0.5;
		private var hexM:Number;
		private var hexN:Number;
		private var hexCount:Number;
		
		private var shadowLine:Number = hexLine;
		private var shadowHeight:Number; 
		
		public function RippleDot(_index:int)
		{
			index = _index;
		}
		
		public function init():void
		{
			colors = [];
		
			dots = [];
		
			myPoints = [];
			arrayMidpoints = [];
		
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
			FlashStage.EQbackSprite.y = FlashStage.EQbackShape.y = 0;
			
			curve = FlashStage.EQbackSprite;
			dot = FlashStage.EQbackShape;
			
			hexWidth = 940;
			hexHeight = 480;
			hexM = Math.ceil(hexWidth/hexSize)+2;
			hexN = Math.ceil(hexHeight/hexSize)+2;
			hexCount = Math.ceil(hexM * hexN);
			hexHeightHarf = hexHeight * 0.5;
			
			shadowHeight = hexHeightHarf * 0.5;
			
			var _m:int = 0;
			var _n:int = 0;
			for(i=0;i<hexCount;i++)
			{
				dots[i] = {m:_m,n:_n,alpha:0};
				_n++;
				if(_n > hexN)
				{
					colors[_m] = Math.sin(r += ri) * rm + ra << 16 | Math.sin(g += gi) * gm + ga << 8 | Math.sin(b += bi) * bm + ba;
					_m ++;
					_n = 0;
				}
			}
		}
		
		public function unRender():void
		{
			
		}
		
		public function render(bytes:ByteArray):void
		{
			try{
			ri = gi = bi = 0.05 + 0.1 * FlashStage._eq_color;
			colors.push(Math.sin(r += ri) * rm + ra << 16 | Math.sin(g += gi) * gm + ga << 8 | Math.sin(b += bi) * bm + ba);
			colors.splice(0,1);
			
			SoundMixer.computeSpectrum(bytes,false);
			
			i = 16;
			curveSize = hexWidth/(i-2);
			while ( --i > -1 ) {
				bytes.position = i * 128;
				var offset:Number = bytes.readFloat()*hexHeightHarf*2*FlashStage._eq_scale;
				if(myPoints[i])
				{
					var offsetLast:Number = myPoints[i].y;
					if(offset < offsetLast)
					{
						offset = offsetLast;
					}
				}
				var myObj:Object = { x :  curveSize * i - curveSize, y : offset};
				myPoints[i] = myObj;
				myPoints[i].y = myPoints[i].y*0.98;
			}
			for (var j:int = 1; j< myPoints.length; j++ ) {
				var midPointX:Number = ( myPoints[j].x + myPoints[j-1].x )/2
				var midPointY:Number = ( myPoints[j].y + myPoints[j-1].y )/2
				var midPointsObj:Object = { x : midPointX, y : midPointY };
				arrayMidpoints[j-1] = midPointsObj;
			}
			curve.graphics.clear();
			draw();
			}catch(e:Error){}
		}
		
		private function draw():void
		{
			curve.graphics.beginFill(0xFFFFFF,0);
			curve.graphics.moveTo(0,hexHeightHarf);
			curve.graphics.lineTo(0,myPoints[0].y+hexHeightHarf);
			curve.graphics.lineTo(myPoints[0].x,myPoints[0].y+hexHeightHarf);
			for (i = 1; i< myPoints.length-1; i++ ) {
				curve.graphics.curveTo ( myPoints[i].x, myPoints[i].y+hexHeightHarf, arrayMidpoints[i].x, arrayMidpoints[i].y+hexHeightHarf );
			}
			curve.graphics.lineTo(myPoints[i].x,myPoints[i].y+hexHeightHarf);
			curve.graphics.lineTo(myPoints[i].x,hexHeightHarf);
			curve.graphics.lineTo(0,hexHeightHarf);
			curve.graphics.lineTo(myPoints[0].x,hexHeightHarf-myPoints[0].y);
			for (i = 1; i< myPoints.length-1; i++ ) {
				curve.graphics.curveTo ( myPoints[i].x, hexHeightHarf-myPoints[i].y, arrayMidpoints[i].x, hexHeightHarf-arrayMidpoints[i].y );
			}
			curve.graphics.lineTo(myPoints[i].x,hexHeightHarf-myPoints[i].y);
			curve.graphics.lineTo(myPoints[i].x,hexHeightHarf);
			curve.graphics.lineTo(0,hexHeightHarf);
			curve.graphics.endFill();
			dot.graphics.clear();
			var scale:Number = FlashStage._eq_power+0.5;
			for(i=0;i<hexCount;i++)
			{
				var _x:Number = dots[i].m * hexSize;
				var _y:Number = dots[i].n * hexSize;
				var _decrease:Number = 0.9;
				var _increase:Number = 0.2;
				var _drawY:Number = _y;
				_increase = 0.05+FlashStage._eq_speed*0.1;
				_decrease = 0.98-FlashStage._eq_speed*0.2;
				_drawY = _drawY+shadowLine;
				if(curve.hitTestPoint(_x + hexHarfSize,_y + hexHarfSize,true))
				{
					if(dots[i].alpha < 1)
					{
						dots[i].alpha += _increase;
					}
					else
					{
						dots[i].alpha = 1;
					}
					dot.graphics.beginFill(colors[dots[i].m],dots[i].alpha);
					dot.graphics.drawRect(_x,_drawY,hexBoxSize*scale,hexBoxSize*scale);
				}
				else
				{
					if(dots[i].alpha > 0.05)
					{
						dots[i].alpha = dots[i].alpha * _decrease;
						dot.graphics.beginFill(colors[dots[i].m],dots[i].alpha);
						dot.graphics.drawRect(_x,_drawY,hexBoxSize*scale,hexBoxSize*scale);
					}
				}
				dot.graphics.endFill();
			}
		}
	}
}