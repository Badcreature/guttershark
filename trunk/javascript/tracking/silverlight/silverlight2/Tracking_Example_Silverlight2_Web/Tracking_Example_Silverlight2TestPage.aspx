﻿<%@ Page Language="C#" AutoEventWireup="true" %>

<%@ Register Assembly="System.Web.Silverlight" Namespace="System.Web.UI.SilverlightControls"
    TagPrefix="asp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" style="height:100%;">
<head runat="server">
    <title>Test Page For Tracking_Example_Silverlight2</title>
    
    <script type="text/javascript" src="tracking.js"></script>
	<script type="text/javascript" src="delegates.js"></script>
    
    	<script type="text/javascript">
		var tracking;
		
		function setupTracking()
		{
		    tracking = new Tracking();
		    tracking.loadXML('tracking.xml');
		}
		
		function invokeTracking(trackID){
		    tracking.track(trackID);
		}
		
	</script>
</head>
<body style="height:100%;margin:0;"  onload="setupTracking();">
    <form id="form1" runat="server" style="height:100%;">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div  style="height:100%;">
            <asp:Silverlight ID="Xaml1" runat="server" Source="~/ClientBin/Tracking_Example_Silverlight2.xap" Version="2.0" Width="100%" Height="100%" />
        </div>
    </form>
    
    <!--tracking init-->
    <script type="text/javascript" src="tracking_init.js"></script>
    <script type="text/javascript" src="wt.js"></script>
</body>
</html>