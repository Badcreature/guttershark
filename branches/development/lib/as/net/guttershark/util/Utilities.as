package net.guttershark.util
{
	import net.guttershark.util.ArrayUtils;
	import net.guttershark.util.BitmapUtils;
	import net.guttershark.util.DateUtils;
	import net.guttershark.util.DictionaryUtils;
	import net.guttershark.util.MathUtils;
	import net.guttershark.util.MouseUtils;
	import net.guttershark.util.ObjectUtils;
	import net.guttershark.util.Singleton;
	import net.guttershark.util.StringUtils;
	import net.guttershark.util.TextFieldUtils;
	import net.guttershark.util.filters.FilterUtils;	

	/**
	 * The Utilities class is a singleton that holds references
	 * to other utility singletons; this is used for inheritance
	 * chains on CoreClip and CoreSprite, which ultimately gets
	 * rid of static functions which are on an average 50% slower than
	 * having a property defined.
	 * 
	 * @see net.guttershark.display.CoreClip CoreClip class.
	 * @see net.guttershark.display.CoreSprite CoreSprite class.
	 */
	final public class Utilities
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
		 * The singleton instance of ColorUtils.
		 */
		public var color:ColorUtils;
		/**
		 * The singleton instance of DateUtils.
		 */
		public var date:DateUtils;
		
		/**
		 * The singleton instance of DictionaryUtils.
		 */
		public var dict:DictionaryUtils;
		
		/**
		 * The singleton instance of DisplayListUtils.
		 */
		public var display:DisplayListUtils;

		/**
		 * The singleton instance of MathUtils.
		 */
		public var math:MathUtils;

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
		 * The singleton instance of ScopeUtils.
		 */
		public var scope:ScopeUtils;

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
			color = ColorUtils.gi();
			date = DateUtils.gi();
			dict = DictionaryUtils.gi();
			mouse = MouseUtils.gi();
			object = ObjectUtils.gi();
			scope = ScopeUtils.gi();
			string = StringUtils.gi();
			text = TextFieldUtils.gi();
			setters = SetterUtils.gi();
			filters = FilterUtils.gi();
		}	}}