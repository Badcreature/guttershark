package
{
	import flash.events.Event;	
	import flash.events.EventDispatcher;	
	import flash.display.MovieClip;	

	public class PasswordedClipManager extends EventDispatcher 
	{

		private static var inst:PasswordedClipManager;
		public function PasswordedClipManager(){}
		public var unlocked:Boolean;
		private var _password:String;
		private var clips:Array;
		
		public static function gi():PasswordedClipManager
		{
			if(!inst) inst = new PasswordedClipManager();
			return inst;
		}
		
		public function addClip(clip:MovieClip):void
		{
			if(!clips) clips = [];
			clips.push(clip);
			clip.visible = false;
		}
		
		public function get password():String
		{
			return _password;
		}
		
		public function set password(password:String):void
		{
			_password = password;
		}
		
		public function tryToUnlock(password:String):void
		{
			if(password != _password && password.length == _password.length) dispatchEvent(new Event("failedAttempt"));
			if(password != _password) return;
			else unlock();
		}
		
		public function unlock():void
		{
			unlocked = true;
			dispatchEvent(new Event("unlock"));
		}
	}}