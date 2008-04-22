package net.guttershark.preloading
{
	
	import flash.events.ProgressEvent;
	
	import mx.preloaders.DownloadProgressBar;
	
	/**
	 * A generic way of replacing the DownloadProgress bar in 
	 * flex. You must embed a swf preloader.
	 */
	public class DownloadPreloader extends DownloadProgressBar
	{
		
		/**
		 * The utility class to grab the embedded swf from.
		 */
		protected var embeddedPreloader:PreloadEmbedder;
		
		/**
		 * Creates a new DownloadPreloader. This should not be 
		 * instantiated. Put the source path 
		 * (com.mccann.floss.preloading.flex.DownloadPreloader)
		 * as the "preloader" attribute of the Application tag.
		 */
		public function DownloadPreloader()
		{
			super();
			if(!embeddedPreloader) throw new Error("You must set 'embeddedPreloader' to a PreloadEmbedder subclass before calling super()");
		}
		
		/**
		 * Overrides the progress handler so we can attach the
		 * embedded swf.
		 */
		override protected function progressHandler(pe:ProgressEvent):void
		{
			super.progressHandler(pe);
			if(PreloadEmbedder.embeddedPreloader != null) addChild(PreloadEmbedder.embeddedPreloader);
		}
	}
}