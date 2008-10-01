package net.guttershark.util 
{
	import flash.display.DisplayObject;	
	import flash.display.Stage;	
	
	/**
	 * The StageUtils class has shortcut methods for common stage functionality needed.
	 */
	public class StageUtils 
	{
		
		/**
		 * Center a display object in the stage. The stageWidth and stageHeight are taken from
		 * <code>dob.stage.stageWidth / dob.stage.stageHeight</code> respectively. <code>fakeStageWidth</code>
		 * and <code>fakeStageHeight</code> are available for cases when you need to use a different
		 * width / height for the stage.
		 */
		public static function CenterInStage(dob:DisplayObject, offsetX:Number = 0, offsetY:Number = 0, wholePixels:Boolean = true, fakeStageWidth:int = -1, fakeStageHeight:int = -1):void
		{
			Assert.NotNull(dob, "Parameter dob cannot be null");
			Assert.NotNull(offsetX, "Parameter offsetX cannot be null");
			Assert.NotNull(offsetY, "Parameter offsetX cannot be null");
			Assert.NotNull(dob.stage, "The display object's stage property cannot be null. Add the display object to the display list before centering.");
			var stageWidth:int;
			var stageHeight:int;
			if(fakeStageHeight > -1) stageWidth = fakeStageWidth;
			else stageWidth = dob.stage.stageWidth;
			if(fakeStageHeight > -1) stageHeight = fakeStageHeight;
			else stageHeight = dob.stage.stageHeight;
			dob.x = ((stageWidth - dob.width) / 2);
			if(offsetX != 0 && !isNaN(offsetX)) dob.x += offsetX;
			dob.y = ((stageHeight - dob.height) / 2);
			if(offsetY != 0 && !isNaN(offsetY)) dob.y += offsetY;
			if(wholePixels)
			{
				dob.x = Math.round(dob.x);
				dob.y = Math.round(dob.y);
			}
		}
	}
}
