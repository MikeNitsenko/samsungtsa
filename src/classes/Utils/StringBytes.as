package classes.Utils
{
	import flash.utils.ByteArray;
	
	public class StringBytes 
	{
		public static function toString(ba:ByteArray):String 
		{
			var acum:String = "";
			
			ba.position = 0;
			
			while (ba.position < ba.length) {
				var dat:String = ba.readUnsignedByte().toString(16);
				
				while (dat.length < 2) dat = "0" + dat;
				
				acum += dat;
			}
			
			ba.position = 0;
			
			return acum;
		}
		
		public static function toByteArray(str:String):ByteArray 
		{
			if (str.length % 2 != 0) return null;
			
			var ba:ByteArray = new ByteArray();
			
			for (var i:int = 0; i < str.length; i += 2) {
				var num:int = parseInt("0x" + str.substr(i, 2));
				ba.writeByte(num);
			}
			
			ba.position = 0;
			return ba;
		}
	}
}