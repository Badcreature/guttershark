package net.guttershark.display.renderers 
{
	import flash.display.Bitmap;	import flash.geom.Point;		import net.guttershark.control.PreloadController;	import net.guttershark.display.CoreClip;	import net.guttershark.support.preloading.Asset;	import net.guttershark.support.preloading.events.PreloadProgressEvent;		
	/**
	 * IN DEVELOPMENT.
	 * 
	 * The BitmapRenderer Class wraps up a fair amount of logic
	 * that is written over and over to load and display a bitmap. And
	 * also provides some common methods that aren't always used, but when
	 * needed take too much time to write over and over.
	 * 
	 * <p>Add the BitmapRenderer to the display list to see it
	 * when it's displayed.</p>
	 * 
	 * <p>The BitmapRenderer uses a delegate for event logic from
	 * the preloader.</p>
	 * 
	 * <p>Delegate methods that must exist on your delegate:</p>
	 * <ul>
	 * <li>complete</li>
	 * <li>progress</li>
	 * </ul>
	 */
	public class BitmapRenderer extends CoreClip
	{
		
		private var _d:*;
		private var _ca:Asset;
		private var da:Boolean;
		
		/**
		 * Constructor or BitmapRenderer instances.
		 */	
		public function BitmapRenderer()
		{
			super();
			pc = new PreloadController();
			em.handleEvents(pc, this, "onPC");
		}
		
		/**
		 * Set the delegate object for preload events.
		 */
		public function set delegate(del:*):void
		{
			if(!("complete" in del)) throw new Error("You must have the 'complete' method defined on your delegate.");
			if(!("progress" in del)) throw new Error("You must have the 'progress' method defined on your delegate.");
			_d = del;
		}
		
		/**
		 * Set the amount of pixels to fill. For the PreloadController.
		 * 
		 * @see net.guttershark.preloading.PreloadController PreloadController Class
		 */
		public function set pixelsToFill(pixelsToFill:int):void
		{
			pc.pixelsToFill = pixelsToFill;
		}
		
		/**
		 * Get the current Asset instance that this bitmap renderer is displaying.
		 */
		public function get currentAsset():Asset
		{
			return _ca;
		}
		
		/**
		 * Loads an asset, but does not display it after load.
		 */
		public function loadAsset(asset:Asset):void
		{
			da = false;
			pc.addItems([asset]);
		}
		
		/**
		 * Loads the asset, and displays it once it's done loading.
		 */
		public function loadAndDisplayAsset(asset:Asset):void
		{
			_ca = asset;
			da = true;
			pc.addItems([asset]);
			pc.start();
		}
		
		/**
		 * Displays the currentAsset
		 */
		public function displayAsset():void
		{
			if(!_ca)
			{
				trace("WARNING: No current asset, not displaying anything.");
				return;
			}
			addChild(am.getBitmap(_ca.libraryName) as Bitmap);
		}
		
		/**
		 * @private
		 */
		public function onPCComplete():void
		{
			_d.complete();
			if(da) displayAsset();
		}
		
		/**
		 * @private
		 */
		public function onPCProgress(ppe:PreloadProgressEvent):void
		{
			_d.progress(ppe);
		}
		
		/**
		 * 
		 */
		public function resize(width:Number,height:Number,constrain:Boolean=true,registration:Point=null):void
		{
		}		
	}}