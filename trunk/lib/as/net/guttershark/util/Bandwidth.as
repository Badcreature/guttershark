package net.guttershark.util
{

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	
	/**
	 * The Bandwidth class downloads a bitmap file, and benchmarks the client's
	 * bandwidth.
	 *  
	 * @example Sniffing the user's bandwidth:
	 * <listing>	
	 * import net.guttershark.managers.EventManager;
	 * import net.guttershark.util.Bandwidth;
	 * 
     * var bs:Bandwidth = new Bandwidth();
     * em.handleEvents(bs,this,"onBS");
     * bs.detect();
     * public function onBSComplete():void
     * {
     * 		trace(Bandwidth.Speed);
     * 		trace(Bandwidth.Speed==Bandwidth.HIGH);
     * 		trace(Bandwidth.Speed==Bandwidth.MED);
     * 		trace(Bandwidth.Speed==Bandwidth.LOW);
     * 		//Bandwidth.Speed will be equal to Bandwidth.LOW / MED / HIGH. One of the three.
     * }
	 * </listing>
	 * 
	 * @see net.guttershark.control.DocumentController DocumentController class
	 */
	final public class Bandwidth extends EventDispatcher
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
		public static var Speed:String = null;
		
		/**
		 * The image to use in the detection script.
		 */
		private var detectImage:URLRequest;
		
		/**
		 * The loader used to load the bandwidth image.
		 */
		public var contentLoader:URLLoader;
		
		//timing / tracking vars
		private var startTime:Number;
		private var endTime:Number;
		private var totalBytes:Number;
		private var bandwidth:uint;
		private var targetMedBandwidth:Number;
		private var targetLowBandwidth:Number;
		
		/**
		 * Constructor for Bandwidth instances.
		 * 
		 * @param targetLowBandwidth The target KBps for low bandwidth.
		 * @param targetMedBandwidth The target KBps for med bandwidth.
		 * @param image This is an optional parameter - by default the sniffer loads a reference to
		 * ./bandwidth.jpg. You can pass a different URLRequest here to change what file
		 * is used in the bandwidth detection.
		 * 
		 * <p>The target high bandwidth is not a parameter because anything higher than the target medium
		 * bandwidth KBps will automatically be high.</p>
		 */
		public function Bandwidth(image:URLRequest=null,targetLowBandwidth:Number=256,targetMedBandwidth:Number=550):void
		{
			if(!image) image = new URLRequest("./bandwidth.jpg");
			this.targetLowBandwidth = targetLowBandwidth;
			this.targetMedBandwidth = targetMedBandwidth;
			this.detectImage = image;
			contentLoader = new URLLoader();
			contentLoader.addEventListener(Event.COMPLETE,onComplete);
		}
			
		/**
		 * Inititiates the bandwidth detection process.
		 */
		public function detect():void
		{
			if(!detectImage) throw new Error("You must supply an image to load.");
			endTime = 0;
			startTime = 0;
			totalBytes = 0;
			bandwidth = 0;
			contentLoader.addEventListener(Event.OPEN,onStart,false,0,true);
			contentLoader.addEventListener(ProgressEvent.PROGRESS,onProgress,false,0,true);
			contentLoader.load(detectImage);
		}
				
		/**
		 * On start of the downloading.
		 */
		private function onStart(se:Event):void
		{
			startTime = getTimer();
		}
		
		/**
		 * When the image completes downloading.
		 */
		private function onComplete(ce:Event):void
		{
			endTime = getTimer();
			var kbytes:uint = (totalBytes * 1000); //converts to kilobytes
			bandwidth = (kbytes / ((endTime - startTime) * 100)); //get Kbps
    		if(bandwidth < targetLowBandwidth) Bandwidth.Speed = Bandwidth.LOW;
    		else if(bandwidth < targetMedBandwidth) Bandwidth.Speed = Bandwidth.MED;
    		else Bandwidth.Speed = Bandwidth.HIGH;
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
			contentLoader.removeEventListener(Event.OPEN,onStart);
			contentLoader.removeEventListener(ProgressEvent.PROGRESS,onProgress);
			contentLoader.removeEventListener(Event.COMPLETE,onComplete);
			//contentLoader.close();
		}
		
		/**
		 * Dispose of internal variables.
		 */
		public function dispose():void
		{
			removeListeners();
			detectImage = null;
			contentLoader = null;
			endTime = NaN;
			startTime = NaN;
			targetLowBandwidth = NaN;
			targetMedBandwidth = NaN;
			totalBytes = NaN;
			bandwidth = NaN;
		}
	}
}