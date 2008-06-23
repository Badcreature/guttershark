package net.guttershark.util 
{
	
	import flash.display.InteractiveObject;	
	
	/**
	 * The ScopeUtils Class provides utilities for working with scope problems,
	 * or simplifying something that is done over and over to alter scope.
	 */
	public class ScopeUtils
	{
		
		/**
		 * Retarget class instance variables to either a nested or parent
		 * movie clip or class. This is generally used when you have
		 * nested clips.
		 * 
		 * @example Re-targetting a class' instance variables to inside of a movie clip. 
		 * <listing>
		 * package
		 * {
		 *   class MyView
		 *   {
		 *       public var firstname:TextField;
		 *       public var lastname:TextField;
		 *       public var formfieldwrapper:MovieClip;
		 *       public function MyView()
		 *       {
		 *          ScopeUtils.ReTargetInstanceVars([
		 *              firstname,lastname,wemet,how,position,position2,
		 *              resume,reel,email,mobile,website,story],
		 *              ["firstname","lastname","wemet","how","position",
		 *              "position2","resume","reel","email","website","mobile",
		 *              "website","story"],forms);
		 *       }
		 *   }
		 * }
		 * </listing>
		 * 
		 * @param	vars	The instance variables in which the pointer is changing.
		 * @param	newTargetInstanceNames	The instance names inside of the new target.
		 * @param	target	The new target.
		 */
		public static function ReTargetInstanceVars(vars:Array, source:InteractiveObject, target:InteractiveObject):void
		{
			for(var i:int = 0; i < vars.length; i++) source[vars[i]] = target[vars[i]];
		}
	}}