#!/usr/bin/php -q
<?php
ignore_user_abort(true);
set_time_limit(0);
ini_set('display_errors', '0');

	function addUnitss($bytes) {
		$units = array('B','kB','MB','GB','TB','PB','EB');
		for($i = 0; $bytes >= 1024 && $i < count($units) - 1; $i++ ) {
			$bytes /= 1024;
		}
		return round($bytes, 1).' '.$units[$i];
	}
	if ($argv[1]){
		function myGetDirs($username, $homeUser, $homeBase) {
			$passwd = file('/etc/passwd');
			$path = false;
			foreach ($passwd as $line) {
				if (strstr($line, $username) !== false) {
					$parts = explode(':', $line);
					$path = $parts[5];
					break;
				}
			}

			$ret = TRUE;
			$U = realpath($path); /// expand
			$B = realpath($path."/.."); /// home is the previous path

			if (isset($U) and !Empty($U) and is_dir($U)) {
				$homeUser = $U;
			}else{
				$ret = FALSE;
			}
			if (isset($B) and !Empty($B) and is_dir($B)) {
				$homeBase = $B;
			}else{
				$ret = FALSE;
			}

			return $ret;
		}

		if(!isset($quotaUser)) {
			$quotaUser = '';
		}

		$topDirectory = "/home";
		$quotaUser = $argv[1];
		$homeUser = $topDirectory.'/'.$quotaUser;
		$homeBase = $topDirectory;
		$quotaEnabled = true;

		if (isset($quotaUser) and !Empty($quotaUser) and file_exists($homeBase.'/aquota.user')) {
			$quotaEnabled = myGetDirs($quotaUser, &$homeUser, &$homeBase); /// get the real home dir
		}

		if ($quotaEnabled) {
			$TeljesMeret = shell_exec("/usr/bin/sudo /usr/sbin/repquota -u $homeBase | grep ^".$quotaUser." | awk '{print \$4}'") * 1024;
			$used = shell_exec("/usr/bin/sudo /usr/sbin/repquota -u $homeBase | grep ^".$quotaUser." | awk '{print \$3}'") * 1024;

			if ($TeljesMeret == 0) {
				$TeljesMeret = disk_total_space($topDirectory);
			}

			$SzabadTerulet = ($TeljesMeret - $used);
			$FelhasznaltTerulet = $used;
		}else{
			$TeljesMeret = disk_total_space($topDirectory);
			$SzabadTerulet = disk_free_space($topDirectory);
			$FelhasznaltTerulet = $TeljesMeret - $SzabadTerulet;
		}
		if ($argv[2] == "yes"){
			$TeljesMeret = disk_total_space($topDirectory);
			$SzabadTerulet = disk_free_space($topDirectory);
			$FelhasznaltTerulet = $TeljesMeret - $SzabadTerulet;
		}
			echo "=|=".addUnitss($TeljesMeret)."=|=".addUnitss($SzabadTerulet)."=|=".
					round((100 - ($SzabadTerulet / $TeljesMeret) * 100), 1)."=|=".
					addUnitss($FelhasznaltTerulet);
	}
?>