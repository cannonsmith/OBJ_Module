//%attributes = {}
//If the date can't be interpreted, !00/00/00! will be returned.

C_TEXT($1; $tDateString)  //Expects YYYY-MM-DD format.
C_DATE($0; $dDate)

$tDateString:=$1
$dDate:=!00-00-00!

C_LONGINT($lYear; $lMonth; $lDay; $lYearsToAdd; $lMonthsToAdd; $lDaysToAdd)
C_DATE($dPivotDate)

If (Length($tDateString)=10)
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
