package net.guttershark.util 
{
	
	import flash.display.InteractiveObject;	
	
	/**
	 * The ScopeUtils Class provides utilities for working with scope problems,
	 * or simplifying something that is usually done over and over to alter scope.
	 */
	public class ScopeUtils
	{
		
		/**
		 * Re-target class instance variables to either a nested or parent
		 * movie clip or class. This is generally used when you have
		 * instance variables on a class, but need to change what clip they
		 * point to inside of another movie clip.
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
		 *           //in this call, "this" represents the source, and "forms" represents the new target host.
		 *           ScopeUtils.ReTargetInstanceVars(["firstname","lastname"],this,formfieldwrapper);
		 *       }
		 *   }
		 * }
		 * </listing>
		 * 
		 * <p>In that example. <code><em>firstname</em></code> and <code><em>lastname</em></code> are defined in
		 * "MyView" but the actual movie clips are inside of formfieldwrapper. So this "re-targetting" of scope re-assigns
		 * firstname to point to <code><em>formfieldwrapper.firstname</em></code>.</p>
		 * 
		 * @param	vars	The instance variables in which the pointer is changing.
		 * @param	source	The source instance where the variables are declared.
		 * @param	target	The new target.
		 */
		public static function ReTargetInstanceVars(vars:Array, source:InteractiveObject, target:InteractiveObject):void
		{
			for(var i:int = 0; i < vars.length; i++) source[vars[i]] = target[vars[i]];
		}
	}}