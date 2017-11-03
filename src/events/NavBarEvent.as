package events
{
	import flash.events.Event;
	
	public class NavBarEvent extends Event
	{
		public static var BACK_EVENT:String = "backEvent";
		public static var NEXT_EVENT:String = "nextEvent";
		
		public function NavBarEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new NavBarEvent(type, bubbles, cancelable);
		}
		

	}
}


