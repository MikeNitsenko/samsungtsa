package events.Model
{
	import flash.events.Event;
	
	public class AdjustRecordEvent extends Event
	{
		public static var ADJUST_EVENT:String = "adjustEvent";
		private var _data:int;
		
		public function AdjustRecordEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:int=-1)
		{
			super(type, bubbles, cancelable);
			_data = data;
		}
		
		override public function clone():Event
		{
			return new AdjustRecordEvent(type, bubbles, cancelable, data);
		}
		
		public function get data():int
		{
			return _data;
		}
	}
}