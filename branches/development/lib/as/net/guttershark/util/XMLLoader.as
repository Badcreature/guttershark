package net.guttershark.util
{	

	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	/**
	 * The XMLLoader Class is used to load xml. It wraps common logic
	 * that must be in place to load XML, and shortens the amount of code
	 * you need to write to load XML.
	 * 
	 * @see #load()
	 */
	public class XMLLoader extends EventDispatcher
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
			Assert.NotNull(request, "Parameter request cannot be null.");
			Assert.NotNull(request.url, "The url property of the request cannot be null");
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