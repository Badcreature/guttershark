package net.guttershark.display
{
	import flash.display.Sprite;
	
	import net.guttershark.control.PreloadController;
	import net.guttershark.managers.AssetManager;
	import net.guttershark.managers.EventManager;
	import net.guttershark.managers.KeyboardEventManager;
	import net.guttershark.managers.LanguageManager;
	import net.guttershark.managers.LayoutManager;
	import net.guttershark.managers.ServiceManager;
	import net.guttershark.managers.SoundManager;
	import net.guttershark.model.Model;
	import net.guttershark.util.Assertions;
	import net.guttershark.util.FlashLibrary;

	/**
	 * The CoreSprite Class is a base class that provides
	 * common properties and methods that are used over
	 * and over in sprites; this class is relief
	 * from having to type the same code over and over.
	 */
	public class CoreSprite extends Sprite
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
		 * The singleton instance of the FlashLibrary.
		 */
		protected var fb:FlashLibrary;

		/**
		 * The SoundManager singleton instance.
		 */
		protected var snm:SoundManager;

		/**
		 * The Assertions singleton instance.
		 */
		protected var ast:Assertions;

		/**
		 * An instance of a layout manager.
		 */
		public var lm:LayoutManager;

		/**
		 * Constructor for CoreSprite instances.
		 */
		public function CoreSprite()
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
			ast = Assertions.gi();
		}

		/**
		 * Dispose of references to pre-defined properties. The only thing
		 * this method does is set references to null. If you have custom
		 * key mappings, or custom event handling with a singleton instance, you should
		 * override dispose, clear up your own custom stuff, then call super.dispose();
		 * 
		 * @example Cleaning up a subclassed CoreSprite
		 * <listing>	
		 * public class MyMC extends CoreSprite
		 * {
		 *     public var themc:MovieClip;
		 *     public function MyMC()
		 *     {
		 *         super();
		 *         em.handleEvents(themc,this,"onTheMC");
		 *     }
		 *     
		 *     public function onTheMCClick():void
		 *     {
		 *         trace("clicked");
		 *     }
		 *     
		 *     override public function dispose():void
		 *     {
		 *         em.disposeEventsForObject(themc);
		 *         super.dispose();
		 *     }
		 * }
		 * </listing>
		 */
		public function dispose():void
		{
			em = null;
			ml = null;
			lm = null;
			km = null;
			lgm = null;
			am = null;
			sm = null;
			fb = null;
			snm = null;
			ast = null;
		}
	}
}