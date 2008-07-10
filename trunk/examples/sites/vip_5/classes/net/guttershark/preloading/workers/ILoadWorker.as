package net.guttershark.preloading.workers
{
	
	import net.guttershark.preloading.Asset;
	
	/**
	 * The ILoadWorker interface creates the contract for objects that are implementing
	 * the worker pattern for preloading.
	 * 
	 * @see net.guttershark.preloading.workers.Worker Worker class
	 * @see net.guttershark.preloading.PreloadController PreloadController class
	 */
	public interface ILoadWorker
	{
		
		/**
		 * 
		 * Override this method in a worker and implement the load logic setup.
		 * Then call <code>start</code> to actually start the loader.
		 * 
		 * @see #start() start method
		 * @see source "See the source code for any one of the worker classes for implementation examples."
		 */
		function load(asset:Asset):void;
		
		/**
		 * @private
		 * 
		 * This is provided as another way to start the preloading. The base Worker class
		 * has logic in it's start method to start the downloading, based off of properties
		 * you set in the individual workers' load method.
		 * 
		 * @see net.guttershark.preloading.workers.Worker#start() Worker start method
		 * @see "See the source code for any one of the worker classes for implementation examples."
		 */
		function start():void;
	}
}