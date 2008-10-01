<?php
	$text=$_REQUEST['tts'];
	$m= substr(md5(microtime()),0,6);
	$fname=$m.".wav";
	$mname=$m.".mp3";
	$o = system("java -jar freetts/lib/freetts.jar -voice kevin -dumpAudio $fname -text $text > /dev/null");
	$f = system("/usr/local/bin/lame $fname $mname");
	unlink("$fname");
	echo "filename=$mname";
?>