package net.guttershark.preloading.workers
{
	
	import net.guttershark.preloading.workers.BitmapWorker;
	
	/**
	 *	The SWFWorker class is the worker that loads all
	 *	swf files.
	 *	
	 *	<p>This class is not used directly. It is used internally to an
	 *	Asset instance.</p>
	 *	
	 *	@see net.guttershark.preloading.PreloadController PreloadController class
	 */
	public class SWFWorker extends BitmapWorker
	{	
		
		/**
		 * All functionality comes from the BitmapWorker.
		 * @see net.guttershark.preloading.workers.BitmapWorker
		 */
		public function SWFWorker():void
		{
			super();
		}
	}
}