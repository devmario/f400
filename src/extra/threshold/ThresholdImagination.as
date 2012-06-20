package extra.threshold
{
	import flash.display.Shape;
	import flash.geom.Point;

	public class ThresholdImagination extends Shape
	{
        
		public var lineLength:Number = 70;
		public var bMode:Boolean = true;
		public var yMax:Number = 700;
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
		
		public var rm:Number = 58+40;
		public var gm:Number = 58+40;
		public var bm:Number = 58+40;
		
		public var ra:Number = 197-40;
		public var ga:Number = 197-40;
		public var ba:Number = 197-40;
		
		private var vx:Number,oldx:Number;
		private var vy:Number,oldy:Number;
		
		public var point:Point=new Point();
		
		public function ThresholdImagination()
		{
			super();
			p[count] = {x: point.x, y: mouseY, vx: point.x / 2, vy: mouseY / 2, w: 0, col: 0,
		    			practal:false,
		    			practalSize:0,
		    			practalPT:null,
		    			practalP:false};
			++count;
			vx = oldx = point.x;
			vy = oldy = point.y;
		}
		
		public function render():void{
			vx = point.x - oldx + rnd() * V - V*.5;
		    vy = point.y - oldy + rnd() * V - V*.5;
		    oldx = point.x;
		    oldy = point.y;
		    p[count] = {x: point.x, 
		    			y: point.y, 
		    			vx: vx * .5, 
		    			vy: vy * .5, 
		    			w: sin(w += sinAdd) * maxestWidth + smallestWidth, 
		    			col: sin(r += ri) * rm + ra << 16 | sin(g += gi) * gm + ga << 8 | sin(b += bi) * bm + ba,
		    			practal:false,
		    			practalSize:0,
		    			practalPT:null,
		    			practalP:false};
		    ++count;
		    this.graphics.clear();
		    this.graphics.clear();
		    this.graphics.moveTo(point.x, point.y);
		    var __reg2:Number = p.length;
		    for (;;) 
		    {
		        if (!(__reg2--)) 
		        {
		            return;
		        }
		
		        this.graphics.lineStyle(p[__reg2].w, p[__reg2].col);
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
		            this.graphics.curveTo(p[__reg2].x, p[__reg2].y, (Number(p[__reg2].x) + Number(p[__reg2 - 1].x)) / 2, (Number(p[__reg2].y) + Number(p[__reg2 - 1].y)) / 2);
		        	if(p[__reg2].practal){
		        		this.graphics.beginFill(0);
		        		this.graphics.drawCircle(p[__reg2].x, p[__reg2].y,p[__reg2].practalSize*(__reg2/p.length));
		        	}
		        	if(p[__reg2].practalP){
		        		p[__reg2].practalPT.x=p[__reg2].x-p[__reg2].practalPT.width/2;
		        		p[__reg2].practalPT.y=p[__reg2].y-p[__reg2].practalPT.height/2;
		        		p[__reg2].practalPT.width=p[__reg2].practalPT.height=p[__reg2].practalSize*(__reg2/p.length);
		        	}
		        }
		
		        if (p.length > lineLength) 
		        {
		            p.splice(0, 1);
		            --count;
		        }
		    } 
		}
		
		
	}
}