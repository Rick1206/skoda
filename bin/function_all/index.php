<?php 
session_start();
$ftype = isset($_POST["Fun_type"]) ? $_POST["Fun_type"] : "" ;

if($ftype == ""){
	return;
}

if(isset($_SESSION["fir"])){
	$_SESSION["status"] = TRUE;
}else{
	$_SESSION["status"] = FALSE;
}

switch ($ftype) {
	case 'Is_login':
		
		$_SESSION["fir"] = "fir"; 
		
		if($_SESSION["status"]){
			$state = "1";
			$message = "Login Success";
		}else{
			$state = "0";
			$message = "Login Failure";
		}
		
		echo "{" . "\"state\":\"" . $state . "\",\"message\":\" ". $message.  "\"" . "}";	
		
		break;
	
	case 'User_submission':
		$state = "1";
		$message = "Upload User profile Success";
		
		$state = is_base64_encoded($_POST['Draw_pic']);
		
		echo "{" . "\"state\":\"" . $state . "\",\"message\":\" ". $message.  "\"" . "}";
		
		break;
		
	case 'User_Profile':
		
		
		$state = "1";		
		$message = "Get User profile Success";
		
		$username = "rick";
		$headpic = "./function_all/rick.jpg";
		
		$q1 = "1";
		$q2 = "2";
		$q3 = "1";
		$q4 = "3";
		$q5 = "4";
			
		echo "{" . "\"state\":\"" . $state . "\",\"message\":\" ". $message."\",\"profile\":{\"username\":\"".$username 
			  ."\",\"headpic\":\"".$headpic
			  ."\",\"profile_q1\":\"".$q1
			  ."\",\"profile_q2\":\"".$q2
			  ."\",\"profile_q3\":\"".$q3
			  ."\",\"profile_q4\":\"".$q4
			  ."\",\"profile_q5\":\"".$q5."\"}}";
		
		break;
	

}


function  base64_decode_fix( $data, $strict = false ) 
{ 
    if( $strict ) 
        if( preg_match( '![^a-zA-Z0-9/+=]!', $data ) ) 
            return( false ); 
    
    return( base64_decode( $data ) ); 
} 

function is_base64_encoded($data)
    {
        if (preg_match('%^[a-zA-Z0-9/+]*={0,2}$%', $data)) {
            return TRUE;
        } else {
            return FALSE;
        }
    };
?>