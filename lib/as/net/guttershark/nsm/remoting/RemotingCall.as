package net.guttershark.nsm.remoting
{
	import net.guttershark.nsm.shared.CallFault;	
	import net.guttershark.nsm.shared.CallResult;	
	
	import flash.events.TimerEvent;
	import flash.net.Responder;
	import flash.utils.*;
	
	import net.guttershark.nsm.shared.BaseCall;
	import net.guttershark.nsm.remoting.RemotingService;

	public class RemotingCall extends BaseCall
	{
		
		private var rs:RemotingService;
		
		public function RemotingCall(rs:RemotingService, callProps:Object)
		{
			super(callProps);
			this.rs=rs;
		}
		
		override public function execute():void
		{
			if(!completed)
			{
				attempts = props.attempts;
				var operation:String = props.endpoint + "." + props.method;
				var responder:Responder = new Responder(onResult, onFault);
				var callArgs:Array = new Array(operation, responder);
				if(!callTimer)
				{
					callTimer = new Timer(props.timeout,attempts);
					callTimer.addEventListener(TimerEvent.TIMER,onTick, false, 0, true);
				}
				tries++;
				if(!callTimer.running) callTimer.start();
				rs.rc.connection.call.apply(null, callArgs.concat(props.params));
				if(limiter) limiter.lockCall(id);
			}
		}
		
		private function onResult(resObj:Object):void
		{
			if(!completed && rs)
			{
				callComplete();
				var re:CallResult = new CallResult(resObj);
				if(!checkForOnResultCallback()) return;
				(props.returnArgs && props.params.length>0 && props.params!=undefined) ? props.onResult(re,props.params) : props.onResult(re);
				dispose();
			}
		}
		
		private function onFault(resObj:Object):void
		{
			if(!completed && rs)
			{
				callComplete();
				var fe:CallFault = new CallFault(resObj);
				if(!checkForOnFaultCallback()) return;
				(props.returnArgs && props.params.length>0 && props.params!=undefined) ? props.onFault(fe,props.params) : props.onFault(fe);
				dispose();
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			rs = null;
		}
	}
}