//%attributes = {}
//Creates a new, empty object. To do this correctly, we have
//to create an empty JSON string ("{}") first and convert it
//into an object. 4D doesn't do this automatically when an
//object is declared because, in theory, the top level of an
//object could be an object ("{}") or an array ("[]"). The
//OBJ_ module only supports the former which usually makes the
//most sense (to me, anyway).

C_OBJECT($0)

C_TEXT($tRawEmptyJSON)

$tRawEmptyJSON:="{}"

$0:=JSON Parse($tRawEmptyJSON)
