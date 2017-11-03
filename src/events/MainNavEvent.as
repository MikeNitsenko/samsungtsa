package events
{
	import flash.events.Event;
	
	public class MainNavEvent extends Event
	{
		public static var BACK_EVENT:String = "mainBackEvent";
		public static var NEXT_EVENT:String = "mainNextEvent";
		
		private var _actionId:String; 
		
		public function MainNavEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, actionId:String="")
		{
			super(type, bubbles, cancelable);
			_actionId = actionId;
		}
		
		public function get actionId():String {
			return _actionId;
		}
		
		override public function clone():Event
		{
			return new MainNavEvent(type, bubbles, cancelable, actionId);
		}
		

	}
}


