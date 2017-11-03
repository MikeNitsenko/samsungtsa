package events
{
	import flash.events.Event;

	public class ImageCheckedEvent extends Event
	{
		public static var CHECK_EVENT:String = "IMAGE_CHECKED_EVENT";
		private var _data:int;
		private var _text:String;
		
		public function ImageCheckedEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:int=-1, text:String="")
		{
			super(type, bubbles, cancelable);
			_data = data;
			_text = text;
		}
		
		override public function clone():Event
		{
			return new ImageCheckedEvent(type, bubbles, cancelable, data, text);
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