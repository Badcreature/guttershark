package net.guttershark.util
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	
	/**
	 * Dispatched after bandwidth has been detected.
	 * 
	 * The <code>bandwidth detected</code> event is of type BandwidthEvent and has the 
	 * constant <code>BandwidthEvent.BANDWIDTH_DETECTED</code>
	 * 
	 * @eventType com.mccann.floss.events.BandwidthEvent
	 */
	[Event(name="bandwidthDetected",type="com.mccann.floss.events.BandwidthEvent")];
	
	/**
	 * Dispatched when an IO Error happens. The error is stemmed directly from the
	 * URLLoader that is loading the bandwidth image.
	 * 
	 * @eventType flash.events.IOErrorEvent
	 */
	[Event(name="ioError",type="flash.events.IOErrorEvent")];
	
	/**
	 * Dispatched when an HTTPStatus Error happens. The status event comes directly
	 * from the URLLoader that loads the bandwidth.jpg file. The event is NOT
	 * dispatched when the event's 'status' code is either 200 or 0.
	 *
	 * @eventType flash.events.HTTPStatusEvent
	 */
	[Event(name="httpStatus",type="flash.events.HTTPStatusEvent")];
	
	/**
	 * Dispatched when an SecurityErrorEvent happens. The event stems directly from
	 * the URLLoader that is used to load the bitmap.jpg.
	 * 
	 * @eventType flash.events.SecurityErrorEvent 
	 */
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")];
	
	/**
	 * Sniff the user's bandwidth. A 'bandwidth.jpg' has to be in
	 * the same directory as the published swf (./bandwidth.jpg)
	 *  
	 * EX:
	 * <code>
     * var bs:Bandwidth = new Bandwidth();
     * bs.addEventListener(BandwidthEvent.BANDWIDTH_DETECTED, onDetect);
     * bs.detect();
     * function onDetect(be:BandwidthEvent)
     * {
     * 		trace(be.bandwidth)
     * 		//be.bandwidth will be equal to Bandwidth.LOW / MED / HIGH. One of the three.
     * }
	 * </code>
	 */
	public class Bandwidth extends EventDispatcher
	{
		/**
		 * Low bandwidth
		 */
		public static const LOW:String = "low";
		
		/**
		 * Medium bandwidth
		 */
		public static const MED:String = "med";
		
		/**
		 * High bandwidth
		 */
		public static const HIGH:String = "high";
		
		/**
		 * Pointer to which bandwidth is detected. Default is Bandwidth.MED
		 */
		public static var Band:String = Bandwidth.MED;
		
		/**
		 * The image to use in the detection script.
		 */
		private var detectImage:URLRequest;
		
		/**
		 * The loader used to load the bandwidth image.
		 */
		private var detectImageLoader:URLLoader;
		
		//timing / tracking vars
		private var startTime:Number;
		private var endTime:Number;
		private var totalBytes:Number;
		private var bandwidth:uint;
		private var targetMedBandwidth:Number;
		private var targetLowBandwidth:Number;
		
		/**
		 * Creates a new Bandwidth
		 * 
		 * @param		URLRequest			This is an optional parameter. By default the sniffer loads a
		 * ./bandwidth.jpg file. You can pass a different URLRequest here to change what file
		 * is used in the bandwidth detection.
		 * 
		 * @param		Number				The target Kbps for low bandwidth
		 * @param		Number				The target Kbps for med bandwidth
		 * 
		 * The target high bandwidth is not a parameter because anything higher than the target medium
		 * bandwidth Kbps will automatically be high.
		 */
		public function Bandwidth(image:URLRequest = null, targetLowBandwidth:Number = 256, targetMedBandwidth:Number = 550):void
		{
			if(!image) image = new URLRequest("./bandwidth.jpg");
			this.targetLowBandwidth = targetLowBandwidth;
			this.targetMedBandwidth = targetMedBandwidth;
			this.detectImage = image;
		}
			
		/**
		  * Triggers the detection process
		  */
		public function detect():void
		{
			if(!detectImage) throw new Error("You must supply an image to load.");
			endTime = 0;
			startTime = 0;
			totalBytes = 0;
			bandwidth = 0;
			detectImageLoader = new URLLoader();
			detectImageLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS,onStatus);
			detectImageLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			detectImageLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
			detectImageLoader.addEventListener(Event.OPEN,onStart);
			detectImageLoader.addEventListener(ProgressEvent.PROGRESS,onProgress);
			detectImageLoader.addEventListener(Event.COMPLETE,onComplete);
			detectImageLoader.load(detectImage);
		}
		
		//on security error.
		private function onSecurityError(se:SecurityErrorEvent):void
		{
			removeListeners();
			dispatchEvent(se);
		} 
		
		//on io error
		private function onIOError(ioe:IOErrorEvent):void
		{
			removeListeners();
			dispatchEvent(ioe);
		}
		
		//on status	
		private function onStatus(se:HTTPStatusEvent):void
		{
			if(se.status != 0 && se.status != 200)
			{
				removeListeners();
				dispatchEvent(se);	
			}
		}
		
		//on start downloading
		private function onStart(se:Event):void
		{
			startTime = getTimer();
		}
		
		// On complete downloading
		private function onComplete(ce:Event):void
		{
			endTime = getTimer();
			var kbytes:uint = (totalBytes * 1000); //converts to kilobytes
			bandwidth = (kbytes / ((endTime - startTime) * 100)); //get Kbps
    		if(bandwidth < targetLowBandwidth) Bandwidth.Band = Bandwidth.LOW;
    		else if(bandwidth < targetMedBandwidth) Bandwidth.Band = Bandwidth.MED;
    		else Bandwidth.Band = Bandwidth.HIGH;
			removeListeners();
			bandwidth = NaN;
			startTime = NaN;
			endTime = NaN;
			totalBytes = NaN;
			detectImage = null;
		}
		
		//On progress of the loader
		private function onProgress(pe:ProgressEvent):void
		{
			if(pe.bytesTotal > 0) totalBytes = pe.bytesTotal;
		}
		
		//removes listeners on the URLLoader.
		private function removeListeners():void
		{
			detectImageLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
			detectImageLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			detectImageLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			detectImageLoader.removeEventListener(Event.OPEN,onStart);
			detectImageLoader.removeEventListener(ProgressEvent.PROGRESS,onProgress);
			detectImageLoader.removeEventListener(Event.COMPLETE,onComplete);
			detectImageLoader.close();
		}
	}
}