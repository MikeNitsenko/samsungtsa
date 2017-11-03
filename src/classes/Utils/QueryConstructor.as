package classes.Utils
{
	import classes.Globals;

	[Bindable]
	public class QueryConstructor
	{
		public static function buildSettingsQuery():String
		{
			var resultQuery:String = "UPDATE ST_SETTINGS SET " +
				"SET_GPS_TRACK_INTERVAL = " + 
				((Globals.GPS_TRACK_INTERVAL as Number)/60000).toString() +
				", " +
				"SET_SYNC_TIME_INTERVAL = " + 
				((Globals.SYNC_TIME_INTERVAL as Number)/60000).toString() + 
				", " +
				"SET_PASSWORD = '" + Globals.USE_PASSWORD + "'" +
				", " +
				"USE_SYNC_TIME_START_HOURS = '" + Globals.USE_SYNC_TIME_START_HOURS + "'" +
				", " +
				"USE_SYNC_TIME_START_MINUTES = '" + Globals.USE_SYNC_TIME_START_MINUTES + "'" +
				", " +
				"SET_USE_NAME = '" + Globals.USE_NAME + "'" +
				", " +
				"SET_USE_CODE = " + Globals.USE_CODE + ";";
			
			return resultQuery;
		}
		
		public static function buildSyncLogQuery(syncID:String, syncType:String):String
		{
			var resultQuery:String = "INSERT INTO WT_SYNC_M_AT_SYNC_LOG " +
				"(SYL_DATETIME, " +
				"SYL_TYPE, " +
				"SYL_USE_CODE, " +
				"SYL_SYN_ID, " +
				"SYL_BEGIN_END) " +
				"VALUES (" + 
				"'" + Globals.CurrentDateTimeWithMinutesSecondsString() + "'," + 
				"'" + syncType + "'," +
				Globals.USE_CODE + "," +
				"'" + syncID + "'," +
				"0" + ");";
			
			return resultQuery;
		}
		
		public static function buildGetMediaFilesList():String
		{
			var resultQuery:String = "SELECT ANS_PHOTO AS IMG_NAME, 'ST_ANSWER' AS IMG_FOLDER " +
										"FROM ST_ANSWER " +
										"WHERE ANS_PHOTO IS NOT NULL AND ANS_PHOTO <> 'null' " +
										"UNION " +
										"SELECT QUE_PHOTO AS IMG_NAME, 'ST_QUESTION' AS IMG_FOLDER " +
										"FROM ST_QUESTION " +
										"WHERE QUE_PHOTO IS NOT NULL AND QUE_PHOTO <> 'null' " +
										"UNION " +
										"SELECT ANS_PHOTO_KAZ AS IMG_NAME, 'ST_ANSWER' AS IMG_FOLDER " +
										"FROM ST_ANSWER " +
										"WHERE ANS_PHOTO_KAZ IS NOT NULL AND ANS_PHOTO_KAZ <> 'null' " +
										"UNION " +
										"SELECT QUE_PHOTO_KAZ AS IMG_NAME, 'ST_QUESTION' AS IMG_FOLDER " +
										"FROM ST_QUESTION " +
										"WHERE QUE_PHOTO_KAZ IS NOT NULL AND QUE_PHOTO_KAZ <> 'null' " +
										"UNION " +
										"SELECT ANS_PHOTO_ENG AS IMG_NAME, 'ST_ANSWER' AS IMG_FOLDER " +
										"FROM ST_ANSWER " +
										"WHERE ANS_PHOTO_ENG IS NOT NULL AND ANS_PHOTO_ENG <> 'null' " +
										"UNION " +
										"SELECT QUE_PHOTO_ENG AS IMG_NAME, 'ST_QUESTION' AS IMG_FOLDER " +
										"FROM ST_QUESTION " +
										"WHERE QUE_PHOTO_ENG IS NOT NULL AND QUE_PHOTO_ENG <> 'null' " +
										"UNION " +
										"SELECT PRO_PHOTO AS IMG_NAME, 'ST_PRODUCTS' AS IMG_FOLDER " +
										"FROM ST_PRODUCTS " +
										"WHERE PRO_PHOTO IS NOT NULL AND PRO_PHOTO <> 'null'";
			return resultQuery;
		}

		public static function buildPrimaryInserts():Array
		{
			var resultArray:Array = new Array();
			
			// main insert
			var resultQuery0:String = "INSERT INTO ST_VISIT (VIS_NUMBER, VIS_USE_CODE, " +
				"VIS_SAL_CODE, VIS_PER_CODE, VIS_ROU_CODE, " +
				"VIS_ROU_DATE, VIS_START_DATE, VIS_FINISH_DATE, VIS_VIT_ID, " +
				"VIS_PROMO_NAME, " +
				"VIS_PROMO_SURNAME, " +
				"VIS_ACCURACY, " +
				"VIS_GPS_TYPE, " +
				"VIS_LATITUDE, " +
				"VIS_LONGITUDE) " +
				"VALUES (" +
				"'" + Globals.VIS_NUMBER + "'" + "," +
				Globals.USE_CODE + "," +
				Globals.SAL_CODE + "," +
				Globals.PER_CODE + "," +
				"(SELECT ROS_ROU_CODE FROM ST_ROUTE_SALEPOINT WHERE ROS_ROU_CODE = " + Globals.ROU_CODE + " AND ROS_SAL_CODE = " + Globals.SAL_CODE + ")," +
				"'" + Globals.ROU_DATE + "'," +
				"'" + Globals.CurrentDateTimeWithMinutesSecondsString() + "'" + "," +
				"'" + Globals.CurrentDateTimeWithMinutesSecondsString() + "'" + "," +
				"'VIT01'" + 
				"," +
				"'" + Globals.VIS_PROMO_NAME + "'" + "," +
				"'" + Globals.VIS_PROMO_SURNAME + "'" + "," +
				"'" + GPSUtil.ACCURACY + "'" + "," +
				"'" + GPSUtil.GPS_PROVIDER + "'" + "," +
				GPSUtil.LAT + "," +
				GPSUtil.LON + 
				")";
			
			// other inserts
			var resultQuery1:String = "UPDATE ST_SURVEY_RESULTS SET SRS_IS_OLD = 1, SRS_ANS_CHECKED = 0 WHERE SRS_SAL_CODE = " + Globals.SAL_CODE + ";";
			var resultQuery2:String = "UPDATE ST_SURVEY SET SUR_IS_OPEN = null;";
			var resultQuery3:String = "UPDATE ST_SALEPOINT SET VISITED = 1 WHERE SAL_CODE = " + Globals.SAL_CODE + ";";
			
			resultArray.push(resultQuery0);
			resultArray.push(resultQuery1);
			resultArray.push(resultQuery2);
			resultArray.push(resultQuery3);
			
			return resultArray;			
		}
		
		public static function buildSubVisitInsert(VIS_TYPE:String):Array
		{
			var resultArray:Array = new Array();
			
			var resultQuery:String = "INSERT INTO ST_VISIT (VIS_NUMBER, VIS_USE_CODE, " +
				"VIS_SAL_CODE, VIS_PER_CODE, VIS_ROU_CODE, " +
				"VIS_ROU_DATE, VIS_START_DATE, VIS_VIT_ID, " +
				"VIS_PROMO_NAME, " +
				"VIS_PROMO_SURNAME, " +
				"VIS_ACCURACY, " +
				"VIS_GPS_TYPE, " +
				"VIS_PARENT_NUMBER, " +
				"VIS_LATITUDE, VIS_LONGITUDE) VALUES (" +
				"'" + Globals.SUB_VIS_NUMBER + "'" + "," +
				Globals.USE_CODE + "," +
				Globals.SAL_CODE + "," +
				Globals.PER_CODE + "," +
				"(SELECT ROS_ROU_CODE FROM ST_ROUTE_SALEPOINT WHERE ROS_ROU_CODE = " + Globals.ROU_CODE + " AND ROS_SAL_CODE = " + Globals.SAL_CODE + ")," +
				"'" + Globals.ROU_DATE + "'," +
				"'" + Globals.CurrentDateTimeWithMinutesSecondsString() + "'" + "," +
				"'" + VIS_TYPE + "'" + 
				"," +
				"'" + Globals.VIS_PROMO_NAME + "'" + "," +
				"'" + Globals.VIS_PROMO_SURNAME + "'" + "," +
				"'" + GPSUtil.ACCURACY + "'" + "," +
				"'" + GPSUtil.GPS_PROVIDER + "'" + "," +
				"'" + Globals.VIS_NUMBER + "'" + "," +
				GPSUtil.LAT + "," +
				GPSUtil.LON + 
				")";
			
			resultArray.push(resultQuery);
			
			return resultArray;
		}
		
		
		public static function buildCheckOutInsert(VIS_TYPE:String):String
		{
			var resultQuery:String = "INSERT INTO ST_VISIT (VIS_NUMBER, VIS_USE_CODE, " +
				"VIS_SAL_CODE, VIS_PER_CODE, VIS_ROU_CODE, " +
				"VIS_ROU_DATE, VIS_START_DATE, VIS_FINISH_DATE, VIS_VIT_ID, " +
				"VIS_PROMO_NAME, " +
				"VIS_PROMO_SURNAME, " +
				"VIS_ACCURACY, " +
				"VIS_GPS_TYPE, " +
				"VIS_PARENT_NUMBER, " +
				"VIS_LATITUDE, VIS_LONGITUDE) VALUES (" +
				"'" + Globals.getUniqueCode() + "'" + "," +
				Globals.USE_CODE + "," +
				Globals.SAL_CODE + "," +
				Globals.PER_CODE + "," +
				"(SELECT ROS_ROU_CODE FROM ST_ROUTE_SALEPOINT WHERE ROS_ROU_CODE = " + Globals.ROU_CODE + " AND ROS_SAL_CODE = " + Globals.SAL_CODE + ")," +
				"'" + Globals.ROU_DATE + "'," +
				"'" + Globals.CurrentDateTimeWithMinutesSecondsString() + "'" + "," +
				"'" + Globals.CurrentDateTimeWithMinutesSecondsString() + "'" + "," +
				"'" + VIS_TYPE + "'" + 
				"," +
				"'" + Globals.VIS_PROMO_NAME + "'" + "," +
				"'" + Globals.VIS_PROMO_SURNAME + "'" + "," +
				"'" + GPSUtil.ACCURACY + "'" + "," +
				"'" + GPSUtil.GPS_PROVIDER + "'" + "," +
				"'" + Globals.VIS_NUMBER + "'" + "," +
				GPSUtil.LAT + "," +
				GPSUtil.LON + 
				")";
			return resultQuery;
		}
		
		public static function buildInsertVisitPhoto(VIS_NUMBER:String, fURL:String, fName:String, proCode:String="null"):String
		{
			var resultQuery:String = "INSERT INTO ST_VISIT_PHOTO (VIP_VIS_NUMBER, VIP_SAL_ID, VIP_PHOTO_URL, " +
				"VIP_PHOTO_NAME, VIP_PRO_CODE, VIP_FOLDER_NAME, VIP_PHOTO_DATE, VIP_ACTIVE) " +
				" " +
				"VALUES (" +
				"'" + VIS_NUMBER + "', " +
				"'" + Globals.SAL_ID + "', " +
				"'" + fURL + "', " + 
				"'" + fName + "', " +
				proCode + ", " +
				"'" + Globals.USE_CODE + "', " +
				"'" + Globals.CurrentDateTimeWithMinutesSecondsString() + "', " +
				"1)"; 
			return resultQuery;
		}
		
		public static function buildMenuLoad(MENU_GROUP:String):String
		{
			var resultQuery:String = "SELECT MNU_NAME AS ITEM_NAME, MNU_DESC AS ITEM_DESC, * " +
				"FROM ST_MENU " +
				"WHERE MNU_GROUP = '" + MENU_GROUP + "' " +
				"AND " +
				"MNU_LANG = 'ru_RU' " + 
				"AND " +
				"MNU_SHOWED = 1 " +
				"ORDER BY MNU_SHOW_ORDER";
			return resultQuery;
		}
		
		public static function buildSelectProductList(WHERE_CLAUSE:String):String
		{
			var resultQuery:String = "SELECT " +
				"(SELECT PRD_PRICE FROM ST_PRICE_DOCUMENT WHERE PRD_PRO_CODE = PRO_CODE AND PRD_SAL_CODE = " + Globals.SAL_CODE + " ORDER BY ROWID DESC LIMIT 1) AS PRO_ACTUAL_PRICE, " +
				"0 AS SELECTED, " +
				"* " +
				"FROM ST_PRODUCTS " +
				"WHERE (1=1) AND (" + WHERE_CLAUSE + ") " + 
				"ORDER BY PRO_NAME";
			return resultQuery;
		}
		
		public static function buildInsertPriceDocument(price:String, coeff:String, promo:String):String
		{
			var resultQuery:String = "INSERT INTO ST_PRICE_DOCUMENT " +
				"(PRD_USE_CODE, " +
				"PRD_PRO_CODE, " +
				"PRD_PRICE, " +
				"PRD_COEFF, " +
				"PRD_VISIT_ID, " +
				"PRD_SAL_CODE, " +
				"PRD_SAL_ID, " +
				"PRD_PROMO, " +
				"PRD_DATE) " +
				"VALUES (" + 
				"'" + Globals.USE_CODE + "'," + 
				"'" + Globals.PRO_CODE + "'," + 
				"'" + price + "'," +
				"'" + coeff + "'," +
				"'" + Globals.SUB_VIS_NUMBER + "'," + 
				"'" + Globals.SAL_CODE + "'," +
				"'" + Globals.SAL_ID + "'," + 
				"'" + promo + "'," +
				"'" + Globals.CurrentDateTimeWithMinutesSecondsString() + "'" + ");";
			
			return resultQuery;
		}
		
		public static function buildUpdatePriceDocument(price:String, coeff:String, promo:String):String
		{
			var resultQuery:String = "UPDATE ST_PRICE_DOCUMENT " +
				"SET " +
				"PRD_PRICE = '" + price + "', " +
				"PRD_COEFF = '" + coeff + "', " +
				"PRD_PROMO = '" + promo + "'," +
				"PRD_DATE = '" + Globals.CurrentDateTimeWithMinutesSecondsString() + "' " +
				"WHERE " +
				"PRD_PRO_CODE = '" + Globals.PRO_CODE + "'" + 
				" AND " + 
				"PRD_VISIT_ID = '" + Globals.SUB_VIS_NUMBER + "';";			
			return resultQuery;
		}
		
		public function QueryConstructor()
		{
		}
	}
}