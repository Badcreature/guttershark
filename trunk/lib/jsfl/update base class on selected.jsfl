var newBaseClass = prompt("Enter the new base class", "");
var items = fl.getDocumentDOM().library.getSelectedItems();
var i=0;
for(i; i < items.length; i++)
{
	var item = items[i];
	var t = item.itemType;
	if(t != "movie clip" && t != "font" && t != "sound" && t != "bitmap") continue;
	item.linkageExportForAS = true;
	item.linkageBaseClass = newBaseClass;
}