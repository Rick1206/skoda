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
		$message = "Login Success";
		
		$state = is_base64_encoded($_POST['pic']);
		
		echo "{" . "\"state\":\"" . $state . "\",\"message\":\" ". $message.  "\"" . "}";
		
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