#!/usr/bin/php -q
<?php
ignore_user_abort(true);
set_time_limit(0);
ini_set('display_errors', '0');

	$filearray = explode("\n", file_get_contents("/etc/hostdz/users/".$argv[1].".info", true));
	foreach ($filearray as $value) {
		if (preg_match('/^RPC:/i', $value)) {
			echo substr($value, 5);;
		}
	}
?>