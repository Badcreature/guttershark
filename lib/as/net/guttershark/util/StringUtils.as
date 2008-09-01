package net.guttershark.util 
{
	
	/**
	 * The StringUtils class contains utility methods for strings.
	 */
	public class StringUtils 
	{
		
		public static const LTRIM_EXP : RegExp = /(\s|\n|\r|\t|\v)*$/;
		public static const RTRIM_EXP : RegExp = /^(\s|\n|\r|\t|\v)*/m;

		/**
		 * Search for key in string.
		 * @param	str	The target string.
		 * @param	key	The key to search for.
		 * @param	caseSensitive	Case sensitive search.
		 */
		public static function search(str:String,key:String,caseSensitive:Boolean=true):Boolean
		{
			if(!caseSensitive)
			{
				str = str.toUpperCase();
				key = key.toUpperCase();
			}
			return (str.indexOf(key)<=-1)?false:true;
		}

		/**
		 * Does a case insensitive compare or two strings and returns true if they are equal.
		 */			
		public static function equals(s1:String, s2:String, caseSensitive:Boolean = false):Boolean
		{
			return (caseSensitive)?(s1==s2):(s1.toUpperCase()==s2.toUpperCase());
		}

		/**
		 * Replace every instance of a string with something else
		 */
		public static function replace(str:String, oldChar:String, newChar:String):String
		{
			return str.split(oldChar).join(newChar);
		}

		/**
		 * Removes all instances of the key from string.
		 */	
		public static function remove(str:String, key:String):String
		{
			return StringUtils.replace(str,key,"");
		}		

		/**
		 * Remove spaces from string.
		 * @param str	The target string.
		 * @return String
		 */
		public static function removeSpaces(str:String):String
		{
			return replace(str," ","");
		}

		/**
		 * Remove tabs from string.
		 * @param	str	The target string.
		 */
		public static function removeTabs(str:String):String
		{
			return replace(str,"	","");	
		}

		/**
		 * Remove leading & trailing white space.
		 * @param	str	The target string.
		 */
		public static function trim(str:String):String
		{
			return ltrim(rtrim(str));
		}

		/**
		 * Removes whitespace from the front of the specified string.
		 * @param	str	The target string.
		 */	
		public static function ltrim(str:String):String
		{
			return str.replace(LTRIM_EXP,"");
		}

		/**
		 * Removes whitespace from the end of a string.
		 */
		public static function rtrim(str:String):String
		{
			return str.replace( RTRIM_EXP,"");
		}

		/**
		 * Remove whitespace, line feeds, carrige returns from string
		 * @param	str	The target string.
		 */
		public static function trimall(str:String):String
		{
			var o:String = "";
			var tab:Number = 9;
			var linefeed:Number = 10;
			var carriage:Number = 13;
			var space:Number = 32;
			var i:int = 0;
			var char:int = str.charCodeAt(i);
			while(i > 0 && char != tab && char != linefeed && char != carriage && char != space)
			{
				o += char;
				i++;
				if(i > str.length) break;
				char = str.charCodeAt(i);
			}
			return o;
		}

		/**
		 * Create a new string in lower camel notation.
		 * @param	str	The target string.
		 */
		public static function toLowerCamel(str:String):String
		{
			var o:String = new String();
			for(var i:int = 0; i < str.length ;i++)
			{
				if(str.charAt(i) != " ")
				{
					if(justPassedSpace)
					{
						o += str.charAt(i).toUpperCase();
						justPassedSpace = false;
					}
					else
					{
						o += str.charAt(i).toLowerCase();
					}
				}
				else var justPassedSpace:Boolean = true;
			}
			return o;
		}

		/**
		 * Determines whether the specified string begins with the specified prefix.
		 * //TODO : change to regex
		 * @param input The string that the prefix will be checked against.
		 * @param prefix The prefix that will be tested against the string.
		 * @return True if the string starts with the prefix, false if it does not.
		 */
		public static function beginsWith(input:String, prefix:String):Boolean
		{			
			return (prefix == input.substring(0,prefix.length));
		}

		/**
		 * Determines whether the specified string ends with the specified suffix.
		 * //TODO : change to regex
		 * @param input The string that the suffic will be checked against.
		 * @param prefix The suffic that will be tested against the string.
		 * @return True if the string ends with the suffix, false if it does not 
		 */
		public static function endsWith(input:String, suffix:String):Boolean
		{
			return (suffix==input.substring(input.length-suffix.length));
		}			

		/**
		 * Format a number with commas - ie. 10000 -> 10,000
		 * @param inNum (Object) String or Number
		 */
		public static function commaFormatNumber(inNum:Object):String
		{
			var tmp:String = String(inNum);
			var outString:String = "";
			var l:Number = tmp.length;
			for(var i:int = 0; i < l;i++)
			{
				if(i % 3 == 0 && i > 0) outString = "," + outString;
				outString = tmp.substr(l-(i+1),1)+outString;
			}
			return outString;		
		}

		/**
		 * Capitalize the first character in the string.
		 */
		public static function firstToUpper(str:String):String
		{
			return str.charAt(0).toUpperCase() + str.substr(1);
		}	

		/**
		 * Transforms source String to per word capitalization.
		 */
		public static function toTitleCase(str:String):String
		{
			var lstr:String = str.toLowerCase();
			return lstr.replace( /\b([a-z])/g, function($0:*):*
			{
				return $0.toUpperCase();
			});
		}

		/**
		 * Encode HTML.
		 * @param	s	The target string that has HTML in it.
		 */
		public static function htmlEncode(s:String):String
		{
			s = replace( s, " ", "&nbsp;" );
			s = replace( s, "&", "&amp;" );
			s = replace( s, "<", "&lt;" );
			s = replace( s, ">", "&gt;" );
			s = replace( s, "™", '&trade;' );
			s = replace( s, "®", '&reg;' );
			s = replace( s, "©", '&copy;' );
			s = replace( s, "€", "&euro;" );
			s = replace( s, "£", "&pound;" );
			s = replace( s, "—", "&mdash;" );
			s = replace( s, "–", "&ndash;" );
			s = replace( s, "…", "&hellip;" );
			s = replace( s, "†", "&dagger;" );
			s = replace( s, "·", "&middot;" );
			s = replace( s, "µ", "&micro;" );
			s = replace( s, "«", "&laquo;" );	
			s = replace( s, "»", "&raquo;" );
			s = replace( s, "•", "&bull;" );
			s = replace( s, "°", "&deg;" );	
			s = replace( s, '"', "&quot;" );			
			return s;
		}

		/**
		 * Decode HTML.
		 * @param	s	The target string that has HTML in it.
		 */
		public static function htmlDecode(s:String):String
		{
			s = replace( s, "&nbsp;", " " );
			s = replace( s, "&amp;", "&" );
			s = replace( s, "&lt;", "<" );
			s = replace( s, "&gt;", ">" );
			s = replace( s, "&trade;", '™' );
			s = replace( s, "&reg;", "®" );
			s = replace( s, "&copy;", "©" );
			s = replace( s, "&euro;", "€" );
			s = replace( s, "&pound;", "£" );
			s = replace( s, "&mdash;", "—" );
			s = replace( s, "&ndash;", "–" );
			s = replace( s, "&hellip;", '…' );
			s = replace( s, "&dagger;", "†" );
			s = replace( s, "&middot;", '·' );
			s = replace( s, "&micro;", "µ" );
			s = replace( s, "&laquo;", "«" );	
			s = replace( s, "&raquo;", "»" );
			s = replace( s, "&bull;", "•" );
			s = replace( s, "&deg;", "°" );
			s = replace( s, "&ldquo", '"' );
			s = replace( s, "&rsquo;", "'" );
			s = replace( s, "&rdquo;", '"' );
			s = replace( s, "&quot;", '"' );
			return s;
		}		

		/**
		 * Sanitize <code>null</code> strings for display purposes.
		 */
		public static function sanitizeNull(str:String):String
		{
			return (str == null || str == "null")?"":str;
		}

		/**
		 * Strip the zero off floated numbers.
		 */	
		public static function stripZeroOnFloat(n:Number):String
		{
			var str:String = "";
			var a:Array = String(n).split(".");
			if(a.length > 1) str = (a[0] == "0") ? "." + a[1] : String(n);
			else str = String(n);
			return str;
		}

		/**
		 * Add zero in front of floated number.
		 */
		public static function padZeroOnFloat(n:Number):String
		{
			return (n>1||n<0)?String(n):("0."+String(n).split( "." )[1]);
		}

		/**
		 * Remove scientific notation from very small floats when casting to String.
		 * 
		 * @param	n	The target number.
		 * 
		 * @example
		 * <listing>	
		 * 	trace(String(0.0000001)); //returns 1e-7
		 * 	trace(floatToString(0.0000001)); //returns .00000001
		 * </listing>
		 */
		public static function floatToString(n:Number):String
		{
			var s:String = String(n);
			return (n<1&&(s.indexOf(".") <= -1 || s.indexOf( "e" ) <= -1)) ? "0." + String(n + 1).split(".")[1]:s;
		}

		/**
		 * Strip the zero off floated numbers and remove Scientific Notation.
		 * @param	n	The target number
		 */
		public static function stripZeroAndRepairFloat(n:Number):String
		{
			var str:String;
			var tmp:String;
			var isZeroFloat:Boolean;
			// +=1 to prevent scientific notation.
			if(n < 1)
			{
				tmp = String((n + 1));
				isZeroFloat = true;
			}
			else
			{
				tmp = String(n);
				isZeroFloat = false;	
			}
			// if we have a float strip the zero (or +=1) off!
			var a:Array = tmp.split(".");
			if(a.length > 1) str = (a[0] == "1" && isZeroFloat == true) ? "." + a[1] : tmp;				
			else str = tmp;
			return str;
		}

		/**
		 * Generate a set of random characters.
		 * @param	amount	The number of characters
		 */
		public static function randChar(amount:Number):String
		{
			var str:String = "";
			for(var i:int = 0;i < amount;i++) str += String.fromCharCode(Math.round(Math.random()*(126-33))+33);
			return str;
		}

		/**
		 * Generate a set of random LowerCase characters.
		 */	
		public static function randLowerChar(amount:Number):String
		{
			var str:String = "";
			for(var i:int = 0;i < amount;i++) str += String.fromCharCode(Math.round(Math.random()*(122-97))+97);
			return str;
		}

		/**
		 * Generate a set of random Number characters.
		 */		
		public static function randNum(amount:Number):String
		{
			var str:String = "";
			for(var i:int = 0;i < amount;i++) str += String.fromCharCode(Math.round(Math.random()*(57-48))+48);
			return str;
		}

		/**
		 * Generate a set of random Special and Number characters.
		 */		
		public static function randSpecialChar(amount:Number):String
		{
			var str:String = "";
			for(var i:int = 0;i < amount;i++) str += String.fromCharCode(Math.round(Math.random()*(64-33))+33);
			return str;
		}	

		/**
		 * Strip HTML markup tags.
		 * @param	str	The target string.
		 */
		public static function stripTags(str:String):String
		{
			var s:Array = new Array();
			var c:Array = new Array();
			for(var i:int = 0;i < str.length;i++)
			{
				if(str.charAt(i) == "<") s.push( i );
				else if (str.charAt( i ) == ">") c.push( i );
			}
			var o:String = str.substring(0,s[0]);
			for(var j:int = 0;j < c.length;j++) o += str.substring( c[j] + 1, s[j + 1] );
			return o;
		}

		/**
		 * Detect HTML line breaks.
		 * @param	str	The target string.
		 */
		public static function detectBr(str:String):Boolean
		{
			return (str.split("<br").length>1)?true:false;
		}

		/**
		 * Convert single quotes to double quotes.
		 * @param	str	The target string.
		 */
		public static function toDoubleQuote(str:String):String
		{
			var sq:String = "'";
			var dq:String = String.fromCharCode(34);
			return str.split(sq).join(dq);
		}

		/**
		 * Convert double quotes to single quotes.
		 * @param	str	The target string.
		 */
		public static function toSingleQuote(str:String):String
		{
			var sq:String = "'";
			var dq:String = String.fromCharCode(34);
			return str.split(dq).join(sq);
		}

		/**
		 * Remove all formatting and return cleaned numbers from string.
		 * 
		 * @param	str	The target string.
		 * 
		 * @example	
		 * <listing>	
		 * StringUtils.toNumeric("123-123-1234"); //returns 1221231234 
		 * </listing>
		 */
		public static function toNumeric(str:String):String
		{
			var len:Number = str.length;
			var result:String = "";
			for(var i:int=0;i<len;i++)
			{
				var code:Number = str.charCodeAt(i);
				if(code >= 48 && code <= 57) result += str.substr(i,1);
			}
			return result;
		}
		
		/**
		 * Find the file type from a source path.
		 */
		public static function FindFileType(source:String):String
		{
			var fileType:String;
			var filenameRegEx:RegExp = new RegExp("\.([a-zA-Z0-9]{1,4}$)","i");
			var filematch:Array = source.match(filenameRegEx);
			if(filematch) fileType = filematch[1].toLowerCase();
			if(!fileType) return null;
			else return fileType;
		}	}}