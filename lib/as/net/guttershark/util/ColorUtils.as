package net.guttershark.util{	import flash.display.BitmapData;	import flash.display.DisplayObject;	import flash.geom.ColorTransform;		import net.guttershark.util.MathUtils;			/**	 * The ColorUtils class contains utility methods for working with colors.	 * 	 * @see http://en.wikipedia.org/wiki/HSV_color_space	 */	final public class ColorUtils 	{		private static var inst:ColorUtils;		private var mu:MathUtils;		public const RGB_MAX:uint = 256;		public const HUE_MAX:uint = 360;		public const PCT_MAX:uint = 100;				/**		 * Singleton access.		 */		public static function gi():ColorUtils		{			if(!inst) inst = Singleton.gi(ColorUtils);			return inst;		}				/**		 * @private		 */		public function ColorUtils()		{			Singleton.assertSingle(ColorUtils);			mu = MathUtils.gi();		}		/**		 * Return the (A)RGB <i>hexadecimal</i> color value of a DisplayObject.		 * 		 * @param src The source display object.		 * @param x The x position to sample.		 * @param y The y position to sample.		 * @param getAlpha Whether or not to read ARGB, or RGB.		 */		public function getColor(src:DisplayObject, x:uint = 0, y:uint = 0, getAlpha:Boolean = false):uint 		{			var bmp:BitmapData = new BitmapData(src.width,src.height);			bmp.draw(src);			var color:uint = (!getAlpha) ? bmp.getPixel(int(x),int(y)) : bmp.getPixel32(int(x),int(y));			bmp.dispose();			return color;		}				/**		 * Set the (A)RGB <i>hexadecimal</i> color value of a DisplayObject using ColorTransform.		 * 		 * @param src The source display object.		 * @param hex The color.		 */		public function setColor(src:DisplayObject, hex:uint):void 		{			var ct:ColorTransform = src.transform.colorTransform;			ct.color = hex;			src.transform.colorTransform = ct;		}								/**		 * Inverts the color of the DisplayObject.		 * 		 * @param src The source display object.		 */		public function invertColor(src:DisplayObject):void 		{			var t:Object = getTransform(src);			setTransform(src,{ra :-t['ra'],ga:-t['ga'],ba:-t['ba'],rb:255-t['rb'],gb:255-t['gb'],bb:255-t['bb']});		}		/**		 * Reset the color of the DisplayObject to its original view (pre-ColorTransformed).		 */		public function resetColor(src:DisplayObject):void 		{ 			setTransform(src,{ra:100,ga:100,ba:100,rb:0,gb:0,bb:0});		}					/**		 * Returns the transform value set by the last setTransform() call.		 * 		 * @return An object with properties {ra,rb,ga,gb,ba,bb,aa,ab}.		 */		public function getTransform(src:DisplayObject):Object 		{			var ct:ColorTransform = src.transform.colorTransform;			return {ra:ct.redMultiplier* 100,rb:ct.redOffset,ga:ct.greenMultiplier*100,gb:ct.greenOffset,ba:ct.blueMultiplier*100,bb:ct.blueOffset,aa:ct.alphaMultiplier*100,ab:ct.alphaOffset};		}		/**		 * Set ColorTransform information for a DisplayObject.		 * 		 * <p>The colorTransformObject parameter is a generic object that you create from the new Object constructor. It has parameters specifying the percentage and 		 * offset values for the red, green, blue, and alpha (transparency) components of a color, entered in the format 0xRRGGBBAA.</p>		 * 		 * @param transformObject An object created with the new Object constructor. This instance of the Object class must have the following properties 		 * that specify color transform values: ra, rb, ga, gb, ba, bb, aa, ab. These properties are explained in the above summary for the setTransform() method. 		 */		public function setTransform(src:DisplayObject,transformObject:Object):void 		{			var t:Object = {ra:100,rb:0,ga:100,gb:0,ba:100,bb:0,aa:100,ab:0};			for(var p:String in transformObject) t[p] = transformObject[p];			var ct:ColorTransform = new ColorTransform(t['ra'] * 0.01,t['ga'] * 0.01,t['ba'] * 0.01,t['aa'] * 0.01,t['rb'],t['gb'],t['bb'],t['ab']);			src.transform.colorTransform = ct;		}				/**		 * Parse a String representation of a color (hex or html) to uint.		 */		public function toColor(str:String):uint 		{			if(str.substr(0,2) == '0x') str = str.substr(2); 			else if(str.substr(0,1)=='#') str = str.substr(1);			return parseInt(str,16);		}		/**		 * Convert a hexidecimal number to a string representation with ECMAScript notation: <code>0xrrggbb</code>.		 * 		 * @param hex The hex color value.		 */		public function toHexString(hex:uint):String 		{			return "0x" + (hex.toString(16)).toUpperCase(); 		}		/**		 * Convert a hexidecimal number to a string representation with HTML notation: <code>#rrggbb</code>.		 * 		 * @param hex The hex color value.		 */		public function toHTML(hex:uint):String 		{			return "#" + (hex.toString(16)).toUpperCase(); 		}		/**		 * Convert hue to RGB values using a linear transformation.		 * 		 * @param min The minimum value of r,g or b.		 * @param max The maximum value of r,g or b.		 * @param hue value angle hue.		 * 		 * @return Object with r,g,h properties on 0-1 scale.		 */ 		public function HueToRGB(min:Number,max:Number,hue:Number):Object 		{			var mu:Number, md:Number, F:Number, n:Number;			while(hue < 0)hue+=HUE_MAX;			n = Math.floor(hue / 60);			F = (hue - n * 60) / 60;			n %= 6;			mu = min + ((max - min) * F);			md = max - ((max - min) * F);			switch (n)			{				case 0: 					return {r: max,g: mu,b: min};				case 1: 					return {r: md,g: max,b: min};				case 2: 					return {r: min,g: max,b: mu};				case 3: 					return {r: min,g: md,b: max};				case 4: 					return {r: mu,g: min,b: max};				case 5: 					return {r: max,g: min,b: md};			}			return null;		}		/**		 * Convert RGB values to a hue using a linear transformation.		 * 		 * @param red The value on 0 to 1 scale.		 * @param green The value on 0 to 1 scale.		 * @param blue The value on 0 to 1 scale.		 * @return The hue degree between 0 and 360.		 */ 		public function RGBToHue(red:Number,green:Number,blue:Number):uint 		{			var f:Number, min:Number, mid:Number, max:Number, n:Number;			max = Math.max(red,Math.max(green,blue));			min = Math.min(red,Math.min(green,blue));			// achromatic case			if(max-min==0) return 0;			mid = mu.center(red,green,blue);			// using this loop to avoid super-ugly nested ifs			while(true) 			{				if(red == max) 				{					if(blue == min) n = 0;					else n = 5;					break;				}				if(green == max) 				{					if(blue == min) n = 1;					else n = 2;					break;				}				if(red == min) n = 3;				else n = 4;				break;			}			if ((n % 2) == 0) f = mid - min;			else f = max - mid;			f = f / (max - min);			return 60 * (n + f);		}						/**		 * Convert an RGB Hexidecimal value to HSL values.		 * 		 * <ul>		 * <li><code>h</code> on 0 - 360 scale.</li>		 * <li><code>l</code> on 0 - 1 scale.</li>		 * <li><code>s</code> on 0 - 1 scale.</li>		 * </ul>		 * 		 * @param red 0 - 1 scale.		 * @param green 0 - 1 scale.		 * @param blue 0 - 1 scale.		 * 		 * @return Object with h (hue), l (lightness), s (saturation) values.		 */		public function RGBtoHSL(red:Number, green:Number, blue:Number):Object 		{			var min:Number, max:Number, delta:Number, l:Number, s:Number, h:Number = 0;				max = Math.max(red,Math.max(green,blue));			min = Math.min(red,Math.min(green,blue));			//l = (min + max) / 2;			l = (min + max) * 0.5;					// L			if(l == 0) return {h:h,l:0,s:1};			//delta = (max - min) / 2;			delta = (max - min) * 0.5;			if (l < 0.5) s = delta / l;			else s = delta / (1 - l);			// H			h = RGBToHue(red,green,blue);			return {h:h,l:l,s:s};									}		/**		 * Convert HSL values to RGB values.		 * 		 * @param hue The hue value on a 0-360 scale.		 * @param luminance 0 to 1.		 * @param saturation 0 to 1.		 * @return Object with r,g,b values on 0 to 1 scale.		 */ 		public function HSLtoRGB(hue:Number, luminance:Number, saturation:Number):Object 		{			var delta:Number;			if(luminance < 0.5) delta = saturation * luminance;			else delta = saturation * (1 - luminance);			return HueToRGB(luminance - delta,luminance + delta,hue);		}				/**		 * Convert RGB values to HSV values.		 * 		 * <ul>		 * <li>h - on 0 to 360 scale</li>		 * <li>s - on 0 to 1 scale</li>		 * <li>v - on 0 to 1 scale</li>		 * </ul>		 * 		 * @param red 0 to 1 scale.		 * @param green 0 to 1 scale.		 * @param blue 0 to 1 scale.		 * @return Object with H,S,V values.		 */ 		public function RGBtoHSV(red:Number, green:Number, blue:Number):Object 		{			var min:Number, max:Number, s:Number, v:Number, h:Number = 0;			max = Math.max(red,Math.max(green,blue));			min = Math.min(red,Math.min(green,blue));			if(max == 0) return {h:0,s:0,v:0};			v = max;			s = (max - min) / max;			h = RGBToHue(red,green,blue);			return {h:h,s:s,v:v};		}		/**		 * Convert HSV values to RGB values.		 * @param hue The hue value on a 0-360 scale.		 * @param saturation on 0 to 1 scale.		 * @param value on 0 to 1 scale.		 * @return Object with r,g,b values on 0 to 1 scale.		 */ 		public function HSVtoRGB(hue:Number, saturation:Number, value:Number):Object 		{			var min:Number = (1 - saturation) * value;			return HueToRGB(min,value,hue);		}		/**		 * Convert HSV to HLS using RGB conversions: color preservation may be dubious.		 * 		 * @param hue The hue value on a 0-360 scale.		 * @param saturation The saturation value on a 0-1 scale.		 * @param value The value on a 0-1 scale.		 * @return Object with h,s,l values on a 0-1 scale.		 */		public function HSVtoHSL(hue:Number, saturation:Number, value:Number):Object 		{			var rgbVal:Object = HSVtoRGB(hue,saturation,value);			return RGBtoHSL(rgbVal.r,rgbVal.g,rgbVal.b);		}		/**		 * Convert HSL to HSV using RGB conversions: color preservation may be dubious.		 * 		 * @param hue The hue value.		 * @param luminance The luminance value.		 * @param saturation The saturation value.		 * @return An object with h,s,v values.		 */		public function HSLtoHSV(hue:Number, luminance:Number, saturation:Number):Object 		{			var rgbVal:Object = HSLtoRGB(hue,luminance,saturation);			return RGBtoHSV(rgbVal.r,rgbVal.g,rgbVal.b);		}						/**		 * Set the color of a DisplayObject from RGB components.		 * 		 * @param r The red value.		 * @param g The green value.		 * @param b The blue value.		 */		public function setRGBComponent(src:DisplayObject, r:Number, g:Number, b:Number):void 		{			r = mu.limit(r,0,RGB_MAX,false);			g = mu.limit(g,0,RGB_MAX,false);			b = mu.limit(b,0,RGB_MAX,false);			setColor(src,hexFromComponents(r,g,b));		}		/**		 * Get the RGB components from a DisplayObject.		 * 		 * @param src The source display object to sample color from.		 * @param x The x location to sample.		 * @param y The y location to sample.		 */		public function getRGBComponent(src:DisplayObject, x:uint = 0, y:uint = 0):Object 		{			var tmpVal:Object = componentsFromHex(getColor(src,x,y));			return {r:tmpVal.r,g:tmpVal.g,b:tmpVal.b};		}				/**		 * Set the color of a DisplayObject from HSL components.		 * 		 * @param src The source display object.		 * @param h The hue value.		 * @param l The luminance value.		 * @param s The saturation value.		 */		public function setHSLComponent(src:DisplayObject, h:Number, s:Number, l:Number):void 		{			h = mu.limit(h,0,HUE_MAX,true);			l = mu.limit(l,0,PCT_MAX,false) / PCT_MAX;			s = mu.limit(s,0,PCT_MAX,false) / PCT_MAX;			var rgbVal:Object = HSLtoRGB(h,l,s);			setColor(src,hexFromPercentages(rgbVal));		}		/**		 * Get the HSL components from a DisplayObject.		 * 		 * @param src 	to sample color from.		 * @param x 	location to sample.		 * @param y 	location to sample.		 * @return An object with h,s,l values.		 */		public function getHSLComponent(src:DisplayObject, x:uint = 0, y:uint = 0):Object 		{			var rgbVal:Object = componentsFromHex(getColor(src,x,y));			rgbVal.r /= 256;			rgbVal.g /= 256;			rgbVal.b /= 256;			var hslVal:Object = RGBtoHSL(rgbVal.r,rgbVal.g,rgbVal.b);			hslVal.h = Math.round(hslVal.h);			hslVal.l = Math.round(hslVal.l * PCT_MAX);			hslVal.s = Math.round(hslVal.s * PCT_MAX);			return hslVal;		}				/**		 * Set the color of a DisplayObject from HSV components.		 * 		 * @param h The hue value.		 * @param s The saturation value.		 * @param v The value.		 */		public function setHSVComponent(src:DisplayObject, h:Number, s:Number, v:Number):void 		{			h = mu.limit(h,0,HUE_MAX,true);			s = mu.limit(s,0,PCT_MAX,false) / PCT_MAX;			v = mu.limit(v,0,PCT_MAX,false) / PCT_MAX;			var rgbVal:Object = HSVtoRGB(h,s,v);			setColor(src,hexFromPercentages(rgbVal));		}		/**		 * Get the HSV components from a DisplayObject.		 * 		 * @param src 	to sample color from.		 * @param x 	location to sample.		 * @param y 	location to sample.		 * @param Object with h,s,v values.		 */		public function getHSVComponent(src:DisplayObject, x:uint = 0, y:uint = 0):Object 		{			var rgbVal:Object = componentsFromHex(getColor(src,x,y));			rgbVal.r /= 256;			rgbVal.g /= 256;			rgbVal.b /= 256;			var hsvVal:Object = RGBtoHSV(rgbVal.r,rgbVal.g,rgbVal.b);			hsvVal.h = Math.round(hsvVal.h);			hsvVal.s = Math.round(hsvVal.s * PCT_MAX);			hsvVal.v = Math.round(hsvVal.v * PCT_MAX);			return hsvVal;		}								/**		 * Convert an RGB hexidecimal value to an object containing its RGB components.		 * 		 * @param hex The hex value.		 * <span class="hide">		 *	TODO - refactor to getRGB or toRGBComponents		 * </span>		 */		public function componentsFromHex(hex:uint):Object 		{			var r:Number = hex >> 16 & 0xff;			var g:Number = hex >> 8 & 0xff;			var b:Number = hex & 0xff;			return {r:r,g:g,b:b};		}			/**		 * Convert an RGB Object to a hexidecimal color value.		 */		public function hexFromPercentages(rgbObj:Object):uint 		{			return hexFromComponents(rgbObj.r * RGB_MAX,rgbObj.g * RGB_MAX,rgbObj.b * RGB_MAX);		}		/**		 * Convert individual RGB values to a hexidecimal value.		 * 		 * @param r The red value.		 * @param g The green value.		 * @param b The blue value.		 */		public function hexFromComponents(r:uint, g:uint, b:uint):uint 		{			var hex:uint = 0;			hex += (r << 16);			hex += (g << 8);			hex += (b);			return hex;	 		}				/**		 * Change the contrast of a hexidecimal Number by a certain increment.		 * 		 * @param hex The color value to shift contrast on.		 * @param inc The increment value to shift.		 */		public function changeContrast(hex:Number, inc:Number):Number 		{			var o:Object = componentsFromHex(hex);			o.r = mu.clamp(o.r + inc,0,255);			o.g = mu.clamp(o.g + inc,0,255);			o.b = mu.clamp(o.b + inc,0,255);			return hexFromComponents(o.r,o.g,o.b);		}				/**		 * Get the ARGB values.		 * 		 * @param rgb The rgb value.		 * @return An object with a,r,g,b values.		 */		public function getARGB(rgb:uint):Object 		{			var a:Number = rgb >> 24 & 0xff;			var r:Number = rgb >> 16 & 0xff;			var g:Number = rgb >> 8 & 0xff;			var b:Number = rgb & 0xff;			return {a:a,r:r,g:g,b:b};		}		/**		 * Set the a,r,g,b values in a new unsigned int.		 * 		 * @param a The alpha value.		 * @param r The red value.		 * @param g The green value.		 * @param b The blue value.		 */		public function setARGB(a:Number,r:Number,g:Number,b:Number):uint 		{			var argb:uint = 0;			argb += (a << 24);			argb += (r << 16);			argb += (g << 8);			argb += (b);			return argb;		}		/**		 * Convert an ARGB color value to grayscale.		 * 		 * @param hex The hex color value.		 */		public function toGrayscale(hex:uint):uint 		{			var color:Object = getARGB(hex);			var c:Number = 0;			c += color.r * .3;			c += color.g * .59;			c += color.b * .11;			color.r = color.g = color.b = c;			return setARGB(color.a,color.r,color.g,color.b);		}				/**		 * Returns a random hexidecimal color.		 */		public function randHexColor():uint		{			return Number("0x"+Math.floor(Math.random()*16777215).toString(16).toUpperCase());		}	}}