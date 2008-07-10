package net.guttershark.core 
{
	import flash.display.MovieClip;
	
	import net.guttershark.events.EventManager;
	import net.guttershark.managers.KeyboardEventManager;
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
	public class CoreClip extends MovieClip implements IDisposable
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
		protected var km:KeyboardEventManager;
		
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
		public function CoreClip()
		{
			super();
			em = EventManager.gi();
			ml = Model.gi();
			km = KeyboardEventManager.gi();
			lm = LanguageManager.gi();
			rm = RemotingManager.gi();
			al = AssetLibrary.gi();
		}
		
		/**
		 * Dispose of the object.
		 */
		public function dispose():void{}
	}
}