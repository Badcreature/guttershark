package net.guttershark.util
{	import net.guttershark.util.Singleton;

	/**	 * The DateUtils class contains utility methods for working with
	 * dates.
	 * 
	 * @see net.guttershark.util.Utilities Utilities class.	 */	final public class DateUtils
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

		/**		 * 0 indexed array of months for use with <code>DateUtils.getMonth()</code>.		 */		public function get months():Array 
		{			return new Array("January","February","March","April","May","June","July","August","September","October","November","December");		}
		
		/**		 * 0 indexed array of short months for use with <code>DateUtils.getMonth()</code>.		 */		public function get shortmonths():Array
		{			return new Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");			}
		
		/**		 * 0 indexed array of days for use with <code>DateUtils.getDay()</code>.		 */		public function get days():Array 
		{			return new Array("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday");		}
		
		/**		 * 0 indexed array of short days for use with <code>DateUtils.getDay()</code>.		 */		public function get shortdays():Array 
		{			return new Array("Sun","Mon","Tue","Wed","Thur","Fri","Sat");		}
		
		/**		 * Get the month name by month number.
		 * 
		 * @param n The 0 based month index.		 */		public function getMonth(n:int):String 
		{			return months[n];			}
		
		/**		 * Get the short month name by month number.
		 * 
		 * @param n The 0 based month index.		 */		public function getShortMonth(n:int):String 
		{			return shortmonths[n];		}
		
		/**		 * Get the day name by day number.
		 * 
		 * @param n The 0 based day index.		 */			public function getDay(n:int):String 
		{			return days[n];			}
		
		/**		 * Get the short day name by day number.
		 * 
		 * @param n The 0 based day index.		 */			public function getShortDay(n:int):String 
		{			return shortdays[n];		}
		
		/**		 * Pads hours, minutes or seconds with a leading 0 - so 12:01 doesn't end up 12:1.
		 * 
		 * @param n The number to pad.		 */		public function padTime(n:int):String 
		{			return (String(n).length < 2) ? String("0" + n) : n as String;		}
		
		/**		 * Convert a DB formatted date string into a Flash Date Object.
		 * 		 * @param dbDate A date formatted like YYYY-MM-DD HH:MM:SS.		 */		public function dateFromDB(dbdate:String):Date 
		{			var tmp:Array = dbdate.split(" ");			var dates:Array = tmp[0].split("-");			var hours:Array = tmp[1].split(":");			var d:Date = new Date(dates[0],dates[1]-1,dates[2],hours[0],hours[1],hours[2]);			return d;		}
		
		/**		 * Takes 24hr hours and converts to 12 hour with am/pm.
		 * 
		 * @param hour24 The hour in 24 hour format.
		 * @return An object with "hours" and "ampm" properties.		 */		public function getHoursAmPm(hour24:int):Object 
		{			var returnObj:Object = new Object();			returnObj.ampm = (hour24 < 12)?"am":"pm";			var hour12:Number = hour24%12;			if(hour12 == 0) hour12 = 12;			returnObj.hours = hour12;			return returnObj;		}
		
		/**		 * Get the differences between two dates in milliseconds - if
		 * the second date is not provided, a new Date() is used.		 * 
		 * @param d1 The first date.
		 * @param d2 The second date.		 */		public function dateDiff(d1:Date,d2:Date=null):Number 
		{			if(!d2) d2 = new Date();			return d2.getTime() - d1.getTime();		}
		
		/**		 * Check if birthdate entered meets required age.
		 * 
		 * @param year The year.
		 * @param month The 0 based month.
		 * @param day The 0 based day.
		 * @param requiredAge The required age that the date must meet.		 */		public function isValidAge(year:int, month:int, day:int, requiredAge:int):Boolean 
		{			if(!isValidDate(year,month,day,true)) return false;			var now:Date = new Date();			var bd:Date = new Date(year+requiredAge,month,day);			return (now.getTime()>bd.getTime());		}
		
		/**		 * Check if a valid date can be created with inputs.
		 * 
		 * @param year The year.
		 * @param month The 0 based month.
		 * @param day The 0 based day.
		 * @param mustBeInPast Whether or not the date must be in the past.		 */		public function isValidDate(year:int, month:int, day:int, mustBeInPast:Boolean):Boolean 
		{			if(!mu.isInRange(year,1800,3000) || isNaN(year)) return false;			if(!mu.isInRange(month,0,11) || isNaN(month)) return false;			if(!mu.isInRange(day,1,31) || isNaN(day)) return false;			if(day > getTotalDaysInMonth(year,month)) return false;			if(mustBeInPast && dateDiff(new Date(year,month,day)) < 0) return false;			return true;		}	
		
		/**		 * Return the number of days in a specific month.
		 * 
		 * @param year The year.
		 * @param month The 0 based month.		 */		public function getTotalDaysInMonth(year:int, month:int):int 
		{			return ms2days(dateDiff(new Date(year,month,1),new Date(year,month + 1,1)));		}
		
		/**		 * Returns the number of days in a specific year.
		 * 
		 * @param year The year.		 */		public function getTotalDaysInYear(year:int):int 
		{			return ms2days(dateDiff(new Date(year,0,1),new Date(year + 1,0,1)));		}
		
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
		}	}}