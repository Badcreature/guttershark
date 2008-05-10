/*
 The webtrendsDelegate funciton is called from the
 tracking.js file. This is a delegate method so that if
 you need to change it you don't have to change the
 tracking.js file.
*/
function webtrendsDelegate(tagStr,appendArr)
{
	var parts = tagStr.split(",");
	var dcsuri = parts[0];
	var ti = parts[1];
	var cg_n = parts[2];
	if(appendArr)
	{
		//append dynamic data
		//say u wanted to override a default ti variable for certain calls,
		//you would provide the 1 element in overrideArr
		if(override[0] != null) dcsuri += overrideArr[0];
		if(override[1] != null) ti += overrideArr[1];
		if(override[2] != null) cg_n += overrideArr[2;
	}
	//call webtrends
	try
	{
		//dcsMultiTrack accepts "pairs" of parameters. 
		//so the odd parameter is the name of the next
		//even parameter. So parameters 0 -> 'DCS.dcsuri'
		//is the name of the next value -> dcsuri.
		
		//alert('DCS.dcsuri: ' + dcsuri + ' WT.ti: ' + ti + ' WT_cg_n: ' + cg_n);
		dcsMultiTrack('DCS.dcsuri',dcsuri,'WT.ti',ti,'WT_cg_n',cg_n);
	}
	catch(e){}
}