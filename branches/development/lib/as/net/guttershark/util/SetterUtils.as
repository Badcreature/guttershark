package net.guttershark.util 
{

	/**
	 * The SetterUtils class is a singleton that has utility methods
	 * that decrease amount of code you have to write for setting the same
	 * properties on multiple objects.
	 * 
	 * <p>All methods can be used in two ways.</p>
	 * 
	 * @example Two uses for each method:
	 * <listing>	
	 * var su:SetterUtils = SetterUtils.gi();
	 * 
	 * var mc1,mc2,mc3:MovieClip;
	 * var mcref:Array = [mc1,mc2,mc3];
	 * 
	 * su.visible(true,mc1,mc2,mc3); //rest style.
	 * 
	 * //array style - this is nice when you want to group
	 * //display objects to you can quickly toggle a property.
	 * su.visible(false,mcref);
	 * </listing>
	 * 
	 * @see net.guttershark.util.Utilities Utilities class.
	 */
	final public class SetterUtils 
	{
		
		/**
		 * Singleton instance.
		 */
		private static var inst:SetterUtils;
		
		/**
		 * Singleton access.
		 */
		public static function gi():SetterUtils
		{
			if(!inst) inst = Singleton.gi(SetterUtils);
			return inst;
		}
		
		/**
		 * @private
		 */
		public function SetterUtils()
		{
			Singleton.assertSingle(SetterUtils);
		}

		/**
		 * Set the buttonMode property on all objects provided.
		 * 
		 * @param value The value to set the buttonMode property to.
		 * @param ...objs An array of objects that have the buttonMode property.
		 */
		public function buttonMode(value:Boolean, ...objs:Array):void
		{
			var l:int = objs.length;
			var k:int = 0;
			var a:Array = objs;
			if(objs[0] is Array)
			{
				a = objs[0];
				l = a.length;
			}
			for(k;k<l;k++) a[k].buttonMode = value;
		}
		
		/**
		 * Set the visible property on all objects provided.
		 * 
		 * @param value The value to set the visible property to.
		 * @param ...objs An array of objects with the visible property.
		 */
		public function visible(value:Boolean, ...objs:Array):void
		{
			var l:int = objs.length;
			var k:int = 0;
			var a:Array = objs;
			if(objs[0] is Array)
			{
				a = objs[0];
				l = a.length;
			}
			for(k;k<l;k++) a[k].visible = value;
		}
		
		/**
		 * Set the alpha property on all objects provided.
		 * 
		 * @param value The value to set the alpha to.
		 * @param ...objs An array of objects with an alpha property.
		 */
		public function alpha(value:Number, ...objs:Array):void
		{
			var l:int = objs.length;
			var k:int = 0;
			var a:Array = objs;
			if(objs[0] is Array)
			{
				a = objs[0];
				l = a.length;
			}
			for(k;k<l;k++) a[k].alpha = value;
		}
		
		/**
		 * Set the cacheAsBitmap property on all objects provided.
		 * 
		 * @param value The value to set the cacheAsBitmap property to.
		 * @param ...objs An array of objects with the cacheAsBitmap property.
		 */
		public function cacheAsBitmap(value:Boolean, ...objs:Array):void
		{
			var l:int = objs.length;
			var k:int = 0;
			var a:Array = objs;
			if(objs[0] is Array)
			{
				a = objs[0];
				l = a.length;
			}
			for(k;k<l;k++) a[k].cacheAsBitmap = value;
		}
		
		/**
		 * Set the useHandCursor property on all objects provided.
		 * 
		 * @param value The value to set the useHandCursor property to.
		 * @param ...objs An array of objects with the useHandCursor property.
		 */
		public function useHandCursor(value:Boolean, ...objs:Array):void
		{
			var l:int = objs.length;
			var k:int = 0;
			var a:Array = objs;
			if(objs[0] is Array)
			{
				a = objs[0];
				l = a.length;
			}
			for(k;k<l;k++) a[k].useHandCursor = value;
		}	
		
		/**
		 * Set the mouseChildren property on all objects provided.
		 * 
		 * @param value The value to set the mouseChildren property to on all objects.
		 * @param ...objs An array of objects with the mouseChildren property.
		 */
		public function mouseChildren(value:Boolean,...objs:Array):void
		{
			var l:int = objs.length;
			var k:int = 0;
			var a:Array = objs;
			if(objs[0] is Array)
			{
				a = objs[0];
				l = a.length;
			}
			for(k;k<l;k++) a[k].mouseChildren = value;
		}
		
		/**
		 * Set the mouseEnabled property on all objects provided.
		 * 
		 * @param value The value to set the mouseEnabled property to on all objects.
		 * @param ..objs An array of objects with the mouseEnabled property.
		 */
		public function mouseEnabled(value:Boolean,...objs:Array):void
		{
			var l:int = objs.length;
			var k:int = 0;
			var a:Array = objs;
			if(objs[0] is Array)
			{
				a = objs[0];
				l = a.length;
			}
			for(k;k<l;k++) a[k].mouseEnabled = value;
		}
		
		/**
		 * Set tab index's on multiple textfields.
		 * 
		 * @param ...fields The textfields to set tabIndex on.
		 */
		public function tabIndex(...fields:Array):void
		{
			var l:int = fields.length;
			var k:int = 0;
			if(fields[0] is Array)
			{
				fields = fields[0];
				l = fields.length;
			}
			for(k;k<l;k++) fields[k].tabIndex = ++k;
		}
		
		/**
		 * Set the tabChildren property on all objects passed.
		 * 
		 * @param The value to set the tabChildren property to on all objects.
		 * @param ..objs An array of objects with the tabChildren property.
		 */
		public function tabChildren(value:Boolean,...objs:Array):void
		{
			var l:int = objs.length;
			var k:int = 0;
			var a:Array = objs;
			if(objs[0] is Array)
			{
				a = objs[0];
				l = a.length;
			}
			for(k;k<l;k++) a[k].tabChildren = value;
		}
		
		/**
		 * Set the tabEnabled property on all objects passed.
		 * 
		 * @param The value to set the tabChildren property to on all objects.
		 * @param ..objs An array of objects with the tabEnabled property.
		 */
		public function tabEnabled(value:Boolean,...objs:Array):void
		{
			var l:int = objs.length;
			var k:int = 0;
			var a:Array = objs;
			if(objs[0] is Array)
			{
				a = objs[0];
				l = a.length;
			}
			for(k;k<l;k++) a[k].tabEnabled = value;
		}
		
		/**
		 * Set the autoSize property on multiple textfields.
		 * 
		 * @param value The autoSize value.
		 * @param ...fields The textfields to set the autoSize property on.
		 */
		public function autoSize(value:String, ...fields:Array):void
		{
			var l:int = fields.length;
			var k:int = 0;
			var a:Array = fields;
			if(fields[0] is Array)
			{
				a = fields[0];
				l = a.length;
			}
			for(k;k<l;k++) a[k].autoSize = value;
		}
	}
}