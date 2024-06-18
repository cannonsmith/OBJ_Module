//%attributes = {"folder":"Objects Get and Set","lang":"en"}
//Returns an object. Use OBJ_IsValid afterward to make sure a real object
//was returned.

C_OBJECT($1; $oObject)
C_TEXT($2; $tKey)  //Can use dot notation
C_TEXT($3; $tGetMethod)  //Copy or Reference. Optional. Default is Reference.
C_OBJECT($0; $oValue)

$oObject:=$1
$tKey:=$2
If (Count parameters>2)
	$tGetMethod:=$3
Else 
	$tGetMethod:="Reference"
End if 

C_TEXT($tLastKey)
C_LONGINT($lIndex)
C_OBJECT($oSubObject; $oCopy)
ARRAY OBJECT($aoArray; 0)

$oSubObject:=OBJP_GetSubObject($oObject; $tKey; ->$tLastKey; ->$lIndex; False)
If ((OBJ_IsValid($oSubObject)=True) & ($tLastKey#""))
	If ($lIndex=0)
		If ($tGetMethod="Copy")
			$oCopy:=OB Get($oSubObject; $tLastKey; Is object)
			$oValue:=OB Copy($oCopy)
		Else 
			$oValue:=OB Get($oSubObject; $tLastKey; Is object)
		End if 
	Else   //The last key refers to an index within an array
		OB GET ARRAY($oSubObject; $tLastKey; $aoArray)
		If ($lIndex<=Size of array($aoArray))
			If ($tGetMethod="Copy")
				$oValue:=OB Copy($aoArray{$lIndex})
			Else 
				$oValue:=$aoArray{$lIndex}
			End if 
		End if 
	End if 
End if 

$0:=$oValue
