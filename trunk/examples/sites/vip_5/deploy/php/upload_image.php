<?php
$name = time().$_FILES['Filedata']['name'];
move_uploaded_file($_FILES['Filedata']['tmp_name'], './uploaded/'.$name);
$name = rawurlencode($name);
echo "&name=$name";
?>