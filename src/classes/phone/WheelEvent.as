package classes.phone
{
	import flash.events.Event;

	public class WheelEvent extends Event
	{
		public var delta:int;
		
		public static const WHEEL:String = "wheel";
		
		public function WheelEvent(type:String, _delta:int, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			delta = _delta;
		}
		
	}
}