if(typeof net == "undefined") var net = {};
if(typeof net.guttershark == "undefined") net.guttershark = {};

/**
 * The Paths class is used for all Path definitions in guttershark.
 */
net.guttershark.Paths=new function()
{
	var _paths={};
	this.addPath=function(pathId,path)
	{
		if(!pathId)
		{
			alert("Parameter pathId required.");
			return;
		}
		if(!path)
		{
			alert("Parameter path required.");
			return;
		}
		_paths[pathId]=path;
	}
	this.getPath=function(pathIds)
	{
		if(!pathIds)
		{
			alert("Parameter pathIds required.");
			return;
		}
		var fp = "";
		for(var i = 0; i < pathIds.length; i++)
		{
			if(!_paths[pathIds[i]])
			{
				alert("Path for id {"+pathIds[i]+"} not defined.")
				return;
			}
			fp += _paths[pathIds[i]];
		}
		return fp;
	}
	this.isPathDefined=function(path)
	{
		return !(_paths[path]===false);
	}
}

/**
 * Class for Cookies.
 */
net.guttershark.Cookies=new function()
{
	this.writeSessionCookie=function(cookieName,cookieValue)
	{
		if(testSessionCookie())
		{
	    document.cookie=escape(cookieName)+"="+escape(cookieValue)+"; path=/";
	    return true;
	  }
	  else return false;
	}
	this.getCookieValue=function(cookieName)
	{
	  var exp = new RegExp(escape(cookieName)+"=([^;]+)");
	  if(exp.test(document.cookie + ";"))
		{
			exp.exec(document.cookie + ";");
	    return unescape(RegExp.$1);
	  }
	  else return false;
	}
	this.testSessionCookie=function()
	{
		document.cookie="testSessionCookie=Enabled";
		if(getCookieValue("testSessionCookie")=="Enabled") return true;
	  else return false;
	}
	this.testPersistentCookie=function()
	{
		writePersistentCookie("testPersistentCookie","Enabled","minutes",1);
	  if(getCookieValue("testPersistentCookie")=="Enabled") return true;
		else return false;
	}
	this.writePersistentCookie=function(CookieName,CookieValue,periodType,offset)
	{
		var expireDate=new Date();
		offset=offset/1;
		var myPeriodType = periodType;
	  switch(myPeriodType.toLowerCase())
		{
			case "years": 
				var year = expireDate.getYear();
	     	// Note some browsers give only the years since 1900, and some since 0.
	     	if (year < 1000) year = year + 1900;
	     	expireDate.setYear(year + offset);
	     	break;
	    case "months":
	      expireDate.setMonth(expireDate.getMonth() + offset);
	      break;
	    case "days":
	      expireDate.setDate(expireDate.getDate() + offset);
	      break;
	    case "hours":
	      expireDate.setHours(expireDate.getHours() + offset);
	      break;
	    case "minutes":
	      expireDate.setMinutes(expireDate.getMinutes() + offset);
	      break;
	    default:
	      alert("Invalid periodType parameter for writePersistentCookie()");
	      break;
	  } 
	  document.cookie = escape(CookieName)+"="+escape(CookieValue)+"; expires="+expireDate.toGMTString()+"; path=/";
	}
	this.deleteCookie=function(cookieName)
	{
		if(getCookieValue(cookieName)) writePersistentCookie(cookieName,"Pending delete","years",-1);
		return true;     
	}
}