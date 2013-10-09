<?php
session_start();
$ftype = isset($_POST["Fun_type"]) ? $_POST["Fun_type"] : "";

//$ftype = isset($_GET["Fun_type"]) ? $_GET["Fun_type"] : "" ;

if ($ftype == "") {
	$tempFile = $_FILES['image']['tmp_name']['0'];//获取FILES的缓存文件
	//echo $tempFile;
     $targetPath = "./";//要保存到的新目录
    $targetFile = "1.jpg";//要生成的文件名
    move_uploaded_file($tempFile,$targetPath.$targetFile);
	//print_r($tempFile);
}

if (isset($_SESSION["fir"])) {
	$_SESSION["status"] = TRUE;
} else {
	$_SESSION["status"] = FALSE;
}

switch ($ftype) {
	case 'Is_login' :
		$_SESSION["fir"] = "fir";

		if ($_SESSION["status"]) {
			$state = "1";
			$message = "Login Success";
		} else {
			$state = "0";
			$message = "Login Failure";
		}

		echo "{" . "\"state\":\"" . $state . "\",\"message\":\" " . $message . "\"" . "}";

		break;

	case 'User_submission' :
		$state = "1";
		$message = "Upload User profile Success";

		$state = is_base64_encoded($_POST['Draw_pic']);

		echo "{" . "\"state\":\"" . $state . "\",\"message\":\" " . $message . "\"" . "}";

		break;

	case 'User_Profile' :
		$_SESSION["status"] = TRUE;
		if ($_SESSION["status"]) {

			$state = "1";
			$message = "Get User profile Success";

			$username = "rick";
			$headpic = "./function_all/rick.jpg";

			$q1 = "3";
			$q2 = "2";
			$q3 = "1";
			$q4 = "3";
			$q5 = "4";

			echo "{" . "\"state\":\"" . $state . "\",\"message\":\" " . $message . "\",\"profile\":[{\"username\":\"" . $username . "\",\"headpic\":\"" . $headpic . "\"}],\"questions\":[{\"questionId\":\"12\",\"title\":\"a\",
			  \"options\":[
           			{\"optionId\": \"12\",\"title\": \"b\",\"selected\": \"true\"},
           			{\"optionId\": \"2\",\"title\": \"c\",\"selected\": \"false\"},
           			{\"optionId\": \"3\",\"title\": \"d\",\"selected\": \"false\"},
           			{\"optionId\": \"5\",\"title\": \"e\",\"selected\": \"false\"}
       		  ]},{
			  	\"questionId\":\"2\",\"title\":\"\",
			  	\"options\":[
					{\"optionId\": \"1\",\"title\": \"\",\"selected\": \"true\"},
           			{\"optionId\": \"2\",\"title\": \"\",\"selected\": \"false\"},
           			{\"optionId\": \"3\",\"title\": \"\",\"selected\": \"false\"},
           			{\"optionId\": \"5\",\"title\": \"\",\"selected\": \"false\"}
			  ]},{
			  	\"questionId\":\"3\",\"title\":\"\",
			  	\"options\":[
			  		{\"optionId\": \"1\",\"title\": \"\",\"selected\": \"false\"},
           			{\"optionId\": \"2\",\"title\": \"\",\"selected\": \"false\"},
           			{\"optionId\": \"3\",\"title\": \"\",\"selected\": \"true\"},
           			{\"optionId\": \"5\",\"title\": \"\",\"selected\": \"false\"}
			  ]},{
			  	\"questionId\":\"4\",\"title\":\"\",
			  	\"options\":[
			  	    {\"optionId\": \"1\",\"title\": \"\",\"selected\": \"false\"},
           			{\"optionId\": \"2\",\"title\": \"\",\"selected\": \"false\"},
           			{\"optionId\": \"3\",\"title\": \"\",\"selected\": \"false\"},
           			{\"optionId\": \"5\",\"title\": \"\",\"selected\": \"true\"}
			 ]},{
			  	\"questionId\":\"5\",\"title\":\"\",
			  	\"options\":[
			  		{\"optionId\": \"1\",\"title\": \"\",\"selected\": \"true\"},
           			{\"optionId\": \"2\",\"title\": \"\",\"selected\": \"false\"},
           			{\"optionId\": \"3\",\"title\": \"\",\"selected\": \"false\"},
           			{\"optionId\": \"5\",\"title\": \"\",\"selected\": \"false\"}
			  ]}]}";

		} else {
			$state = "0";
			$message = "Get User profile Faliure";
			echo "{" . "\"state\":\"" . $state . "\",\"message\":\" " . $message . "\"" . "}";
		}
		break;
}

function base64_decode_fix($data, $strict = false) {
	if ($strict)
		if (preg_match('![^a-zA-Z0-9/+=]!', $data))
			return (false);

	return ( base64_decode($data));
}

function is_base64_encoded($data) {
	if (preg_match('%^[a-zA-Z0-9/+]*={0,2}$%', $data)) {
		return TRUE;
	} else {
		return FALSE;
	}
};
?>