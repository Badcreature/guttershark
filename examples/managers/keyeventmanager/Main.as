package 
{
	import flash.text.TextField;
	
	import net.guttershark.control.DocumentController;
	import net.guttershark.managers.KeyManager;	

	public class Main extends DocumentController
	{
		
		public var textfeeld:TextField;

		public function Main()
		{
			super();
		}
		
		override protected function setupComplete():void
		{
			km = KeyManager.gi();
			km.addMapping(stage,"CONTROL+SHIFT+M",onWhatever);
			km.addMapping(stage,"Whatup",onWordup);
			km.addMapping(stage,"f",onW);
			km.addMapping(stage," ",onSpace);
			km.addMapping(stage,"CONTROL+SHIFT+F", onWhatever);
			km.addMapping(stage,"CONTROL+SHIFT+F+M",onWhatever);
			km.addMapping(stage,"CONTROL",onControl);
			km.addMapping(stage,"CONTROL+m",onm);
			km.addMapping(stage,"SHIFT",onW);
			km.addMapping(textfeeld,"ENTER",onTFEnter);
			km.am(stage,"RIGHT",onRight,true,onRightRepeat);
		}
		
		private function onRight():void
		{
			trace("right down");
		}
		
		
		private function onRightRepeat():void
		{
			trace("right down repeat");
			textfeeld.x+=1;
		}
		
		public function onTFEnter():void
		{
			trace("YOU PRESSED ENTER");
		}

		private function onm():void
		{
			trace("on ctrl m");
		}
		
		private function onControl():void
		{
			trace("on control");
		}
		
		private function onWhatever():void
		{
			trace("sequence matched");
		}
		
		private function onW():void
		{
			trace("on f");
		}
		
		private function onWordup():void
		{
			trace("typed wordup");
		}
		
		private function onSpace():void
		{
			trace("space pressed");
		}
	}}