package net.guttershark.util
{

	/**
	 * dates.
	{
		
		/**
		 * Singleton instance.
		 */
		private static var inst:DateUtils;

		private var mu:MathUtils;

		/**
		 * Singleton access.
		 */
		public static function gi():DateUtils
		{
			if(!inst) inst = Singleton.gi(DateUtils);
			return inst;
		}
		
		/**
		 * @private
		 */
		public function DateUtils()
		{
			Singleton.assertSingle(DateUtils);
			mu = MathUtils.gi();
		}

		/**
		{
		
		/**
		{
		
		/**
		{
		
		/**
		{
		
		/**
		 * 
		 * @param n The 0 based month index.
		{
		
		/**
		 * 
		 * @param n The 0 based month index.
		{
		
		/**
		 * 
		 * @param n The 0 based day index.
		{
		
		/**
		 * 
		 * @param n The 0 based day index.
		{
		
		/**
		 * 
		 * @param n The number to pad.
		{
		
		/**
		 * 
		{
		
		/**
		 * 
		 * @param hour24 The hour in 24 hour format.
		 * @return An object with "hours" and "ampm" properties.
		{
		
		/**
		 * the second date is not provided, a new Date() is used.
		 * @param d1 The first date.
		 * @param d2 The second date.
		{
		
		/**
		 * 
		 * @param year The year.
		 * @param month The 0 based month.
		 * @param day The 0 based day.
		 * @param requiredAge The required age that the date must meet.
		{
		
		/**
		 * 
		 * @param year The year.
		 * @param month The 0 based month.
		 * @param day The 0 based day.
		 * @param mustBeInPast Whether or not the date must be in the past.
		{
		
		/**
		 * 
		 * @param year The year.
		 * @param month The 0 based month.
		{
		
		/**
		 * 
		 * @param year The year.
		{
		
		/**
		 * Determines whether or not the provided year is a leap year.
		 * 
		 * @param year The year to check.
		 */
		public function isLeapYear(year:int):Boolean
		{
			return ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0);
		}
		
		/**
		 * Convert number of weeks to milliseconds.
		 * 
		 * @param n The number of weeks.
		 */
		public function weeks2ms(n:Number):Number 
		{
			return n * days2ms(7);
		}
		
		/**
		 * Convert number of days to milliseconds.
		 * 
		 * @param n The number of days.
		 */
		public function days2ms(n:Number):Number 
		{
			return n * hours2ms(24);
		}
		
		/**
		 * Convert number of hours to milliseconds.
		 * 
		 * @param n The number of hours.
		 */
		public function hours2ms(n:Number):Number 
		{
			return n * minutes2ms(60);
		}
		
		/**
		 * Convert minutes to milliseconds.
		 * 
		 * @param n The number of minutes.
		 */
		public function minutes2ms(n:Number):Number 
		{
			return n * seconds2ms(60);
		}
		
		/**
		 * Convert seconds to milliseconds.
		 * 
		 * @param n The number of seconds.
		 */
		public function seconds2ms(n:Number):Number 
		{
			return n * ms(1000);
		}
		
		/**
		 * @private
		 */
		public function ms(n:Number):Number 
		{
			return n;
		}
		
		/**
		 * Convert milliseconds to weeks.
		 * 
		 * @param n The milliseconds.
		 */
		public function ms2weeks(n:Number):Number 
		{
			return n / days2ms(7);
		}

		/**
		 * Convert milliseconds to days.
		 * 
		 * @param n The milliseconds.
		 */
		public function ms2days(n:Number):Number 
		{
			return n / hours2ms(24);
		}
		
		/**
		 * Convert milliseconds to hours.
		 * 
		 * @param n The milliseconds.
		 */
		public function ms2hours(n:Number):Number
		{
			return n / minutes2ms(60);
		}
		
		/**
		 * Convert milliseconds to hours.
		 * 
		 * @param n The milliseconds.
		 */
		public function ms2minutes(n:Number):Number 
		{
			return n / seconds2ms(60);
		}

		/**
		 * Convert milliseconds to seconds.
		 * 
		 * @param n The milliseconds.
		 */
		public function ms2seconds(n:Number):Number 
		{
			return n / ms(1000);
		}