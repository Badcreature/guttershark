package net.guttershark.util.types
{
	
	import flash.utils.ByteArray;	
	
	/**
	 * The ObjectUtils class has utility methods for working with objects.
	 */
	final public class ObjectUtils
	{
		
		/**
		 * Clone an object instance - this is not recommended to clone
		 * anything other than a native top level object.
		 * 
		 * @example Cloning a generic object:
		 * <listing>	
		 * var myObj:Object = new Object();
		 * myObj.message = "hello world";
		 * var myCopy:Object = ObjectUtils.Clone(myObj);
		 * trace(myCopy.message);
		 * </listing>
		 * 
		 * @param object The object to clone.
		 */
		public static function clone(object:*):*
		{
			if(!object) throw new ArgumentError("Parameter object cannot be null");
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeObject(object);
			byteArray.position = 0;
			return byteArray.readObject();
		}
	}
}