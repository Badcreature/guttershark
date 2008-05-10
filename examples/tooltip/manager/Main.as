package
{
	
	import fl.controls.CheckBox;	
	import fl.controls.Button;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import net.guttershark.managers.ToolTipManager;
	import net.guttershark.ui.controls.ToolTipDataProvider;
	import net.guttershark.util.FlashLibrary;
	
	public class Main extends MovieClip 
	{

		private var toolTipManager:ToolTipManager;
		public var mybutton:Button;
		public var mybutton2:Button;
		public var mycheckbox:CheckBox;
		public var mycheckbox2:CheckBox;
		private var toolTipDisplayListSandbox:Sprite;

		public function Main()
		{
			super();
			init();
		}
		
		private function init():void
		{
			toolTipDisplayListSandbox = new Sprite();
			addChild(toolTipDisplayListSandbox);
			toolTipManager = new ToolTipManager(toolTipDisplayListSandbox,500);
			var renderer1:ToolTip1 = FlashLibrary.GetMovieClip("TT1") as ToolTip1;
			var renderer2:ToolTip2 = FlashLibrary.GetMovieClip("TT2") as ToolTip2;
			toolTipManager.addToolTip(mybutton, renderer1, new ToolTipDataProvider("My Button"));
			toolTipManager.addToolTip(mycheckbox, renderer2, new ToolTipDataProvider("My Checkbox"));
			toolTipManager.addToolTip(mycheckbox2, renderer2, new ToolTipDataProvider("My Other Checkbox"));
			toolTipManager.addToolTip(mybutton2, renderer1, new ToolTipDataProvider("My Other Button"));
		}
	}}