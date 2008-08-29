package net.guttershark.display 
{
	import flash.display.MovieClip;
	
	import net.guttershark.managers.EventManager;
	import net.guttershark.managers.KeyboardEventManager;
	import net.guttershark.managers.LanguageManager;
	import net.guttershark.managers.ServiceManager;
	import net.guttershark.managers.SoundManager;
	import net.guttershark.model.Model;
	import net.guttershark.preloading.AssetLibrary;
	import net.guttershark.preloading.PreloadController;
	import net.guttershark.services.remoting.RemotingManager;
	import net.guttershark.util.FlashLibrary;	

	/**
	 * The CoreClass Class is a base class that provides
	 * common properties and methods that are used over
	 * and over in movie clips. This class is relief
	 * from having to type the same code over and over.
	 */
	public class CoreClip extends MovieClip
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
		 * The FlashLibrary singleton instance.
		 */
		protected var fb:FlashLibrary;

		/**
		 * The SoundManager singleton instance.
		 */
		protected var snm:SoundManager;

		/**
		 * Constructor for CoreClips instances.
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
			sm = ServiceManager.gi();
			fb = FlashLibrary.gi();
			snm = SoundManager.gi();
		}

		/**
		 * Dispose of the object.
		 */
		public function dispose():void{}
	}
}