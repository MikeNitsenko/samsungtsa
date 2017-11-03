package
{
	import flash.system.Capabilities;
	
	import mx.core.DPIClassification;
	import mx.core.RuntimeDPIProvider;
	
	public class TsaRuntimeDPIProvider extends RuntimeDPIProvider
	{
		public function TsaRuntimeDPIProvider() {
		}
		
		override public function get runtimeDPI():Number {
			
			/* Adobe way of overriding app dpi */
			/*
			if (Capabilities.screenDPI == 240 && 
				Capabilities.screenResolutionY == 1024 && 
				Capabilities.screenResolutionX == 600) {
				return DPIClassification.DPI_160;
			}
			
			if (Capabilities.screenDPI < 200)
				return DPIClassification.DPI_160;
			
			if (Capabilities.screenDPI <= 280)
				return DPIClassification.DPI_240;
			
			return DPIClassification.DPI_320; 
			*/
			
			/* Caltrain Times app way - much better deals with fonts
			https://github.com/renaun/CaltrainTimes/blob/master/src/com/renaun/mobile/dpi/CustomDPIProvider.as */
			
			var screenX:Number = Capabilities.screenResolutionX;
			var screenY:Number = Capabilities.screenResolutionY;
			var pixelCheck:Number = screenX * screenY;
			var pixels:Number = (screenX*screenX) + (screenY*screenY);
			var screenSize:Number = Math.sqrt(pixels)/Capabilities.screenDPI;
			//trace("screenSize: " + screenSize + " - " + Capabilities.screenDPI + " - " + screenX +"/"+screenY + " - " + pixelCheck);
			if (screenSize > 4.3 && pixelCheck > 510000 && pixelCheck < 610000 &&
				Capabilities.screenDPI < 240 && pixelCheck != 1296000) 
			{
				//trace("Force 240");
				return DPIClassification.DPI_240;
			}
			else if (screenSize > 6.9 && screenSize < 11 && pixelCheck > 610000 && pixelCheck < 1920000 && pixelCheck != 1296000)
			{
				//trace("Force 240 Tablet");
				return DPIClassification.DPI_240;	
			}
			
			if (Capabilities.screenDPI < 200)
				return DPIClassification.DPI_160;
			
			if (Capabilities.screenDPI <= 280)
				return DPIClassification.DPI_240;
			
			return DPIClassification.DPI_320; 
		}
		
	}
}