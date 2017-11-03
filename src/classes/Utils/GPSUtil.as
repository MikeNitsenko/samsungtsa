package classes.Utils
{
	import com.distriqt.extension.dialog.Dialog;
	import com.distriqt.extension.location.AuthorisationStatus;
	import com.distriqt.extension.location.Location;
	import com.distriqt.extension.location.LocationRequest;
	import com.distriqt.extension.location.Position;
	import com.distriqt.extension.location.events.AuthorisationEvent;
	import com.distriqt.extension.location.events.LocationEvent;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	
	import spark.collections.Sort;
	import spark.collections.SortField;
	
	import classes.Globals;

	public class GPSUtil extends EventDispatcher
	{
		public static var LAT:String = "0";
		public static var LON:String = "0";
		public static var ACCURACY:String = "0";
		public static var GPS_PROVIDER:String = "location";
		public static var GPS_UPDATE_INTERVAL:int = 1000;
		public static var GPS_COUNTER:int = 0;
		public static var GPS_ENABLED:Boolean = false;
		public static var GPS_ARRAY:ArrayCollection = new ArrayCollection();
		private static var dispatcher:EventDispatcher = new EventDispatcher();
		private static var arrListeners:ArrayCollection = new ArrayCollection();
		private static var _wasAvailable : Boolean = false;
		private static var acPositions:ArrayCollection = new ArrayCollection();
		
		public static function stopLocationMonitoring():void
		{
			Location.service.removeEventListener( LocationEvent.UPDATE, location_updateHandler );			
			var success:Boolean = Location.service.stopLocationMonitoring();
			trace("stopLocationMonitoring() " + success );
			
			try
			{
				Globals.loadingClose();
			} catch (err:Error) { trace("No active window detected: " + err.getStackTrace()); }
		}
		
		public static function startLocationMonitoring():void
		{
			checkLocationAvailability();
			
			// timer to check if user turned Geolocation Service ON / OFF
			var timer:Timer = new Timer( 500 );
			timer.addEventListener( TimerEvent.TIMER, timerHandler );
			timer.start();
			
			if (Location.isSupported) 
			{							
				if ((Location.service.hasAuthorisation()) && (GPS_ENABLED))
				{
					Location.service.addEventListener( ErrorEvent.ERROR, location_errorHandler, false, 0, true );	
					Location.service.addEventListener( LocationEvent.UPDATE, location_updateHandler);
					
					var request:LocationRequest = new LocationRequest();
					request.accuracy = LocationRequest.ACCURACY_HUNDRED_METERS;
					request.priority = LocationRequest.PRIORITY_BALANCED_POWER_ACCURACY;
					request.interval = GPS_UPDATE_INTERVAL;
					request.fastestInterval = GPS_UPDATE_INTERVAL;
					
					var success:Boolean = Location.service.startLocationMonitoring( request );
					trace( "startLocationMonitoring() " + success );
					Location.service.startPeriodicReporting(GPS_UPDATE_INTERVAL,request);
					
					acPositions = new ArrayCollection();
				}
				else
				{
					Globals.loadingClose();
					//Globals.showOkDialog("GPS отключен", "Пожалуйста, включите службы определения местоположения");
					dispatcher.dispatchEvent(new Event("ERROR_GPS"));
				}
			}
			else
			{
				Globals.loadingClose();
				Globals.showOkDialog("GPS не поддерживается", "Похоже, Ваше устройство не поддерживает работу с GPS датчиком");
			}
		}
		
		
		private static function location_errorHandler( event:ErrorEvent ):void
		{
			Globals.loadingClose();
			dispatcher.dispatchEvent(new Event("ERROR_GPS"));
			trace( "LOCATION ERROR:: " + event.text );
		}
		private static function location_updateHandler( event:LocationEvent ):void
		{
			LAT = event.position.latitude.toString();
			LON = event.position.longitude.toString();
			ACCURACY = event.position.horizontalAccuracy.toString();
			
			var p:Position = event.position;
			acPositions.addItem(p);
			
			trace("altitude: " + p.altitude);
			trace("heading: " + p.heading);
			trace("horizontalAccuracy: " + p.horizontalAccuracy);
			trace("latitude: " + p.latitude);
			trace("longitude: " + p.longitude);
			trace("speed: " + p.speed);
			trace("timestamp: " + p.timestamp);
			trace("verticalAccuracy: " + p.verticalAccuracy);
			
			trace("location updated: ["+event.position.latitude+","+event.position.longitude +"] time: " + Globals.CurrentDateTimeWithMinutesSecondsString());
			
			if (p.horizontalAccuracy < 100) {
				endUpdating();
			} else if (acPositions.length == 5) 
			{
				var dataSortField:SortField = new SortField();
				dataSortField.name = "horizontalAccuracy";
				dataSortField.numeric = true;
				var numericDataSort:Sort = new Sort();
				numericDataSort.fields = [dataSortField];
				acPositions.sort = numericDataSort;
				acPositions.refresh();	
				
				LAT = (acPositions.getItemAt(0) as Position).latitude.toString();
				LON = (acPositions.getItemAt(0) as Position).longitude.toString();
				ACCURACY = (acPositions.getItemAt(0) as Position).horizontalAccuracy.toString();
				
				endUpdating();
			}
		}
		
		private static function endUpdating():void
		{
			stopLocationMonitoring();
			dispatcher.dispatchEvent(new Event("HAS_GPS"));
		}
		
		// timer handler to check if user turned Geolocation Service ON / OFF
		private static function timerHandler( event:TimerEvent ):void
		{
			checkLocationAvailability();
		}
		private static function checkLocationAvailability():void
		{
			if (Location.service.isAvailable() != _wasAvailable)
			{
				_wasAvailable = Location.service.isAvailable();
				if (_wasAvailable)
				{
					GPS_ENABLED = true;
					Dialog.service.toast("location:available");
					trace("location:available");
					
					startLocationMonitoring();
				}
				else 
				{
					GPS_ENABLED = false;
					Dialog.service.toast("location:unavailable");
					trace("location:unavailable");
					
					Globals.loadingClose();
					Globals.showOkDialog("GPS отключен", "Пожалуйста, включите службы определения местоположения");
					dispatcher.dispatchEvent(new Event("ERROR_GPS"));
				}
			}
		}


		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{				
			for(var i:Number = 0; i<arrListeners.length; i++)
			{
				if (arrListeners[i].type == type)
				{
					if(dispatcher.hasEventListener(arrListeners[i].type))
					{
						dispatcher.removeEventListener(arrListeners[i].type, arrListeners[i].listener);
						arrListeners.removeItemAt(i);
					}
				}
			}
			
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);			
			arrListeners.addItem({type:type, listener:listener});
		}
		
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{			
			for(var i:Number = 0; i<arrListeners.length; i++)
			{
				if (arrListeners[i].type == type)
				{
					if(dispatcher.hasEventListener(arrListeners[i].type))
					{
						dispatcher.removeEventListener(arrListeners[i].type, arrListeners[i].listener);
						arrListeners.removeItemAt(i);
					}
				}
			}
		}
	}
}