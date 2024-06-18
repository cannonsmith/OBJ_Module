//%attributes = {}
//Converts an object directly into a compressed 4D blob. Only use if moving
//between 4D and 4D and you want best compression.

C_OBJECT($1; $oObject)
C_BLOB($0; $xBlob)

$oObject:=$1

If (OBJ_IsValid($oObject))
	VARIABLE TO BLOB($oObject; $xBlob)
	COMPRESS BLOB($xBlob; GZIP best compression mode)
End if 

$0:=$xBlob
