var l = fl.documents.length;
var count = -1;
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