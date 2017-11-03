package events.Model
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	public class ExternalDataEvent extends Event
	{
		
		public static var DATA_LOADED:String = "externalDataLoaded";
		
		private var _data:ArrayCollection;
		private var _hasError:Boolean;
		private var _errorText:String;
		
		public function ExternalDataEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:ArrayCollection=null, hasError:Boolean=false, errorText:String="")
		{
			super(type, bubbles, cancelable);
			_data = data;
			_hasError = hasError;
			_errorText = errorText;
		}
		
		override public function clone():Event
		{
			return new ExternalDataEvent(type, bubbles, cancelable, data, hasError, errorText);
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