package extra.delicateNote
{
	import classes.FlashStage;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;

	public class DelicateNote
	{
		public var action:Array = [];
		public var spectrum:Array;
		public var maxSpectrum:Array;
	    
	    private static var res: Number = 80;
	    private static var a: Number = 100;
	    private static var b: Number = 1;
	    private static var bk: Number = 1.015;
	    private static var reactPow: Number = 0.8;
	    private static var reactRange: Number = 4;
	    private static var mmin: Number = 40;
	    private var _y:Array;
	    private var gridx:Number;
	    private var k:Number;
	    private var m:Object;
	    private var mx:Number;
	    private var mx0:Number;
	    private var my:Number;
	    private var my0:Number;
	    private var vx:Array;
	    private var vy:Array;
	    private var _x:Array;
	    private var x0:Array;
	    private var x_right:Number;
	    private var y0:Array;
	    private var y_bottom:Number;
	    
		private var pow:Number = 0.6;
	    
	    public var rq:Number = 0;
		public var gq:Number = 127;
		public var bq:Number = 255;
		public var wq:Number = 0;
		public var riq:Number = 0.05;
		public var giq:Number = 0.05;
		public var biq:Number = 0.05;
		
		public var rmq:Number = 58+40;
		public var gmq:Number = 58+40;
		public var bmq:Number = 58+40;
		
		public var raq:Number = 197-40;
		public var gaq:Number = 197-40;
		public var baq:Number = 197-40;
		
		public var stageWidth:Number = 940;
		public var stageHeight:Number = 480;
		public var index:int;
		
		private var practal_sprite:Sprite;

		public function DelicateNote(_index:int)
		{
			super();
			index = _index;
			practal_sprite = FlashStage.EQbackSprite;
		}
		private var notesSp:Array = [];
		private var noteG:Array = [];
		
		public function init():void
		{
			FlashStage.initEQbitmap();
			FlashStage.EQbackSprite.x = FlashStage.EQbackShape.x = FlashStage.EQfront.x = 0;
			FlashStage.EQbackSprite.y = FlashStage.EQbackShape.y = FlashStage.EQfront.y = 480/2 - 100;
			FlashStage.EQbackSprite.graphics.clear();
			FlashStage.EQbackShape.graphics.clear();
			FlashStage.EQfront.graphics.clear();
			while(FlashStage.EQbackSprite.numChildren != 0)
			{
				FlashStage.EQbackSprite.removeChildAt(0);
			}
			
			spectrum = [];
			maxSpectrum = [];
			var i:uint;
			for(i = 0;i<256;i++)
			{
				spectrum[i] = maxSpectrum[i] = 0;
			}
			maxSpectrum[0] = 0;
			for(i = 0;i < res;i++)
			{
				wArray[i] = 0;
				cArray[i] = Math.sin(rq += riq) * rmq + raq << 16 | Math.sin(gq += giq) * gmq + gaq << 8 | Math.sin(bq += biq) * bmq + baq;
			}
			this.k = 0.07 + 0.05;
	        this.mx = 0;
	        this.my = 0;
	        this.m = {};
	        this._x = [];
	        this._y = [];
	        this.y0 = [];
	        this.x0 = [];
	        this.vy = [];
	        this.vx = [];
	        this.x_right = stageWidth;
	        this.y_bottom = stageHeight;
	        this.gridx = this.x_right / res;
	        var __reg3:Number = 0;
	        while (__reg3 <= res) 
	        {
	        	spectrum[__reg3] = 0;
	            this._x[__reg3] = this.gridx * __reg3;
	        	noteG[__reg3] = {x:this._x[__reg3],y:0,vx:0,vy:0,r:5};
	            this._y[__reg3] = 0;
	            this.x0[__reg3] = this._x[__reg3];
	            this.y0[__reg3] = this._y[__reg3];
	            this.vx[__reg3] = 0;
	            this.vy[__reg3] = 0;
	            ++__reg3;
	        }
		}
	
		private var wArray:Array = [];
		private var cArray:Array = [];
		
		private var xArray:Array = [];
		
		private var avr:Number = 0;
		private var maxAvr:Number = 0;
		
		private var toque:Number = 0;
		private var toqueB:Boolean = false;
		private var preToque:Number = 0;
		
		public function unRender():void
		{
		}
		
		public function render(backShape:Sprite,frontShape:Shape,byteArray:ByteArray):void
		{
			try{
			if(byteArray)
			{
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
			}
			
			var sigma:Number = 0;
			for(i = 0;i < 40;i++)
			{
				sigma += spectrum[i];
			}
			avr = isNaN(sigma / 40 * 30) ? 0:sigma / 40 * 30;
  			if(avr > maxAvr){
				maxAvr = avr;
			}
			else
			{
				maxAvr += (0 - maxAvr) / 5;
			}
	     	bk = 1.06 - avr/30*0.06;
	     	toque = avr;
			var sm:Object = {};
			sm.x = 0;
			sm.y = -toque+1;
			react(sm);
  			this.mx0 = this.mx;
	        this.my0 = this.my;
	        this.mx = this.mx-3;
	        if(this.mx<0)
	        	this.mx = stageWidth;
	        if(this.mx>stageWidth)
	        	this.mx = 0;
	        this.my = sm.y;
	        var __reg2:Number = this.my - this.my0;
       	 	var __reg3:Number = this.mx - this.mx0;
        	this.m.x = Math.max(Math.min(__reg3, mmin), 0 - mmin);
	        this.m.y = Math.max(Math.min(__reg2, mmin), 0 - mmin);
	        this.spring();
	        this.movePoint();
		   	this.drawCurve(frontShape,frontShape);
		 }catch(e:Error){}
	        
		}
		
		private function spring():void
	    {
	       var __reg2:Number = 0;
	        for (;;) 
	        {
	            if (__reg2 > res) 
	            {
	                return;
	            }
	            if (__reg2 == 0) 
	            {
	                __reg3 = this._y[__reg2 + 1] - this._y[__reg2];
	                __reg4 = this._x[__reg2 + 1] - this._x[__reg2];
	            }
	            else 
	            {
	                if (__reg2 == res) 
	                {
	                    __reg3 = this._y[__reg2 - 1] - this._y[__reg2];
	                    __reg4 = this._x[__reg2 - 1] - this._x[__reg2];
	                }
	                else 
	                {
	                    var __reg3:Number = this._y[__reg2 + 1] + this._y[__reg2 - 1] - 2 * this._y[__reg2];
	                    var __reg4:Number = this._x[__reg2 + 1] + this._x[__reg2 - 1] - 2 * this._x[__reg2];
	                }
	
	            }
	            var __reg5:Number = __reg3 * this.k;
	            var __reg6:Number = __reg4 * this.k;
	            this.vy[__reg2] = (this.vy[__reg2] + __reg5) / bk;
	            this.vx[__reg2] = (this.vx[__reg2] + __reg6) / bk;
	            ++__reg2;
	        } 
	
	    }
	
	    private function movePoint():void
	    {
	        var __reg4:Number = 0;
	        var __reg3:Number = 0;
	        var __reg2:Number = 0;
	        for (;;) 
	        {
	            if (__reg2 > res) 
	            {
	                return;
	            }
	            this._y[__reg2] = this._y[__reg2] + this.vy[__reg2];
	            this.vy[__reg2] = (this.vy[__reg2] + (this.y0[__reg2] - this._y[__reg2]) / a) / b;
	            if (__reg2 != 0 && __reg2 != res) 
	            {
	                this._x[__reg2] = this._x[__reg2] + this.vx[__reg2];
	                this.vx[__reg2] = (this.vx[__reg2] + (this.x0[__reg2] - this._x[__reg2]) / a) / b;
	            }
	            else 
	            {
	                this.vx[__reg2] = 0;
	            }
	            ++__reg2;
	        }
	
	    }
	
	    private function react(mt:Object):void
	    {
	    	
	    	var __reg11:Number = Math.round(this.mx / this.gridx);
	        var __reg10:Number = Math.ceil(reactRange * Math.abs(mt.y) / 20);
	        var __reg9:Number = Math.abs(mt.y / 8) + 3;
	        var __reg3:Number = 0;
	        for (;;) 
	        {
	            if (__reg3 > res) 
	            {
	                return;
	            }
	            var __reg7:Number = Math.abs(__reg11 - __reg3);
	            var __reg8:Number = Math.max((__reg10 - __reg7) / __reg10, 0) * 3.14159 - 1.5708;
	            var __reg6:Number = (Math.sin(__reg8) + 1) / 2;
	            var __reg4:Number = (pow * reactPow * mt.y * __reg6 + (__reg9 - __reg9 / 2)) * stageWidth / 1000;
	            this.vy[__reg3] = this.vy[__reg3] + __reg4;
	            this.vx[__reg3] = this.vx[__reg3] + __reg4 * mt.x / mt.y / 3;
	            ++__reg3;
	        }
	    }
		private var rota:Number = 0;
		private var wq1:Number = 0;
		private var countRes:Number = 0;
	    private function drawCurve(backShape:Shape,frontShape:Shape):void
	    {
	    	for(var q:uint = 0;q<spectrum.length;q++)
	    	{
	    		if(spectrum[q] > maxSpectrum[q])
	    		{
	    			maxSpectrum[q] = spectrum[q];
	    		}else
	    		{
	    			maxSpectrum[q] -= 0.005;
	    		}
	    	}
	    	wq1 += (Math.pow(avr/4,1.5)-wq1)/5;
			riq = giq = biq = 0.01-(maxAvr/400);
	    	var colorRGB:uint = Math.sin(rq += riq) * rmq + raq << 16 | Math.sin(gq += giq) * gmq + gaq << 8 | Math.sin(bq += biq) * bmq + baq;
	    	cArray.push(colorRGB);
	    	cArray.splice(0,1);
	    	wArray.push(wq1);
	    	wArray.splice(0,1);
	        backShape.graphics.clear();
	        var lineWidth:Number = 5;
	        backShape.graphics.lineStyle(1,0x000000,0.1);
	        backShape.graphics.moveTo(this.mx,-stageHeight/2 - 200);
	        backShape.graphics.lineTo(this.mx,stageHeight/2 + 200);
	        backShape.graphics.lineStyle(wq1,cArray[0]);
	        backShape.graphics.moveTo(this._x[0], this._y[0]);
	        backShape.graphics.lineTo((this._x[0] + this._x[1]) / 2, (this._y[0] + this._y[1]) / 2);
	        var __reg2:Number = 1;
        	practal_sprite.graphics.clear();
        	practal_sprite.graphics.lineStyle(0,0,0);
	        while (__reg2 < res) 
	        {
		        noteG.push({col:cArray[__reg2],x:this._x[__reg2],y:this._y[__reg2],vx:this.vx[__reg2],vy:this.vy[__reg2],r:maxAvr,height:0,i:Math.floor(Math.random()*50)});
		    	noteG.splice(0,1);
	        	colorRGB += 5;
	        	noteG[__reg2].x += noteG[__reg2].vx*10;
	        	noteG[__reg2].y += noteG[__reg2].vy*10;
	        	noteG[__reg2].r = noteG[__reg2].r/1.2;
	        	noteG[__reg2].height = 5;
	        	practal_sprite.graphics.beginFill(noteG[__reg2].col);
	        	practal_sprite.graphics.drawRect(noteG[__reg2].x-6,noteG[__reg2].y,12,noteG[__reg2].height);
	        	practal_sprite.graphics.endFill();
	        	backShape.graphics.lineStyle(wq1,cArray[__reg2]);
	            backShape.graphics.curveTo(this._x[__reg2], this._y[__reg2], (this._x[__reg2] + this._x[__reg2 + 1]) / 2, (this._y[__reg2] + this._y[__reg2 + 1]) / 2);
	            ++__reg2;
	        }
	        backShape.graphics.lineTo(this._x[res], this._y[res]);
	    }
	}
}