package net.guttershark.core 
{
	import flash.display.Sprite;
	
	import net.guttershark.events.EventManager;
	import net.guttershark.managers.KeyboardEventManager;
	import net.guttershark.managers.LanguageManager;
	import net.guttershark.managers.PathManager;
	import net.guttershark.model.Model;
	import net.guttershark.preloading.AssetLibrary;
	import net.guttershark.preloading.PreloadController;
	import net.guttershark.remoting.RemotingManager;
	import net.guttershark.services.ServiceManager;
	import net.guttershark.util.FlashLibrary;		

	/**
	 * The CoreSprite Class is a base class that providesasdf
	 * common properties and methods that are used over
	 * and over in sprites. This class is relief
	 * from having to type the same code over and over.
	 */
	public class CoreSprite extends Sprite implements IDisposable
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
		 * A placeholder variable for a PreloadController instance. You should initialize this yourself.
		 */
		protected var pc:PreloadController;
		
		/**
		 * The AssetLibrary singleton instance.
		 */
		protected var al:AssetLibrary;

		/**
		 * The ServiceManager singleton instance.
		 */
		protected var sm:ServiceManager;

		/**
		 * The singleton instance of the FlashLibrary.
		 */
		protected var fb:FlashLibrary;

		/**
		 * The PathManager singleton instance.
		 */
		protected var pm:PathManager;

		/**
		 * Constructor for CoreSprite instances.
		 */
		public function CoreSprite()
		{
			super();
			em = EventManager.gi();
			ml = Model.gi();
			km = KeyboardEventManager.gi();
			lm = LanguageManager.gi();
			rm = RemotingManager.gi();
			al = AssetLibrary.gi();
			sm = ServiceManager.gi();
			fb = FlashLibrary.gi();
			pm = PathManager.gi();
		}

		/**
		 * Dispose of the object.
		 */
		public function dispose():void{}
	}
}