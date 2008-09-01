package net.guttershark.support.servicemanager.shared
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;	

	public class BaseCall 
	{
		
		public var id:String;
		public var limiter:Limiter;
		protected var completed:Boolean;
		protected var tries:int;
		protected var attempts:int;
		protected var callTimer:Timer;
		protected var props:Object;
		
		public function BaseCall(callProps:Object)
		{
			props = callProps;
			tries = 0;
			attempts = 1;
		}
		
		public function execute():void{}
		
		protected function onTick(e:TimerEvent):void
		{
			trace(tries,attempts);
			if(!completed)
			{
				if(tries >= attempts)
				{
					completed = true;
					if(!props.onTimeout)
					{
						trace("WARNING: Call timed out, but onTimeout callback was not defined. You will not receive a fault event, or result event when a timeout occurs.");
						return;
					}
					props.onTimeout();
					return;
				}
				if(!props.onRetry) trace("WARNING: Call is retrying, but no onRetry callback is defined.");
				else props.onRetry();
				execute();
			}
		}
		
		protected function callComplete():void
		{
			completed=true;
			callTimer.stop();
			if(limiter) limiter.releaseCall(id);
		}
		
		protected function checkForOnResultCallback():Boolean
		{
			if(!props.onResult)
			{
				trace("WARNING: A result was recieved, but no onResult callback was defined.");
				dispose();
				return false;
			}
			return true;
		}
		
		protected function checkForOnFaultCallback():Boolean
		{
			if(!props.onFault)
			{
				trace("WARNING: A fault was recieved, but no onFault callback was defined.");
				dispose();
				return false;
			}
			return true;
		}
		
		public function dispose():void
		{
			tries = 0;
			attempts = 0;
			completed = false;
			callTimer = null;
			limiter = null;
			id = null;
			props = null;
		}	}}