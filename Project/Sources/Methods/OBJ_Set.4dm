//%attributes = {}
//Sets the passed in record, field, or variable. If you are passing in a table,
//all of it's fields will automatically be named based on each field name. If you
//want to get or set an individual field later, use the keypath to the table +
//the name of the field. For example, let's say there is a table named "Contacts"
//with a field named "FirstName". If you did this:
// OBJ_Set($oObject;"Mother.ContactRecord";->[Contacts])
//Then you could change the FirstName field in the object this way:
// OBJ_Set_Text($oObject;"Mother.ContactRecord.FirstName")

C_OBJECT($1; $oObject)
C_TEXT($2; $tKey)
C_POINTER($3; $pValue)  //Table, field, or variable

$oObject:=$1
$tKey:=$2
$pValue:=$3

C_TEXT($tVarName)
C_LONGINT($lTableNum; $lFieldNum; $lType)

//Figure out what we are pointing to. Could be a table record, field, or any kind of variable
RESOLVE POINTER($pValue; $tVarName; $lTableNum; $lFieldNum)

Case of 
	: (($tVarName="") & ($lTableNum>0) & ($lFieldNum=0))  //Record
		OBJ_Set_Record($oObject; $tKey; $pValue)
		
	: (($tVarName="") & ($lTableNum>0) & ($lFieldNum>0))  //Field
		$lType:=Type($pValue->)
		Case of 
			: (($lType=Is alpha field) | ($lType=Is text))
				OBJ_Set_Text($oObject; $tKey; $pValue->)
				
			: (($lType=Is integer) | ($lType=Is longint))
				OBJ_Set_Long($oObject; $tKey; $pValue->)
				
			: ($lType=Is real)
				OBJ_Set_Real($oObject; $tKey; $pValue->)
				
			: ($lType=Is date)
				OBJ_Set_Date($oObject; $tKey; $pValue->)
				
			: ($lType=Is time)
				OBJ_Set_Time($oObject; $tKey; $pValue->)
				
			: ($lType=Is boolean)
				OBJ_Set_Bool($oObject; $tKey; $pValue->)
				
			: ($lType=Is picture)
				OBJ_Set_Picture($oObject; $tKey; $pValue->; ".png")
				
			: ($lType=Is BLOB)
				OBJ_Set_Blob($oObject; $tKey; $pValue->)
				
			: ($lType=Is object)
				OBJ_Set_Object($oObject; $tKey; $pValue->)
				
		End case 
		
		
	Else   //A variable of some type
		$lType:=Type($pValue->)
		Case of 
			: (($lType=Is string var) | ($lType=Is text))
				OBJ_Set_Text($oObject; $tKey; $pValue->)
				
			: (($lType=Is integer) | ($lType=Is longint))
				OBJ_Set_Long($oObject; $tKey; $pValue->)
				
			: ($lType=Is real)
				OBJ_Set_Real($oObject; $tKey; $pValue->)
				
			: ($lType=Is date)
				OBJ_Set_Date($oObject; $tKey; $pValue->)
				
			: ($lType=Is time)
				OBJ_Set_Time($oObject; $tKey; $pValue->)
				
			: ($lType=Is boolean)
				OBJ_Set_Bool($oObject; $tKey; $pValue->)
				
			: ($lType=Is picture)
				OBJ_Set_Picture($oObject; $tKey; $pValue->; ".png")
				
			: ($lType=Is BLOB)
				OBJ_Set_Blob($oObject; $tKey; $pValue->)
				
			: ($lType=Is object)
				OBJ_Set_Object($oObject; $tKey; $pValue->)
				
			: (($lType=Array 2D) | ($lType=Blob array) | ($lType=Boolean array) | ($lType=Date array) | \
				($lType=Integer array) | ($lType=LongInt array) | ($lType=Object array) | \
				($lType=Picture array) | ($lType=Real array) | ($lType=String array) | \
				($lType=Text array) | ($lType=Time array))
				OBJ_Set_4DArray($oObject; $tKey; $pValue)
				
		End case 
		
		
End case 
