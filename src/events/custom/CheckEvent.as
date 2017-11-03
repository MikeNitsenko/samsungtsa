package events.custom
{
	import flash.events.Event;
	
	public class CheckEvent extends Event
	{
		public static var CHECK_EVENT:String = "checkEvent";
		public static var ADJUST_EVENT:String = "adjustEvent";
		private var _data:int;
		private var _text:String;
		
		public function CheckEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:int=-1, text:String="")
		{
			super(type, bubbles, cancelable);
			_data = data;
			_text = text;
		}
		
		override public function clone():Event
		{
			return new CheckEvent(type, bubbles, cancelable, data, text);
		}
		
		public function get data():int
		{
			return _data;
		}
		
		public function get text():String
		{
			return _text;
		}
	}
}