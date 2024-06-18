//%attributes = {"folder":"Objects Private","lang":"en"}
//If the date can't be interpreted, !00/00/00! will be returned.

//Note that we test for the string date to be >= 10, not just = 10. This is a change in
//4Dv16r6 with object notation turned on. In some cases (ex. save object as blob and then
//load again), 4D changes the date string from "YYYY-MM-DD" to "YYYY-MM-DDTHH:MM:SS.SSSZ"
//for some reason. It shouldn't be interpreting it as a date, but seems to insist on doing
//that. I've filed a bug and am waiting to hear back. In the meantime, we only care about
//the date portion anyway, so as long as it has at least 10 characters, we parse into a date.
//This note was added on 2018-05-23.

C_TEXT($1; $tDateString)  //Expects YYYY-MM-DD format.
C_DATE($0; $dDate)

$tDateString:=$1
$dDate:=!00-00-00!

C_LONGINT($lYear; $lMonth; $lDay; $lYearsToAdd; $lMonthsToAdd; $lDaysToAdd)
C_DATE($dPivotDate)

If (Length($tDateString)>=10)
	$lYear:=Num(Substring($tDateString; 1; 4))
	$lMonth:=Num(Substring($tDateString; 6; 2))
	$lDay:=Num(Substring($tDateString; 9; 2))
	If (($lYear#0) & ($lMonth#0) & ($lDay#0))
		$dPivotDate:=!2000-01-01!
		$lYearsToAdd:=$lYear-2000
		$lMonthsToAdd:=$lMonth-1
		$lDaysToAdd:=$lDay-1
		$dDate:=Add to date($dPivotDate; $lYearsToAdd; $lMonthsToAdd; $lDaysToAdd)
	End if 
End if 

$0:=$dDate
