if(typeof net == "undefined") var net = {};
if(typeof net.guttershark == "undefined") net.guttershark = {};
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
	this.getPath=function(pathId)
	{
		if(!_paths[pathId])
		{
			alert("Path not set for {"+pathId+"}")
			return;
		}
		return _paths[pathId];
	}
	this.getFullPath=function(firstPathId,secondPathId)
	{
		if(!firstPathId)
		{
			alert("Parameter firstPathId required");
			return;
		}
		if(!secondPathId)
		{
			alert("Parameter secondPathId required");
			return;
		}
		if(!_paths[firstPathId])
		{
			alert("Path for {"+firstPathId+"} not defined.");
			return;
		}
		if(!_paths[secondPathId])
		{
			alert("Path for {"+secondPathId+"} not defined.");
			return;
		}
		return _paths[firstPathId]+_paths[secondPathId];
	}
	this.isDefined=function(path)
	{
		return !(_paths[path]===false);
	}
}