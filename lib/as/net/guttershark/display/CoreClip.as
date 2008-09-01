package net.guttershark.display 
{
	import flash.display.MovieClip;
	
	import net.guttershark.control.PreloadController;
	import net.guttershark.managers.AssetManager;
	import net.guttershark.managers.EventManager;
	import net.guttershark.managers.KeyboardEventManager;
	import net.guttershark.managers.LanguageManager;
	import net.guttershark.managers.LayoutManager;
	import net.guttershark.managers.ServiceManager;
	import net.guttershark.managers.SoundManager;
	import net.guttershark.model.Model;
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
		protected var lgm:LanguageManager;
		
		/**
		 * A placeholder variable for a PreloadController instance. You should initialize this yourself.
		 */
		protected var pc:PreloadController;
		
		/**
		 * The AssetManager singleton instance.
		 */
		protected var am:AssetManager;
		
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
		 * An instance of a layout manager.
		 */
		public var lm:LayoutManager;

		/**
		 * Constructor for CoreClips instances.
		 */
		public function CoreClip()
		{
			super();
			em = EventManager.gi();
			ml = Model.gi();
			lm = new LayoutManager(this);
			km = KeyboardEventManager.gi();
			lgm = LanguageManager.gi();
			am = AssetManager.gi();
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