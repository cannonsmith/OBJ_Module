//%attributes = {"folder":"Objects Get and Set","lang":"en"}
//Creates or updates a key with the passed in value
//The JSON value will be a string in this format: "HH:MM:SS"

C_OBJECT($1; $oObject)
C_TEXT($2; $tKey)  //Can use dot notation
C_TIME($3; $hValue)

$oObject:=$1
$tKey:=$2
$hValue:=$3

C_TEXT($tLastKey; $tConvertedValue)
C_LONGINT($lIndex)
C_OBJECT($oSubObject)
ARRAY TEXT($atArray; 0)

$oSubObject:=OBJP_GetSubObject($oObject; $tKey; ->$tLastKey; ->$lIndex; True)
If ((OBJ_IsValid($oSubObject)=True) & ($tLastKey#""))
	If ($lIndex=0)  //No [x] on the last element, so set directly
		$tConvertedValue:=String(($hValue+0)\3600; "00")+":"+String((($hValue+0)\60)%60; "00")+":"+String(($hValue+0)%60; "00")
		OB SET($oSubObject; $tLastKey; $tConvertedValue)
	Else   //The last key refers to an index within an array
		OB GET ARRAY($oSubObject; $tLastKey; $atArray)  //Get the array out
		If ($lIndex>Size of array($atArray))  //Then need to add elements to the array
			INSERT IN ARRAY($atArray; Size of array($atArray)+1; $lIndex-Size of array($atArray))
		End if 
		$tConvertedValue:=String(($hValue+0)\3600; "00")+":"+String((($hValue+0)\60)%60; "00")+":"+String(($hValue+0)%60; "00")
		$atArray{$lIndex}:=$tConvertedValue  //Set the value in the array
		OB SET ARRAY($oSubObject; $tLastKey; $atArray)  //Put the array back into the object
	End if 
Else 
	BEEP
	TRACE  //Developer error
End if 
