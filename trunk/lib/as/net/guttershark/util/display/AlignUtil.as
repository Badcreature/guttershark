package net.guttershark.util.display{	import flash.display.DisplayObject;	import flash.display.Stage;		
	/**	 * Static class wrapping various Alignment utilities.	 */	public class AlignUtil 	{		/**		 * Center align object to target.		 */		public static  function alignCenter(item:DisplayObject,target:DisplayObject):void 		{			xAlignCenter(item,target);			yAlignCenter(item,target);		}		/**		 * Horizontal center align object to target.		 */		public static  function xAlignCenter(item:DisplayObject,target:DisplayObject):void 		{			item.x = int(target.width / 2 - item.width / 2);		}		/**		 * Vertical center align object to target.		 */		public static  function yAlignCenter(item:DisplayObject,target:DisplayObject):void 		{			item.y = int(target.height / 2 - item.height / 2);		}		/**		 * Right align object to target.		 */		public static  function alignRight(item:DisplayObject,target:DisplayObject):void 		{			xAlignRight(item,target);			yAlignRight(item,target);		}		/**		 * Horizontal right align object to target.		 */		public static  function xAlignRight(item:DisplayObject,target:DisplayObject):void 		{			item.x = int(target.width - item.width);		}		/**		 * Vertical right align object to target.		 */		public static  function yAlignRight(item:DisplayObject,target:DisplayObject):void 		{			item.y = int(target.height - item.height);		}		/**		 * Left align object to target.		 */		public static  function alignLeft(item:DisplayObject,target:DisplayObject):void 		{			xAlignLeft(item,target);			yAlignLeft(item,target);		}		/**		 * Horizontal left align object to target.		 */			public static  function xAlignLeft(item:DisplayObject,target:DisplayObject):void 		{			item.x = int(target.x);		}		/**		 * Vertical left  align object to target.		 */			public static  function yAlignLeft(item:DisplayObject,target:DisplayObject):void 		{			item.y = int(target.y);		}		/**		 * Center align object to stage.		 */		public static  function stageAlignCenter(stage:Stage,item:DisplayObject):void		{			stageAlignXCenter(stage,item);			stageAlignYCenter(stage,item);		}		/**		 * Horizontal center align object to stage.		 */		public static  function stageAlignXCenter(stage:Stage,item:DisplayObject):void		{			item.x=int(stage.stageWidth/2-item.width/2);		}		/**		 * Vertical center align object to stage.		 */		public static  function stageAlignYCenter(stage:Stage,item:DisplayObject):void 		{			item.y=int(stage.stageHeight/2-item.height/2);		}		/**		 * Align object to stage right.		 */		public static  function stageAlignRight(stage:Stage,item:DisplayObject):void 		{			item.x=int(stage.stageWidth-item.width);		}		/**		 * Align object to stage bottom.		 */		public static  function stageAlignBottom(stage:Stage,item:DisplayObject):void 		{			item.y=int(stage.stageHeight-item.height);		}		/**		 * A wrapper for setting the scale on two display objects.		 * @param item	to be scaled 		 * @param scale	scale percentage		 */		public static  function scale(item:DisplayObject,scale:Number):void 		{			item.scaleX = scale;			item.scaleY = scale;		}		/**		 * Scale target item to fit within target confines.		 * @param item 		to be aligned 		 * @param targetW 	item width		 * @param targetH 	item height		 * @param center 	object		 * @return void		 */		public static  function scaleToFit(item:DisplayObject,targetW:Number,targetH:Number,center:Boolean):void 		{			if(item.width<targetW && item.width>item.height) 			{				item.width = targetW;				item.scaleY = item.scaleX;			}			else			{				item.height = targetH;				item.scaleX = item.scaleY;			}			if(center) 			{				item.x = int(targetW/2-item.width/2);				item.y = int(targetH/2-item.height/2);			}		}		/**		 * Scale while retaining original w:h ratio.		 * @param item 		to be scaled		 * @param targetW 	item width		 * @param targetH 	item height		 * @return void		 */		public static  function scaleRatio(item:DisplayObject,targetW:Number,targetH:Number):void 		{			if(targetW/targetH<item.height/item.width) targetW = targetH * item.width / item.height; 			else targetH = targetW * item.height / item.width;			item.width = targetW;			item.height = targetH;		}		/**		 * Flip object on an axis.		 * @param obj 	to flip		 * @param axis 	to flip on ["x" or "y"]		 * @return void		 * @throws Error on invalid axis 		 */		public static  function flip(obj:Object,axis:String="y"):void 		{			if(axis != "_x" && axis != "_y") 			{				throw new Error("@@@ AlignUtils.flip() Error: expects axis param: 'x' or 'y'.");				return;			}			var _scale:String = axis == "x" ? "scaleX" :"scaleY";			var _prop:String = axis == "x" ? "width" : "height";			obj[_scale] = -obj[_scale];			obj[axis] -= obj[_prop];		}	}}