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