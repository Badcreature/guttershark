package net.guttershark.util
{
	
	/**
	 * The DateUtils2 class has date utility methods on it that
	 * either aren't provided in the Date class, or in Adobe's DateUtil
	 * class.
	 */
	public class DateUtils2
	{
		
		/**
		 * Get the remaing time (seconds,hours,days,years) until the specified date will happen.
		 * 
		 * @param	futureDate	The target future date
		 * @return 	A generic object with these properties: {seconds:x,minutes:x,hours:x,days:x,years:x}
		 */ 
		public static function RemainingUntil(futureDate:Date):Object
		{
			Assert.NotNull(futureDate, "Parameter futureDate cannot be null");
			var currentMillisecs:Number;
			var currentDate:Date = new Date();
			var eventDate:Date = futureDate;
			var eventMillisecs:Number = eventDate.getTime();	
			var msecs:Number;
			currentMillisecs = currentDate.getTime();	
			msecs = eventMillisecs - currentMillisecs;
			var secs:Number = Math.floor(msecs/1000); // 1000 milliseconds make a second
			var mins:Number = Math.floor(secs/60); // 60 seconds make a minute;
			var hours:Number = Math.floor(mins/60); // 60 minutes make a hour;
			var days:Number = Math.floor(hours/24); // 24 hours make a second;
			var years:Number = Math.floor(days/365);
			return {seconds:secs, minutes:mins, hours:hours, days:days, years:years};
		}
	}
}