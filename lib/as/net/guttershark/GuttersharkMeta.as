package net.guttershark 
{
	
	import net.guttershark.guttershark_internal;
	
	/**
	 * Meta data about the net.guttershark package.
	 */
	public class GuttersharkMeta
	{
		
		/**
		 * The version of the entire net.guttershark package.
		 */
		guttershark_internal static const version:String = "0.4B1";
		
		/**
		 * Package dependencies.
		 * 
		 * <ul>
		 * <li>gs.*</li>
		 * <li>MacMouseWheel</li>
		 * </ul>
		 */
		guttershark_internal static const dependencies:Array = ["gs.*","com.pixelbreaker.ui.osx.MacMouseWheel"];
	}
}
