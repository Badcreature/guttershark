/**
 * Get's all selected items' base class from the library.
 */
function getSelectedBaseClassesCSV()
{
	var items = fl.getDocumentDOM().library.getSelectedItems();
	var used = [];
	var i=0;
	var classList = "";
	for(i; i<items.length;i++)
	{
		var item = items[i];
		if(used[item.linkageBaseClass]) continue;
		var t = item.itemType;
		if(t != "movie clip" && t != "font" && t != "sound" && t != "bitmap") continue;
		if(item.linkageBaseClass == "" || !item.linkageBaseClass) continue;
		used[item.linkageBaseClass] = true;
		classList += item.linkageBaseClass + ",";
	}
	var a = classList.split(",");
	a.pop();
	classList = a.join(",");
	return classList.toString();
}

/**
 * Tests to see if any documents are open.
 */
function isDocumentOpen()
{
	if(fl.documents.length>0) return true;
	return false;
}

/**
 * Writes an XML file - this is a proxy way of doing it,
 * as it is retarded trying to mess with quotes / double quotes
 * with MMExecute from AS. So a full file URI is required,
 * plus an escaped XML string.
 * @param	file	A full file URI - as JSFL requires.
 * @param	xml	An escaped string that will become XML when unescaped.
 */
function writeXML(fileURI,xml)
{
	FLfile.write(fileURI,unescape(xml));
}

/**
 * Returns the contents of a file as an escaped string.
 * The contents are escaped for safe transfer to Flash.
 */
function getFileContents(fileURI)
{
	var f = unescape(fileURI);
	if(!FLfile.exists(f)) return null;
	var c = FLfile.read(f);
	return escape(c);
}