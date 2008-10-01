<?php
require_once("phpmailer_php4/class.phpmailer.php");
$mail             = new PHPMailer();
$body             = $mail->getFile('contents.html');
$body             = eregi_replace("[\]",'',$body);
$body 		 	  = $BODY;
$mail->IsSMTP();
$mail->SMTPAuth   = true;                  // enable SMTP authentication
$mail->SMTPSecure = "ssl";                 // sets the prefix to the servier
$mail->Host       = "smtp.gmail.com";      // sets GMAIL as the SMTP server
$mail->Port       = 465;                   // set the SMTP port for the GMAIL server
$mail->Username   = "beingthexemplary@gmail.com";  // GMAIL username
$mail->Password   = "smithers";            // GMAIL password
$mail->AddReplyTo("beingthexemplary@gmail.com","First Last");
$mail->From       = "aaron@rubyamf.org";
$mail->FromName   = "Aaron Smith";
$mail->Subject    = $SUBJECT;
//$mail->Body     = "Hi,<br>This is the HTML BODY<br>";                      //HTML Body
$mail->AltBody    = "To view the message, please use an HTML compatible email viewer!"; // optional, comment out and test
$mail->WordWrap   = 50; // set word wrap
$mail->MsgHTML($body);
$mail->AddAddress("beingthexemplary@gmail.com", "Aaron Smith");
//$mail->AddAttachment("images/phpmailer.gif");
$mail->IsHTML(true); // send as HTML
if(!$mail->Send())
{
  echo "Mailer Error: " . $mail->ErrorInfo;
}
else
{
	echo "&success=true";
}
?>
