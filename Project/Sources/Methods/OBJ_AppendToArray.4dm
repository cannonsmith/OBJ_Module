//%attributes = {}
//When building up an array of objects before inserting the array into a
//parent object, this method can be used to append the object to the array
//with a copy or a reference. A copy ensures you can re-use the original
//object to add more objects to the array without affecting objects
//already added. By reference doesn't do this, so you have to decide what
//you want. A typical scenario would work like this:

//C_OBJECT($oParent;$oTemp)
//ARRAY OBJECT($oObjects;0)
//
//$oTemp:=OBJ_Create
//For ($x;1;$lCount)
//  OBJ_Clear($oTemp) 
//  ... build up $oTemp ...
//  OBJ_AppendToArray ($oTemp;->$oObjects;"Copy")
//End for 
//OBJ_Set_Array ($oParent;"MyObjectArray";->$oObjects)


C_OBJECT($1; $oObject)
C_POINTER($2; $pObjectArray)
C_TEXT($3; $tAppendType)  //Copy or Reference. Optional. Default is Copy.

$oObject:=$1
$pObjectArray:=$2
If (Count parameters>2)
	$tAppendType:=$3
Else 
	$tAppendType:="Copy"
End if 

C_OBJECT($oCopy)

If ($tAppendType="Reference")
	APPEND TO ARRAY($pObjectArray->; $oObject)
Else 
	$oCopy:=OB Copy($oObject)
	APPEND TO ARRAY($pObjectArray->; $oCopy)
End if 
