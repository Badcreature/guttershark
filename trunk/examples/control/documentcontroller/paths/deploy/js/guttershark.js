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