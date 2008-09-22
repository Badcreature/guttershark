package net.guttershark.core 
{
	import flash.display.MovieClip;
	
	import net.guttershark.events.EventManager;
	import net.guttershark.managers.KeyManager;
	import net.guttershark.managers.LanguageManager;
	import net.guttershark.model.Model;
	import net.guttershark.preloading.AssetLibrary;
	import net.guttershark.preloading.PreloadController;
	import net.guttershark.remoting.RemotingManager;	

	/**
	 * The CoreObject Class is a base class that provides
	 * common properties and methods that are used over
	 * and over in classes. This class is relief
	 * from having to type the same code over and over.
	 */
	public class CoreObject extends MovieClip implements IDisposable
	{

		/**
		 * The EventManager singleton instance.
		 */
		protected var em:EventManager;
		
		/**
		 * The Model singleton instance.
		 */
		protected var ml:Model;
		
		/**
		 * The KeyboardEventManager singleton instance.
		 */
		protected var km:KeyManager;
		
		/**
		 * The LanguageManager singleton instance.
		 */
		protected var lm:LanguageManager;
		
		/**
		 * The RemotingManager singleton instance.
		 */
		protected var rm:RemotingManager;
		
		/**
		 * A PreloadController instance.
		 */
		protected var pc:PreloadController;
		
		/**
		 * The AssetLibrary singleton instance.
		 */
		protected var al:AssetLibrary;

		/**
		 * Constructor for CoreObject instances.
		 */
		public function CoreObject()
		{
			super();
			em = EventManager.gi();
			ml = Model.gi();
			km = KeyManager.gi();
			lm = LanguageManager.gi();
			rm = RemotingManager.gi();
			al = AssetLibrary.gi();
		}
		
		/**
		 * Creates a new PreloadController in the "pc" property. And set's up auto
		 * event management through the EventManager. The callback method prefix is
		 * "onPreloader." So you can define onPreloaderPreloadProgress, etc.
		 * @param	pixels	The amount of pixels the preloader should fill.
		 */
		protected function setupPreloadController(pixels:int = 100):void
		{
			pc = new PreloadController(pixels);
			em.handleEvents(pc, this, "onPreloader");
		}
		
		/**
		 * Dispose of the preload controller instance in the EventManager.
		 */
		public function dispose():void
		{
			em.disposeEventsForObject(pc);
		}	}}