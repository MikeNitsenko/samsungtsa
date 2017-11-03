package classes.Model
{
	import com.distriqt.extension.dialog.Dialog;
	import com.distriqt.extension.dialog.builders.AlertBuilder;
	
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLStatement;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	
	import classes.Globals;
	
	import events.Model.InsertProgressEvent;
	import events.Model.QueryEvent;
	import events.custom.CheckEvent;

	public class  Database extends EventDispatcher
	{
		//private var conn:SQLConnection;		
		public var OPERATION_TYPE:String;
		//public static var QUERY_STRING:String;
		public var QUERY_ARRAY:ArrayCollection;
		
		public static var conn:SQLConnection;
		public static var dbFileTemplate:File = File.applicationDirectory.resolvePath("assets/database/tsa.db");
		public static var dbFile:File = File.applicationStorageDirectory.resolvePath("tsa_new.db");
		public static var stmt:SQLStatement = new SQLStatement
		private static var dispatcher:EventDispatcher = new EventDispatcher();
		private static var arrListeners:ArrayCollection = new ArrayCollection();
		private static var statCol:ArrayCollection = new ArrayCollection();
		private static var adjLength:int = 0;
		private static var insCount:int;
		private static var adjArr:ArrayCollection = new ArrayCollection();
		private static var executeInsertTimer:Timer = new Timer(1, 1);
		
		private static var templateVersion:String = "";
		private static var currentVersion:String = "";
		
		public static function openDB():void
		{	
			conn = new SQLConnection();
			
			if (!dbFile.exists)
			{
				dbFileTemplate.copyTo(dbFile);
			}
			
			conn.addEventListener(SQLEvent.OPEN, onOpen);
			conn.addEventListener(SQLErrorEvent.ERROR, openError);
			
			conn.open(dbFile, SQLMode.READ);
			currentVersion = checkVersion();
			conn.close();
			
			conn.open(dbFileTemplate, SQLMode.READ);
			templateVersion = checkVersion();
			conn.close();
			
			if (currentVersion != templateVersion)
			{
				try
				{
					dbFile.deleteFile();
				} catch (err:Error) {		}
				openDB();
			}
			else
			{
				conn.addEventListener(SQLEvent.OPEN, onOpen);
				conn.addEventListener(SQLErrorEvent.ERROR, openError);
				
				conn.openAsync(dbFile, SQLMode.UPDATE);
				
				Globals.DB_VERSION_NUMBER = currentVersion;
			}
		}
		private static function onOpen(e:SQLEvent):void
		{
			conn.removeEventListener(SQLEvent.OPEN, onOpen);
			dispatcher.dispatchEvent(new Event("DB_OPEN"));

		}
		private static function openError(event:SQLErrorEvent):void
		{
			conn.removeEventListener(SQLErrorEvent.ERROR, openError);
			/*
			var ca:cusAlert = new cusAlert();
			ca.TEXT = "\nMessage:\n" + event.error.message + "\n" + "Details:\n" + event.error.details;
			ca.show(); */
			Dialog.service.create( 
				new AlertBuilder(true)
				.setTitle("Database Open Error")
				.setMessage("\nMessage:\n" + event.error.message + "\n" + "Details:\n" + event.error.details)
				.addOption("OK")
				.build()
			).show();
		}
		
		
		public static function checkVersion():String
		{					
			var result:String = "";
			
			stmt = new SQLStatement();

			stmt.sqlConnection = conn;
			stmt.text = "SELECT SET_DB_VERSION FROM ST_SETTINGS";//QUERY_STRING;	
			try
			{
				stmt.execute();
	
				result = stmt.getResult().data[0].SET_DB_VERSION;
			}
			catch (err:Error) {}
			
			return result;
		}
		
		
		public static function closeDB():void
		{
			conn.close();
		}

		public static function init(query:String):void
		{					
			stmt = new SQLStatement();
				
			stmt.addEventListener(SQLEvent.RESULT, resultHandler); 
			stmt.addEventListener(SQLErrorEvent.ERROR, errorHandler);
				
			stmt.sqlConnection = conn;
			stmt.text = query;//QUERY_STRING;				
			stmt.execute();
		}
		
		protected static function resultHandler(event:SQLEvent):void 
		{
			stmt.removeEventListener(SQLEvent.RESULT, resultHandler); 
			var arr:Array = new Array();			
			try
			{
				arr = stmt.getResult().data;
			} catch (err:Error) {}
			
			dispatcher.dispatchEvent(new QueryEvent(QueryEvent.DATA_LOADED, false, false, new ArrayCollection(arr))); 
		}
		
		protected static function errorHandler(event:SQLErrorEvent):void 
		{ 	
			Globals.loadingClose();
			stmt.removeEventListener(SQLEvent.RESULT, errorHandler); 
			/*
			var ca:cusAlert = new cusAlert();
			ca.TEXT = ResourceManager.getInstance().getString('localizedContent','DatabaseQueryError') + "\nMessage:\n" + event.error.message + "\n" + "Details:\n" + event.error.details;
			ca.show();	*/
			Dialog.service.create( 
				new AlertBuilder(true)
				.setTitle("Database Open Error")
				.setMessage("\nMessage:\n" + event.error.message + "\n" + "Details:\n" + event.error.details)
				.addOption("OK")
				.build()
			).show();
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
			//dispatcher.removeEventListener(type, listener, useCapture);
		}
		
	
		
		
		
		// ADJUST

		public static function ADJUST(adjustArray:ArrayCollection):void
		{			
			insCount = 0;

			adjArr = adjustArray;			
			conn.addEventListener(SQLEvent.BEGIN, beginHandler);
			conn.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			//conn.setSavepoint("ADJUST");
			conn.begin();
		}
		
		
		/**
		 * Called when a transaction begins successfully.
		 */
		private static function beginHandler(event:SQLEvent):void
		{
			conn.removeEventListener(SQLEvent.SET_SAVEPOINT, beginHandler);
			conn.removeEventListener(SQLErrorEvent.ERROR, errorHandler);
			
			adjArr.filterFunction = filterByLength;
			adjArr.refresh();
			
			function filterByLength(item:Object):Boolean
			{
				var res:Boolean = false;
				if ((item.query as String).length > 10)
				{
					res = true;
				}
				return res;
			}
			
			adjLength = adjArr.length;

			stmt = new SQLStatement();
			stmt.sqlConnection = conn;
			
			// listener for breaking thread timer
			executeInsertTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerHandler);
			// start execution
			executeNextInsertStatement();
		}
		
		private static function timerHandler(event:TimerEvent):void
		{
			executeInsertTimer.reset();
			executeNextInsertStatement();
		}
		
		private static function executeNextInsertStatement():void
		{
			stmt.addEventListener(SQLEvent.RESULT, insertResult); 
			stmt.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			//stmt.text = (adjArr.getItemAt(insCount).query as String).replace(/[~%&\\;"']/g,"");
			stmt.text = adjArr.getItemAt(insCount).query;		
			stmt.execute();
		}
		
		private static function insertResult(event:SQLEvent):void 
		{ 									
			insCount++;
			if (insCount < adjLength)
			{
				if (insCount % 100 == 0)
				{
					executeInsertTimer.start();
					dispatcher.dispatchEvent(new InsertProgressEvent(InsertProgressEvent.PROGRESS,false,false,insCount.toString() + " / " + adjLength.toString(),insCount,adjLength));
				}
				else
				{
					executeNextInsertStatement();
				}
			}
			else
			{
				stmt.removeEventListener(SQLEvent.RESULT, insertResult); 
				stmt.removeEventListener(SQLErrorEvent.ERROR, insertErrorHandler);
				// commit the transaction
				conn.addEventListener(SQLEvent.COMMIT, commitHandler);
				conn.addEventListener(SQLErrorEvent.ERROR, insertErrorHandler);
				//conn.releaseSavepoint("ADJUST");
				conn.commit();
			}	
		}
		
		
		
		private static function insertErrorHandler(event:SQLErrorEvent):void 
		{ 			
			dispatcher.dispatchEvent(new CheckEvent(CheckEvent.ADJUST_EVENT, false, false, 0, event.error.message + "\n" + event.error.details)); 
			conn.removeEventListener(SQLErrorEvent.ERROR, insertErrorHandler);
			//conn.rollbackToSavepoint("ADJUST");	
			conn.rollback();
		} 
		
		private static function commitHandler(event:SQLEvent):void
		{
			conn.removeEventListener(SQLEvent.RELEASE_SAVEPOINT, commitHandler);
			conn.removeEventListener(SQLErrorEvent.ERROR, errorHandler);			
			// dispatch the complete event and clean up						
			dispatcher.dispatchEvent(new CheckEvent(CheckEvent.ADJUST_EVENT, false, false, 1)); 
		}
		
		public function Database()
		{
		}
	}
}