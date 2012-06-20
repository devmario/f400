package extra.particle{

	import classes.FlashStage;

	public class SimpleParticleGenerator{

		private var _speed:Number;
		private var _angleDeg:Number = -90;
		public var _particles:Array;
		
		public var index:int;
		
		public var thisX:Number = 0;
		public var thisY:Number = 0;
		
		public var _color:uint;
		
		public var AnlgeB:Boolean = false;
		
		public function SimpleParticleGenerator(color:uint) {
			_particles = new Array();
			_color = color;
			/* var timer:Timer=new Timer(10, 0);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start(); */
		}
		
		public function addParticle():void {
			var __scale:Number=1+FlashStage._eq_scale*3;

			var __gravSpeed:Number=0;
			var __acc:Number=0;
			
			var __spread:Number
			
			__spread = Math.random()*10;
			__spread -= 5;
			
			var __angle:Number=(angleDeg+__spread) / 180 * Math.PI;
			var __age:uint=0;
			
			var __speed:Number = Math.random()*(speed*.2)+speed*.8;
			
			_particles.push({x:0,y:0,alpha:1,gravSpeed:__gravSpeed,acc:__acc,spread:__spread,speed:__speed,angle:__angle,scale:__scale,age:__age});
		}
		
		public function render():void
		{
			var i:uint;
			for( i = 0 ; i < FlashStage._eq_power*5 ; i++)
			{
				addParticle();
			}
				
			var gravAcc:Number=0.8;
			for (i=0; i<_particles.length; i++) {
				var t:Object = _particles[i];
				t.speed += t.acc;
				t.gravSpeed += gravAcc;
				t.scale = t.scale*0.95;
				var incx:Number = Math.cos(t.angle)*t.speed;
				t.x += incx;
				t.y += Math.sin(t.angle)*t.speed;
				t.y += Math.sin(90)*t.gravSpeed;
				t.age++;
				t.alpha = t.scale;
				if(t.alpha < 0)
				{
					t.alpha = 0;
				}
				FlashStage.EQbackShape.graphics.beginFill(_color,t.alpha);
				FlashStage.EQbackShape.graphics.drawCircle(t.x+thisX,t.y+thisY,3*t.scale);
				if (t.y>0 || t.scale < 0 || t.alpha <= 0) {
					_particles.splice(i, 1);
				}
			}
		}
		
		public function set speed(n:Number):void {
			_speed=n;
		}
		public function get speed():Number {
			return _speed;
		}
		
		public function set angleDeg(n:Number):void {
			_angleDeg=n;
		}
		public function get angleDeg():Number {
			return _angleDeg;
		}
	}
}
