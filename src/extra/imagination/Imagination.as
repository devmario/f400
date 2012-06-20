package extra.imagination
{
	import classes.FlashStage;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;

	public class Imagination
	{
		[Embed(source="../../../asset/circle_alpha.png")]
		private var circle_C:Class;
		
		private var practal_sprite:Sprite;
        
		public var lineLength:Number = 50;
		public var bMode:Boolean = true;
		public var yMax:Number = 400;
		public var xMax:Number = 930/2;
		public var cMode:Boolean = false;
		public var rMax:Number = 300;
		public var xTension:Number = -.98;
		public var yTension:Number = .5;
		public var V:Number = 2;
		public var smallestWidth:Number = 5;
		public var maxestWidth:Number = 5;
		public var sinAdd:Number =.2;
		
		public var p:Array = new Array();
		private var count:Number = 0;
		
		private var rnd:Function = Math.random;
		private var sin:Function = Math.sin;
		
		public var r:Number = 0;
		public var g:Number = 127;
		public var b:Number = 255;
		public var w:Number = 0;
		public var ri:Number = 0.025;
		public var gi:Number = 0.025;
		public var bi:Number = 0.025;
		
		public var rm:Number = 58+41;
		public var gm:Number = 58+41;
		public var bm:Number = 58+41;
		
		public var ra:Number = 197-41;
		public var ga:Number = 197-41;
		public var ba:Number = 197-41;
		
		private var vx:Number,oldx:Number;
		private var vy:Number,oldy:Number;
		
		public var point:Point=new Point();
		
		public var index:int;
		
		public function Imagination(_index:int)
		{
			super();
			
			index = _index;
			
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
		
			count = 0;
			
			practal_sprite = FlashStage.EQbackSprite;
			
			p = [];
			p[count] = {x: point.x, y: point.y, vx: point.x / 2, vy: point.y / 2, w: 0, col: 0,
		    			practal:false,
		    			practalSize:0,
		    			practalPT:null,
		    			practalP:false};
		    
			++count;
			vx = oldx = point.x;
			vy = oldy = point.y;
		}
		
		public function unRender():void
		{
			if(practal_sprite)
			{
				while(practal_sprite.numChildren != 0)
				{
					practal_sprite.removeChildAt(0);
				}
			}
		}
		
		private var widthLine:Number = 0;
		private var angle:Number = 0;
		public function render(backShape:Sprite,frontShape:Shape,byteArray:ByteArray):void{
			try{
				
				ri = gi = bi = 0.05 * FlashStage._eq_color;
			SoundMixer.computeSpectrum( byteArray, true, 0 );
			
			var value: Number;
			
			var smooth: Number;
			
			
			for( var i: int = 0 ; i < 256 ; i++ )
			{
				value = byteArray.readFloat();
				
				
				if( i == 0 ) smooth = value;
				else smooth += ( value - smooth ) / 8;
				if(i==0){
					V = Math.pow(smooth*10,2)*(0.5+FlashStage._eq_power);
					addCircleP((0.5+FlashStage._eq_scale)*smooth * 100);
				}
			}
			
			
			
			angle += 0.1 * FlashStage._eq_speed + 0.005;
			
			point.x = Math.sin(angle) * 200;
			point.y = Math.cos(angle) * 200;
			
			vx = point.x - oldx + rnd() * V - V*.5;
		    vy = point.y - oldy + rnd() * V - V*.5;
		    
		    oldx = point.x;
		    oldy = point.y;
		    p[count] = {x: point.x, 
		    			y: point.y, 
		    			vx: vx * .5, 
		    			vy: vy * .5, 
		    			w: (sin(w += sinAdd) * maxestWidth + smallestWidth), 
		    			col: sin(r += ri) * rm + ra << 16 | sin(g += gi) * gm + ga << 8 | sin(b += bi) * bm + ba,
		    			practal:false,
		    			practalSize:0,
		    			practalPT:null,
		    			practalP:false};
		    ++count;
		    practal_sprite.graphics.clear();
		    backShape.graphics.clear();
		    backShape.graphics.moveTo(point.x, point.y);
		    var __reg2:Number = p.length;
		    for (;;) 
		    {
		        if (!(__reg2--)) 
		        {
		            return;
		        }
				var lineAlpha:Number = __reg2 > p.length/2 ? 1 : 1 - ((p.length/2-__reg2)/(p.length/2));
		        backShape.graphics.lineStyle(p[__reg2].w*(__reg2/p.length)*(0.5+FlashStage._eq_scale), p[__reg2].col,lineAlpha);
		        p[__reg2].x = p[__reg2].x + p[__reg2].vx;
		        p[__reg2].y = p[__reg2].y + p[__reg2].vy;
		        if(bMode)
		        {
		        	if (p[__reg2].y > yMax) 
			        {
			            p[__reg2].y = yMax;
			        	p[__reg2].vy = p[__reg2].vy * xTension;
			            p[__reg2].vx = p[__reg2].vx * yTension;
			        }
			        
		        }
		        if(cMode)
		        {
		        	var centerPoint:Point=new Point(0,0);
		        	var mPoint:Point=new Point(p[__reg2].x,p[__reg2].y);
		        	var distance:Number=Point.distance(centerPoint,mPoint);
		        	if(distance > rMax)
		        	{
		        		var multiPoint:Point=Point.interpolate(mPoint,centerPoint,rMax/distance);
		        		p[__reg2].x = multiPoint.x;
		        		p[__reg2].y = multiPoint.y;
			        	p[__reg2].vy = p[__reg2].vy * xTension;
			            p[__reg2].vx = p[__reg2].vx * yTension;
		        	}
		        }
		        
		        if (__reg2) 
		        {
		            backShape.graphics.curveTo(p[__reg2].x, p[__reg2].y, (Number(p[__reg2].x) + Number(p[__reg2 - 1].x)) / 2, (Number(p[__reg2].y) + Number(p[__reg2 - 1].y)) / 2);
		        	if(p[__reg2].practal){
		        		practal_sprite.graphics.beginFill(0);
		        		practal_sprite.graphics.drawCircle(p[__reg2].x, p[__reg2].y,p[__reg2].practalSize*(__reg2/p.length));
		        	}
		        	if(p[__reg2].practalP){
		        		p[__reg2].practalPT.x=p[__reg2].x-p[__reg2].practalPT.width/2;
		        		p[__reg2].practalPT.y=p[__reg2].y-p[__reg2].practalPT.height/2;
		        		p[__reg2].practalPT.width=p[__reg2].practalPT.height=p[__reg2].practalSize*(__reg2/p.length);
		        	}
		        }
		
		        if (p.length > lineLength) 
		        {
		        	if(p[0].practalPT)
		        		practal_sprite.removeChild(p[0].practalPT);
		            p.splice(0, 1);
		            --count;
		        }
		    } 
		 }catch(e:Error){}
		}
		
		public function addCircle(force:Number):void{
			p[p.length - 1].practal=true;
			p[p.length - 1].practalSize=force;
		}
		
		public function addCircleP(force:Number):void{
			var dis:DisplayObject=practal_sprite.addChild(new circle_C());
			var col:ColorTransform=new ColorTransform();
			col.color=p[p.length - 1].col;
		   	dis.transform.colorTransform=col;
			p[p.length - 1].practalP=true;
			p[p.length - 1].practalPT=dis;
			p[p.length - 1].practalSize=force;
    		p[p.length - 1].practalPT.width=p[p.length - 1].practalPT.height=p[p.length - 1].practalSize*((p.length - 1)/p.length);
    		p[p.length - 1].practalPT.x=p[p.length - 1].x-p[p.length - 1].practalPT.width/2;
    		p[p.length - 1].practalPT.y=p[p.length - 1].y-p[p.length - 1].practalPT.height/2;
		}
		
		
	}
}