package events.Model
{
	import flash.events.Event;
	
	public class InsertProgressEvent extends Event
	{
		
		public static var PROGRESS:String = "progress";
		public static var FAULT:String = "fault";
		
		private var _status:String;
		private var _loaded:Number;
		private var _total:Number;
		
		public function InsertProgressEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, status:String="", loaded:Number = 0, total:Number = 0)
		{
			super(type, bubbles, cancelable);
			_status = status;
			_loaded = loaded;
			_total = total;
		}
		
		override public function clone():Event
		{
			return new InsertProgressEvent(type, bubbles, cancelable, status, loaded, total);
		}
		
		public function get status():String
		{
			return _status;
		}
		public function get loaded():Number
		{
			return _loaded;
		}
		public function get total():Number
		{
			return _total;
		}
	}
}