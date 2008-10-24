package net.guttershark.display
{
	import net.guttershark.managers.ContextMenuManager;	
	
	import flash.display.MovieClip;
	
	import net.guttershark.control.PreloadController;
	import net.guttershark.managers.AssetManager;
	import net.guttershark.managers.EventManager;
	import net.guttershark.managers.KeyManager;
	import net.guttershark.managers.LanguageManager;
	import net.guttershark.managers.LayoutManager;
	import net.guttershark.managers.ServiceManager;
	import net.guttershark.managers.SoundManager;
	import net.guttershark.model.Model;
	import net.guttershark.util.Assertions;
	import net.guttershark.util.Utilities;	

	/**
	 * The CoreClip class is a base class that provides
	 * common properties and methods that are used over
	 * and over in movie clips; this class is relief
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
		protected var km:KeyManager;
		
		/**
		 * The LanguageManager singleton instance.
		 */
		protected var lgm:LanguageManager;
		
		/**
		 * A placeholder variable for a PreloadController instance - you should initialize this yourself.
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
		protected var lm:LayoutManager;
		
		/**
		 * The Utilities singleton instance.
		 */
		protected var utils:Utilities;
		
		/**
		 * An instance of the context menu manager.
		 */
		protected var cmm:ContextMenuManager;

		/**
		 * Constructor for CoreClips instances.
		 */
		public function CoreClip()
		{
			super();
			em=EventManager.gi();
			ml=Model.gi();
			lm=new LayoutManager(this);
			km=KeyManager.gi();
			lgm=LanguageManager.gi();
			am=AssetManager.gi();
			sm=ServiceManager.gi();
			snm=SoundManager.gi();
			ast=Assertions.gi();
			utils=Utilities.gi();
			cmm=ContextMenuManager.gi();
		}

		/**
		 * Dispose of references to pre-defined properties. The only thing
		 * this method does is set references to null. If you have custom
		 * key mappings, or custom event handling with a singleton instance, you should
		 * override dispose, clear up your own custom stuff, then call super.dispose();
		 * 
		 * @example Cleaning up a subclassed CoreClip
		 * <listing>	
		 * public class MyMC extends CoreClip
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
			em=null;
			ml=null;
			lm=null;
			km=null;
			lgm=null;
			am=null;
			sm=null;
			snm=null;
			ast=null;
			utils=null;
			cmm=null;
		}
	}
}