package extra.kaleidoscope
{
	import classes.FlashStage;
	
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;
	
	public class KaleidoscopeEXP
	{
		public var index:int;
		
		private var degToRad:Number = Math.PI / 180;
		private var sqrt2:Number = Math.sqrt(2);
		
		private var g_alphas:Array = [10,100,10];
		private var g_ratios:Array = [0x0,0x7F,0xFF];
		private var radians:Number = 0;
		private var g_matrix:Matrix;
		
		private var howManyReflections:Number = 5;
		
		private var nbrSprites:Number = 3;
		private var spritePeriod:Number = 200;
		private var minSpriteRad:Number = 600/16;
		private var maxSpriteRad:Number = 600/4;
		private var maxYTravel:Number = 600/6;
		private var maxXTravel:Number = 600/3;
		private var sprites:Array = new Array(nbrSprites);
		
		private var n:int = 0;
		
		private var container:Sprite;
		private var containerMask:Sprite;
		private var bgMC:Sprite;
		private var containrtSpr:Array;
		private var sIdx:Array;
		
		public function KaleidoscopeEXP(_index:int)
		{
			super();
			index = _index;
			g_matrix = new Matrix();
			g_matrix.createGradientBox(100,100,radians,0,0);
		}
		
		public function init():void
		{
			container = FlashStage.EQbackSprite;
			
			containrtSpr = [];
			sIdx = [];
			
			var i:int;
			
			for(var j:int = 0; j < nbrSprites; ++j) 
			{
				for(i = 0; i < howManyReflections; ++i) 
				{
					var	nam:String = "obj_" + i + "_" + j;
					var spr:Sprite =  new Sprite();
					container.addChild(spr);
					spr.rotation = i*360/howManyReflections;
					spr.name = nam;
					spr.addEventListener(Event.ENTER_FRAME,drawSprite);
					sIdx[nam] = j;
					containrtSpr[nam] = spr;
					n++;
					nam = "objR_" + i + "_" + j;
					spr = new Sprite();
					container.addChild(spr);
					spr.scaleX = -100;
					spr.rotation = i*360/howManyReflections;
					spr.name = nam;
					spr.addEventListener(Event.ENTER_FRAME,drawSprite);
					sIdx[nam] = j;
					containrtSpr[nam] = spr;
					n++;
				}
			}
			
			for (i = 0; i < nbrSprites; ++i) 
			{
				sprites[i] = new Array();
				sprites[i].ctr = (i * spritePeriod) / nbrSprites;
				randomizeSprite(i);
			}
			container.addEventListener(Event.ENTER_FRAME,updateSprites);
			
			var containerParent:Sprite = Sprite(container.parent);
			containerMask = containerParent.addChildAt(new Sprite(),containerParent.getChildIndex(container)+1) as Sprite;
			containerMask.x = container.x;
			containerMask.y = container.y;
			container.mask = containerMask;
			containerMask.graphics.beginFill(0);
			containerMask.graphics.drawCircle(0,0,300);
		}
		
		public function unRender():void
		{
			container.rotation = 0;
			while(container.numChildren != 0)
			{
				container.removeChildAt(0);
			}
		}
		
		public function render(backShape:Sprite,frontShape:Shape,byteArray:ByteArray):void
		{
			
		}
		
		private function drawBGCircle(g:Graphics):void
		{
			var sRad:Number = 150;
			var alphas:Array = [100,0];
			var ratios:Array = [0xAA,0xFF];
		  	var colors:Array = [0,0];
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(sRad*2,sRad*2,0,-sRad,-sRad);
			g.moveTo(-sRad,-sRad);
		  	g.beginGradientFill(GradientType.RADIAL,colors,alphas,ratios,matrix);
			g.lineTo(sRad,-sRad);
			g.lineTo(sRad,sRad);
			g.lineTo(-sRad,sRad);
			g.lineTo(-sRad,-sRad);
			g.endFill();
		}
		
		private function drawArc(g:Graphics,x:Number,y:Number,radius:Number,ba:Number,ea:Number):void
		{
			var a:Number = Math.tan(Math.PI/8);
			var r:Number = radius;
			var theta:Number = 45*degToRad;
			var cr:Number = radius/Math.cos(theta/2);
			var angle:Number = (ba+45)*degToRad;
			var cangle:Number = angle-theta/2;
			var n:Number = (ea-ba)/45;
			for (var i:Number=0;i < n;i++,angle += theta,cangle += theta) 
			{
				var endX:Number = r*Math.cos (angle);
				var endY:Number = r*Math.sin (angle);
				var cX:Number = cr*Math.cos (cangle);
				var cY:Number = cr*Math.sin (cangle);
				g.curveTo(cX+x,cY+y, endX+x,endY+y);
			}
		}
		
		private function drawNegArc(g:Graphics,x:Number,y:Number,radius:Number,ba:Number,ea:Number):void
		{
			var a:Number = Math.tan(Math.PI/8);
			var r:Number = radius;
			var theta:Number = 45*degToRad;
			var cr:Number = radius/Math.cos(theta/2);
			var angle:Number = (ba+45)*degToRad;
			var cangle:Number = angle-theta/2;
			var n:Number = (ea-ba)/45;
			for (var i:Number=0;i < n;i++,angle += theta,cangle += theta) 
			{
				var endX:Number = r*Math.cos(angle);
				var endY:Number = r*Math.sin(angle);
				var cX:Number = cr*Math.cos(cangle);
				var cY:Number = cr*Math.sin(cangle);
				g.curveTo(x+cX,y-cY,x+endX,y-endY);
			}
		}
		
		private function drawYin(g:Graphics,x:Number,y:Number,radius:Number,fC:Number,fA:Number,withHole:Boolean):void
		{
			var rad2:Number = radius/2;
			g.moveTo(x+radius,y);
		  	var colors:Array = [fC,fC,0xFFFFFF-fC];
		  	g.beginGradientFill("radial",colors,g_alphas,g_ratios,g_matrix);
			drawArc(g, x, y, radius, 0, 180);
			drawArc(g, x-rad2,y, rad2, 180, 360);
			drawNegArc(g, x+rad2,y, rad2, 180, 360);
			if (withHole) {
				var radC:Number = rad2*(sqrt2-1);
				g.moveTo(x+radC-rad2,y);
				drawArc(g, x-rad2, y, radC, 0, 360);
			}
			g.endFill()
		}
		
		private function drawYang(g:Graphics,x:Number,y:Number,radius:Number,fC:Number,fA:Number,withHole:Boolean):void
		{
			var rad2:Number = radius/2;
			g.moveTo(x-radius,y);
		    var colors:Array = [fC,fC,0xFFFFFF-fC];
		    g.beginGradientFill("linear",colors,g_alphas,g_ratios,g_matrix);
			drawArc(g, x, y, radius, 180, 360);
			drawArc(g, x+rad2,y, rad2, 0, 180);
			drawNegArc(g, x-rad2,y, rad2, 0, 180);
			if (withHole) {
				var radC:Number = rad2*(sqrt2-1);
				g.moveTo(x+rad2+radC,y);
				drawArc(g, x+rad2, y, radC, 0, 360);
			}
			g.endFill()
		}
		
		private function drawCircle(g:Graphics,x:Number,y:Number,radius:Number,fC:Number,fA:Number):void
		{
			g.moveTo(x+radius,y);
			g.beginFill(fC,fA);
			drawArc(g, x, y, radius, 0, 360);
			g.endFill()
		}
		
		private function drawSprite(event:Event):void
		{
			var s:Sprite = Sprite(event.currentTarget);
			var g:Graphics = s.graphics;
			var spr:Object = sprites[sIdx[s.name]];
			g.clear();
			var x:Number = spr.sx;
			var y:Number = spr.sy;
			var rad:Number = spr.rad;
			var rad2:Number = rad/2;
			var radC:Number = rad2*(sqrt2-1);
			drawYin(g, x, y, rad, spr.tint, spr.sa, true);
		}
		
		private function randomizeSprite(i:int):void
		{
			sprites[i].tint = Math.floor(Math.random()*0xFFFFFF);
			sprites[i].tintb = Math.floor(Math.random()*0xFFFFFF);
			sprites[i].rad = minSpriteRad + Math.random()*(maxSpriteRad - minSpriteRad);
			sprites[i].spin = Math.random()*8*Math.PI;
			sprites[i].shape = Math.floor(Math.random()*5);
		}

		private function updateSprites(event:Event):void
		{
			container.rotation = container.rotation + 1;
			for (var i:int = 0; i < nbrSprites; ++i)
			{
				sprites[i].ctr++;
				if (sprites[i].ctr > spritePeriod)
				{
					sprites[i].ctr = 0;
					randomizeSprite(i);
				}
				var r:Number = sprites[i].ctr / spritePeriod;
				sprites[i].r = r;
				sprites[i].sx = -Math.cos(r*Math.PI*2)*maxXTravel;
				sprites[i].sy = Math.sin(r*Math.PI*2)*maxYTravel;
				sprites[i].sa = Math.sin(r*Math.PI) * 100;
				sprites[i].cx = Math.cos(r*sprites[i].spin);
				sprites[i].cy = -Math.sin(r*sprites[i].spin);
			}
		}

	}
}