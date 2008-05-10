package net.guttershark.util 
{
	
	import flash.utils.ByteArray;	
	
	public class ObjectUtils 
	{
		
		/**
		 * Clone an object instance. This is not recommended to clone
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
		 * @param	object	The object to clone.
		 * @return	The cloned object
		 */
		public static function Clone(object:*):*
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeObject(object);
			byteArray.position = 0;
			return byteArray.readObject();
		}
	}
}