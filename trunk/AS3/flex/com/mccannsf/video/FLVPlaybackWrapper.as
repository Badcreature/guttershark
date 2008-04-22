/**
 * Copyright Mccann Worldgroup 2008
 */
package net.guttershark.video
{
	
	import fl.video.FLVPlayback;
	import mx.flash.UIMovieClip;
	
	/**
	 * Used as a utility class to wrap an FLVPlayback in 
	 * flash so it doesn't complain when we have Flex
	 * files in the source.
	 */
	public class FLVPlaybackWrapper extends UIMovieClip
	{
		
		/**
		 * An instance of an FLVPlayer on the stage.
		 * The instance name should be flvPlayback;
		 */
		public var flvPlayback:FLVPlayback;
		
		/**
		 * Get a reference to the playback component.
		 */
		public function get player():FLVPlayback
		{
			return flvPlayback;
		}
	}
}