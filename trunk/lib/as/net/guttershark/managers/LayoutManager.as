package net.guttershark.managers{	import flash.geom.Point;		import flash.display.DisplayObject;	import flash.display.DisplayObjectContainer;	import flash.display.Stage;		/**	 * The LayoutManager class adds shortcuts for layout, and layer management	 * with a display objects children.	 * 	 * <p>DisplayObject's must have their registration point at 0,0 in	 * order for the align / stage align methods to function correctly. Otherwise	 * you'll see shifts in what is expected.</p>	 * 	 * @example	Using a layout manager from a CoreClip.	 * <listing>		 * public class MyClip extends CoreClip	 * {	 *     public function MyClip()	 *     {	 *         super(); //critical	 *         	 *         var mc1:MovieClip = new MovieClip();	 *         //draw vector box in mc1 here...	 *        	 *         var mc2:MovieClip = new MovieClip();	 *         //draw vector box in mc2 here...	 *         	 *         var mc3:MovieClip = new MovieClip();	 *         //draw vector box in mc3 here...	 *         	 *         lm.addChildren(mc1,mc2,mc3); //shortcut to add multiple children.	 *         	 *         lm.bringInFront(mc1,mc2); //moves mc1 in front of mc2.	 *         lm.sendToBack(mc1); //sends mc1 all the way to the back.	 *         lm.bringForward(mc2); //brings mc2 forward (in front of mc3).	 *     }	 * }	 * </listing>	 * 	 * @example Using a layout manager manually.	 * <listing>		 * var lm:LayoutManager = new LayoutManager(this);	 * 	 * var mc1:MovieClip = new MovieClip();	 * //draw box in mc1	 * 	 * var mc2:MovieClip = new MovieClip();	 * //draw box in mc2	 * 	 * var mc3:MovieClip = new MovieClip();	 * //draw box in mc3	 * 	 * lm.addChildren(mc1,mc2,mc3);	 * lm.bringToFront(mc1); //moves mc1 in front	 * </listing>	 * 	 * <p>There is also an extended example in guttershark/examples/managers/layoutmanager/</p>	 * 	 * @see net.guttershark.display.CoreClip#lm CoreClip lm property	 * @see net.guttershark.display.CoreSprite#lm CoreSprite lm property	 */	final public class LayoutManager	{				/**		 * The container in which layering operations will occur.		 */		protected var container:DisplayObjectContainer;		/**		 * zero point for local to local translations.		 */		private static var ZeroPoint:Point;				/**		 * The stage width from the versy first time a layout manager instance was created.		 */		private static var FirstStageWidth:int;				/**		 * The stage height from the versy first time a layout manager instance was created.		 */		private static var FirstStageHeight:int;				/**		 * a reference to the stage		 */		private static var StageRef:Stage;				/**		 * Whether or not to use whole pixels on for x and y coordinates.		 */		public static var wholePixels:Boolean = true;				/**		 * Ignore the stage align property and correctly translate		 * stage alignment operations to the actual stage viewport -		 * meaning if the stage.align property is anything other		 * than undefined or TOP_LEFT, correctly translate the 		 * positioning offsets that occur when setting x and y.		 */		public static var ignoreStageAlign:Boolean = true;		/**		 * Constructor for LayoutManager instances. 		 */		public function LayoutManager(target:DisplayObjectContainer)		{			container = target;			if(!FirstStageHeight)			{				FirstStageHeight = target.stage.stageHeight;				FirstStageWidth = target.stage.stageWidth;				StageRef = target.stage;				ZeroPoint = new Point(0,0);			}		}				/**		 * Gets the properties needed for container coordinate translations.		 * 		 * @param target The target display object.		 * @param relativeTo The relative to display object.		 */		private function getProps(target:DisplayObject,relativeTo:DisplayObject):Object		{			var props:Object = {};			props.iw = target.width;			props.ih = target.height;			props.tw = relativeTo.width;			props.th = relativeTo.height;			props.tgp = relativeTo.localToGlobal(ZeroPoint);			props.ilp = target.parent.globalToLocal(props.tgp);			return props;		}				/**		 * Bring a target display object in front of another display object.		 * 		 * @param target The target display object to re-layer.		 * @param relativeTo The display object in which the target will be brought in front of.		 */		public function bringInFront(target:DisplayObject, relativeTo:DisplayObject):void		{			var index:int = container.getChildIndex(relativeTo);			if(index < container.getChildIndex(target)) index +=1;			if(index!=-1) container.setChildIndex(target,index);		}				/**		 * Send a target display object behind another display object.		 * 		 * @param target The target display object to re-layer.		 * @param relativeTo The display object in which the target will be moved behind.		 */		public function sendBehind(target:DisplayObject, relativeTo:DisplayObject):void		{			var index:int = container.getChildIndex(relativeTo);			if(index!=-1) container.setChildIndex(target,index);		}				/**		 * Bring a display object forward 1 layer.		 * 		 * @param target The target display object.		 */		public function bringForward(target:DisplayObject):void		{			var index:int = container.getChildIndex(target)+1;			if(index == container.numChildren) return;			if(index!=-1) container.setChildIndex(target,index);		}				/**		 * Send the target display object backward 1 layer.		 * 		 * @param target The target display object.		 */		public function sendBackward(target:DisplayObject):void		{			var index:int = Math.max(0,container.getChildIndex(target)-1);			container.setChildIndex(target,index);			if(index!=-1) container.setChildIndex(target,index);		}				/**		 * Bring the target display object to the top most layer.		 * 		 * @param target The target display object.		 */		public function bringToFront(target:DisplayObject):void		{			var index:int = container.numChildren-1;			container.setChildIndex(target,index);			if(index!=-1) container.setChildIndex(target,index);		}				/**		 * Send the target display object to bottom most layer.		 * 		 * @param target The target display object.		 */		public function sendToBack(target:DisplayObject):void		{			container.setChildIndex(target,0);		}				/**		 * Add all children specified to the display list.		 * 		 * @param ...children An array of display objects to add.		 */		public function addChildren(...children):void		{			for each(var child:DisplayObject in children) container.addChild(child);		}				/**		 * Add all children specified onto the display list of the target container.		 * 		 * @param target A display object to add the spefified children onto.		 * @param ...children An array of display objects to add.		 */		public function addChildrenTo(target:DisplayObjectContainer,...children):void		{			for each(var child:DisplayObject in children) target.addChild(child);		}		/**		 * Remove all children from the display list.		 */		public function removeAllChildren():void		{			if(container.numChildren<1) return;			var i:int = 0;			var l:int = container.numChildren;			for(i;i<l;i++) container.removeChildAt(0);		}				/**		 * Remove all children specified from the display list.		 * 		 * @param ...children The children to remove.		 */		public function removeChildren(...children):void		{			for each(var child:DisplayObject in children) container.removeChild(child);		}				/**		 * Remove all children from the display list of the specified target object.		 * 		 * @param target The target display object container whose children will be removed.		 */		public function removeAllChildrenFrom(target:DisplayObjectContainer):void		{			if(target.numChildren<1) return;			var i:int = 0;			var l:int = target.numChildren;			for(i;i<l;i++) target.removeChildAt(0);		}		/**		 * Align the target display object centered on the x coordinate relatively		 * to another display object.		 * 		 * @param target The target display object to align.		 * @param relativeTo The target display object that target will be aligned to.		 */		public function alignXCenter(target:DisplayObject,relativeTo:DisplayObject):void		{			var props:Object = getProps(target,relativeTo);			if(wholePixels) target.x = Math.round(props.ilp.x + ((props.tw - props.iw) / 2));			else target.x = props.ilp.x + ((props.tw - props.iw) / 2);		}		/**		 * Align the target display object centered on the y coordinate relatively		 * to another display object.		 * 		 * @param target The target display object to align.		 * @param relativeTo The target display object that target will be aligned to.		 */		public function alignYCenter(target:DisplayObject,relativeTo:DisplayObject):void 		{			var props:Object = getProps(target,relativeTo);			if(wholePixels) target.y = Math.round(props.ilp.y + ((props.th - props.ih) / 2));			else target.y = props.ilp.y + ((props.th - props.ih) / 2);		}				/**		 * Align the target display object to the right edge of another display object.		 * 		 * @param target The target display object to align.		 * @param relativeTo The target display object that target will be aligned to.		 */		public function alignRight(target:DisplayObject,relativeTo:DisplayObject):void		{			var props:Object = getProps(target,relativeTo);			if(wholePixels) target.x = Math.round(props.ilp.x + ((props.tw - props.iw)));			else target.x = props.ilp.x + ((props.tw - props.iw));		}				/**		 * Align the target display object to the left edge of another display object.		 * 		 * @param target The target display object to align.		 * @param relativeTo The target display object that target will be aligned to.		 */			public function alignLeft(target:DisplayObject,relativeTo:DisplayObject):void 		{			var props:Object = getProps(target,relativeTo);			if(wholePixels) target.x = Math.round(props.ilp.x);			else target.x = props.ilp.x;		}				/**		 * Align a display object to the top edge of another display object.		 * 		 * @param target The target display object to align.		 * @param relativeTo The target display object that target will be aligned to.		 */		public function alignTop(target:DisplayObject,relativeTo:DisplayObject):void 		{			var props:Object = getProps(target,relativeTo);			if(wholePixels) target.y = Math.round(props.ilp.y);			else target.y = props.ilp.y;		}				/**		 * Align a display object to the bottom edge of another display object.		 * 		 * @param target The target display object to align.		 * @param relativeTo The target display object that target will be aligned to.		 */		public function alignBottom(target:DisplayObject,relativeTo:DisplayObject):void 		{			var props:Object = getProps(target,relativeTo);			if(wholePixels) target.y = Math.round(props.ilp.y + (props.th-props.ih));			else target.y = props.ilp.y + props.th;		}				/**		 * Align a display object to the dead center of another display object.		 * 		 * @param target The target display object to align.		 * @param relativeTo The target display object that target will be aligned to.		 */		public function alignCenter(target:DisplayObject,relativeTo:DisplayObject):void		{			alignXCenter(target,relativeTo);			alignYCenter(target,relativeTo);		}				/**		 * Align a display object to the top center of another display object.		 * 		 * @param target The target display object to align.		 * @param relativeTo The target display object that target will be aligned to.		 */		public function alignTopCenter(target:DisplayObject,relativeTo:DisplayObject):void		{			alignXCenter(target,relativeTo);			alignTop(target,relativeTo);		}				/**		 * Align a display object to the bottom center of another display object.		 * 		 * @param target The target display object to align.		 * @param relativeTo The target display object that target will be aligned to.		 */		public function alignBottomCenter(target:DisplayObject,relativeTo:DisplayObject):void		{			alignXCenter(target,relativeTo);			alignBottom(target,relativeTo);		}				/**		 * Align a display object to the top left corner of another display object.		 * 		 * @param target The target display object to align.		 * @param relativeTo The target display object that target will be aligned to.		 */		public function alignTopLeft(target:DisplayObject,relativeTo:DisplayObject):void		{			alignLeft(target,relativeTo);			alignTop(target,relativeTo);		}				/**		 * Align a display object to the left middle of another display object.		 * 		 * @param target The target display object to align.		 * @param relativeTo The target display object that target will be aligned to.		 */		public function alignMiddleLeft(target:DisplayObject,relativeTo:DisplayObject):void 		{			alignLeft(target,relativeTo);			alignYCenter(target,relativeTo);		}				/**		 * Align a display object to the bottom left corner of another display object.		 * 		 * @param target The target display object to align.		 * @param relativeTo The target display object that target will be aligned to.		 */		public function alignBottomLeft(target:DisplayObject,relativeTo:DisplayObject):void		{			alignLeft(target,relativeTo);			alignBottom(target,relativeTo);		}				/**		 * Align a display object to the top right corner of another display object.		 * 		 * @param target The target display object to align.		 * @param relativeTo The target display object that target will be aligned to.		 */		public function alignTopRight(target:DisplayObject,relativeTo:DisplayObject):void		{			alignRight(target,relativeTo);			alignTop(target,relativeTo);		}				/**		 * Align a display object to the right middle of another display object.		 * 		 * @param target The target display object to align.		 * @param relativeTo The target display object that target will be aligned to.		 */		public function alignMiddleRight(target:DisplayObject,relativeTo:DisplayObject):void		{			alignRight(target,relativeTo);			alignYCenter(target,relativeTo);		}				/**		 * Align a display object to the bottom right corner of another display object.		 * 		 * @param target The target display object to align.		 * @param relativeTo The target display object that target will be aligned to.		 */		public function alignBottomRight(target:DisplayObject,relativeTo:DisplayObject):void		{			alignRight(target,relativeTo);			alignBottom(target,relativeTo);		}				/**		 * Gets common properties for the target item.		 * 		 * @param item The target display object.		 */		private function propsForStageAligns(item:DisplayObject):Object		{			var props:Object = {};			props.iw = item.width;			props.ih = item.height;			return props;		}				/**		 * Takes care of updating the X coordinate for adjustments to		 * stage size by resize, because if the stage.align property		 * is anything other than top left, the coordinates get		 * shifted strangely.		 */		private function updatePointXForStageAdjustments(p:Point):Point		{			if(StageRef.stageHeight == FirstStageHeight && StageRef.stageWidth == FirstStageWidth) return p;			if(!(StageRef.align || StageRef.align == "T" || StageRef.align == "B"))			{				if(FirstStageWidth < StageRef.stageWidth) p.x -= (StageRef.stageWidth - FirstStageWidth) / 2;				else p.x += (FirstStageWidth - StageRef.stageWidth) / 2;			}			else if(StageRef.align == "R" || StageRef.align == "TR" || StageRef.align == "BR")			{				if(FirstStageWidth < StageRef.stageWidth) p.x -= (StageRef.stageWidth - FirstStageWidth);				else p.x += (FirstStageWidth - StageRef.stageWidth);			}			if(wholePixels) p.x = Math.round(p.x);			return p;		}				/**		 * Takes care of updating the Y coordinate for adjustments to		 * stage size by resize, because if the stage.align property		 * is anything other than top left, the coordinates get		 * shifted strangely.		 */		private function updatePointYForStageAdjustments(p:Point):Point		{			if(StageRef.stageHeight == FirstStageHeight && StageRef.stageWidth == FirstStageWidth) return p;			if(!(StageRef.align) || StageRef.align == "L" || StageRef.align == "R")			{				if(FirstStageHeight < StageRef.stageHeight) p.y -= (StageRef.stageHeight - FirstStageHeight) / 2;				else p.y += (FirstStageHeight - StageRef.stageHeight) / 2;			}			else if(StageRef.align == "BL" || StageRef.align == "BR" || StageRef.align == "B")			{				if(FirstStageHeight < StageRef.stageHeight) p.y -= (StageRef.stageHeight - FirstStageHeight);				else p.y += (FirstStageHeight - StageRef.stageHeight);			}			if(wholePixels) p.y = Math.round(p.y);			return p;		}				/**		 * Align the target display object centered on the x coordinate relatively		 * to the stage.		 * 		 * @param target The target display object to align.		 */		public function stageAlignXCenter(target:DisplayObject):void		{			var props:Object = propsForStageAligns(target);			var nx:int = (container.stage.stageWidth - props.iw) / 2;			var p:Point = new Point(nx,0);			var np:Point = target.parent.globalToLocal(p);			if(ignoreStageAlign) np = updatePointXForStageAdjustments(np);			target.x = np.x;		}		/**		 * Align the target display object centered on the y coordinate relatively		 * to the stage.		 * 		 * @param target The target display object to align.		 */		public function stageAlignYCenter(item:DisplayObject):void		{			var props:Object = propsForStageAligns(item);			var ny:int = (container.stage.stageHeight - props.ih) / 2;			var p:Point = new Point(0,ny);			var np:Point = item.parent.globalToLocal(p);			if(ignoreStageAlign) np = updatePointYForStageAdjustments(np);			item.y = np.y;		}				/**		 * Align the target display object to the right edge of the stage.		 * 		 * @param target The target display object to align.		 */		public function stageAlignRight(target:DisplayObject):void		{			var props:Object = propsForStageAligns(target);			var nx:int = (container.stage.stageWidth - props.iw);			var p:Point = new Point(nx,0);			var np:Point = target.parent.globalToLocal(p);			if(ignoreStageAlign) np = updatePointXForStageAdjustments(np);			target.x = np.x;		}			/**		 * Align the target display object to the left edge of the stage.		 * 		 * @param target The target display object to align.		 */		public function stageAlignLeft(target:DisplayObject):void		{			var p:Point = new Point(0,0);			var np:Point = target.parent.globalToLocal(p);			if(ignoreStageAlign) np = updatePointXForStageAdjustments(np);			target.x = np.x;		}		/**		 * Align the target display object to the bottom edge of the stage.		 * 		 * @param target The target display object to align.		 */		public function stageAlignBottom(target:DisplayObject):void		{			var props:Object = propsForStageAligns(target);			var ny:int = (container.stage.stageHeight - props.ih);			var p:Point = new Point(0,ny);			var np:Point = target.parent.globalToLocal(p);			if(ignoreStageAlign) np = updatePointYForStageAdjustments(np);			target.y = np.y;		}				/**		 * Align the target display object to the top edge of the stage.		 * 		 * @param target The target display object to align.		 */		public function stageAlignTop(target:DisplayObject):void		{			var p:Point = target.parent.globalToLocal(ZeroPoint);			if(ignoreStageAlign) p = updatePointYForStageAdjustments(p);			target.y = p.y;		}				/**		 * Align the target display object to the dead center of the stage.		 * 		 * @param target The target display object to align.		 */		public function stageAlignCenter(target:DisplayObject):void		{			stageAlignXCenter(target);			stageAlignYCenter(target);		}				/**		 * Align the target display object to the right middle of the stage.		 * 		 * @param target The target display object to align.		 */		public function stageAlignMiddleRight(target:DisplayObject):void		{			stageAlignRight(target);			stageAlignYCenter(target);		}				/**		 * Align the target display object to the left middle of the stage.		 * 		 * @param target The target display object to align.		 */		public function stageAlignMiddleLeft(target:DisplayObject):void		{			stageAlignLeft(target);			stageAlignYCenter(target);		}				/**		 * Align the target display object to the top center of the stage.		 * 		 * @param target The target display object to align.		 */		public function stageAlignTopCenter(target:DisplayObject):void		{			stageAlignTop(target);			stageAlignXCenter(target);		}				/**		 * Align the target display object to the bottom center of the stage.		 * 		 * @param target The target display object to align.		 */		public function stageAlignBottomCenter(target:DisplayObject):void		{			stageAlignBottom(target);			stageAlignXCenter(target);		}				/**		 * Align the target display object to the top right corner of the stage.		 * 		 * @param target The target display object to align.		 */		public function stageAlignTopRight(target:DisplayObject):void		{			stageAlignRight(target);			stageAlignTop(target);		}				/**		 * Align the target display object to the bottom right corner of the stage.		 * 		 * @param target The target display object to align.		 */		public function stageAlignBottomRight(target:DisplayObject):void		{			stageAlignBottom(target);			stageAlignRight(target);		}				/**		 * Align the target display object to the bottom left corner of the stage.		 * 		 * @param target The target display object to align.		 */		public function stageAlignBottomLeft(target:DisplayObject):void		{			stageAlignLeft(target);			stageAlignBottom(target);		}				/**		 * Align the target display object to the top left corner of the stage.		 * 		 * @param target The target display object to align.		 */		public function stageAlignTopLeft(target:DisplayObject):void		{			stageAlignTop(target);			stageAlignLeft(target);		}	}}