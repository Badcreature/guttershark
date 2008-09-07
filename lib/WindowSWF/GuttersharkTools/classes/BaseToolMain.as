package  
{
	import net.guttershark.display.CoreSprite;	
	
	public class BaseToolMain extends CoreSprite 
	{
		public function BaseToolMain()
		{
			super();
		}
		public var id:String;
		public var controller:*;
		public var saved:Boolean;
		public function changeFLA():void{}
		public function save():void{}	}}