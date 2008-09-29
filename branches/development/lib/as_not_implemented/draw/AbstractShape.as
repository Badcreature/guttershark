package net.guttershark.display.draw{	import flash.errors.IllegalOperationError;		import flash.events.Event;		import flash.display.JointStyle;		import flash.display.LineScaleMode;		import flash.display.Shape;	/**	 * The AbstractShape class is the base class for all draw classes.	 */	public class AbstractShape extends Shape 	{		/**		 * flag that indicates change.		 */		protected var _changed:Boolean = false;				/**		 * The fill color;		 */		protected var fillColor:Number = 0xFFFFFF;				/**		 * The fill alpha.		 */		protected var fillAlpha:Number = 1;				/**		 * Line style thickness.		 */		protected var lineThickness:Number = 1;				/**		 * Line color.		 */		protected var lineColor:uint = 0x000000;				/**		 * Line alpha.		 */		protected var lineAlpha:Number = 1;				/**		 * Line pixel hinting.		 */		protected var linePixelHinting:Boolean = false;				/**		 * Line stale mode.		 */		protected var lineScaleMode:String = LineScaleMode.NORMAL;				/**		 * Line caps.		 */		protected var lineCaps:String = null;				/**		 * Line Joints.		 */		protected var lineJoints:String = JointStyle.MITER;				/**		 * Line miter limit.		 */		protected var lineMiterLimit:Number = 3;		/**		 * Constructor for AbstractShape instances.		 */		public function AbstractShape() 		{			addEventListener(Event.ADDED_TO_STAGE,onStage,false,0,true);			addEventListener(Event.REMOVED_FROM_STAGE,offStage,false,0,true);		}		/**		 * Set the stroke style of the shape.		 */		public function setStrokeStyle(thickness:Number = 1, color:uint = 0x000000, alpha:Number = 1, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = "miter", miterLimit:Number = 10):void 		{			lineThickness = thickness;			lineColor = color;			lineAlpha = alpha;			linePixelHinting = pixelHinting;			lineScaleMode = scaleMode;			lineCaps = caps;			lineJoints = joints;			lineMiterLimit = miterLimit;			setChanged();		}		/**		 * Set the fill style of the shape.		 */		public function setFillStyle(color:uint = 0xFFFFFF, alpha:Number = 1):void 		{			fillColor = color;			fillAlpha = alpha;			setChanged();		}				/**		 * When the shape has been added to the stage.		 */		protected function onStage(e:Event):void 		{			stage.addEventListener(Event.RENDER,render,false,0,true);			if(hasChanged()) requestDraw();		}		/**		 * When the shape has been removed from the stage.		 */		protected function offStage(e:Event):void 		{			stage.removeEventListener(Event.RENDER,render);		}		/**		 * Handles screen updates when stage.invalidate() fires.		 */		protected function render(e:Event):void		{			if(hasChanged()) draw();		}		/**		 * Draw the Shape graphics as defined by <code>AbstractShape</code> subclasses.		 * 		 * <p>In order to increase performance <code>draw()</code> is only called		 * when during a stage RENDER event fires.</p>		 */		protected function draw():void 		{			graphics.clear();			graphics.lineStyle(lineThickness,lineColor,lineAlpha,linePixelHinting,lineScaleMode,lineCaps,lineJoints,lineMiterLimit);			graphics.beginFill(fillColor,fillAlpha);			drawShape();			graphics.endFill();			clearChanged();		}		/**		 * Draw the specific lines of the Shape as defined by <code>AbstractShape</code> subclasses.		 */		protected function drawShape():void 		{			throw new IllegalOperationError("AbstractShape.drawShape() may only be invoked by subclasses.");		}		/**		 * Flag the shape as changed which forces a redraw on the next render.		 */		protected function setChanged():void 		{			_changed = true;			requestDraw();		}		/**		 * Reset the changed flag, until another change.		 */		protected function clearChanged():void 		{			_changed = false;		}		/**		 * Indicates whether the shape change has been rendered yet or not.		 */		protected function hasChanged():Boolean 		{			return _changed;		}		/**		 * Forces a stage.invalidate() call, which will force an update to the shape, if it		 * has been changed since the last REDRAW.		 */		protected function requestDraw():void 		{			if(stage != null) stage.invalidate();		}	}}