package net.guttershark.util 
{	import net.guttershark.util.converters.TimeConverter;	import net.guttershark.util.math.Range;	
	/**	 * Static class for handling dates & converting them into readable strings. Note that all day & month collections are 0-indexed.	 */	public class DateUtil 
	{
		/**		 * Gets 0 indexed array of months for use with <code>DateUtils.getMonth()</code>.		 */		public static function get months():Array 
		{			return new Array("January","February","March","April","May","June","July","August","September","October","November","December");		}
		/**		 * Gets 0 indexed array of short months for use with <code>DateUtils.getMonth()</code>.		 */		public static function get shortmonths():Array
		{			return new Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");			}
		/**		 * Gets 0 indexed array of days for use with <code>DateUtils.getDay()</code>.		 */		public static function get days():Array 
		{			return new Array("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday");		}
		/**		 * Get 0 indexed array of days for use with <code>DateUtils.getDay();</code>.		 */		public static function get shortdays():Array 
		{			return new Array("Sun","Mon","Tue","Wed","Thur","Fri","Sat");		}
		/**		 * Get the month name by month number.<br>		 * Usage:<br><code>		 * trace(DateUtils.getMonth(0); // returns "January"		 * </code>		 */		public static function getMonth(n:int):String 
		{			return months[n];			}
		/**		 * Get the short month name by month number.		 * Usage:<br><code>		 * trace(DateUtils.getShortMonth(0); // returns "Jan"		 * </code>		 */		public static function getShortMonth(n:int):String 
		{			return shortmonths[n];			}
		/**		 * Get the day name by day number.		 * Usage:<br><code>		 * trace(DateUtils.getDay(0); // returns "Sunday"		 * </code>		 */			public static function getDay(n:int):String 
		{			return days[n];			}
		/**		 * Get the short day name by day number.		 * Usage:<br><code>		 * trace(DateUtils.getShortDay(0); // returns "Sun"		 * </code>		 */			public static function getShortDay(n:int):String 
		{			return shortdays[n];		}
		/**		 * Pads hours, Minutes or Seconds with a leading 0, 12:01 doesn't end up 12:1		 */		public static function padTime(n:int):String 
		{			return (String(n).length < 2) ? String("0" + n) : n as String;		}
		/**		 * Convert a DB formatted date string into a Flash Date Object.		 * @param dbDate	date in YYYY-MM-DD HH:MM:SS format		 */		public static function dateFromDB(dbdate:String):Date 
		{			var tmp:Array = dbdate.split(" ");			var dates:Array = tmp[0].split("-");			var hours:Array = tmp[1].split(":");			var d:Date = new Date(dates[0],dates[1] - 1,dates[2],hours[0],hours[1],hours[2]);			return d;		}
		/**		 * Takes 24hr hours and converts to 12 hour with am/pm.		 */		public static function getHoursAmPm(hour24:int):Object 
		{			var returnObj:Object = new Object();			returnObj['ampm'] = (hour24 < 12) ? "am" : "pm";			var hour12:Number = hour24 % 12;			if (hour12 == 0) 
			{				hour12 = 12;			}			returnObj['hours'] = hour12;			return returnObj;		}
		/**		 * Get the differences between two Dates in milliseconds.		 * @return 	difference between two dates in ms		 */		public static function dateDiff(d1:Date, d2:Date = null):Number 
		{			if(!d2) d2 = new Date();			return d2.getTime() - d1.getTime();		}
		/**		 * Check if birthdate entered meets required age.		 */		public static function isValidAge(year:int, month:int, day:int, requiredAge:int):Boolean 
		{			if (!isValidDate(year,month,day,true)) return false;			var now:Date = new Date();			var bd:Date = new Date(year + requiredAge,month,day);			return (now.getTime() > bd.getTime());		}
		/**		 * Check if a valid date can be created with inputs.		 */		public static function isValidDate(year:Number, month:Number, day:Number, mustBeInPast:Boolean):Boolean 
		{			if(!Range.isInRange(year,1800,3000) || isNaN(year)) return false;			if(!Range.isInRange(month,0,11) || isNaN(month)) return false;			if(!Range.isInRange(day,1,31) || isNaN(day)) return false;			if(day > getTotalDaysInMonth(year,month)) return false;			if(mustBeInPast && dateDiff(new Date(year,month,day)) < 0) return false;			return true;		}	
		/**		 * Return the number of dates in a specific month.		 */		public static function getTotalDaysInMonth(year:int, month:int):int 
		{			return TimeConverter.ms2days(dateDiff(new Date(year,month,1),new Date(year,month + 1,1)));		}
		/**		 * Returns the number of days in a specific year.		 */		public static function getTotalDaysInYear(year:int):int 
		{			return TimeConverter.ms2days(dateDiff(new Date(year,0,1),new Date(year + 1,0,1)));		}		}}