package classes.Utils
{
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
	import classes.Globals;
	import classes.Model.ExternalData;
	
	import events.PartSyncEvent;
	import events.Model.ExternalDataEvent;

	public class PartSync extends EventDispatcher
	{
		private static var dispatcher:EventDispatcher = new EventDispatcher();
		private static var arrListeners:ArrayCollection = new ArrayCollection();
		
		/* ===============================================			
		PART SYNC
		=================================================*/	
		public static function startPartSync():void
		{
			writeLog("Начало синхронизации. Авторизация пользователя");
			// call for IMEI
			var ed:ExternalData = new ExternalData("get_auth");
			ed.addEventListener(ExternalDataEvent.DATA_LOADED, imeiAuthLoaded,false,0,true);
			ed.getAuth(Globals.USE_IMEI);
		}			
		private static function imeiAuthLoaded(event:ExternalDataEvent):void
		{
			if (event.hasError) {
				writeLog(event.errorText);
				moveToNextStep(true,event.errorText);
			} else {					
				writeLog("Отправка файла лога");
				prepareUploadSyncData();
			}
		}
		
		/* ===============================================			
		PREPARE AND SEND UPLOAD SYNC DATA		
		=================================================*/	
		
		private static function prepareUploadSyncData():void
		{
			var ed:ExternalData = new ExternalData("sync_file_upload");
			ed.addEventListener(ExternalDataEvent.DATA_LOADED, sendUploadSyncFileHandler, false,0,true);
			ed.sendUploadSyncFile("P");
		}
		private static function sendUploadSyncFileHandler(event:ExternalDataEvent):void
		{
			if (event.hasError) {
				writeLog(event.errorText);
				moveToNextStep(true,event.errorText);
			} else {					
				sendUnzipToServer(event.data.getItemAt(0).FILENAME);
			}
		}
		
		/* ===============================================			
		SEND UNZIP AND WRITE COMMAND TO SERVER		
		=================================================*/	
		
		private static function sendUnzipToServer(zipFileName:String):void
		{
			writeLog("Отправка команды записи данных в базу");
			
			try // remove file
			{
				File.documentsDirectory.resolvePath("TSA_PROMO/" + zipFileName).deleteFile();
			} catch (err:Error) { trace(err.getStackTrace()); }
			
			var ed:ExternalData = new ExternalData("write_file_data");
			ed.addEventListener(ExternalDataEvent.DATA_LOADED, sendUnzipToServerHandler, false,0,true);
			ed.sendUnzipAndWrite(zipFileName);
		}
		private static function sendUnzipToServerHandler(event:ExternalDataEvent):void
		{
			if (event.hasError) 
			{
				writeLog(event.errorText);					
			} 
			else 
			{
				writeLog("Отправка данных завершена");
			}
			moveToNextStep(false);
		}
		
		private static function writeLog(message:String):void
		{
			trace("PART SYNC: " + message);
		}
		
		/* ===============================================			
		MOVE TO THE NEXT STEP		
		=================================================*/	
		private static function moveToNextStep(hasError:Boolean, errorText:String=""):void
		{
			Globals.loadingClose();
			try
			{
				dispatcher.dispatchEvent(new PartSyncEvent(PartSyncEvent.SYNC_RESULT,false,false,null, hasError, errorText));
			}
			catch (err:Error) { trace("PartSyncEvent dispatch Error: " + err.message); }
		}		
		
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {			
			
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
		
		public function PartSync()
		{
		}
	}
}