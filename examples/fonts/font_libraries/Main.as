package 
{
	import flash.text.AntiAliasType;	
	import flash.text.TextField;	
	import flash.text.TextFormat;	
	import flash.events.Event;	
	
	import net.guttershark.preloading.Asset;	
	import net.guttershark.preloading.PreloadController;	
	import net.guttershark.control.DocumentController;	
	
	public class Main extends DocumentController
	{
		
		private var pc:PreloadController;
		public var test:TextField;
		public var test2:TextField;

		public function Main()
		{
			super();
		}
		
		override protected function setupComplete():void
		{
			pc = new PreloadController();
			var items:Array = [new Asset("ArialBold.swf","ArialBold"),
				new Asset("FranklinGothicMedium.swf","FranklinGothicMedium")];
			pc.addItems(items);
			pc.addEventListener(Event.COMPLETE, onComplete);
			pc.start();
		}
		
		private function onComplete(e:Event):void
		{
			var f = pc.library.getFontFromSWFLibrary("FranklinGothicMedium","FranklinGothicMedium");
			var a = pc.library.getFontFromSWFLibrary("ArialBold","ArialBold");
			
			var format:TextFormat = new TextFormat();
			format.font = f.fontName;
			format.size = 20;
			format.bold = true;
			
			var format1:TextFormat = new TextFormat();
			format1.font = a.fontName;
			format1.size = 10;
			format1.bold = true;
			
			var t:TextField = new TextField();
			t.embedFonts = true;
			t.autoSize = "left";
			t.defaultTextFormat = format1;
			t.text = "arial bold";
		
			
			var t1:TextField = new TextField();
			t1.embedFonts = true;
			t1.antiAliasType = AntiAliasType.ADVANCED;
			t1.autoSize = "left";
			t1.defaultTextFormat = format;
			t1.text = "franklin gothic medium";
			t1.x = 100;
			
			test.defaultTextFormat = format1;
			test.embedFonts = true;
			test.autoSize = "left";
			test.text = "word";
			
			test2.defaultTextFormat = format;
			test2.antiAliasType = "advanced";
			test2.embedFonts = true;
			test2.autoSize = "left";
			test2.text = "word";
			
			addChild(t1);
			addChild(t);
		}	}}