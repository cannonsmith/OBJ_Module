//%attributes = {"folder":"Objects Load and Save","lang":"en"}
//Expects a 4D blob that only has an object variable in it

C_BLOB($1; $xBlob)
C_OBJECT($0; $xObject)

$xBlob:=$1

C_LONGINT($lCompressed)

If (BLOB size($xBlob)>0)
	BLOB PROPERTIES($xBlob; $lCompressed)
	If ($lCompressed#Is not compressed)
		EXPAND BLOB($xBlob)
	End if 
	BLOB TO VARIABLE($xBlob; $xObject)
End if 

$0:=$xObject
