package
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	import fl.controls.Button;
	
	import gs.TweenMax;
	import gs.easing.Quad;
	
	import net.guttershark.control.DocumentController;
	import net.guttershark.control.PreloadController;
	import net.guttershark.display.FLV;
	import net.guttershark.support.events.FLVEvent;
	import net.guttershark.support.preloading.Asset;
	import net.guttershark.support.preloading.events.PreloadProgressEvent;	
	public class Main extends DocumentController
		public function onStopClick():void