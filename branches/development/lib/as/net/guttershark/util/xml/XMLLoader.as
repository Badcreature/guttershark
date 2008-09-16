package net.guttershark.util.xml
{	

	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	/**
	 * The XMLLoader class loads xml.
	 * 
	 * @see #load()
	 */
	final public class XMLLoader extends EventDispatcher
	{	

		/**
		 * The loader object used for xml loading.
		 */
		public var contentLoader:URLLoader;
		
		/**
		 * The final XML data that has been loaded.
		 */
		private var _data:XML;
		
		/**
		 * Constructor for XMLLoader instances.
		 */
		public function XMLLoader()
		{
			contentLoader = new URLLoader();
			contentLoader.addEventListener(Event.COMPLETE, onXMLComplete);
		}
		
		/**
		 * Load an xml file.
		 * 
		 * @param	request	A URLRequest to the xml file.
		 * 
		 * @example Load an xml file:
		 * <listing>	
		 * import net.guttershark.managers.EventManager;
		 * import net.guttershark.util.XMLLoader;
		 * 
		 * private var xloader:XMLLoader = new XMLLoader();
		 * em.handleEvents(xloader,this,"onXML");
		 * 
		 * public function onXMLComplete():void
		 * {
		 *   trace(e.target.data);
		 *   trace(xloader.data);
		 * }
		 * 
		 * xloader.load(new URLRequest(myxmlfile));
		 * </listing>
		 */
		public function load(request:URLRequest):void
		{
			if(!request) throw new ArgumentError("Parameter request cannot be null.");
			contentLoader.dataFormat = URLLoaderDataFormat.TEXT;
			contentLoader.load(request);
		}
		
		/**
		 * Close the internal loader instance.
		 */
		public function close():void
		{
			contentLoader.close();
		}
		
		/**
		 * The final XML data that has been loaded.
		 */
		public function get data():XML
		{
			return _data;
		}
		
		/**
		 * Closes internal loader, and disposes of internal objects in memory.
		 */
		public function dispose():void
		{
			_data = null;
			contentLoader.removeEventListener(Event.COMPLETE, onXMLComplete);
			contentLoader.close();
			contentLoader = null;
		}
		
		private function onXMLComplete(e:Event):void
		{
			_data = XML(e.target.data);
		}
	}
}