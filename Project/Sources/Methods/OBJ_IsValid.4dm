//%attributes = {"folder":"Objects General","lang":"en"}
//Returns true if the passed in object is a valid
//object.

C_OBJECT($1; $oObject)
C_BOOLEAN($0; $fIsValid)

$oObject:=$1
$fIsValid:=OB Is defined($oObject)

$0:=$fIsValid
