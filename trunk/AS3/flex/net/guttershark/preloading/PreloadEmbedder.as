package net.guttershark.preloading
{

	import flash.display.Loader;
	import flash.utils.setTimeout;
	
	/**
	 * A generic SWF preloader embedder class that can be use
	 * in combination with the DownloadPreloader, and
	 * a preloader that is accessible after creation complete.
	 */
	public class PreloadEmbedder
	{
		
		/**
		 * The loader used to initialize the swf bytes.
		 */
		public static var loader:Loader;
		
		/**
		 * The preloader coming out of the swf. Note that the 
		 * preloader class name in the swf should be "Preloader"
		 */
		public static var embeddedPreloader:BaseSitePreloader;
		
		/**
		 * The SWFByte property is an embeded swf. This swf is embedded
		 * at compile time so that at run-time, the swf can be initiazlized
		 * and added to the stage
		 */
		[Embed(source="/flash/embedded/preloader.swf", mimeType="application/octet-stream")]
		public static var SWFBytes:Class;
		
		/**
		 * Instantiate the swf
		 */
		public function PreloadEmbedder()
		{
			if(!embeddedPreloader)
			{
				loader = new Loader();
				if(!SWFBytes) throw new Error("You need to declare and embed SWFBytes property");
				loader.loadBytes(new SWFBytes());
				flash.utils.setTimeout(initSWF,100);
			}
		}
		
		/**
		 * Initializes the swf.
		 */
		private function initSWF():void
		{
			var klazz:Class = loader.contentLoaderInfo.applicationDomain.getDefinition("Preloader") as Class;
			embeddedPreloader = new klazz() as BaseSitePreloader;
		}
	}
}