var l = fl.documents.length;
var firstIndex = fl.findDocumentIndex(fl.getDocumentDOM().name);
var count = firstIndex - 1;
publishNext();
function publishNext()
{
	count++;
	if(count == l)
	{
		return;
	}
	else if(count == l - 1)
	{
		fl.closeAllPlayerDocuments();
	}
	fl.setActiveWindow(fl.documents[count]);
	fl.getDocumentDOM().testMovie();
	publishNext();
}
fl.setActiveWindow(fl.documents[firstIndex]);