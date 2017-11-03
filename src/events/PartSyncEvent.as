package events
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	public class PartSyncEvent extends Event
	{
		
		public static var SYNC_RESULT:String = "syncCompleted";
		
		private var _data:ArrayCollection;
		private var _hasError:Boolean;
		private var _errorText:String;
		
		public function PartSyncEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:ArrayCollection=null, hasError:Boolean=false, errorText:String="")
		{
			super(type, bubbles, cancelable);
			_data = data;
			_hasError = hasError;
			_errorText = errorText;
		}
		
		override public function clone():Event
		{
			return new PartSyncEvent(type, bubbles, cancelable, data, hasError, errorText);
		}
		
		public function get data():ArrayCollection
		{
			return _data;
		}
		
		public function get hasError():Boolean
		{
			return _hasError;
		}
		
		public function get errorText():String 
		{
			return _errorText;
		}
	}
}