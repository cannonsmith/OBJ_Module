//%attributes = {}
//Creates or updates a key with the passed in object. If you choose the
//"Reference" option, only a reference to the object will be embedded which
//means another method can change the original object and the embedded object
//will also change. If you choose "Copy" (the default), a copy will be made so
//no outside influence can accidentally change the embedded object.

C_OBJECT($1; $oObject)
C_TEXT($2; $tKey)  //Can use dot notation
C_OBJECT($3; $oChildObject)
C_TEXT($4; $tEmbeddType)  //Copy or Reference. Optional. Default is Copy.

$oObject:=$1
$tKey:=$2
$oChildObject:=$3
If (Count parameters>3)
	$tEmbeddType:=$4
Else 
	$tEmbeddType:="Copy"
End if 

C_TEXT($tLastKey)
C_LONGINT($lIndex)
C_OBJECT($oSubObject; $oCopiedObject)
ARRAY OBJECT($aoArray; 0)

$oSubObject:=OBJP_GetSubObject($oObject; $tKey; ->$tLastKey; ->$lIndex; True)
If ((OBJ_IsValid($oSubObject)=True) & ($tLastKey#""))
	If ($lIndex=0)  //No [x] on the last element, so set directly
		If ($tEmbeddType="Reference")
			OB SET($oSubObject; $tLastKey; $oChildObject)
		Else 
			$oCopiedObject:=OB Copy($oChildObject; True)
			OB SET($oSubObject; $tLastKey; $oCopiedObject)
		End if 
	Else   //The last key refers to an index within an array
		OB GET ARRAY($oSubObject; $tLastKey; $aoArray)  //Get the array out
		If ($lIndex>Size of array($aoArray))  //Then need to add elements to the array
			INSERT IN ARRAY($aoArray; Size of array($aoArray)+1; $lIndex-Size of array($aoArray))
		End if 
		If ($tEmbeddType="Reference")
			$aoArray{$lIndex}:=$oChildObject
		Else 
			$aoArray{$lIndex}:=OB Copy($oChildObject; True)
		End if 
		OB SET ARRAY($oSubObject; $tLastKey; $aoArray)  //Put the array back into the object
	End if 
Else 
	BEEP
	TRACE  //Developer error
End if 
