var domhash=[];
var root = window.domain;
if(root==undefined)root="NODOMAIN/";

/**
 * get the root url for the site.
 */
function getRootURL()
{
	return root;
}

/**
 * set the root url for the site.
 */
function setRootURL(url)
{
	root = url;
}

/**
 * add a path by id
 */
function addPath(id, pathFromRoot)
{
	if(!id || !pathFromRoot) alert("Parameters {id} and {pathFromRoot} are required.");
	domhash[id] = pathFromRoot;
}

/**
 * get a path - not full path though, see getFullPath.
 */
function getPath(id)
{
	if(!id) alert("Parameter {id} is required.")
	return domhash[id];
}

/**
 * get a path with the full root url.
 */
function getFullPath(id)
{
	return getRootURL()+getPath(id);
}

/**
 * shortcut to embed a swf. takes a structure like this:
 * EX:
 * var vars = {model:"model.xml"}
 * var params = {wmode:"transparent"};
 * embedswf({
 *		swf:"main.swf",div:"flashcontent",vars:vars,params:params,
 *		width:"100%",height:"100%",version:"9.0.0",
 *		expressInstall:"js/expressinstall.swf",
 *		swffit:{minw:100,minh:100,maxw:800,maxh:800,centered:true},
 *		macwheel:true
 * })
 */
function embedswf(params)
{
	//swfobject.embedSWF(params.swf,params.div,params.width,params.height,params.version,params.expressInstall,params.vars,params.params,params.attributes);
	//if(params.macwheel) try{swfmacmousewheel.registerObject(attributes.id);}catch(e){}
	//if(params.swffit) 
}