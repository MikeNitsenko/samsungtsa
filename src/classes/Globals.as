package classes
{
	import com.distriqt.extension.application.Application;
	import com.distriqt.extension.cameraui.CameraUI;
	import com.distriqt.extension.dialog.Dialog;
	import com.distriqt.extension.dialog.DialogTheme;
	import com.distriqt.extension.dialog.DialogType;
	import com.distriqt.extension.dialog.DialogView;
	import com.distriqt.extension.dialog.ProgressDialogView;
	import com.distriqt.extension.dialog.builders.ActivityBuilder;
	import com.distriqt.extension.dialog.builders.AlertBuilder;
	import com.distriqt.extension.dialog.builders.ProgressDialogBuilder;
	import com.distriqt.extension.dialog.objects.DialogAction;
	import com.distriqt.extension.flurry.Flurry;
	import com.distriqt.extension.location.Location;
	import com.distriqt.extension.mediaplayer.MediaPlayer;
	import com.distriqt.extension.message.Message;
	import com.distriqt.extension.nativewebview.NativeWebView;
	import com.distriqt.extension.nativewebview.events.BrowserViewEvent;
	import com.distriqt.extension.networkinfo.NetworkInfo;
	import com.distriqt.extension.networkinfo.NetworkInterface;
	import com.distriqt.extension.networkinfo.events.NetworkInfoEvent;
	import com.distriqt.extension.permissions.AuthorisationStatus;
	import com.distriqt.extension.permissions.Permissions;
	import com.distriqt.extension.permissions.events.AuthorisationEvent;
	
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;
	
	import pl.mateuszmackowiak.nativeANE.properties.SystemProperties;

	[Bindable]
	public class Globals
	{
		
		public static var APP_KEY:String = "f038b2c57dcab3303a5cf601c85ccb24fbd92272VjikNS/pQYiobd54NFTTAuRICfeJIUH7Ro18cEymzhitGzon7K6n53Nv3EanKDmz4f0dOWgGib4n+ywmHdEOsmpMdi17IPdI4dUoLwwYmMR2P1RqJFi5wOyDZvlOoJmmDHPWvfW0Iah3aB63HlIqA1wBck1AVLRwew+UkaPNdEREbKBC4L0cAvDUwV5B1emKIllXiJs6FMJQVaqUSCDh8n71f3jTWyK7IhBrHlany160Hr9rrt7VyBuw/6NP3G78ezCodIFvoB3qdYPeHfPgFPe6RmBrk1mxKRv8y4JciESjUzPlQvbaznJNCGc3Br6iBtUMu9hvxi45dwRycDh4Iw==";
		
		public static var TEST_ARRAY:ArrayCollection = new ArrayCollection();
		public static var FONT_SIZE:Number = 15;
		public static var LOG_FILE_PATH:String = "TSA_PROMO/logs/log.csv";
		public static var MEDIA_FILES_FOLDER_PATH:String = "TSA_PROMO/media";
		public static var VISIT_PHOTOS_FOLDER_PATH:String = "TSA_PROMO/photos";
		
		public static var MAIN_COLOR:uint = 0x17468B;		
		
		// NAVIGATION
		public static var mainNavArray:Array = new Array();
		
		// SYNC
		public static var VERSION_NUMBER:String = "0.0";
		public static var DB_VERSION_NUMBER:String = "0.0";
		public static var NEW_VERSION_NUMBER:String = "0.0";
		public static var SERVER_URL:String = "http://service.tsaplatform.com";
		public static var SERVICES_NAME:String = "TSA.MOB.SAMSUNGKZ";
		public static var SERVLET_NAME:String = "Operations";
		public static var WSDL:String = "";
		public static var WS_PATH:String = "";
		public static var WS_UPDATE_PATH:String = "";
		public static var LANG:String = "ru_RU";
		public static var TRY_COUNT:int = 60;
		public static var FIRST_TRANSITION_HAPPENED:Boolean = false;
		public static var PATH:String = "";
		public static var DEVICE_UNIQUE_ID:String = "";
		public static var NETWORK_IS_REACHABLE:Boolean = false;
		public static var NETWORK_WIFI_ENABLED:Boolean = false;
		public static var NETWORK_MOBILE_ENABLED:Boolean = false;
		public static var URL_REQUEST_TIMEOUT:Number = 10000;
		public static var TABLES_TO_CLEAR:Array = ["ST_VISIT", "ST_DOC_HEADERS", "ST_DOC_DETAILS", "ST_SALEPOINT",
													"ST_ROUTE","ST_ROUTE_SALEPOINT","ST_VISIT_CALENDAR",
													"ST_SURVEY","ST_QUESTION","ST_ANSWER", "ST_PRODUCTS", 
													"ST_SURVEY_DETAILS", "ST_CHANNEL", "ST_SALES_CHANNEL", "ST_LOCATION",
													"ST_SURVEY_RESULTS","ST_RECEIPTS","ST_USER_GPS_TRACK","ST_RESPONDENTS",
													"ST_VISIT_PHOTO", "ST_PROD_BASKET_DETAILS","ST_PROMO_NAMES","ST_PRICE_DOCUMENT"]; 
		
		// GPS
		public static var GPS_TRACK_INTERVAL:Number = 1800000; // 30 min * 60 s * 1000 ms
		public static var SYNC_TIME_INTERVAL:Number = 0;
		
	
		// USER SYNC TIME DATA
		public static var USE_SYNC_TIME_START_HOURS:String = "20";
		public static var USE_SYNC_TIME_START_MINUTES:String = "01";
		
		// REFERENCES
		public static var SAL_CODE:String = "";
		public static var SAL_ID:String = "";
		public static var SAL_IS_OUT_OF_ROUTE:String = "0";
		public static var SAL_IS_VISITED:Boolean = false;
		public static var SAL_NAME:String = "";
		public static var SAL_USE_COMMENT:String = "";
		public static var SAL_CHA_CODE:String = "";
		public static var SAL_ARRAY:ArrayCollection = new ArrayCollection();
		
		public static var SUR_CODE:String = "";
		public static var SUR_NAME:String = "";
		public static var SUR_IS_PROMO:Boolean = false;
		
		public static var USE_CODE:String = "0";
		public static var USE_LOC_CODE:String = "";
		public static var USE_IMEI:String = "";
		public static var USE_IMSI:String = "";
		public static var USE_PHONE_NUMBER:String = "";
		public static var USE_REG_CODE:String = "";
		public static var USE_LOGIN:String = "(не синхронизирован)";
		public static var USE_NAME:String = "";
		public static var USE_PASSWORD:String = "";
		
		public static var PER_CODE:String = "null";
		
		public static var ROU_CODE:String = "";
		public static var ROU_DATE:String = CurrentDateTimeString();
		public static var ROU_DATE_HYPHEN:String = "";
		public static var ROU_DATE_SELECTED:Date = new Date();
		public static var ROU_NAME:String = "(не выбран)";
		public static var ROU_IS_OPENED:Boolean = false;
		
		public static var VIS_IS_OPENED:Boolean = false;
		
		public static var PAY_CODE:String = "";
		public static var PAY_NAME:String = "";
		public static var PAY_DATE:String = "";
		public static var PAY_PERCENT:Number = 0;
		
		public static var VIS_NUMBER:String = "";
		public static var SUB_VIS_NUMBER:String = "";
		public static var VIS_TYPE:String = "";
		
		public static var DOC_NUMBER:String = "";
		
		public static var navBreadcrumb:Array = new Array();
		
		// VISIT
		public static var FIRST_TIME_VISIT:Boolean = false;
		public static var ALLOW_END_VISIT:Boolean = false;
		public static var VISIT_TIMER:String = "0 (мин)";
		public static var CHECK_DONE_SALE:Boolean = false;
		public static var CHECK_DONE_POSM:Boolean = false;
		public static var CHECK_DONE_SURVEY:Boolean = false;
		
		public static var NEED_TO_UPDATE:Boolean = false;
		
		public static var EMERGENCY:Boolean = false;
		
		// Main Display Object Container - necesseary for pop-ups
		public static var d:DisplayObjectContainer;		
		
	
		// PROMO
		public static var BUTTON_CHROME_COLOR:uint = 0xFFFFFF;
		public static var BUTTON_COLOR:uint = 0x004f94;
		public static var SURVEY_CODE:String = "745";
		public static var VIS_PROMO_NAME:String = "DEMO";
		public static var VIS_PROMO_SURNAME:String = "USER";
		public static var SMS_CODE_SENT:Boolean = false;
		public static var SURVEY_LANG:String = "RUS";
		public static var QUE_TEXT_LANG:String = "QUE_TEXT";
		public static var ANS_TEXT_LANG:String = "ANS_TEXT";
		public static var QUE_PHOTO_LANG:String = "QUE_PHOTO";
		public static var ANS_PHOTO_LANG:String = "ANS_PHOTO";
		public static var BLOCK_BACK_BUTTON:Boolean = false;
		public static var RES_CODE_SENT_VIA_SIM:String = "0";
		public static var VIDEO_PLAY_COMPLETED:Boolean = false;		
		
		// DIALOGS
		private static var progressDialog:ProgressDialogView;
		private static var activityDialog:DialogView;
		
		// PRICE ENTRY
		public static var backFromPriceEntryForm:Boolean = false;
		public static var PRO_CODE:String = "";
		public static var PRO_NAME:String = "";
		public static var PRO_PRICE:String = "";
		public static var PRO_COEFF:String = "";
		public static var PRO_COEFF_CODE:String = "";
		public static var priceEntryWhereClause:String = "1=1";
		public static var acProductTypes:ArrayCollection = new ArrayCollection();
		public static var acVendors:ArrayCollection = new ArrayCollection();
		public static var shouldTakePricePhoto:Boolean = true;
	

		public static function CurrentDateTimeString():String
		{               
			var CurrentDateTime:Date = new Date();
			var CurrentDF:DateFormatter = new DateFormatter();
			CurrentDF.formatString = "DD.MM.YYYY";
			var DateTimeString:String = CurrentDF.format(CurrentDateTime);
			return DateTimeString;
		}
		
		public static function CurrentTimeString():String
		{               
			var CurrentDateTime:Date = new Date();
			var CurrentDF:DateFormatter = new DateFormatter();
			CurrentDF.formatString = "JJ:NN:SS";
			var DateTimeString:String = CurrentDF.format(CurrentDateTime);
			return DateTimeString;
		}
		
		public static function CurrentDateTimeWithMinutesString():String
		{               
			var CurrentDateTime:Date = new Date();
			var CurrentDF:DateFormatter = new DateFormatter();
			CurrentDF.formatString = "DD.MM.YYYY JJ:NN";
			var DateTimeString:String = CurrentDF.format(CurrentDateTime);
			return DateTimeString;
		}
		
		public static function CurrentDateTimeWithMinutesSecondsString():String
		{               
			var CurrentDateTime:Date = new Date();
			var CurrentDF:DateFormatter = new DateFormatter();
			CurrentDF.formatString = "DD.MM.YYYY JJ:NN:SS";
			var DateTimeString:String = CurrentDF.format(CurrentDateTime);
			return DateTimeString;
		}
		
		public static function getRawDateString():String
		{               
			var CurrentDateTime:Date = new Date();
			var CurrentDF:DateFormatter = new DateFormatter();
			CurrentDF.formatString = "DDMMYYYYJJNNSS";
			var DateTimeString:String = CurrentDF.format(CurrentDateTime);
			return DateTimeString;
		}
		
		public static function getUniqueCode():String
		{
			var salt:int = Math.round(Math.random()*10000);
			return Globals.USE_CODE + "/" + salt.toString() + " - " + Globals.CurrentDateTimeWithMinutesSecondsString();
		}
		
		public static function getUniqueNameForPhoto():String
		{
			var salt:int = Math.round(Math.random()*10000);
			return Globals.USE_CODE + "_" + salt.toString() + "_" + getRawDateString();
		}
		
		
		public static function matchSalepointWithSalepointsInRoute(SAL_CODE:String):Boolean
		{
			var result:Boolean = false;
			
			for (var i:int=0;i<Globals.SAL_ARRAY.length; i++)
			{
				if (Globals.SAL_ARRAY.getItemAt(i).SAL_CODE == SAL_CODE)
				{
					result = true;
				}
			}	
			
			return result;
		}
		
		
		//date format
		public static function dateToYYYYMMDDHyphen(aDate:Date):String {
			var SEPARATOR:String = "-";
			
			var mm:String = (aDate.month + 1).toString();
			if (mm.length < 2) mm = "0" + mm;
			
			var dd:String = aDate.date.toString();
			if (dd.length < 2) dd = "0" + dd;
			
			var yyyy:String = aDate.fullYear.toString();
			
			return yyyy + SEPARATOR + mm + SEPARATOR + dd ;
		}
		
		//date format
		public static function dateToDDMMYYYYPoint(aDate:Date):String {
			var SEPARATOR:String = ".";
			
			var mm:String = (aDate.month + 1).toString();
			if (mm.length < 2) mm = "0" + mm;
			
			var dd:String = aDate.date.toString();
			if (dd.length < 2) dd = "0" + dd;
			
			var yyyy:String = aDate.fullYear.toString();
			//return yyyy + SEPARATOR + mm + SEPARATOR + dd;
			return dd + SEPARATOR + mm + SEPARATOR + yyyy;
		}
		
		
		public static function stringToDate(ds:String):Date
		{
			var dateA:Array = ds.split(" ");						
			
			var dmy:String = dateA[0];
			var hms:String = dateA[1];
			
			var dmyA:Array = dmy.split("-");
			
			var year:int = int(dmyA[0]);
			var month:int = int(dmyA[1])-1;
			var day:int = int(dmyA[2]);
			
			var hmsA:Array = hms.split(":");
			var h:int = int(hmsA[0]);
			var m:int = int(hmsA[1]);
			var s:int = int(hmsA[2]);
			
			return new Date(year, month, day, h, m, s);
		}
		
		public static function stringToDateFromDDMMYYYYHHMMSSPoint(ds:String):Date
		{
			var dateA:Array = ds.split(" ");						
			
			var dmy:String = dateA[0];
			var hms:String = dateA[1];
			
			var dmyA:Array = dmy.split(".");
			
			var day:int = int(dmyA[0]);
			var month:int = int(dmyA[1])-1;
			var year:int = int(dmyA[2]);
			
			var hmsA:Array = hms.split(":");
			var h:int = int(hmsA[0]);
			var m:int = int(hmsA[1]);
			var s:int = int(hmsA[2]);
			
			return new Date(year, month, day, h, m, s);
		}
		
		public static function stringToDateFromDDMMYYYYPoint(ds:String):Date
		{
			var dmyA:Array = ds.split(".");
			
			var day:int = int(dmyA[0]);
			var month:int = int(dmyA[1])-1;
			var year:int = int(dmyA[2]);

			return new Date(year, month, day,0,0,0);
		}
		
		public static function filterDistinctValue(arrIn:ArrayCollection, field:String):ArrayCollection 
		{
			var arr:ArrayCollection = new ArrayCollection();
			
			for (var j:int=0; j<arrIn.length; j++) {
				arr.addItem(arrIn.getItemAt(j));
			}
			
			if( arr == null || field == null || field.length == 0 ) {
				return null;
			}
			
			var arrOut:ArrayCollection = new ArrayCollection();
			var objAux:Object = {};
			
			for(var i:int = 0; i < arr.length; i++) {
				var key:String = arr[i][field]
				if( objAux[key] == null ) {
					objAux[key] = arr[i];
					arrOut.addItem( arr[i] );
				}
			}
			objAux = null;
			
			return arrOut;
		}	

		
		public static function randomFromRange(minNum:Number, maxNum:Number):Number
		{
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
		}

		public static function readSystemProperties():void
		{
			
			if (Permissions.isSupported)
			{
				Permissions.service.setPermissions( [ "android.permission.READ_PHONE_STATE", 
														"android.permission.INTERNET",
														"android.permission.ACCESS_FINE_LOCATION",
														"android.permission.ACCESS_COARSE_LOCATION",
														"android.permission.WAKE_LOCK",
														"android.permission.CAMERA",
														"android.permission.ACCESS_NETWORK_STATE",
														"android.permission.ACCESS_WIFI_STATE",
														"android.permission.SEND_SMS",
														"android.permission.WRITE_SMS",
														"android.permission.READ_SMS",
														"android.permission.WRITE_EXTERNAL_STORAGE", 
														"android.permission.READ_EXTERNAL_STORAGE",
														"android.permission.WAKE_LOCK"] );
				
				Permissions.service.addEventListener( AuthorisationEvent.CHANGED, authorisationChangedHandler );
				
				var status:String = Permissions.service.authorisationStatus();
				trace( "authorisationStatus="+status );
				switch (status)
				{
					case AuthorisationStatus.NOT_DETERMINED:
					case AuthorisationStatus.SHOULD_EXPLAIN:
						trace( "Requesting Access" );
						Permissions.service.requestAccess();
						return;
						
					case AuthorisationStatus.DENIED:
					case AuthorisationStatus.UNKNOWN:
					case AuthorisationStatus.RESTRICTED:
						trace( "Access Denied" );
						return;
						
					case AuthorisationStatus.AUTHORISED:
						trace( "Authorised" );
						break;						
				}
			}	
			
			// read IMEI and IMSI
			if(SystemProperties.isSupported)
			{
				var dictionary:Dictionary = SystemProperties.getInstance().getSystemProperites();
				if(!dictionary){
					trace("return null dictionary");
					return;
				}
				
				for (var key:String in dictionary) 
				{ 
					var readingType:String = key; 
					var readingValue:String = dictionary[key]; 
					
					if (readingType == "IMEI")
					{
						Globals.USE_IMEI = readingValue;
						trace("IMEI: " + Globals.USE_IMEI);
					}
					if (readingType == "IMSI")
					{
						Globals.USE_IMSI = readingValue;
						trace("IMSI: " + Globals.USE_IMSI);
					}
				} 
				dictionary = null;
			}
			else
			{
				trace("SystemProperties is NOT supported on this platform!!");
			}
			
			try
			{
				Flurry.service.analytics.setUserID(Globals.USE_IMEI);	
			}
			catch (err:Error) { trace("Flurry UserId Error: " + err.getStackTrace()); }
			
			// read version number
			var appXml:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = appXml.namespace();
			Globals.VERSION_NUMBER = appXml.ns::versionNumber[0];
		}
		private static function authorisationChangedHandler( event:AuthorisationEvent ):void
		{
			trace( "authorisation changed: " + event.status );
		}
		
	
		
		public static function initializeANEs(stage:Stage):void 
		{
			try // Dialogs ANE initaliazation
			{
				Dialog.init(Globals.APP_KEY);
				
				trace( "Dialog.isSupported:         " + Dialog.isSupported );
				trace( "Dialog.version: " + Dialog.VERSION );
				
				if (Dialog.isSupported)
				{
					Dialog.service.root = stage;
					Dialog.service.setDefaultTheme(new DialogTheme(DialogTheme.MATERIAL_LIGHT));
				}
				else {
					trace("ERROR: Dialog ANE UNSUPPORTED");
				}
			}
			catch (errDialogs:Error) { trace("ERROR: " + errDialogs.message); };	
			
			try // Application ANE initaliazation
			{
				com.distriqt.extension.application.Application.init(Globals.APP_KEY);
				
				trace( "Application.isSupported:         " + com.distriqt.extension.application.Application.isSupported );
				trace( "Application.version: " + com.distriqt.extension.application.Application.VERSION );
				
				if (com.distriqt.extension.application.Application.isSupported)
				{
					Globals.DEVICE_UNIQUE_ID = com.distriqt.extension.application.Application.service.device.uniqueId();
					Globals.USE_PHONE_NUMBER = com.distriqt.extension.application.Application.service.device.phone;
				} else {
					trace("ERROR: Application ANE UNSUPPORTED");
				}
			}
			catch (errApplication:Error) { trace("ERROR: " + errApplication.message); };
			
			try // MediaPlayer ANE initaliazation
			{
				MediaPlayer.init(Globals.APP_KEY);
				if (MediaPlayer.isSupported)
				{
					trace("MediaPlayer is supported");
				}
			}
			catch (errMediaPlayer:Error)
			{
				trace( errMediaPlayer.getStackTrace() );
			}
			
			try // Location ANE initaliazation
			{
				Location.init(Globals.APP_KEY);
				if (Location.isSupported)
				{
					trace( "Location Supported: " + Location.isSupported );
					trace( "Location Version:   " + Location.service.version );
				}
			}
			catch (errLocation:Error)
			{
				trace("ERROR: Location ANE UNSUPPORTED: " + errLocation.getStackTrace());
			}
			
			try // NativeWebView ANE initaliazation
			{
				NativeWebView.init(Globals.APP_KEY);
				if (NativeWebView.isSupported)
				{
					trace( "NativeWebView Supported: " + NativeWebView.isSupported );
					trace( "NativeWebView Version:   " + NativeWebView.service.version );
					NativeWebView.service.browserView.addEventListener( BrowserViewEvent.READY, browserView_readyHandler );
					NativeWebView.service.browserView.prepare();
				}
			}
			catch (errNativeWebView:Error)
			{
				trace("ERROR: NativeWebView ANE UNSUPPORTED: " + errNativeWebView.getStackTrace());
			}
			
			try // NetworkInfo ANE initaliazation
			{
				NetworkInfo.init( Globals.APP_KEY );
				
				trace( "NetworkInfo.isSupported:         " + NetworkInfo.isSupported );
				trace( "NetworkInfo.networkInfo.version: " + NetworkInfo.networkInfo.version );

				if (NetworkInfo.isSupported)
				{				
					NetworkInfo.networkInfo.addEventListener( NetworkInfoEvent.CHANGE, networkInfo_changeHandler );
					
					function networkInfo_changeHandler( event:NetworkInfoEvent ):void
					{
						Globals.NETWORK_IS_REACHABLE = NetworkInfo.networkInfo.isReachable();
						
						var ntf:Vector.<NetworkInterface> = NetworkInfo.networkInfo.findInterfaces();
						
						for each (var interfaceObj:NetworkInterface in ntf)
						{
							if (interfaceObj.name.toLowerCase() == "wifi") {
								NETWORK_WIFI_ENABLED = interfaceObj.active;
							}
							if (interfaceObj.name.toLowerCase() == "mobile") {
								NETWORK_MOBILE_ENABLED = interfaceObj.active;
							}
						}
					}
				}
			}
			catch (errNetworkInfo:Error) { trace( "ERROR:"+errNetworkInfo.message ); }
			
			try // CameraUI ANE initaliazation
			{
				CameraUI.init(APP_KEY);
				if (CameraUI.isSupported) 
				{
					trace( "CameraUI Supported: " + CameraUI.isSupported );
					trace( "CameraUI Version:   " + CameraUI.service.version );
				}				
			}
			catch (errCameraUI:Error)
			{
				trace("ERROR: CameraUI ANE UNSUPPORTED: " + errCameraUI.getStackTrace());
			}
			
			try // Message ANE initaliazation
			{
				Message.init(APP_KEY);
				if (Message.isSupported)
				{
					trace( "Message Supported: " + Message.isSupported );
					trace( "Message Version:   " + Message.service.version );
				}
			}
			catch (errMessage:Error)
			{
				trace("ERROR: Message ANE UNSUPPORTED: " + errMessage.getStackTrace());
			}
			
			try //  ANE Permissions
			{
				Permissions.init(Globals.APP_KEY);
				if (Permissions.isSupported)
				{
					trace( "Permissions Supported: " + Permissions.isSupported );
					trace( "Permissions Version:   " + Permissions.service.version );
				}
			}
			catch (errMessagePermissions:Error)
			{
				trace("ERROR: Permissions ANE UNSUPPORTED: " + errMessagePermissions.getStackTrace());
			}
			
			try //  ANE Flurry
			{
				Flurry.init(Globals.APP_KEY);
				if (Flurry.isSupported)
				{
					trace( "Flurry Supported: " + Flurry.isSupported );
					trace( "Flurry Version:   " + Flurry.service.version );
					trace( "Flurry Agent Version: " + Flurry.service.analytics.getFlurryAgentVersion() );
					Flurry.service.analytics.initialise("T3WYW8MXD3YZ49Y4DVSZ");					
				}
			}
			catch (errFlurry:Error)
			{
				trace("ERROR: Flurry ANE UNSUPPORTED: " + errFlurry.getStackTrace());
			}
		}
		
		private static function browserView_readyHandler( event:BrowserViewEvent ):void
		{
			NativeWebView.service.browserView.removeEventListener( BrowserViewEvent.READY, browserView_readyHandler );
			// Browser views are now ready to be used in your application
			trace("Browser views are now ready to be used in your application");
		}
		
		
		public static function writeUserParams(ac:ArrayCollection):void
		{				
			Globals.USE_CODE = ac.getItemAt(0).USE_CODE;
			Globals.USE_NAME = ac.getItemAt(0).PER_NAME;
			Globals.USE_PASSWORD = ac.getItemAt(0).USE_PASSWORD;
			Globals.USE_LOC_CODE = ac.getItemAt(0).USE_LOC_CODE;
			Globals.USE_SYNC_TIME_START_HOURS = ac.getItemAt(0).USE_SYNC_TIME_START_HOURS;
			Globals.USE_SYNC_TIME_START_MINUTES = ac.getItemAt(0).USE_SYNC_TIME_START_MINUTES;						
			Globals.GPS_TRACK_INTERVAL = (ac.getItemAt(0).USE_GPS_TRACK_INTERVAL as Number)*60*1000;
			Globals.SYNC_TIME_INTERVAL = (ac.getItemAt(0).USE_SYNC_TIME_INTERVAL as Number)*60*1000;
		}
		
		
		public static function showOkDialog(title:String, text:String):void
		{
			Dialog.service.create( 
				new AlertBuilder( true )
				.setTitle(title)
				.setMessage(text)
				.addOption("OK", DialogAction.STYLE_POSITIVE )
				.build()
			).show();
		}
		
		public static function loadingShow(title:String, message:String):void
		{
			if (Dialog.isSupported)
			{
				progressDialog = Dialog.service.create( 
					new ProgressDialogBuilder()
					.setTitle( title )
					.setMessage( message )
					.setStyle( DialogType.STYLE_SPINNER )
					.setCancelable( false )
					.build()
				);
				progressDialog.show();
			}
		}
		
		public static function loadingClose():void
		{	
			try
			{
				progressDialog.dismiss();
				progressDialog.dispose();
			}
			catch (err:Error) { trace("Globals LoadingClose ERROR: No active windows found"); }
		}
		
		public static function activityShow():void
		{
			if (activityDialog == null)
			{
				activityDialog = Dialog.service.create( 
					new ActivityBuilder()
					.setTheme( new DialogTheme( DialogTheme.MATERIAL_LIGHT ))
					.build()
				);
				activityDialog.show();
			}
		}
		
		public static function activityDismiss():void
		{
			try
			{
				activityDialog.dismiss();
				activityDialog.dispose();
				activityDialog = null;
			}
			catch (err:Error) { trace("No activity to dismiss"); }
		}
		
		public function Globals()
		{
		}
	}
}