package net.guttershark.util 
{
	import flash.text.StyleSheet;		

	/**
	 * The StyleSheetUtils class contains utility methods for working
	 * with stylesheets.
	 */
	public class StyleSheetUtils
	{
		
		/**
		 * The singleton instance.
		 */
		private static var inst:StyleSheetUtils;
		
		/**
		 * @private
		 */
		public function StyleSheetUtils()
		{
			Singleton.assertSingle(StyleSheetUtils);
		}

		/**
		 * Singleton access.
		 */
		public static function gi():StyleSheetUtils
		{
			if(!inst)inst=Singleton.gi(StyleSheetUtils);
			return inst;
		}
		
		/**
		 * Merge any number of stylesheets into one new
		 * style sheet. If the same style is declared in
		 * more than one stylesheet, they will be overwritten
		 * with the last stylsheet object, that declares it.
		 * 
		 * @example Calling mergeStyleSheets:
		 * <listing>	
		 * var myStyleSheet1=new StyleSheet();
		 * //.. add some styles to style 1
		 * var myStyleSheet2=new StyleSheet();
		 * //.. add some styles to style 2
		 * 
		 * var newStyle:StyleSheet;
		 * //merge
		 * newStyle = utils.styles.mergeStyleSheets(myStyleSheet1,myStyleSheet2);
		 * 
		 * //or you can call with an array.
		 * var a:Array=[myStyleSheet1,myStyleSheet2];
		 * newStyle = utils.styles.mergeStyleSheets(a);
		 * </listing>
		 */
		public function mergeStyleSheets(...sheets:Array):StyleSheet
		{
			if(sheets[0] is Array)sheets=sheets[0];
			var newstyles:StyleSheet=new StyleSheet();
			var i:int=0;
			var l:int=sheets.length;
			var k:int;
			var j:int;
			var sn:String;
			for(i;i<l;i++)
			{
				var s:StyleSheet=StyleSheet(sheets[i]); 
				var nm:Array=s.styleNames;
				k=0;
				j=nm.length;
				for(k;k<j;k++)
				{
					sn=nm[k];
					newstyles.setStyle(sn,s.getStyle(sn));
				}
			}
			return newstyles;
		}	}}