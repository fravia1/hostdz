<?php
if ($_GET){
	if ($_GET["x1"] == "rpc"){
		$filearray = explode("\n", file_get_contents("/etc/seedbox-from-scratch/users/".$_GET["username"].".info", true));
		foreach ($filearray as $value) {
			if (preg_match('/^RPC:/i', $value)) {
			   echo substr($value, 5);;
			}
		}
	}else
		echo 'jsonHostDZApi({"stat": "fail","id":"101","message":"apiKey is wrong"})';
}elseif($_POST){
	//die(print_r($_POST));
	if ($_POST["ApiKey"] == md5("{$_POST["username"]}=|rb|=fhrestart") AND !empty($_POST["username"])){
		$filearray = file_get_contents("/var/www/rutorrent/conf/users/{$_POST["username"]}/access.ini", true);
		if ($filearray[0]){
			shell_exec("sudo su --login --command \"/home/{$_POST["username"]}/restartSeedbox\" {$_POST["username"]} > /dev/null 2>&1 &");
			echo json_encode(array("return" => "succes"));
		}else
			echo "Not found user with id";
	}elseif ($_POST["ApiKey"] == md5($_POST["username"]."=|fhtorles|=".$_POST["username"]."=|fhtorles|=") AND !empty($_POST["username"])){
		$filearray = file_get_contents("/var/www/rutorrent/conf/users/{$_POST["username"]}/access.ini", true);
		if ($filearray[0]){
			shell_exec("bash deleteSeedboxUser {$_POST["username"]} > /dev/null 2>&1 &");
			echo json_encode(array("return" => "succes"));
		}else
			echo "Not found user with id";
	}elseif (!empty($_POST["username"]) AND !empty($_POST["upw"]) AND !empty($_POST["space"])){
		shell_exec("bash createSeedboxUser {$_POST["username"]} {$_POST["upw"]} > /dev/null 2>&1 &");
		sleep(3);
		shell_exec("sudo setquota -u {$_POST["username"]} {$_POST["space"]} {$_POST["space"]} 0 0 /home > /dev/null 2>&1 &");
		echo json_encode(array("return" => "succes"));
	}else
		echo 'jsonHostDZApi({"stat": "fail","id":"101","message":"apiKey is wrong"})';
}else
	echo 'jsonHostDZApi({"stat": "fail","id":"101","message":"apiKey is wrong"})';
?>
