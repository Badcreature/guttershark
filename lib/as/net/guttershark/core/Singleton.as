package net.guttershark.core{		import flash.utils.Dictionary;	import net.guttershark.util.Assert;		/**	 * The Singleton Class is a helper class to enforce Singleton's in Guttershark.	 * And allow extensibility to Singletons, without typing the same darn thing	 * over and over for each extended singletong.	 * 	 * @example A base singleton, with another singleton extending it.	 * <listing>	 * //The base singleton class.	 * package	 * {	 *     public class MySingleton	 *     {	 *         private static var inst:MySingleton;	 *         public function MySingleton()	 *         {	 *             Singleton.assertSingle(MySingleton);	 *         }	 *         public static function gi():MySingleton	 *         {	 *             if(!inst) inst = Singleton.gi(MySingleton);	 *             return inst;	 *         }	 *     }	 * }	 * 	 * //the singleton extended from the base MySingleton class.	 * package	 * {	 *     import MySingleton;	 *     public class MyExtendedSingleton extends MySingleton	 *     {	 *         private static var inst:MyExtendedSingleton;	 *         public function MyExtendedSingleton()	 *         {	 *             Singleton.assertSingle(MyExtendedSingleton);	 *         }	 *         public static function gi():MyExtendedSingleton()	 *         {	 *             if(!inst) inst = Singleton.gi(MyExtendedSingleton,MySingleton);	 *             return inst;	 *         }	 *     }	 * }	 * 	 * package	 * {	 *     public class Main extends Sprite	 *     {	 *         public function Main()	 *         {	 *             var mes:MyExtendedSingleton = MyExtendedSingleton.gi();	 *             //either of the following will fail.	 *             var ms:MySingleton = new MySingleton();	 *             var mss:MySingleton = MySingleton.gi();	 *         }	 *     }	 * }	 * </listing>	 */	public class Singleton	{				/**		 * Keeps track of the instances available.		 */		private static var insts:Dictionary;				/**		 * Get an instance of a class, and cancel any parent classes.		 * @param	clazz	The class of the instance you're after.		 * @param	cancelParentClasses	An array of Classes to cancel, so they cannot be instantiated again.		 * This is specifically for when you extend a singleton, you need to make sure you pass all of it's		 * super classes.		 */		public static function gi(clazz:Class,...cancelParentClasses:Array):*		{			var inst:*;			if(!insts) insts = new Dictionary();			if(insts[clazz] && insts[clazz] != -1) inst = insts[clazz];			if(!inst)			{				inst = new clazz();				insts[clazz] = inst;			}			if(cancelParentClasses)			{				for each(var cl:Class in cancelParentClasses){insts[cl] = -1;}			}			return inst;		}				/**		 * Assert that there is only one instance of a class.		 */		public static function assertSingle(clazz:Class):void		{			if(insts[clazz]) throw new Error("Error creating class, {"+clazz+"}. It's a singleton and cannot be instantiated more than once.");		}	}}