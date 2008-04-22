/** * Copyright Mccann Worldgroup 2008 */package net.guttershark.util {		import mx.flash.ContainerMovieClip;		import mx.flash.FlexContentHolder;		import mx.flash.UIMovieClip;		import net.guttershark.util.Library;		/**	 * Utility Class to help get a UIMovieClip from a 	 * flash library.	 */	public class FlashLibrary extends Library	{				/**		 * Returns an item from the library as a UIMovieClip		 */		public static function GetUIMovieClip(libraryName:String):UIMovieClip		{			var instance:Class = flash.utils.getDefinitionByName(libraryName) as Class;			var s:UIMovieClip = new instance() as UIMovieClip;			return s;		}				/**		 * Returns a item from the library as a FlexContentHolder		 */		public static function GetFlexContentHolder(libraryName:String):UIMovieClip		{			var instance:Class = flash.utils.getDefinitionByName(libraryName) as Class;			var s:UIMovieClip = new instance() as FlexContentHolder;			return s;		}				/**		 * Returns an item from the libaray as a ContainerMovieClip		 */		public static function GetContainerMovieClip(libraryName:String):UIMovieClip		{			var instance:Class = flash.utils.getDefinitionByName(libraryName) as Class;			var s:UIMovieClip = new instance() as ContainerMovieClip;			return s;		}	}}