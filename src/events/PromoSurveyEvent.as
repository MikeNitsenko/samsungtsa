package events
{
	import flash.events.Event;
	
	public class PromoSurveyEvent extends Event
	{
		public static var FINISH_EVENT:String = "finishEventPromo";
		public static var DELETE_EVENT:String = "deleteEventPromo";
		public static var BACK_EVENT:String = "backEventPromo";
		public static var NEXT_EVENT:String = "nextEventPromo";
		
		public function PromoSurveyEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new PromoSurveyEvent(type, bubbles, cancelable);
		}
		

	}
}


