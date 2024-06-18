//%attributes = {}
//Expects a compressed 4D blob that only has an object variable in it

C_BLOB($1; $xBlob)
C_OBJECT($0; $xObject)

$xBlob:=$1

If (BLOB size($xBlob)>0)
	EXPAND BLOB($xBlob)
	BLOB TO VARIABLE($xBlob; $xObject)
End if 

$0:=$xObject
