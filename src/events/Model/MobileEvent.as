package events.Model
{
	import flash.events.Event;
	
	public class MobileEvent extends Event
	{
		
		public static var URL_LOADED:String = "urlLoaded";
		public static var FAULT:String = "fault";
		
		private var _url:String;
		
		public function MobileEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, url:String="")
		{
			super(type, bubbles, cancelable);
			_url = url;
		}
		
		override public function clone():Event
		{
			return new MobileEvent(type, bubbles, cancelable, url);
		}
		
		public function get url():String
		{
			return _url;
		}
	}
}