package classes.Model
{
	import com.coltware.airxzip.ZipFileWriter;
	import com.distriqt.extension.application.Application;
	import com.distriqt.extension.dialog.Dialog;
	import com.distriqt.extension.dialog.DialogType;
	import com.distriqt.extension.dialog.ProgressDialogView;
	import com.distriqt.extension.dialog.builders.ProgressDialogBuilder;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestDefaults;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.utils.Base64Encoder;
	
	import classes.Globals;
	import classes.Utils.QueryConstructor;
	import classes.Utils.TextFile;
	
	import events.Model.ExternalDataEvent;
	import events.Model.QueryEvent;
	import events.custom.CheckEvent;
	
	
	public class ExternalData extends EventDispatcher
	{		
		protected var arrResult:ArrayCollection;		
		private var loader:URLLoader;
		private var progressDialog:ProgressDialogView;
		private var progressInterval:uint;
		private var progress:Number = 0;
		private var operationType:String = "";
		private var zipFileName:String = "";
		private var syncID:String = "";
		private var UPDATE_ARRAY:ArrayCollection = new ArrayCollection();
		private var syncAC:ArrayCollection = new ArrayCollection();
		private var syncTableName:String = "";
		private var syncViewCount:Number = 0;
		private var syncType:String = "";
		private var tempVisitPhotosAC:ArrayCollection = new ArrayCollection();
		private var imgNum:int = 0;
		private var imageAC:ArrayCollection = new ArrayCollection();
		private var imageCounter:int = 0;
		private var imageQnt:int = 0;
		private var fileListSD:ArrayCollection;

		/* ===============================================			
		INIT			
		=================================================*/	
		public function ExternalData(_operationType:String)
		{
			arrResult = new ArrayCollection();			
			operationType = _operationType;
		}
		
		/* ===============================================			
		AUTHENTICATION			
		=================================================*/	
		public function getAuth(IMEI:String):void
		{
			loader = new URLLoader();
			configureListeners(loader);
			
			//var operation:String = "Operations?operation=get_auth";
			var operation:String = "Operations?operation=" + operationType;
			var req:URLRequest = new URLRequest(Globals.SERVER_URL + "/" + Globals.SERVICES_NAME + "/" + operation);
			req.method = URLRequestMethod.POST;
			req.data = new URLVariables("name=John+Doe"); // read here: http://stackoverflow.com/questions/509219/flex-3-how-to-support-http-authentication-urlrequest
			req.data = new URLVariables("IMEI=" + IMEI);
			
			var encoder:Base64Encoder = new Base64Encoder();        
			encoder.encode("batuser:Batpromo12#");
			
			var credsHeader:URLRequestHeader = new URLRequestHeader("Authorization", "Basic " + encoder.toString());
			req.requestHeaders.push(credsHeader);
			
			req.idleTimeout = Globals.URL_REQUEST_TIMEOUT;
			URLRequestDefaults.idleTimeout = Globals.URL_REQUEST_TIMEOUT;
			
			createProgressDialog("Авторизация");
			loader.load(req);
		}
		
		/* ===============================================			
		GET SYNC STATUS			
		=================================================*/
		public function getSyncStatus():void
		{
			loader = new URLLoader();
			configureListeners(loader);

			var operation:String = "Operations?operation=" + operationType;
			var req:URLRequest = new URLRequest(Globals.SERVER_URL + "/" + Globals.SERVICES_NAME + "/" + operation);
			req.method = URLRequestMethod.POST;
			req.data = new URLVariables("use_code=" + Globals.USE_CODE);
			
			var encoder:Base64Encoder = new Base64Encoder();        
			encoder.encode("batuser:Batpromo12#");
			
			var credsHeader:URLRequestHeader = new URLRequestHeader("Authorization", "Basic " + encoder.toString());
			req.requestHeaders.push(credsHeader);
			
			req.idleTimeout = Globals.URL_REQUEST_TIMEOUT;
			URLRequestDefaults.idleTimeout = Globals.URL_REQUEST_TIMEOUT;
			
			createProgressDialog("Запрос статуса авторизации");
			loader.load(req);
		}
		
		/* ===============================================			
		CHECK RESPONDENT BY PHONE		
		=================================================*/	
		public function checkRespondentByPhone(phone:String, surCode:String):void
		{
			loader = new URLLoader();
			configureListeners(loader);

			var operation:String = "Operations?operation=" + operationType + "&phone=" + phone + "&sur_code=" + surCode;
			var req:URLRequest = new URLRequest(Globals.SERVER_URL + "/" + Globals.SERVICES_NAME + "/" + operation);
			req.method = URLRequestMethod.POST;
			req.data = new URLVariables("name=John+Doe"); // read here: http://stackoverflow.com/questions/509219/flex-3-how-to-support-http-authentication-urlrequest
			
			var encoder:Base64Encoder = new Base64Encoder();        
			encoder.encode("batuser:Batpromo12#");
			
			var credsHeader:URLRequestHeader = new URLRequestHeader("Authorization", "Basic " + encoder.toString());
			req.requestHeaders.push(credsHeader);
			
			req.idleTimeout = Globals.URL_REQUEST_TIMEOUT;
			URLRequestDefaults.idleTimeout = Globals.URL_REQUEST_TIMEOUT;
			
			createProgressDialog("Проверка респондента в базе");
			loader.load(req);
		}
		
		/* ===============================================			
		WRITE FILE DATA			
		=================================================*/	
		public function sendUnzipAndWrite(zipFileName:String):void
		{
			loader = new URLLoader();
			configureListeners(loader);
			
			//var operation:String = "Operations?operation=write_file_data&use_code=" + Globals.USE_CODE + "&file_name=" + zipFileName;
			var operation:String = "Operations?operation=" + operationType + "&use_code=" + Globals.USE_CODE + "&file_name=" + zipFileName;
			var req:URLRequest = new URLRequest(Globals.SERVER_URL + "/" + Globals.SERVICES_NAME + "/" + operation);
			req.method = URLRequestMethod.POST;
			req.data = new URLVariables("name=John+Doe");
			
			var encoder:Base64Encoder = new Base64Encoder();        
			encoder.encode("batuser:Batpromo12#");
			
			var credsHeader:URLRequestHeader = new URLRequestHeader("Authorization", "Basic " + encoder.toString());
			req.requestHeaders.push(credsHeader);
			
			req.idleTimeout = Globals.URL_REQUEST_TIMEOUT;
			URLRequestDefaults.idleTimeout = Globals.URL_REQUEST_TIMEOUT;
			
			createProgressDialog("Отправка команды записи данных в базу");
			loader.load(req);
		}
		
		// listeners		
		private function configureListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
			dispatcher.addEventListener(Event.OPEN, openHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		private function completeHandler(event:Event):void {
			var resultLoader:URLLoader = URLLoader(event.target);
			var result:ArrayCollection = new ArrayCollection();
			var hasError:Boolean = false;
			var errorText:String = "";
			try
			{
				arrResult = convertJsonToArrayCollection(resultLoader.data.toString());	
				
				var o:Object = JSON.parse(resultLoader.data.toString());
				result = new ArrayCollection(o["result"] as Array);
				
				if (result.length == 0) 
				{
					hasError = true;
					errorText = getErrorMessage();
					disposeProgressDialog(result, hasError, errorText);
				} 
				else 
				{
					doTricksWithResponse(result);
				}
			}
			catch (err:Error) { 
				trace("completeHandlerError: " + err.message); 
				hasError = true;
				errorText = operationType + ": " + err.message;
				disposeProgressDialog(result, hasError, errorText);
			}			
			trace("completeHandler: " + resultLoader.data);
		}
		
		private function openHandler(event:Event):void {
			trace("openHandler: " + event);
		}
		
		private function progressHandler(event:ProgressEvent):void {
			trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			disposeProgressDialog(null,true,event.toString());
			trace("securityErrorHandler: " + event);
		}
		
		private function httpStatusHandler(event:HTTPStatusEvent):void {
			trace("httpStatusHandler: " + event);
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			disposeProgressDialog(null,true,event.toString());
			trace("ioErrorHandler: " + event);
		}
		
		/* ===============================================			
		PARSE JSON FUNCTION			
		=================================================*/	
		private function convertJsonToArrayCollection(result:String):ArrayCollection
		{
			var array:Array = new Array();	
			var arr2:Array = JSON.parse(result) as Array;
			try
			{
				var resObject:Object = JSON.parse(result);
				for (var key:String in resObject)
				{				
					array.push(resObject[key]);
				}				
			}
			catch (err:Error) {	trace("convertJsonError: " + err.message); }

			return new ArrayCollection(array);
		}
		
		/* ===============================================			
		INDETERMINATE PROGRESS CALLOUT			
		=================================================*/	
		private function createProgressDialog(title:String):void
		{
			if (Dialog.isSupported)
			{
				progressDialog = Dialog.service.create( 
					new ProgressDialogBuilder()
					.setTitle( title )
					.setMessage( "Ожидание ответа от сервера..." )
					.setStyle( DialogType.STYLE_SPINNER )
					.setCancelable( false )
					.build()
				);
				progressDialog.show();
			}
		}
		
		private function disposeProgressDialog(result:ArrayCollection,hasError:Boolean=false,errorText:String=""):void
		{
			dispatchExternalDataEvent(result,hasError,errorText);			
			progressDialog.dismiss();
			progressDialog.dispose();
		}
		
		
		/* ===============================================			
		SEND LOG FILE 	
		=================================================*/	
		public function sendLogFile():void
		{
			var logFile:File = File.documentsDirectory.resolvePath(Globals.LOG_FILE_PATH);
			if (logFile.exists)
			{
				// prepare log file
				zipFileName = Globals.USE_CODE + "_" + Globals.getRawDateString() + "_LOG.zip";
				var file:File = File.documentsDirectory.resolvePath("TSA_PROMO/" + zipFileName);
				
				var writer:ZipFileWriter = new ZipFileWriter();
				writer.open(file);
				
				var data:ByteArray = new ByteArray();
				data.writeUTFBytes(TextFile.read())
				writer.addBytes(data, Globals.USE_CODE + "_LOG.csv");
				
				writer.close();
				
				// send file
				sendFile(zipFileName,"Отправка лога");
			}
			else
			{
				trace("ОШИБКА: Не найден файл лога");
			}
		}
		
		/* ===============================================			
		SEND UPLOAD SYNC FILE 	
		=================================================*/	
		public function sendUploadSyncFile(_syncType:String):void
		{
			trace("SEND UPLOAD SYNC FILE: Подготовка данных к отправке");
			
			syncType = _syncType;
			UPDATE_ARRAY = new ArrayCollection();
			
			Database.addEventListener(QueryEvent.DATA_LOADED, GET_SYNC_DATA_RESULT, false, 0, true);
			Database.init("SELECT * FROM ST_SYNC ORDER BY SYN_ORDER");	
		}
		private function GET_SYNC_DATA_RESULT(e:QueryEvent):void
		{
			syncID = syncType + "_" + Globals.getUniqueCode();
			
			var bq:BatchQuery = new BatchQuery();
			bq.query = QueryConstructor.buildSyncLogQuery(syncID, syncType)
			
			UPDATE_ARRAY.addItem(bq);
			
			Database.removeEventListener(QueryEvent.DATA_LOADED, GET_SYNC_DATA_RESULT);
			if (e.data.length > 0)
			{
				syncAC = e.data;
				getQueriesForView(0);
			}
		}
		
		private function getQueriesForView(viewNum:Number):void
		{
			if (viewNum < syncAC.length)
			{
				syncTableName = syncAC.getItemAt(viewNum).SYN_SERVER_TABLE;
				Database.addEventListener(QueryEvent.DATA_LOADED, writeQueriesForView, false, 0, true);
				Database.init("SELECT * FROM " + syncAC.getItemAt(viewNum).SYN_VIEW_NAME);	
			}
			else
			{
				SEND_DATA_PREPARED();
			}
		}
		
		private function writeQueriesForView(e:QueryEvent):void
		{
			Database.removeEventListener(QueryEvent.DATA_LOADED, writeQueriesForView);
			syncViewCount++;
			if (e.data.length > 0)
			{
				for (var i:int=0; i<e.data.length; i++)
				{
					var bq:BatchQuery = new BatchQuery();
					var obj:Object = e.data.getItemAt(i);
					var keysArray:Array = new Array();
					var valuesArray:Array = new Array();
					for (var key:String in obj)
					{
						keysArray.push(key);
						var value:String = obj[key];
						switch (value)
						{
							case "" 	: value = "NULL"; break;
							case "null" : value = "NULL"; break;
							case null 	: value = "NULL"; break;
							default		: value = "N'" + value + "'";
						}
						valuesArray.push(value);
					}
					keysArray.push("SYN_ID");
					valuesArray.push("'" + syncID + "'");
					
					bq.query = "INSERT INTO " + syncTableName + " (" + keysArray.join(",") + ") VALUES (" + valuesArray.join(",") + ");"
					UPDATE_ARRAY.addItem(bq);
				}
			}
			getQueriesForView(syncViewCount);
		}
		
		private function SEND_DATA_PREPARED():void
		{
			var bq:BatchQuery = new BatchQuery();
			bq.query = "UPDATE ST_IMEI " +
				"SET IME_APP_VERSION = '" + Globals.VERSION_NUMBER + "'," +
				"IME_UNIQUE_ID = '" + Application.service.device.uniqueId() + "' " +
				"WHERE IME_SERIAL_NUMBER = '" + Globals.USE_IMEI + "';";
			UPDATE_ARRAY.addItem(bq);
			
			trace("Подготовка ZIP файла выгрузки");
			
			var s:String = new String();
			
			for (var i:int=0; i<UPDATE_ARRAY.length; i++)
			{
				s += UPDATE_ARRAY.getItemAt(i).query;
			}
			
			zipFileName = Globals.USE_CODE + "_" + Globals.getRawDateString() + ".zip";
			var file:File = File.documentsDirectory.resolvePath("TSA_PROMO/" + zipFileName);
			
			var writer:ZipFileWriter = new ZipFileWriter();
			writer.open(file);
			
			var data:ByteArray = new ByteArray();
			data.writeUTFBytes(s);
			writer.addBytes(data, Globals.USE_CODE + ".txt");
			
			writer.close();
			
			sendFile(zipFileName,"Отправка данных на сервер");
		}
		
		/* ===============================================			
		SEND FILE (COMMON FUNCTION)	 	
		=================================================*/	
		private function sendFile(zipFileName:String, progressTitle:String, fileIsImage:Boolean=false, fileUrl:String=""):void
		{
			var file:File = new File();
			if (!fileIsImage) {
				file = File.documentsDirectory.resolvePath("TSA_PROMO/" + zipFileName);
			} else {
				file.url = fileUrl;
			}
			
			//var operation:String = "Operations?operation=sync_file_upload&use_code=" + Globals.USE_CODE + "&file_name=" + zipFileName;
			var operation:String = "Operations?operation=" + operationType + "&use_code=" + Globals.USE_CODE + "&file_name=" + zipFileName;
			var req:URLRequest = new URLRequest(Globals.SERVER_URL + "/" + Globals.SERVICES_NAME + "/" + operation);
			req.method = URLRequestMethod.POST;
			req.data = new URLVariables("name=John+Doe"); // read here: http://stackoverflow.com/questions/509219/flex-3-how-to-support-http-authentication-urlrequest
			
			var encoder:Base64Encoder = new Base64Encoder();        
			encoder.encode("batuser:Batpromo12#");
			
			var credsHeader:URLRequestHeader = new URLRequestHeader("Authorization", "Basic " + encoder.toString());
			req.requestHeaders.push(credsHeader);
			
			file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, fileCompleteHandler);
			file.addEventListener(Event.OPEN, fileOpenHandler);
			file.addEventListener(ProgressEvent.PROGRESS, fileProgressHandler);
			file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, fileSecurityErrorHandler);
			file.addEventListener(HTTPStatusEvent.HTTP_STATUS, fileHttpStatusHandler);
			file.addEventListener(IOErrorEvent.IO_ERROR, fileIoErrorHandler);
			
			try
			{
				createDeterminateProgressDialog(progressTitle, "Передача файла на сервер...");
				file.upload(req);
			}
			catch (err:Error)
			{
				trace("file Error: " + err.message);
				disposeDeterminateProgressDialog(null,true,err.toString());
			}
		}
		// handlers for send file
		private function fileCompleteHandler(event:DataEvent):void {

			var result:ArrayCollection = new ArrayCollection();
			var hasError:Boolean = false;
			var errorText:String = "";
			try
			{
				arrResult = convertJsonToArrayCollection(event.data);	
				//result = new ArrayCollection(arrResult.getItemAt(1) as Array);
				
				var o:Object = JSON.parse(event.data.toString());
				result = new ArrayCollection(o["result"] as Array);
				
				if (result.length == 0) 
				{
					hasError = true;
					errorText = getErrorMessage();
					disposeDeterminateProgressDialog(result, hasError, errorText);
				} 
				else 
				{
					doTricksWithResponse(result);
				}
			}
			catch (err:Error) { 
				trace("fileCompleteHandlerError: " + err.message); 
				hasError = true;
				errorText = err.message;
				disposeDeterminateProgressDialog(result, hasError, errorText);
			}
			
			trace("fileCompleteHandler: " + event.data);
		}
		
		private function fileOpenHandler(event:Event):void {
			trace("fileOpenHandler: " + event);
		}
		
		private function fileProgressHandler(event:ProgressEvent):void {
			progressDialog.update(event.bytesLoaded/event.bytesTotal);
			trace("fileProgressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
		}
		
		private function fileSecurityErrorHandler(event:SecurityErrorEvent):void {
			disposeDeterminateProgressDialog(null,true,event.toString());
			trace("fileSecurityErrorHandler: " + event);
		}
		
		private function fileHttpStatusHandler(event:HTTPStatusEvent):void {
			trace("fileHttpStatusHandler: " + event);
		}
		
		private function fileIoErrorHandler(event:IOErrorEvent):void {
			disposeDeterminateProgressDialog(null,true,event.toString());
			trace("fileIoErrorHandler: " + event);
		}
		
		
		/* ===============================================			
		SEND REQUEST FOR MOBILE DATA PREPARATION		
		=================================================*/	
		public function getMobileData():void
		{
			loader = new URLLoader();
			
			//var operation:String = "Operations?operation=write_file_data&use_code=" + Globals.USE_CODE + "&file_name=" + zipFileName;
			var operation:String = "Operations?operation=" + operationType + "&use_code=" + Globals.USE_CODE;
			var req:URLRequest = new URLRequest(Globals.SERVER_URL + "/" + Globals.SERVICES_NAME + "/" + operation);
			req.method = URLRequestMethod.POST;
			req.data = new URLVariables("name=John+Doe");
			
			var encoder:Base64Encoder = new Base64Encoder();        
			encoder.encode("batuser:Batpromo12#");
			
			var credsHeader:URLRequestHeader = new URLRequestHeader("Authorization", "Basic " + encoder.toString());
			req.requestHeaders.push(credsHeader);

			loader.load(req);
		}
		
		
		
		/* ===============================================			
		DETERMINATE PROGRESS CALLOUT			
		=================================================*/	
		private function createDeterminateProgressDialog(title:String, message:String):void
		{
			if (Dialog.isSupported)
			{
				progressDialog = Dialog.service.create( 
					new ProgressDialogBuilder()
					.setTitle( title )
					.setMessage( message )
					.setStyle( DialogType.STYLE_HORIZONTAL )
					.setCancelable( false )
					.build()
				);

				progressDialog.show();				
				progress = 0;
				progressDialog.update(progress);
			}
		}
		

		
		private function disposeDeterminateProgressDialog(result:ArrayCollection,hasError:Boolean=false,errorText:String=""):void
		{
			try
			{
				progressDialog.dispose();
			} catch (err:Error) { trace("No progress dialog created"); }
			
			dispatchExternalDataEvent(result,hasError,errorText);
		}
		
		/* ===============================================			
		LET'S DO ALL DATA OPERATIONS HERE			
		=================================================*/
		private function doTricksWithResponse(result:ArrayCollection):void
		{
			switch (operationType)
			{
				case "get_auth" : writeUserParams(result);
					break;
				case "sync_file_upload" : syncFileUploadCommit();
					break;
				case "get_sync_status" : disposeDeterminateProgressDialog(result,false,"");
					break;
				case "check_respondent" : disposeDeterminateProgressDialog(result,false,"");
					break;
				case "write_file_data" : disposeDeterminateProgressDialog(result,false,"");
					break;
				case "sync_photo_upload" : imgNum++; validatePhotoNumberAndSend();
					break;
				default : disposeDeterminateProgressDialog(result,false,"");
			}
		}
		
		private function syncFileUploadCommit():void
		{
			var result:ArrayCollection = new ArrayCollection();
			var o:Object = new Object();
			o["FILENAME"] = zipFileName;
			result.addItem(o);
			disposeDeterminateProgressDialog(result,false,"")
		}
		
		
		/* ===============================================			
		SEND VISIT PHOTOS
		=================================================*/	
		public function sendVisitPhotos():void
		{
			Database.addEventListener(QueryEvent.DATA_LOADED, visitPhotosDataLoaded, false, 0, true);
			Database.init("SELECT * FROM ST_VISIT_PHOTO WHERE VIP_ACTIVE = 1");
		}
		private function visitPhotosDataLoaded(e:QueryEvent):void
		{
			Database.removeEventListener(QueryEvent.DATA_LOADED, visitPhotosDataLoaded );				
			
			if (e.data.length > 0)
			{
				tempVisitPhotosAC = e.data;
				imgNum = 0;
				validatePhotoNumberAndSend();
			}
			else
			{
				disposeDeterminateProgressDialog(null,false,"");
			}
		}
		
		private function validatePhotoNumberAndSend():void
		{
			if (imgNum < tempVisitPhotosAC.length)
			{
				try // take care of hanging progresses
				{
					progressDialog.dispose();
				} catch (err:Error) { trace("No progress dialog created"); }
				
				var file:File = new File();
				file.url = tempVisitPhotosAC.getItemAt(imgNum).VIP_PHOTO_URL;		
				
				if (file.exists)
				{			
					var imgFileName:String = tempVisitPhotosAC.getItemAt(imgNum).VIP_PHOTO_NAME;
					sendFile(imgFileName,"Отправка фото",true,file.url);
				}
				else
				{
					imgNum++;
					validatePhotoNumberAndSend();
				}
			}
			else
			{
				disposeDeterminateProgressDialog(null,false,"");
			}
		}
		
		
		
		/* ===============================================			
		WRITE USER PARAMS			
		=================================================*/	
		private function writeUserParams(ac:ArrayCollection):void
		{				
			Globals.writeUserParams(ac);
			
			trace("Авторизован: " + Globals.USE_NAME);
			trace("Запись настроек пользователя");
			
			var setAdjArr:ArrayCollection = new ArrayCollection();
			var bqSettings:BatchQuery = new BatchQuery();
			bqSettings.query = QueryConstructor.buildSettingsQuery();
			setAdjArr.addItem(bqSettings);
			Database.addEventListener(CheckEvent.ADJUST_EVENT, WRITE_SETTINGS_RESULT, false, 0, true);
			Database.ADJUST(setAdjArr);
		}
		private function WRITE_SETTINGS_RESULT(e:CheckEvent):void
		{
			Database.removeEventListener(CheckEvent.ADJUST_EVENT, WRITE_SETTINGS_RESULT);
			if (e.data > 0) 
			{
				trace("Запись настроек пользователя выполнена успешно")
				disposeProgressDialog(null, false, "");
			}
			else 
			{
				trace("Ошибка при записи настроек:\n" + e.text);
				disposeProgressDialog(null, true, "Ошибка при записи настроек:\n" + e.text);
			}
		}
		
		
		/* ===============================================			
		GET ERROR MESSAGE			
		=================================================*/	
		private function getErrorMessage():String
		{
			var errMessage:String = "ОШИБКА: ";
			switch (operationType)
			{
				case "get_auth" : errMessage += "Пользователь с IMEI [" + Globals.USE_IMEI + "] не найден в базе. " +
					"Пожалуйста, обратитесь к администратору системы";
					break;
				case "sync_file_upload" : errMessage += "Пустой ответ от сервера";
					break;
				case "get_sync_status" : errMessage += "Пустой ответ от сервера";
					break;
				default : errMessage = operationType + ": Произошла ошибка";
			}
			return errMessage;
		}
		
		/* ===============================================			
		DISPATCH EXTERNAL DATA EVENT			
		=================================================*/	
		private function dispatchExternalDataEvent(result:ArrayCollection,hasError:Boolean=false,errorText:String=""):void
		{
			try
			{
				dispatchEvent(new ExternalDataEvent(ExternalDataEvent.DATA_LOADED, false, false, result, hasError, errorText));
			}
			catch (err:Error) { trace("External Data dispatch Error: " + err.message); }
		}
	}	
}