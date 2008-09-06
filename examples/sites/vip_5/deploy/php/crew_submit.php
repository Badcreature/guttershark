<?php
require_once("phpmailer_php4/class.phpmailer.php");
$lastname = $_POST['lastname'];
$firstname = $_POST['firstname'];
$wemet = $_POST['wemet'];
$how = $_POST['how'];
$position = $_POST['position'];
$position2 = $_POST['position2'];
$resume = $_POST['resume'];
$reel = $_POST['reel'];
$email = $_POST['email'];
$mobile = $_POST['mobile'];
$website = $_POST['website'];
$story = $_POST['story'];
$headshot = $_POST['headshot'];

//MAILER VARS
$SUBJECT = "Crew Submission";
$BODY = "Firstname: " . $firstname . "<br/>Lastname: " . $lastname . "<br/>Have We Met? " . $wemet. "<br/>How? " . $how . "<br/>Position Desired: " . $position . "<br/>Position 2: ". $position2 . "<br/>Have Resume? " . $resume . "<br/>Have Reel? " . $reel . "<br/>Email: " .
$email . "<br/>Mobile Phone: " . $mobile . "<br/>Website: " . $website . "<br/>Story: " . $story;
if($headshot) $BODY .= "<br/>Headshot Picture: $headshot";
$ATTACHMENT  = "";

require_once("gmail.php");
/*$mail = new PHPMailer();
$mail->Subject = "Crew Submission";
$mail->FromAddress = "test@vip.com";
$mail->FromName = "VIP";
$mail->AddAddress("mrbig@vip.com");
$mail->Body = "Crew Submission\n";
$b = &$mail->body;
$b .= "Firstname: " . $firstname . "\nLastname: " . $lastname . "\n Have We Met? " . $wemet. "\n How?" . $how . "\n Position Desired: " . $position . "\n Have Resume? " . $resume . "\n Have Reel? " . $reel . "\n Email: " .
$email . "\n Mobile Phone: " . $mobile . "\nWebsite: " . $website . "\nStory: " . $story;
$mail->Send();*/
?>