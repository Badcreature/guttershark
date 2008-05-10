package net.guttershark.util 
{
	
	/**
	 * The ArrayUtils class contains utility methods for arrays.
	 */
	public class ArrayUtils 
	{
		
		/**
		 * Clones an array.
		 * @param	array	The array to clone.
		 * @return	The cloned array.
		 */
		public static function Clone(array:Array):Array
		{
			Assert.NotNull(array, "The array cannot be null");
			return array.concat();
		}
		
		/**
		 * Shuffles an array.
		 * @param	array	The array to shuffle.
		 */
		public static function Shuffle(array:Array):void
		{
			Assert.NotNull(array, "The array cannot be null");
			var len:Number = array.length; 
	   		var rand:Number;
	   		var temp:*;
	   		for(var i:int = 0; i < len; i++)
	   		{ 
	   			rand = Math.floor(Math.random()*len); 
	   			temp = array[i]; 
	   			array[i] = array[rand]; 
	   			array[rand] = temp; 
	   		}
		}
	}
}
