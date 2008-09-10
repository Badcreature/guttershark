package net.guttershark.util 
{

	/**
	 * The StringUtils class contains utility methods for strings.
	 */
	public class StringUtils 
	{

		public static const LTRIM_EXP:RegExp = /(\s|\n|\r|\t|\v)*$/;

		public static const RTRIM_EXP:RegExp = /^(\s|\n|\r|\t|\v)*/m;

		/**
		 * Returns everything after the first occurrence of the provided character in the string.
		 *
		 * @param p_string The string.
		 * @param p_begin The character or sub-string.
		 * 
		 * @return String
		 */
		public static function afterFirst(p_string:String, p_char:String):String 
		{
			if(p_string == null) return '';
			var idx:int = p_string.indexOf(p_char);
			if(idx == -1) return '';
			idx += p_char.length;
			return p_string.substr(idx);
		}

		/**
		 * Returns everything after the last occurence of the provided character in p_string.
		 *
		 * @param p_string The string.
		 * @param p_char The character or sub-string.
		 * 
		 * @return String
		 */
		public static function afterLast(p_string:String, p_char:String):String 
		{
			if(p_string == null) return ''; 
			var idx:int = p_string.lastIndexOf(p_char);
			if(idx == -1) return '';
			idx += p_char.length;
			return p_string.substr(idx);
		}

		/**
		 * Returns everything before the first occurrence of the provided character in the string.
		 *
		 * @param p_string The string.
		 * @param p_begin The character or sub-string.
		 * 
		 * @return String
		 */
		public static function beforeFirst(p_string:String, p_char:String):String 
		{
			if(p_string == null) return '';
			var idx:int = p_string.indexOf(p_char);
			if(idx == -1) return '';
			return p_string.substr(0,idx);
		}

		/**
		 * Returns everything before the last occurrence of the provided character in the string.
		 *
		 * @param p_string The string.
		 * @param p_begin The character or sub-string.
		 * 
		 * @return String
		 */
		public static function beforeLast(p_string:String, p_char:String):String 
		{
			if(p_string == null) return '';
			var idx:int = p_string.lastIndexOf(p_char);
			if(idx == -1) return '';
			return p_string.substr(0,idx);
		}

		/**
		 * Returns everything after the first occurance of p_start and before the first occurrence of p_end in p_string.
		 *
		 * @param p_string The string.
		 * @param p_start The character or sub-string to use as the start index.
		 * @param p_end The character or sub-string to use as the end index.
		 *	
		 * @return String
		 */
		public static function between(p_string:String, p_start:String, p_end:String):String 
		{
			var str:String = '';
			if(p_string == null) return str;
			var startIdx:int = p_string.indexOf(p_start);
			if(startIdx != -1) 
			{
				startIdx += p_start.length; 
				// RM: should we support multiple chars? (or ++startIdx);
				var endIdx:int = p_string.indexOf(p_end,startIdx);
				if(endIdx != -1) str = p_string.substr(startIdx,endIdx - startIdx); 
			}
			return str;
		}

		/**
		 * Capitallizes the first word in a string or all words..
		 *
		 * @param p_string The string.
		 * @param p_all (optional) Boolean value indicating if we should capitalize all words or only the first.
		 * 
		 * @return String
		 */
		public static function capitalize(p_string:String, ...args):String 
		{
			var str:String = trimLeft(p_string);
			//trace('capl',args[0]);
			if(args[0] === true) return str.replace(/^.|\b./g,_upperCase);
			else  return str.replace(/(^\w)/,_upperCase);
		}

		/**
		 * Utility method that intelligently breaks up your string,
		 * allowing you to create blocks of readable text.
		 * This method returns you the closest possible match to the p_delim paramater,
		 * while keeping the text length within the p_len paramter.
		 * If a match can't be found in your specified length an  '...' is added to that block,
		 * and the blocking continues untill all the text is broken apart.
		 *
		 * @param p_string The string to break up.
		 * @param p_len Maximum length of each block of text.
		 * @param p_delim delimter to end text blocks on, default = '.'
		 * 
		 * @return Array
		 */
		public static function block(p_string:String, p_len:uint, p_delim:String = "."):Array 
		{
			var arr:Array = new Array();
			if(p_string == null || !contains(p_string,p_delim)) return arr;
			var chrIndex:uint = 0;
			var strLen:uint = p_string.length;
			var replPatt:RegExp = new RegExp("[^" + escapePattern(p_delim) + "]+$");
			while (chrIndex < strLen)
			{
				var subString:String = p_string.substr(chrIndex,p_len);
				if (!contains(subString,p_delim))
				{
					arr.push(truncate(subString,subString.length));
					chrIndex += subString.length;
				}
				subString = subString.replace(replPatt,'');
				arr.push(subString);
				chrIndex += subString.length;
			}
			return arr;
		}

		/**
		 * Determines whether the specified string contains any instances of p_char.
		 *
		 * @param p_string The string.
		 * @param p_char The character or sub-string we are looking for.
		 *
		 * @return Boolean
		 */
		public static function contains(p_string:String, p_char:String):Boolean 
		{
			if(p_string == null) return false;
			return p_string.indexOf(p_char) != -1;
		}

		/**
		 * Removes whitespace from the front (left-side) of the specified string.
		 *
		 * @param p_string The String whose beginning whitespace will be removed.
		 *
		 * @return String
		 */
		public static function trimLeft(p_string:String):String 
		{
			if(p_string == null) return '';
			return p_string.replace(/^\s+/,'');
		}

		/**
		 * Removes whitespace from the end (right-side) of the specified string.
		 * 
		 * @param p_string The String whose ending whitespace will be removed.
		 * 
		 * @return String
		 */
		public static function trimRight(p_string:String):String 
		{
			if(p_string == null) return '';
			return p_string.replace(/\s+$/,'');
		}

		/**
		 * Determines the number of times a charactor or sub-string appears within the string.
		 *
		 * @param p_string The string.
		 * @param p_char The character or sub-string to count.
		 * @param p_caseSensitive (optional, default is true) A boolean flag to indicate if the search is case sensitive.
		 *	
		 * @return uint
		 */
		public static function countOf(p_string:String, p_char:String, p_caseSensitive:Boolean = true):uint 
		{
			if(p_string == null) return 0;
			var char:String = escapePattern(p_char);
			var flags:String = (!p_caseSensitive) ? 'ig' : 'g';
			return p_string.match(new RegExp(char,flags)).length;
		}

		/**
		 * Pads p_string with specified character to a specified length from the left.
		 *
		 * @param p_string String to pad
		 * @param p_padChar Character for pad.
		 * @param p_length Length to pad to.
		 * 
		 * @return String
		 */
		public static function padLeft(p_string:String, p_padChar:String, p_length:uint):String 
		{
			var s:String = p_string;
			while(s.length<p_length) s = p_padChar + s;
			return s;
		}

		/**
		 * Pads p_string with specified character to a specified length from the right.
		 *
		 * @param p_string String to pad
		 * @param p_padChar Character for pad.
		 * @param p_length Length to pad to.
		 * 
		 * @return String
		 */
		public static function padRight(p_string:String, p_padChar:String, p_length:uint):String 
		{
			var s:String = p_string;
			while (s.length < p_length) 
			{ 
				s += p_padChar; 
			}
			return s;
		}

		/**
		 * Properly cases the string in "sentence format".
		 *
		 * @param p_string The string to check
		 *
		 * @return String
		 */
		public static function properCase(p_string:String):String 
		{
			if(p_string == null) return '';
			var str:String = p_string.toLowerCase().replace(/\b([^.?;!]+)/,capitalize);
			return str.replace(/\b[i]\b/,"I");
		}

		/**
		 * Removes all instances of the remove string in the input string.
		 *
		 * @param p_string The string that will be checked for instances of remove string
		 * @param p_remove The string that will be removed from the input string.
		 * @param p_caseSensitive An optional boolean indicating if the replace is case sensitive. Default is true.
		 *
		 * @return String
		 */
		public static function remove(p_string:String, p_remove:String, p_caseSensitive:Boolean = true):String 
		{
			if(p_string == null) return '';
			var rem:String = escapePattern(p_remove);
			var flags:String = (!p_caseSensitive) ? 'ig' : 'g';
			return p_string.replace(new RegExp(rem,flags),'');
		}

		/**
		 * Returns the specified string in reverse character order.
		 *
		 * @param p_string The String that will be reversed.
		 *
		 * @return String
		 */
		public static function reverse(p_string:String):String 
		{
			if(p_string == null) return '';
			return p_string.split('').reverse().join('');
		}

		/**
		 * Returns the specified string in reverse word order.
		 *
		 * @param p_string The String that will be reversed.
		 *
		 * @return String
		 */
		public static function reverseWords(p_string:String):String 
		{
			if(p_string == null) return '';
			return p_string.split(/\s+/).reverse().join('');
		}

		/**
		 * Determines the percentage of similiarity, based on editDistance
		 *
		 * @param p_source The source string.
		 * @param p_target The target string.
		 *
		 * @return Number
		 */
		public static function similarity(p_source:String, p_target:String):Number 
		{
			var ed:uint = editDistance(p_source,p_target);
			var maxLen:uint = Math.max(p_source.length,p_target.length);
			if(maxLen == 0) return 100;
			return (1 - ed / maxLen) * 100;
		}

		/**
		 * Levenshtein distance (editDistance) is a measure of the similarity between two strings,
		 * The distance is the number of deletions, insertions, or substitutions required to
		 * transform p_source into p_target.
		 *
		 * @param p_source The source string.
		 * @param p_target The target string.
		 * 
		 * @return uint
		 */
		public static function editDistance(p_source:String, p_target:String):uint 
		{
			var i:Number;
			var j:Number;
			if(p_source == null) p_source = '';
			if(p_target == null) p_target = '';
			if(p_source == p_target) return 0;
			var d:Array = new Array();
			var cost:uint;
			var n:uint = p_source.length;
			var m:uint = p_target.length;
			if(n == 0) return m;
			if(m == 0) return n;
			for(i = 0;i <= n; i++) d[i] = new Array();
			for(i = 0;i <= n; i++) d[i][0] = i;
			for(j = 0;j <= m; j++) d[0][j] = j;
			for (i = 1;i <= n; i++)
			{
				var s_i:String = p_source.charAt(i-1);
				for(j = 1;j <= m; j++) 
				{
					var t_j:String = p_target.charAt(j-1);
					if(s_i == t_j) cost = 0; 
					else cost = 1;
					d[i][j] = _minimum(d[i - 1][j] + 1,d[i][j - 1] + 1,d[i - 1][j - 1] + cost);
				}
			}
			return d[n][m];
		}

		/**
		 * Swaps the casing of a string.
		 *
		 * @param p_string The source string.
		 * 
		 * @return String
		 */
		public static function swapCase(p_string:String):String 
		{
			if(p_string == null) return '';
			return p_string.replace(/(\w)/,_swapCase);
		}

		/**
		 * Remove's all &lt; and &gt; based tags from a string
		 *
		 * @param p_string The source string.
		 *
		 * @return String
		 */
		public static function stripTags(p_string:String):String 
		{
			if(p_string == null) return '';
			return p_string.replace(/<\/?[^>]+>/igm,'');
		}

		/**
		 * Determines the number of words in a string.
		 *
		 * @param p_string The string.
		 *
		 * @return uint
		 */
		public static function wordCount(p_string:String):uint 
		{
			if(p_string == null) return 0;
			return p_string.match(/\b\w+\b/g).length;
		}

		/**
		 * Returns a string truncated to a specified length with optional suffix
		 *
		 * @param p_string The string.
		 * @param p_len The length the string should be shortend to.
		 * @param p_suffix (optional, default=...) The string to append to the end of the truncated string.
		 *
		 * @return String
		 */
		public static function truncate(p_string:String, p_len:uint, p_suffix:String = "..."):String 
		{
			if(p_string == null) return '';
			if(!p_len) p_len = p_string.length;
			p_len -= p_suffix.length;
			var trunc:String = p_string;
			if(trunc.length > p_len) 
			{
				trunc = trunc.substr(0,p_len);
				if(/[^\s]/.test(p_string.charAt(p_len))) trunc = trimRight(trunc.replace(/\w+$|\s+$/,''));
				trunc += p_suffix;
			}
			return trunc;
		}

		/**
		 * Search for key in string.
		 * 
		 * @param	str	The target string.
		 * @param	key	The key to search for.
		 * @param	caseSensitive	Case sensitive search.
		 */
		public static function search(str:String,key:String,caseSensitive:Boolean = true):Boolean
		{
			if(!caseSensitive)
			{
				str = str.toUpperCase();
				key = key.toUpperCase();
			}
			return (str.indexOf(key) <= -1) ? false : true;
		}

		/**
		 * Does a case insensitive compare or two strings and returns true if they are equal.
		 */			
		public static function equals(s1:String, s2:String, caseSensitive:Boolean = false):Boolean
		{
			return (caseSensitive) ? (s1 == s2) : (s1.toUpperCase() == s2.toUpperCase());
		}

		/**
		 * Replace every instance of a string with something else
		 */
		public static function replace(str:String, oldChar:String, newChar:String):String
		{
			return str.split(oldChar).join(newChar);
		}		

		/**
		 * Remove spaces from string.
		 * 
		 * @param str	The target string.
		 * 
		 * @return String
		 */
		public static function removeSpaces(str:String):String
		{
			return replace(str," ","");
		}

		/**
		 * Remove tabs from string.
		 * 
		 * @param	str	The target string.
		 */
		public static function removeTabs(str:String):String
		{
			return replace(str,"	","");	
		}

		/**
		 * Remove leading & trailing white space.
		 * 
		 * @param	str	The target string.
		 */
		public static function trim(str:String):String
		{
			return ltrim(rtrim(str));
		}

		/**
		 * Removes whitespace from the front of the specified string.
		 * 
		 * @param	str	The target string.
		 */	
		public static function ltrim(str:String):String
		{
			return str.replace(LTRIM_EXP,"");
		}

		/**
		 * Removes whitespace from the end of a string.
		 * 
		 * @param	str	The target string.
		 */
		public static function rtrim(str:String):String
		{
			return str.replace(RTRIM_EXP,"");
		}

		/**
		 * Remove whitespace, line feeds, carrige returns from string
		 * 
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
		 * 
		 * @param	str	The target string.
		 */
		public static function toLowerCamel(str:String):String
		{
			var o:String = new String();
			for(var i:int = 0;i < str.length;i++)
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
		 * 
		 * //TODO : change to regex
		 * 
		 * @param input The string that the prefix will be checked against.
		 * @param prefix The prefix that will be tested against the string.
		 * 
		 * @return true if the string starts with the prefix, false if it does not.
		 */
		public static function beginsWith(input:String, prefix:String):Boolean
		{			
			return (prefix == input.substring(0,prefix.length));
		}

		/**
		 * Determines whether the specified string ends with the specified suffix.
		 * 
		 * //TODO : change to regex
		 * 
		 * @param input The string that the suffic will be checked against.
		 * @param prefix The suffic that will be tested against the string.
		 * 
		 * @return True if the string ends with the suffix, false if it does not 
		 */
		public static function endsWith(input:String, suffix:String):Boolean
		{
			return (suffix == input.substring(input.length - suffix.length));
		}			

		/**
		 * Format a number with commas - ie. 10000 -> 10,000
		 * 
		 * @param inNum (Object) String or Number
		 */
		public static function commaFormatNumber(inNum:Object):String
		{
			var tmp:String = String(inNum);
			var outString:String = "";
			var l:Number = tmp.length;
			for(var i:int = 0;i < l;i++)
			{
				if(i % 3 == 0 && i > 0) outString = "," + outString;
				outString = tmp.substr(l - (i + 1),1) + outString;
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
			return lstr.replace(/\b([a-z])/g,function($0:*):*
			{
				return $0.toUpperCase();
			});
		}

		/**
		 * Encode HTML.
		 * 
		 * @param	s	The target string that has HTML in it.
		 */
		public static function htmlEncode(s:String):String
		{
			s = replace(s," ","&nbsp;");
			s = replace(s,"&","&amp;");
			s = replace(s,"<","&lt;");
			s = replace(s,">","&gt;");
			s = replace(s,"™",'&trade;');
			s = replace(s,"®",'&reg;');
			s = replace(s,"©",'&copy;');
			s = replace(s,"€","&euro;");
			s = replace(s,"£","&pound;");
			s = replace(s,"—","&mdash;");
			s = replace(s,"–","&ndash;");
			s = replace(s,"…","&hellip;");
			s = replace(s,"†","&dagger;");
			s = replace(s,"·","&middot;");
			s = replace(s,"µ","&micro;");
			s = replace(s,"«","&laquo;");	
			s = replace(s,"»","&raquo;");
			s = replace(s,"•","&bull;");
			s = replace(s,"°","&deg;");	
			s = replace(s,'"',"&quot;");			
			return s;
		}

		/**
		 * Decode HTML.
		 * 
		 * @param	s	The target string that has HTML in it.
		 */
		public static function htmlDecode(s:String):String
		{
			s = replace(s,"&nbsp;"," ");
			s = replace(s,"&amp;","&");
			s = replace(s,"&lt;","<");
			s = replace(s,"&gt;",">");
			s = replace(s,"&trade;",'™');
			s = replace(s,"&reg;","®");
			s = replace(s,"&copy;","©");
			s = replace(s,"&euro;","€");
			s = replace(s,"&pound;","£");
			s = replace(s,"&mdash;","—");
			s = replace(s,"&ndash;","–");
			s = replace(s,"&hellip;",'…');
			s = replace(s,"&dagger;","†");
			s = replace(s,"&middot;",'·');
			s = replace(s,"&micro;","µ");
			s = replace(s,"&laquo;","«");	
			s = replace(s,"&raquo;","»");
			s = replace(s,"&bull;","•");
			s = replace(s,"&deg;","°");
			s = replace(s,"&ldquo",'"');
			s = replace(s,"&rsquo;","'");
			s = replace(s,"&rdquo;",'"');
			s = replace(s,"&quot;",'"');
			return s;
		}		

		/**
		 * Sanitize <code>null</code> strings for display purposes.
		 */
		public static function sanitizeNull(str:String):String
		{
			return (str == null || str == "null") ? "" : str;
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
			return (n > 1 || n < 0) ? String(n) : ("0." + String(n).split(".")[1]);
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
			return (n < 1 && (s.indexOf(".") <= -1 || s.indexOf("e") <= -1)) ? "0." + String(n + 1).split(".")[1] : s;
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
			for(var i:int = 0;i < amount;i++) str += String.fromCharCode(Math.round(Math.random() * (126 - 33)) + 33);
			return str;
		}

		/**
		 * Generate a set of random LowerCase characters.
		 */	
		public static function randLowerChar(amount:Number):String
		{
			var str:String = "";
			for(var i:int = 0;i < amount;i++) str += String.fromCharCode(Math.round(Math.random() * (122 - 97)) + 97);
			return str;
		}

		/**
		 * Generate a set of random Number characters.
		 */		
		public static function randNum(amount:Number):String
		{
			var str:String = "";
			for(var i:int = 0;i < amount;i++) str += String.fromCharCode(Math.round(Math.random() * (57 - 48)) + 48);
			return str;
		}

		/**
		 * Generate a set of random Special and Number characters.
		 */		
		public static function randSpecialChar(amount:Number):String
		{
			var str:String = "";
			for(var i:int = 0;i < amount;i++) str += String.fromCharCode(Math.round(Math.random() * (64 - 33)) + 33);
			return str;
		}

		/**
		 * Detect HTML line breaks.
		 * @param	str	The target string.
		 */
		public static function detectBr(str:String):Boolean
		{
			return (str.split("<br").length > 1) ? true : false;
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
			for(var i:int = 0;i < len;i++)
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
		}

		/* **************************************************************** */
		/*	These are helper methods used by some of the above methods.		*/
		/* **************************************************************** */
		private static function escapePattern(p_pattern:String):String 
		{
			// RM: might expose this one, I've used it a few times already.
			return p_pattern.replace(/(\]|\[|\{|\}|\(|\)|\*|\+|\?|\.|\\)/g,'\\$1');
		}
		
		private static function _minimum(a:uint, b:uint, c:uint):uint 
		{
			return Math.min(a,Math.min(b,Math.min(c,a)));
		}

		private static function _quote(p_string:String, ...args):String
		{
			switch (p_string) 
			{
				case "\\":
					return "\\\\";
				case "\r":
					return "\\r";
				case "\n":
					return "\\n";
				case '"':
					return '\\"';
				default:
					return '';
			}
		}

		private static function _upperCase(p_char:String, ...args):String 
		{
			//trace('cap latter ',p_char);
			return p_char.toUpperCase();
		}

		private static function _swapCase(p_char:String, ...args):String 
		{
			var lowChar:String = p_char.toLowerCase();
			var upChar:String = p_char.toUpperCase();
			switch (p_char) 
			{
				case lowChar:
					return upChar;
				case upChar:
					return lowChar;
				default:
					return p_char;
			}
		}	}}