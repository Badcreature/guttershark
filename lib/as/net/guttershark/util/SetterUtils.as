package net.guttershark.util 
{
	import net.guttershark.model.Model;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.ContextMenu;		

	/**
	 * The SetterUtils class is a singleton that has utility methods
	 * that decrease amount of code you have to write for setting the same
	 * properties on multiple objects.
	 * 
	 * <p>All methods can be used in two ways.</p>
	 * 
	 * @example Two uses for each method:
	 * <listing>	
	 * var su:SetterUtils=SetterUtils.gi();
	 * 
	 * var mc1,mc2,mc3:MovieClip;
	 * var mcref:Array=[mc1,mc2,mc3];
	 * 
	 * su.visible(true,mc1,mc2,mc3); //rest style.
	 * 
	 * //array style - this is nice when you want to group
	 * //display objects to you can quickly toggle a property.
	 * su.visible(false,mcref);
	 * </listing>
	 * 
	 * <p>There are a ton of other methods in here that offer
	 * the same benefts.</p>
	 */
	final public class SetterUtils 
	{
		
		/**
		 * Singleton instance.
		 */
		private static var inst:SetterUtils;
		
		/**
		 * The MathUtils singleton instance.
		 */
		private var mu:MathUtils;
		
		/**
		 * Singleton access.
		 */
		public static function gi():SetterUtils
		{
			if(!inst) inst=Singleton.gi(SetterUtils);
			return inst;
		}
		
		/**
		 * @private
		 */
		public function SetterUtils()
		{
			Singleton.assertSingle(SetterUtils);
			mu=MathUtils.gi();
		}

		/**
		 * Set the buttonMode property on all objects provided.
		 * 
		 * @param value The value to set the buttonMode property to.
		 * @param ...objs An array of objects that have the buttonMode property.
		 */
		public function buttonMode(value:Boolean, ...objs:Array):void
		{
			var l:int=objs.length;
			var k:int=0;
			var a:Array=objs;
			if(objs[0] is Array)
			{
				a=objs[0];
				l=a.length;
			}
			for(k;k<l;k++) a[k].buttonMode=value;
		}
		
		/**
		 * Set the visible property on all objects provided.
		 * 
		 * @param value The value to set the visible property to.
		 * @param ...objs An array of objects with the visible property.
		 */
		public function visible(value:Boolean, ...objs:Array):void
		{
			var l:int=objs.length;
			var k:int=0;
			var a:Array=objs;
			if(objs[0] is Array)
			{
				a=objs[0];
				l=a.length;
			}
			for(k;k<l;k++) a[k].visible=value;
		}
		
		/**
		 * Set the alpha property on all objects provided.
		 * 
		 * @param value The value to set the alpha to.
		 * @param ...objs An array of objects with an alpha property.
		 */
		public function alpha(value:Number, ...objs:Array):void
		{
			var l:int=objs.length;
			var k:int=0;
			var a:Array=objs;
			if(objs[0] is Array)
			{
				a=objs[0];
				l=a.length;
			}
			for(k;k<l;k++) a[k].alpha=value;
		}
		
		/**
		 * Set the cacheAsBitmap property on all objects provided.
		 * 
		 * @param value The value to set the cacheAsBitmap property to.
		 * @param ...objs An array of objects with the cacheAsBitmap property.
		 */
		public function cacheAsBitmap(value:Boolean, ...objs:Array):void
		{
			var l:int=objs.length;
			var k:int=0;
			var a:Array=objs;
			if(objs[0] is Array)
			{
				a=objs[0];
				l=a.length;
			}
			for(k;k<l;k++) a[k].cacheAsBitmap=value;
		}
		
		/**
		 * Set the useHandCursor property on all objects provided.
		 * 
		 * @param value The value to set the useHandCursor property to.
		 * @param ...objs An array of objects with the useHandCursor property.
		 */
		public function useHandCursor(value:Boolean, ...objs:Array):void
		{
			var l:int=objs.length;
			var k:int=0;
			var a:Array=objs;
			if(objs[0] is Array)
			{
				a=objs[0];
				l=a.length;
			}
			for(k;k<l;k++) a[k].useHandCursor=value;
		}	
		
		/**
		 * Set the mouseChildren property on all objects provided.
		 * 
		 * @param value The value to set the mouseChildren property to on all objects.
		 * @param ...objs An array of objects with the mouseChildren property.
		 */
		public function mouseChildren(value:Boolean,...objs:Array):void
		{
			var l:int=objs.length;
			var k:int=0;
			var a:Array=objs;
			if(objs[0] is Array)
			{
				a=objs[0];
				l=a.length;
			}
			for(k;k<l;k++) a[k].mouseChildren=value;
		}
		
		/**
		 * Set the mouseEnabled property on all objects provided.
		 * 
		 * @param value The value to set the mouseEnabled property to on all objects.
		 * @param ..objs An array of objects with the mouseEnabled property.
		 */
		public function mouseEnabled(value:Boolean,...objs:Array):void
		{
			var l:int=objs.length;
			var k:int=0;
			var a:Array=objs;
			if(objs[0] is Array)
			{
				a=objs[0];
				l=a.length;
			}
			for(k;k<l;k++) a[k].mouseEnabled=value;
		}
		
		/**
		 * Set tab index's on multiple textfields.
		 * 
		 * @param ...fields The textfields to set tabIndex on.
		 */
		public function tabIndex(...fields:Array):void
		{
			var l:int=fields.length;
			var k:int=0;
			if(fields[0] is Array)
			{
				fields=fields[0];
				l=fields.length;
			}
			for(k;k<l;k++) fields[k].tabIndex=++k;
		}
		
		/**
		 * Set the tabChildren property on all objects passed.
		 * 
		 * @param The value to set the tabChildren property to on all objects.
		 * @param ..objs An array of objects with the tabChildren property.
		 */
		public function tabChildren(value:Boolean,...objs:Array):void
		{
			var l:int=objs.length;
			var k:int=0;
			var a:Array=objs;
			if(objs[0] is Array)
			{
				a=objs[0];
				l=a.length;
			}
			for(k;k<l;k++) a[k].tabChildren=value;
		}
		
		/**
		 * Set the tabEnabled property on all objects passed.
		 * 
		 * @param The value to set the tabChildren property to on all objects.
		 * @param ..objs An array of objects with the tabEnabled property.
		 */
		public function tabEnabled(value:Boolean,...objs:Array):void
		{
			var l:int=objs.length;
			var k:int=0;
			var a:Array=objs;
			if(objs[0] is Array)
			{
				a=objs[0];
				l=a.length;
			}
			for(k;k<l;k++) a[k].tabEnabled=value;
		}
		
		/**
		 * Set the autoSize property on multiple textfields.
		 * 
		 * @param value The autoSize value.
		 * @param ...fields The textfields to set the autoSize property on.
		 */
		public function autoSize(value:String, ...fields:Array):void
		{
			var l:int=fields.length;
			var k:int=0;
			var a:Array=fields;
			if(fields[0] is Array)
			{
				a=fields[0];
				l=a.length;
			}
			for(k;k<l;k++) a[k].autoSize=value;
		}
		
		/**
		 * Set the x property on multiple object.
		 * 
		 * @param value The x value.
		 * @param ..objs An array of objects with the x property.
		 */
		public function x(value:Number, ...objs:Array):void
		{
			var l:int=objs.length;
			var k:int=0;
			var a:Array=objs;
			if(objs[0] is Array)
			{
				a=objs[0];
				l=a.length;
			}
			for(k;k<l;k++) a[k].x=value;
		}
		
		/**
		 * Set the y property on multiple object.
		 * 
		 * @param value The y value.
		 * @param ..objs An array of objects with the x property.
		 */
		public function y(value:Number, ...objs:Array):void
		{
			var l:int=objs.length;
			var k:int=0;
			var a:Array=objs;
			if(objs[0] is Array)
			{
				a=objs[0];
				l=a.length;
			}
			for(k;k<l;k++)a[k].y=value;
		}
		
		/**
		 * Set any property to the specified value, on all objects.
		 * 
		 * @param objs The objects to toggle the visible property on.
		 */
		public function prop(prop:String,value:*,...objs:Array):void
		{
			var l:int=objs.length;
			var k:int=0;
			var a:Array=objs;
			if(objs[0] is Array)
			{
				a=objs[0];
				l=a.length;
			}
			for(k;k<l;k++)a[k][prop]=value;
		}
		
		/**
		 * Toggles the visible property on all objects provided.
		 * 
		 * @param objs The objects to toggle the visible property on.
		 */
		public function toggleVisible(...objs:Array):void
		{
			var l:int=objs.length;
			var k:int=0;
			var a:Array=objs;
			if(objs[0] is Array)
			{
				a=objs[0];
				l=a.length;
			}
			for(k;k<l;k++)a[k].visible=!a[k].visible;
		}
		
		/**
		 * Flip the alpha property on all objects provide, if the
		 * alpha on an object is equal to either val1 or val2, the
		 * values are flipped.
		 * 
		 * @param val1 The first alpha value.
		 * @param val2 The second alpha value.
		 * @param objs The objects to toggle the visible property on.
		 */
		public function flipAlpha(val1:Number,val2:Number,...objs:Array):void
		{
			var l:int=objs.length;
			var k:int=0;
			var a:Array=objs;
			if(objs[0] is Array)
			{
				a=objs[0];
				l=a.length;
			}
			var obj:*;
			var al:Number;
			for(k;k<l;k++)
			{
				obj=a[k];
				al=mu.sanitizeFloat(obj.alpha,1);
				if(al==val1)obj.alpha=val2;
				else if(al==val2)obj.alpha=val1;
			}
		}
		
		/**
		 * Toggle any property on any object - if the current value
		 * of the property is value1, it will be set to value2, as
		 * well as the reverse.
		 * 
		 * @param prop The property to toggle.
		 * @param value1 The first value.
		 * @param value2 The second value.
		 * @param ...objs The objects whose property will be toggled.
		 */
		public function flipProp(prop:String,value1:*,value2:*,...objs:Array):void
		{
			var l:int=objs.length;
			var k:int=0;
			var a:Array=objs;
			if(objs[0] is Array)
			{
				a=objs[0];
				l=a.length;
			}
			var obj:*;
			for(k;k<l;k++)
			{
				obj=a[k];
				if(obj[prop]==value1)obj[prop]=value2;
				else if(obj[prop]==value2)obj[prop]=value1;
			}
		}
		
		/**
		 * Toggles the value of a boolean property to the opposite value
		 * for all objects provided.
		 * 
		 * @param prop The property to toggle.
		 * @param objs All objects whose property will be flipped.
		 */
		public function flipBoolean(prop:String, ...objs:Array):void
		{
			var l:int=objs.length;
			var k:int=0;
			var a:Array=objs;
			if(objs[0] is Array)
			{
				a=objs[0];
				l=a.length;
			}
			for(k;k<l;k++)a[k][prop]=!a[k][prop];
		}
		
		/**
		 * Set properties on an object, the properties come from
		 * the model in a &lt;propset&gt;&lt/propset&gt;
		 * node.
		 * 
		 * @param obj The object whose properties will be updated.
		 * @param propsId The id of the &lt;propset&gt; node in the model.
		 */
		public function propsFromModel(obj:*, propsId:String):void
		{
			var ml:Model=Model.gi();
			if(!ml.xml)throw new Error("The model xml has not been loaded or set, cannot set properties from the model.");
			var n:XMLList=ml.xml.properties..propset.(@id==propsId);
			var usedText:Boolean;
			if(obj is TextField)
			{
				var t:TextField=TextField(obj);
				if(n.textFormat!=undefined&&n.styleSheet!=undefined)trace("WARNING: A textfield cannot have both a stylesheet, and a textformat. One or the other should be used. The stylehsset will be used if you do have both.");
				if(n.textFormat!=undefined)
				{
					var tf:TextFormat=ml.getTextFormatById(n.textFormat.@id);
					t.defaultTextFormat=tf;
					t.setTextFormat(tf);
				}
				if(n.styleSheet!=undefined)t.styleSheet=ml.getStyleSheetById(n.styleSheet.@id);
				if(n.text!=undefined||n.htmlText!=undefined)
				{
					if(n.text.@id!=undefined)
					{
						usedText=true;
						obj.text=ml.getContentById(n.text.@id);
					}
					else if(n.htmlText.@id!=undefined)
					{
						usedText=true;
						obj.htmlText=ml.getContentById(n.htmlText.@id);
					}
				}
			}
			if(n.contextMenu)
			{
				if(n.contextMenu.@id!=undefined)
				{
					var cmm:ContextMenu=ml.createContextMenuById(n.contextMenu.@id);
					obj.contextMenu=cmm;
				}
			}
			var children:XMLList=n.children();
			var child:XML;
			for each(child in children)
			{
				var k:String=child.name().toString();
				var s:String=child.toString();
				if(k=="textFormat"||k=="styleSheet"||k=="contextMenu")continue;
				if(usedText&&(k=="text"||k=="htmlText"))continue;
				if(k=="xywh")
				{
					var e:int=0;
					var r:int=4;
					var props:Array=["x","y","width","height"];
					var prop:String;
					for(e;e<r;e++)
					{
						prop=props[e];
						if(child.attribute(prop)!=undefined)
						{
							s=child.attribute(prop).toString();
							if(isPlusMinus(s))obj[prop]=getPlusMinusVal(s,obj[prop]);
							else obj[prop]=Number(s);
						}
					}
					continue;
				}
				if(s=="true")
				{
					obj[k]=true;
					continue;
				}
				else if(s=="false")
				{
					obj[k]=false;
					continue;
				}
				if(isPlusMinus(s))
				{
					obj[k]=getPlusMinusVal(s,Number(obj[k]));
					continue;
				}
				obj[k]=s;
			}
		}
		
		/**
		 * Helper method for propsFromModel.
		 */
		private function getPlusMinusVal(s:String,curVal:Number):Number
		{
			var op:String=s.substr(0,1);
			var val:Number=Number(s.substr(1,s.length));
			if(op=="+")return curVal+=val;
			else if(op=="-")return curVal-=val;
			return curVal;
		}
		
		/**
		 * Helper method for propsFromModel.
		 */
		private function isPlusMinus(s:String):Boolean
		{
			var r:RegExp=/^\+|\-[\.0-9]*$/i;
			return r.test(s);
		}
	}
}