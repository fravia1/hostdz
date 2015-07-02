#!/usr/bin/php -q
<?php
ignore_user_abort(true);
set_time_limit(0);
error_reporting(0);
ini_set('display_errors', '0');

if (file_exists("/etc/hostdz/users/".$argv[1].".info")){
	$filearray = explode("\n", file_get_contents("/etc/hostdz/users/".$argv[1].".info", true));
	foreach ($filearray as $value) {
		if (preg_match('/SABNZBD HTTPS port:/i', $value)) {
			echo substr($value, 20);;
		}
	}
}else
	echo "No user with id.";
?>