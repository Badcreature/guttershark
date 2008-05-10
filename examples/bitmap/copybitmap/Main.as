package 
{

	import flash.display.Bitmap;	
	import flash.display.BitmapData;	

	import net.guttershark.util.BitmapUtils;
	import net.guttershark.control.DocumentController;	
	
	public class Main extends DocumentController
	{
		
		public function Main()
		{
			super();
		}
		
		override protected function setupComplete():void
		{
			var bmd:BitmapData = new BitmapData(50,50,false,0xFF0066);
			var bitmap1:Bitmap = new Bitmap(bmd);
			addChild(bitmap1);
			var bitmap2:Bitmap = BitmapUtils.CopyBitmap(bitmap1);
			bitmap2.x = 100;
			bitmap2.y = 100;
			addChild(bitmap2);
		}	}}