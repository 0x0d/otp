<?php
function checkOTP($pin,$otp,$initsecret)
{
 $maxperiod = 3*60; // in seconds = +/- 3 minutes
 $time=gmdate("U");
 echo $time;
 for($i = $time - $maxperiod; $i <= $time + $maxperiod; $i++)
 {
    $md5 = substr(md5(substr($i,0,-1).$initsecret.$pin),0,6);
    if($otp == $md5) return(true);
 }
return(false);
}

echo checkOTP('3216','9f9fc1d','d41d8cd98f0b24e9');
?>
