package net.guttershark.services.remoting.limiting
{
	
	/**
	 * Used in a RemotingService to stop duplicate calls 
	 * to a call that that hasn't responded yet.
	 * 
	 * Each RemotingCall made from a RemotingService
	 * manages retries and max attempts so dupliacate
	 * calls being made that haven't responded is
	 * not a good thing. This stops that.
	 */
	public class RemotingCallLimiter
	{

		/**
		 * The lookup for calls.
		 */
		private var callsInProgress:Array;
		
		/**
		 * New RemotinCallLimiter.
		 */
		public function RemotingCallLimiter()
		{
			callsInProgress = [];
		}
		
		/**
		 * Locks a call so that no further calls can be made to it
		 * until it's unlocked.
		 * 
		 * @param		String		A unique identifier for a remoting call.
		 * @return		void
		 */
		public function lockCall(uniquePath:String):void
		{
			callsInProgress[uniquePath] = true;
		}
		
		/**
		 * Releases a call from the call pool.
		 * 
		 * @param		String		The unique identifier for a remoting call.
		 * @return		void
		 */
		public function releaseCall(uniquePath:String):void
		{
			if(!uniquePath) return;				
			callsInProgress[uniquePath] = false;
		}
		
		/**
		 * Test whether or not a call can be executed.
		 * 
		 * @param		String		The unique identifier for a remoting call.
		 * @return		Boolean
		 */
		public function canExecute(uniquePath:String):Boolean
		{
			return (!callsInProgress[uniquePath]);
		}
		
		/**
		 * Clears all currently locked calls.
		 * 
		 * @return		void
		 */
		public function releaseAllCalls():void
		{
			callsInProgress = [];
		}
		
		/**
		 * Dispose of this RemotingCallLimiter.
		 */
		public function dispose():void
		{
			releaseAllCalls();
			callsInProgress = null;
		}
	}
}