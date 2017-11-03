
package classes.Utils
{
	import com.distriqt.extension.dialog.Dialog;
	
	import flash.events.GeolocationEvent;
	import flash.events.TimerEvent;
	import flash.sensors.Geolocation;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	
	import classes.Globals;
	import classes.Model.BatchQuery;
	import classes.Model.Database;
	import classes.Model.ExternalData;
	
	import events.Model.AdjustRecordEvent;
	import events.Model.QueryEvent;
	import events.custom.CheckEvent;
	
	[Bindable]
	public class GpsTrackingUtil
	{
		
		protected static var geo:Geolocation;
		protected static var geoLastEvent:GeolocationEvent;
		protected static var geoCheckCount:int;
		protected static var geoTimer:Timer;
		
		protected static var gpsTimer:Timer;
		protected static var syncTimer:Timer;
		
		protected static var gpsObject:Object;
		
		protected static var count:int = 0;
		protected static var syncCount:int = 0;

		
		public static function startGpsTracking():void
		{
			clearAll();
			var GPS_TRACK:Number = Globals.GPS_TRACK_INTERVAL;
			var SYNC_TIME:Number = Globals.SYNC_TIME_INTERVAL
			if (Globals.GPS_TRACK_INTERVAL > 0)
			{
				gpsTimer = new Timer(Globals.GPS_TRACK_INTERVAL);
				gpsTimer.addEventListener(TimerEvent.TIMER,onGpsTimerStep);
				gpsTimer.start();
			}
			
			if (Globals.SYNC_TIME_INTERVAL > 0)
			{
				syncTimer = new Timer(Globals.SYNC_TIME_INTERVAL);
				syncTimer.addEventListener(TimerEvent.TIMER,onSyncTimerStep);
				syncTimer.start();
			}

			
			showToast("Трекинг запущен");
		}
		
		public static function clearAll():void
		{
			count = 0;
			syncCount = 0;
			
			try
			{
				geoTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,onTimeout);
				geoTimer.stop();
			}
			catch (err:Error) {
				
			} 
			try
			{
				geo.removeEventListener(GeolocationEvent.UPDATE, onUpdate);
				geo = null;
			}
			catch (err:Error) {
			
			}
			try
			{
				gpsTimer.removeEventListener(TimerEvent.TIMER,onGpsTimerStep);
				gpsTimer.stop();
				gpsTimer = null;
			}
			catch (err:Error) {
		
			}
			try
			{
				syncTimer.removeEventListener(TimerEvent.TIMER,onSyncTimerStep);
				syncTimer.stop();
				syncTimer = null;
			}
			catch (err:Error) {
	
			}
				
			
		}
		
		protected static function onGpsTimerStep(event:TimerEvent):void
		{
			if (((new Date).hours >= 6) && ((new Date).hours <= 23))
			{
				getCurrentCoordinates();
			}
			else
			{
				clearAll();
			}			
		}
		
		protected static function onSyncTimerStep(event:TimerEvent):void
		{
			//sendGpsTracktoDB();
			trace("GPS UTIL: Tracker Step at: " + Globals.CurrentDateTimeWithMinutesSecondsString());
		}

		
		protected static function getCurrentCoordinates():void
		{
			if(Geolocation.isSupported)
			{
				geoCheckCount = 0;
				geo = new Geolocation();
				geo.setRequestedUpdateInterval(500);        // suggest a very frequent update of 500ms
				try
				{
					geo.removeEventListener(GeolocationEvent.UPDATE, onUpdate);
				}
				catch (err:Error) 
				{					
				}
				geo.addEventListener(GeolocationEvent.UPDATE, onUpdate);
			
				// Create a timer
				geoTimer = new Timer(30000,1);
				try
				{
					geoTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,onTimeout);
				} 
				catch(error:Error) 
				{
					
				}
				geoTimer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimeout);
				geoTimer.start();
			} 
			else 
			{
				showToast("GPS недоступен на данном устройстве" );
			}
		}
		
		protected static function onUpdate(event:GeolocationEvent):void
		{
			++geoCheckCount;
			//if(geoCheckCount <= 1) return; // Throw away the first location event because it's almost always the last known location, not current location
			geoLastEvent = event;
			
			if(event.horizontalAccuracy <= 150)
			{
				try
				{
					geoTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,onTimeout);
				} 
				catch(error:Error) 
				{
					
				}
				
				geoTimer.stop();
				
				
			
				try
				{
					geo.removeEventListener(GeolocationEvent.UPDATE, onUpdate);
				} 
				catch(error:Error) 
				{
					
				}
			//	geo.removeEventListener(GeolocationEvent.UPDATE, onUpdate);
				geo = null;
				fillGpsObject(event);
			}
		}
		
		protected static function onTimeout(event:TimerEvent):void
		{
			geoTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,onTimeout);
			geoTimer.stop();
			geoTimer = null;
			if(geoLastEvent != null)
			{
				fillGpsObject(geoLastEvent);
			} 
			else 
			{
				//log.appendText("Unable to determine location before timeout\n");
				showToast("Невозможно определить координаты для трекинга!" );
			}
			geo.removeEventListener(GeolocationEvent.UPDATE, onUpdate);
			geo = null;
		}
		
		
		protected static function fillGpsObject(event:GeolocationEvent):void
		{
			count++;
			
		
		
			var bq:BatchQuery = new BatchQuery();
			bq.query = "INSERT INTO ST_USER_GPS_TRACK (GTR_USE_CODE, GTR_SYNC_NUMBER, GTR_NUMBER, GTR_LATITUDE, GTR_LONGITUDE, " +
				"GTR_SPEED, GTR_HOR_ACCURACY, GTR_DEVICE_DATETIME) VALUES (" +
				Globals.USE_CODE + ", " + 
				syncCount.toString() + ", " + 
				count + ", " + 
				"'" + event.latitude.toString() + "'," + 
				"'" + event.longitude.toString() + "'," +
				"'" + event.speed.toString() + "'," +
				"'" + event.horizontalAccuracy.toString() + "'," +
				"'" + Globals.CurrentDateTimeWithMinutesSecondsString() + "'" + ");";
			var adjArr:ArrayCollection = new ArrayCollection();	
			adjArr.addItem(bq);
			Database.removeEventListener(CheckEvent.ADJUST_EVENT, SAVE_GPS_TO_MOBILE_DB );
			Database.addEventListener(CheckEvent.ADJUST_EVENT, SAVE_GPS_TO_MOBILE_DB, false, 0, true);
			Database.ADJUST(adjArr);
		}
		
		private static function SAVE_GPS_TO_MOBILE_DB(e:CheckEvent):void
		{
			if (e.data > 0) {
			
			}	
			else	
			{
			
			}
		}
		
		/*
		public static function sendGpsTracktoDB():void
		{
			//var db:Database = new Database();
			Database.removeEventListener( QueryEvent.DATA_LOADED, sendGpsTracktoServer);
			Database.addEventListener(QueryEvent.DATA_LOADED, sendGpsTracktoServer, false, 0, true);
			//db.OPERATION_TYPE = "SELECT";
			Database.init("SELECT *  FROM ST_USER_GPS_TRACK");
		}
		
		
		public static function sendGpsTracktoServer(e:QueryEvent):void
		{
			if (e.data != null)
			{			
				var gpsArray:ArrayCollection = new ArrayCollection();
				
				for (var i:int=0;i<e.data.length;i++)
				{
					var bq:BatchQuery = new BatchQuery();
					bq.query = "INSERT INTO ST_USER_GPS_TRACK (GTR_USE_CODE, GTR_SYNC_NUMBER, GTR_NUMBER, GTR_LATITUDE, GTR_LONGITUDE, " +
						"GTR_SPEED, GTR_HOR_ACCURACY, GTR_DEVICE_DATETIME) VALUES (" +
						Globals.USE_CODE + ", " + 
						syncCount.toString() + ", " + 
						e.data.getItemAt(i).GTR_NUMBER + ", " + 
						"'" + e.data.getItemAt(i).GTR_LATITUDE + "'," + 
						"'" + e.data.getItemAt(i).GTR_LONGITUDE + "'," +
						"'" + e.data.getItemAt(i).GTR_SPEED + "'," +
						"'" + e.data.getItemAt(i).GTR_HOR_ACCURACY + "'," +
						"'" + e.data.getItemAt(i).GTR_DEVICE_DATETIME + "'" + ");";
					gpsArray.addItem(bq);
				}
				
				var ed:ExternalData = new ExternalData();
				ed.addEventListener(AdjustRecordEvent.ADJUST_EVENT, gpsDataSent, false, 0, true);
				ed.adjustLargeRecord(gpsArray);
			}
		}
		
		
		
		private static function gpsDataSent(e:AdjustRecordEvent):void
		{
			syncCount++;
			//Globals.GPS_ARRAY = new ArrayCollection();
			
			var ed:ExternalData = new ExternalData();
			ed.addEventListener(QueryEvent.DATA_LOADED, LOAD_SETTINGS_DONE, false, 0, true);
			ed.queryData(
				//COLUMNS_LIST
				"*",
				//VIEW_NAME
				"ST_USER"
				, 
				//WHERE_CLAUSE
				"WHERE USE_CODE = " + Globals.USE_CODE
				, 
				//LIMIT_CLAUSE
				null
			);
		}
		
		private static function LOAD_SETTINGS_DONE(e:QueryEvent):void
		{
			if (e.data.length > 0)	
			{
				Globals.GPS_TRACK_INTERVAL = (e.data.getItemAt(0).USE_GPS_TRACK_INTERVAL as Number)*60*1000;
				Globals.SYNC_TIME_INTERVAL = (e.data.getItemAt(0).USE_SYNC_TIME_INTERVAL as Number)*60*1000;
				
				//startGpsTracking();
			} 
			else 
			{
				showToast( "При получении параметров GPS произошла ошибка");
			}	
			var bq2:BatchQuery = new BatchQuery();
			bq2.query = "UPDATE ST_SETTINGS SET SET_GPS_TRACK_INTERVAL = "+(e.data.getItemAt(0).USE_GPS_TRACK_INTERVAL as Number)
				+", SET_SYNC_TIME_INTERVAL = "+(e.data.getItemAt(0).USE_SYNC_TIME_INTERVAL as Number)+";";
			var bq:BatchQuery = new BatchQuery();
			bq.query = "Delete FROM ST_USER_GPS_TRACK;";
			var adjArr:ArrayCollection = new ArrayCollection();	
			adjArr.addItem(bq);
			adjArr.addItem(bq2);
			Database.removeEventListener(CheckEvent.ADJUST_EVENT, clearTable);
			Database.addEventListener(CheckEvent.ADJUST_EVENT, clearTable, false, 0, true);
			Database.ADJUST(adjArr);
		}
		
		private static function clearTable(e:CheckEvent):void
		{
			if(e.data > 0)
			{
				trace("GPS UTIL: Cleared");
			}
			else
			{
				trace("GPS UTIL: ERROR: " + e.text);	
			}
			startGpsTracking();
		}
		*/
		
		protected static function showToast(text:String):void
		{
			Dialog.service.toast(text);
		}
	}
}