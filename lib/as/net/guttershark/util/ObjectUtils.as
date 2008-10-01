package net.guttershark.util
{
	import net.guttershark.util.Singleton;	

	import flash.utils.ByteArray;	
	
	/**
	 * The ObjectUtils class has utility methods for working with objects.
	 * 
	 * @see net.guttershark.util.Utilities Utilities class.
	 */
	final public class ObjectUtils
	{
		
		/**
		 * Singleton instance.
		 */
		private static var inst:ObjectUtils;
		
		/**
		 * Singleton access.
		 */
		public static function gi():ObjectUtils
		{
			if(!inst) inst = Singleton.gi(ObjectUtils);
			return inst;
		}
		
		/**
		 * @private
		 */
		public function ObjectUtils()
		{
			Singleton.assertSingle(ObjectUtils);
		}

		/**
		 * Clone an object instance - this is not recommended to clone
		 * anything other than a native top level Object.
		 * 
		 * @example Cloning a generic object:
		 * <listing>	
		 * var utils:Utilities = Utilities.gi();
		 * var myObj:Object = new Object();
		 * myObj.message = "hello world";
		 * var myCopy:Object = utils.object.clone(myObj);
		 * trace(myCopy.message);
		 * </listing>
		 * 
		 * @param object The object to clone.
		 */
		public function clone(object:*):*
		{
			if(!object) throw new ArgumentError("Parameter object cannot be null");
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeObject(object);
			byteArray.position = 0;
			return byteArray.readObject();
		}
	}
}