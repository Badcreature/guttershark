package net.guttershark.util
{
	import net.guttershark.util.filters.FilterUtils;	
	import net.guttershark.util.types.TextFieldUtils;	
	import net.guttershark.util.types.StringUtils;	
	import net.guttershark.util.types.ObjectUtils;	
	import net.guttershark.util.types.MouseUtils;	
	import net.guttershark.util.types.DictionaryUtils;	
	import net.guttershark.util.Singleton;
	import net.guttershark.util.types.ArrayUtils;
	import net.guttershark.util.types.BitmapUtils;
	import net.guttershark.util.types.DateUtils;		

	/**
	 * The Utilities class is a singleton that holds references
	 * to other utility singletons; this is used for inheritance
	 * chains on CoreClip and CoreSprite, which ultimately get's
	 * rid of static functions which are on an average 50% slower than
	 * having a property defined. Each type of utility is a singleton,
	 * so you can use them freely anywhere you whish, this is just
	 * a nice way of wrapping it for readability when using
	 * the utilities.
	 */
	public class Utilities
	{
		
		/**
		 * Singleton instance.
		 */
		private static var inst:Utilities;
		
		/**
		 * The singleton instance of ArrayUtils.
		 */
		public var array:ArrayUtils;
		
		/**
		 * The singleton instance of BitmapUtils.
		 */
		public var bitmap:BitmapUtils;
		
		/**
		 * The singleton instance of DateUtils.
		 */
		public var date:DateUtils;
		
		/**
		 * The singleton instance of DictionaryUtils.
		 */
		public var dict:DictionaryUtils;

		/**
		 * The singleton instance of MouseUtils.
		 */
		public var mouse:MouseUtils;
		
		/**
		 * The singleton instance of ObjectUtils.
		 */
		public var object:ObjectUtils;
		
		/**
		 * The singleton instance StringUtils.
		 */
		public var string:StringUtils;
		
		/**
		 * The singleton instance of TextFieldUtils.
		 */
		public var text:TextFieldUtils;

		/**
		 * The singleton instance of SetterUtils.
		 */
		public var setters:SetterUtils;
		
		/**
		 * The singleton instance of FilterUtils.
		 */
		public var filters:FilterUtils;

		/**
		 * Singleton access.
		 */
		public static function gi():Utilities
		{
			if(!inst) inst = Singleton.gi(Utilities);
			return inst;
		}
		
		/**
		 * @private
		 */
		public function Utilities()
		{
			Singleton.assertSingle(Utilities);
			array = ArrayUtils.gi();
			bitmap = BitmapUtils.gi();
			date = DateUtils.gi();
			dict = DictionaryUtils.gi();
			mouse = MouseUtils.gi();
			object = ObjectUtils.gi();
			string = StringUtils.gi();
			text = TextFieldUtils.gi();
			setters = SetterUtils.gi();
			filters = FilterUtils.gi();
		}	}}