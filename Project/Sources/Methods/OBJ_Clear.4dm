//%attributes = {}
//Objects don't need to have their memory free-ed in the same way
//xml dom objects do. They are like normal variables that will
//be cleared automatically once they go out of scope. However, if
//desired, this method can be called to set an object back to its
//empty state, thus freeing memory sooner. It is also helpful when
//reusing an object, but wanting to start with a clean state.

C_OBJECT($1; $oObject)

$oObject:=$1

C_LONGINT($x; $lSize)
ARRAY TEXT($atKey; 0)

OB GET PROPERTY NAMES($oObject; $atKey)
$lSize:=Size of array($atKey)
For ($x; 1; $lSize)
	OB REMOVE($oObject; $atKey{$x})
End for 
