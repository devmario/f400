package extra.kaleidoscope
{
	import classes.FlashStage;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	
	public class KaleidoscopeExp2
	{
		private var deepFlag:Boolean = false;
	    private var _numMirrors:Number = 6;
	    private var _mirrorHeight:Number = 150;
	    private var _bd:BitmapData;
	    private var _bitmap:BitmapData;
	    private var _blockClip:DisplayObject;
	    private var _colorCount:Number;
	    private var _contentClip:DisplayObject;
	    private var _currentColor:Number;
	    private var _height:Number = 400;
	    private var _imageData:String;
	    private var _imageHeight:Number;
	    private var _imageWidth:Number;
	    private var _mirrorAngle:Number;
	    private var _paneList:Array;
	    private var _pixelCount:Number;
	    private var _scanID:uint;
	    private var _totalPixels:Number;
	    private var _translate:Matrix;
	    private var _width:Number = 400;
	    private var _xscale:Number = 1;
	    private var _yscale:Number = 1;
	    private var height:Number;
	    private var width:Number;
		
		public var index:int;
		
		public var container:Sprite;
		
		public var paneSprite:Array;
		
	    public function KaleidoscopeExp2(_index:int)
	    {
	        super();
	        
	        index = _index;
	        
	        container = FlashStage.EQbackSprite;
	        
	        width = _width;
	        height = _height;
	        
	        _mirrorHeight = _width / 2;
	        
	        _xscale = _yscale = 1;
	        
	        setMirrorPairs(this._numMirrors / 2);
	        
	        _paneList = [];
	        paneSprite = [];
	        
	        _translate = new Matrix();
	        _translate.translate(this.width / 2, this.height / 2);
	    }
	
	    public function setContentClip(contentClip:DisplayObject):void
	    {
	        _contentClip = contentClip;
	    }
	
	    public function update():void
	    {
	        var __reg6:Number;
	        var __reg2:Number;
	        var __reg4:Shape;
	        var __reg3:Sprite;
	        var __reg7:Sprite;
	        var __reg5:Number = _mirrorAngle * Math.PI / 180;
	        __reg6 = _paneList.length;
	        __reg2 = 0;
	        while (__reg2 < __reg6) 
	        {
	        	container.removeChildAt(0);
	            ++__reg2;
	        }
	        _paneList = [];
	        paneSprite = [];
	        if(_bd)
	       		_bd.dispose();
	        _bd = new BitmapData(width, height, true, 16777215);
	        __reg2 = 0;
	        while (__reg2 < _numMirrors) 
	        {
	        	var sprite:Sprite = container.addChild(new Sprite()) as Sprite;
	            _paneList[__reg2] = sprite;
	            __reg4 = sprite.addChild(new Shape()) as Shape;
	            __reg4.graphics.beginFill(0);
	            __reg4.graphics.lineTo(-100,-100);
	            __reg4.graphics.lineTo(100,-100);
	            __reg4.graphics.lineTo(0,0);
	            __reg4.graphics.endFill();
	            __reg4.height = height / 2;
	            __reg4.width = Math.tan(__reg5 / 2) * height / 2 * 2;
	            __reg4.rotation = __reg2 * _mirrorAngle + _mirrorAngle / 2 + 90;
	            __reg3 = sprite.addChild(new Sprite()) as Sprite;
	            paneSprite[__reg2] = __reg3;
	            __reg7 = __reg3.addChild(new Sprite()) as Sprite;
	            __reg7.x = width / -2;
	            __reg7.y = height / -2;
	            __reg7.addChild(new Bitmap(_bd,PixelSnapping.AUTO,true));
	            __reg3.rotation = __reg2 * _mirrorAngle;
	            if (__reg2 % 2 == 1) 
	            {
	                __reg3.scaleX = -1;
	                __reg3.rotation = __reg3.rotation + _mirrorAngle * (_numMirrors / 2 + 1);
	            }
	            __reg3.mask = __reg4;
	            sprite.cacheAsBitmap = true;
	            ++__reg2;
	        }
	        var __reg8:BitmapData = new BitmapData(width, height, true, 16777215);
	        _bd.draw(_contentClip, _translate);
	    }
	
	    public function setMirrorPairs(value:Number):void
	    {
	        this._numMirrors = value * 2;
	        this._mirrorAngle = 360 / this._numMirrors;
	    }
	
	    public function getMirrorAngle():Number
	    {
	        return this._mirrorAngle;
	    }
	
	    public function encodeBitmap():Boolean
	    {
	        if (this._scanID == 0) 
	        {
	            this._bitmap = new BitmapData(this.width, this.height, false, 0);
	            this._bitmap.draw(container, this._translate);
	            this._imageWidth = this.width;
	            this._imageHeight = this.height;
	            this._totalPixels = this.width * this.height;
	            this._imageData = this._imageWidth + "," + this._imageHeight + ",";
	            this._currentColor = NaN;
	            this._colorCount = 1;
	            this._pixelCount = 0;
	            this._scanID = setInterval(scanBitmap, 30);
	            return true;
	            return;
	        }
	        return false;
	    }
	
	    public function scanBitmap():void
	    {
	        var __reg5:int = getTimer();
	        var __reg4:Number;
	        var __reg3:Number;
	        var __reg2:Number;
	        while (getTimer() - __reg5 < 25 && this._pixelCount < this._totalPixels) 
	        {
	            __reg3 = Math.floor(this._pixelCount / this._imageWidth);
	            __reg4 = this._pixelCount - __reg3 * this._imageWidth;
	            __reg2 = this._bitmap.getPixel(__reg4, __reg3);
	            if (__reg2 != this._currentColor && !isNaN(this._currentColor)) 
	            {
	                this._imageData = this._imageData + (this.zeroPad(this._currentColor.toString(16), 6) + this._colorCount + ",");
	                this._colorCount = 1;
	            }
	            else 
	            {
	                ++this._colorCount;
	            }
	            this._currentColor = __reg2;
	            ++this._pixelCount;
	        }
			if (this._pixelCount == this._totalPixels) 
	        {
	            clearInterval(this._scanID);
	            this._scanID = 0;
	            this._imageData = this._imageData + (this.zeroPad(this._currentColor.toString(16), 6) + this._colorCount);
	            return;
	        }
	    }
	
	    public function zeroPad(str:String, num:Number):String
	    {
	        while (str.length < 6) 
	        {
	            str = "0" + str;
	        }
			return str;
	    }
	
	    public function rotatePanes():void
	    {
	        var __reg3:Number = this._paneList.length;
	        var __reg2:Number;
	        __reg2 = 0;
	        while (__reg2 < __reg3) 
	        {
	            if (__reg2 % 2 == 1) 
	            {
	                paneSprite[__reg2].rotation += 1;
	            }
	            else 
	            {
	                paneSprite[__reg2].rotation -= 1;
	            }
	            ++__reg2;
	        }
	    }
	}
}

