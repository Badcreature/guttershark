package net.guttershark.util
{
	import net.guttershark.errors.AccessError;	
	import net.guttershark.core.IDisposable;	

	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	/**
	 * Dispatched when the xml has completed loading.
	 */
	[Event("complete", type="flash.events.Event")];
	
	/**
	 * Dispatched when an http status error occurs.
	 */
	[Event("httpStatus", type="flash.events.HTTPStatusEvent")];
	
	/**
	 * Dispatched when an io error occurs.
	 */
	[Event("ioError", type="flash.events.IOErrorEvent")];
	
	/**
	 * Dispatched on progress.
	 */
	[Event("progress", type="flash.events.ProgressEvent")];
	
	/**
	 * Dispatched on security error.
	 */
	 [Event("securityError", type="flash.events.SeecurityErrorEvent")]
	
	/**
	 * The XMLLoader class is used to load xml. It wraps common logic
	 * that must be in place to load XML, and shortens the amount of code
	 * you need to write to load XML.
	 * 
	 * @see #load()
	 */
	public class XMLLoader extends EventDispatcher implements IDisposable
	{	

		/**
		 * The loader object used for xml loading.
		 */
		private var loader:URLLoader;
		
		/**
		 * A flag indicator to detect Memory errors.
		 */
		private var state:int;
		
		/**
		 * The final XML data that has been loaded.
		 */
		private var _data:XML;
		
		/**
		 * Constructor for XMLLoader instances.
		 */
		public function XMLLoader()
		{
			state = 0;
		}
		
		/**
		 * Load an xml file.
		 * 
		 * @param	request	A URLRequest to the xml file.
		 * 
		 * @throws	ArgumentError	When the request was not supplied.
		 * 
		 * @example Load an xml file:
		 * <listing>	
		 * private var xloader:XMLLoader = new XMLLoader(new URLRequest(myxmlfile));
		 * xloader.addEventListener(Event.COMPLETE, onx);
		 * private function onx(e:Event):void
		 * {
		 *   trace(e.target.data);
		 *   trace(xloader.data);
		 * }
		 * </listing>
		 */
		public function load(request:URLRequest):void
		{
			if(!request) throw new ArgumentError("You must supply a valid xml file location.");
			state = state & 1;
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onXMLComplete);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.addEventListener(IOErrorEvent.DISK_ERROR, onIOError);
			loader.addEventListener(IOErrorEvent.NETWORK_ERROR, onIOError);
			loader.addEventListener(IOErrorEvent.VERIFY_ERROR, onIOError);
			loader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.load(request);
		}
		
		/**
		 * Close the internal loader instance.
		 */
		public function close():void
		{
			loader.close();
		}
		
		/**
		 * The final XML data that has been loaded.
		 * 
		 * @throws	AccessError		When the data property is null because it had been previously disposed.
		 */
		public function get data():XML
		{
			if(((state & 1) == 1) && ((state >> 1) == 1)) throw new AccessError("The XMLLoader instance has already been disposed of.");
			else return _data;
		}
		
		/**
		 * Closes internal loader, and disposes of internal objects in memory.
		 */
		public function dispose():void
		{
			_data = null;
			state = state & 3;
			loader.removeEventListener(Event.COMPLETE, onXMLComplete);
			loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.removeEventListener(IOErrorEvent.DISK_ERROR, onIOError);
			loader.removeEventListener(IOErrorEvent.NETWORK_ERROR, onIOError);
			loader.removeEventListener(IOErrorEvent.VERIFY_ERROR, onIOError);
			loader.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			loader.close();
		}
		
		private function onXMLComplete(e:Event):void
		{
			_data = XML(e.target.data);
			if(this.hasEventListener(Event.COMPLETE)) dispatchEvent(e);
		}
		
		private function onSecurityError(e:SecurityErrorEvent):void
		{
			if(this.hasEventListener(SecurityErrorEvent.SECURITY_ERROR)) dispatchEvent(e);
			else throw new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR,false,false,"SecurityError loading xml file.");
		}

		private function onStatus(e:HTTPStatusEvent):void
		{
			if(e.status == 200 || e.status == 0) return;
			if(this.hasEventListener(HTTPStatusEvent.HTTP_STATUS)) dispatchEvent(e);
			else throw e;
		}
		
		private function onIOError(e:IOErrorEvent):void
		{
			if(this.hasEventListener(IOErrorEvent.DISK_ERROR) || this.hasEventListener(IOErrorEvent.IO_ERROR) || 
				this.hasEventListener(IOErrorEvent.NETWORK_ERROR) || this.hasEventListener(IOErrorEvent.VERIFY_ERROR))
				dispatchEvent(e);
			else throw e;
		}
		
		private function onProgress(e:ProgressEvent):void
		{
			if(this.hasEventListener(ProgressEvent.PROGRESS)) dispatchEvent(e);
		}
	}
}