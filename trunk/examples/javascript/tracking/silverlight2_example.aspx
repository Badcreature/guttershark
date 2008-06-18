<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Register Assembly="System.Web.Silverlight" Namespace="System.Web.UI.SilverlightControls" TagPrefix="asp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" style="height:100%;">
<head runat="server">
    <title>Test Page For Tracking_Example_Silverlight2</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<script type="text/javascript" src="js/tracking/tracking.js"></script>
	<script type="text/javascript" src="js/tracking/delegates.js"></script>
	<script type="text/javascript" src="js/tracking/tracking_init.js"></script>
    <script type="text/javascript" src="js\wt.js"></script>
	<script type="text/javascript">
		setupTracking('tracking.xml');
	</script>
	<script type="text/javascript">	
		function invokeTracking(trackID){
		    tracking.track(trackID);
		}
	</script>
</head>
<body style="height:100%;margin:0;">
    <form id="form1" runat="server" style="height:100%;">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div  style="height:100%;">
            <asp:Silverlight ID="Xaml1" runat="server" Source="silverlight/silverlight2/Tracking_Example_Silverlight2_Web/ClientBin/Tracking_Example_Silverlight2.xap" Version="2.0" Width="100%" Height="100%" />
        </div>
    </form>
<noscript><img border="0" name="DCSIMG" width="1" height="1" src="http://" + gDomain + "/" + gDcsId + "/njs.gif?dcsuri=/nojavascript&WT.js=No" style="display:none"/></noscript>
<img style="display:none" id="atlas_tag" src="" />
</body>
</html>