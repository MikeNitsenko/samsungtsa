package events.Model
{
	import flash.events.Event;
	import mx.collections.ArrayCollection;
	
	public class QueryEvent extends Event
	{
		
		public static var DATA_LOADED:String = "dataLoaded";
		
		private var _data:ArrayCollection;
		
		public function QueryEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:ArrayCollection=null)
		{
			super(type, bubbles, cancelable);
			_data = data;
		}
		
		override public function clone():Event
		{
			return new QueryEvent(type, bubbles, cancelable, data);
		}
		
		public function get data():ArrayCollection
		{
			return _data;
		}
	}
}