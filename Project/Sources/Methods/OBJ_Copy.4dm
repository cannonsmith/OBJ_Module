//%attributes = {}
//If you copy an object like this:
//     $oCopy:=$oOriginal
//4D copies by reference. Changing $oOriginal later
//affects $oCopy and visa-versa since they point to
//the same object.

//If you copy an object using OB Copy (which this
//method wraps), it will make an actual copy so you
//now have two objects.

C_OBJECT($1; $oObject)
C_OBJECT($0; $oCopy)

$oObject:=$1

$oCopy:=OB Copy($oObject)

$0:=$oCopy
