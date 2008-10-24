/*                   __    __                         __                       __         
 *                  /\ \__/\ \__                     /\ \                     /\ \        
 *       __   __  __\ \ ,_\ \ ,_\    __   _ __   ____\ \ \___      __     _ __\ \ \/'\    
 *     /'_ `\/\ \/\ \\ \ \/\ \ \/  /'__`\/\`'__\/',__\\ \  _ `\  /'__`\  /\`'__\ \ , <    
 *    /\ \_\ g \ \_u \\ \ t_\ \ t_/\  __e\ \ \/r\__, `s\ \ \ \ h/\ \L\.a_\ \ r/ \ \ \\`k  
 *    \ \____ \ \____/ \ \__\\ \__\ \____\\ \_\\/\____/ \ \_\ \_\ \__/.\_\\ \_\  \ \_\ \_\
 *     \/___L\ \/___/   \/__/ \/__/\/____/ \/_/ \/___/   \/_/\/_/\/__/\/_/ \/_/   \/_/\/_/
 *       /\____/                                                                          
 *       \_/__/                                                                           
 */
package net.guttershark.control 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.ui.ContextMenu;	

	/**
	 * The Frame1Controller class is a controller
	 * you can use for movies that have two frames on the root - 
	 * the 1st frame being the preloader, the second being for the application
	 * start (where all other classes are exported in frame 2).
	 * 
	 * <p>In that type of movie (2 frames), you extend this class
	 * for the Document Class, then place an instance of a movie
	 * clip on frame 2 that is bound to a subclass of
	 * DocumentController - there is an example in 
	 * examples/control/frame1controller.</p>
	 * 
	 * <p>You also need to update what frame to export classes in:
	 * file->publish settings->flash-> settings->export classes in frame->2</p>
	 * 
	 * @example Subclassing Frame1Controller:
	 * <listing>	
	 * package
	 * {
	 *     public class MyFrame1Controller extends Frame1Controller()
	 *     {
	 *     
	 *         //onstage (only declare what's on frame 1 && don't give an instance name to the main clip on frame 2).
	 *         public var preloader:MovieClip;
	 *         public var percentLabel:TextField;
	 *         
	 *         public function MyFrame1Controller()
	 *         {
	 *             super();
	 *         }
	 *         
	 *         override protected function get pixelsToFill():int
	 *         {
	 *             return 550;
	 *         }
	 *         
	 *         override protected function gotoStartFrame():void
	 *         {
	 *             gotoAndStop(2);
	 *             dispose();
	 *         }
	 *         
	 *         override protected function onProgress(pixels:int,percent:Number):void
	 *         {
	 *             trace("preload complete, start the app/site.");
	 *             gotoAndStop(2); //the real function call.
	 *         }
	 *         
	 *         override protected function dispose():void
	 *         {
	 *             super.dispose();
	 *             trace("dispose");
	 *             preloader = null;
	 *             percentLabel = null;
	 *         }
	 *     }
	 * }
	 * </listing>
	 * 
	 * @see external (external: examples/control/frame1controller).
	 */
	public class Frame1Controller extends MovieClip
	{
		
		/**
		 * The amount of pixels that your preloader needs to fill -
		 * set this so that calculations happen for you.
		 * 
		 * @see #onProgress()
		 */
		private var _pixelsToFill:int = 100;

		/**
		 * Constructor for Frame1Controller instances.
		 */
		public function Frame1Controller()
		{
			super();
			stop();
			contextMenu=new ContextMenu();
			contextMenu.hideBuiltInItems();
			_pixelsToFill=pixelsToFill;
			if(this.totalFrames<2) throw new Error("You must have more than 1 frame in the movie to use Frame1Controller");
			loaderInfo.addEventListener(ProgressEvent.PROGRESS,onp,false,0,true);
			loaderInfo.addEventListener(Event.COMPLETE,onc,false,0,true);
		}
		
		/**
		 * On swf load progress.
		 */
		private function onp(pe:ProgressEvent):void
		{
			var bt:Number = pe.bytesTotal;
			var bl:Number = pe.bytesLoaded;
			var pixels:int = (bl/bt)*pixelsToFill;
			var percent:Number = Math.ceil((bl/bt)*100);
			onProgress(pixels,percent);
		}
		
		/**
		 * on swf load complete.
		 */
		private function onc(e:Event):void
		{
			gotoStartFrame();
		}
		
		/**
		 * A method you can override to control which frame to gotoAndStop
		 * after the swf has completely downloaded - that frame should be
		 * the application start frame, the default frame is 2.
		 */
		protected function gotoStartFrame():void
		{
			dispose();
		}

		/**
		 * A method you can override to accept pixels and percent on the progress
		 * of the swf loading.
		 */
		protected function onProgress(pixels:int, percent:Number):void{}
		
		/**
		 * A stub method you should override to alter the amount
		 * of pixels your site preloader needs to fill - the
		 * default is 100.
		 */
		protected function get pixelsToFill():int
		{
			return _pixelsToFill;
		}
		
		/**
		 * Dispose of this frame 1 controller, you should always call 
		 * super.dispose() if you override this.
		 */
		protected function dispose():void
		{
			//delay here, if dispose is called too soon, flashvars might not propogate to a DocumentController.
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS,onp);
			loaderInfo.removeEventListener(Event.COMPLETE,onc);
			_pixelsToFill = 0;
		}	}}