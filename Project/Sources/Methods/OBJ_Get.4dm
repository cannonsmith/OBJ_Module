//%attributes = {}
//Returns the value at the passed in key path, but does so based on the type of the
//pointer passed in. It can point to any kind of variable, a table, or a field.

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
		If ($tKey="")
			$tKey:=Table name($pValue)
		End if 
		OBJ_Get_Record($oObject; $tKey; $pValue)
		
	: (($tVarName="") & ($lTableNum>0) & ($lFieldNum>0))  //Field
		If ($tKey="")
			$tKey:=Table name($pValue)+"."+Field name($pValue)
		End if 
		$lType:=Type($pValue->)
		Case of 
			: (($lType=Is alpha field) | ($lType=Is text))
				$pValue->:=OBJ_Get_Text($oObject; $tKey)
				
			: (($lType=Is integer) | ($lType=Is longint))
				$pValue->:=OBJ_Get_Long($oObject; $tKey)
				
			: ($lType=Is real)
				$pValue->:=OBJ_Get_Real($oObject; $tKey)
				
			: ($lType=Is date)
				$pValue->:=OBJ_Get_Date($oObject; $tKey)
				
			: ($lType=Is time)
				$pValue->:=OBJ_Get_Time($oObject; $tKey)
				
			: ($lType=Is boolean)
				$pValue->:=OBJ_Get_Bool($oObject; $tKey)
				
			: ($lType=Is picture)
				$pValue->:=OBJ_Get_Picture($oObject; $tKey; ".png")
				
			: ($lType=Is BLOB)
				$pValue->:=OBJ_Get_Blob($oObject; $tKey)
				
			: ($lType=Is object)
				$pValue->:=OBJ_Get_Object($oObject; $tKey; "Copy")
				
			Else 
				TRACE  //Developer error
				
		End case 
		
		
	Else   //A variable of some type
		$lType:=Type($pValue->)
		Case of 
			: (($lType=Is string var) | ($lType=Is text))
				$pValue->:=OBJ_Get_Text($oObject; $tKey)
				
			: (($lType=Is integer) | ($lType=Is longint))
				$pValue->:=OBJ_Get_Long($oObject; $tKey)
				
			: ($lType=Is real)
				$pValue->:=OBJ_Get_Real($oObject; $tKey)
				
			: ($lType=Is date)
				$pValue->:=OBJ_Get_Date($oObject; $tKey)
				
			: ($lType=Is time)
				$pValue->:=OBJ_Get_Time($oObject; $tKey)
				
			: ($lType=Is boolean)
				$pValue->:=OBJ_Get_Bool($oObject; $tKey)
				
			: ($lType=Is picture)
				$pValue->:=OBJ_Get_Picture($oObject; $tKey; ".png")
				
			: ($lType=Is BLOB)
				$pValue->:=OBJ_Get_Blob($oObject; $tKey)
				
			: ($lType=Is object)
				$pValue->:=OBJ_Get_Object($oObject; $tKey; "Copy")
				
			: (($lType=Array 2D) | ($lType=Blob array) | ($lType=Boolean array) | ($lType=Date array) | \
				($lType=Integer array) | ($lType=LongInt array) | ($lType=Object array) | \
				($lType=Picture array) | ($lType=Real array) | ($lType=String array) | \
				($lType=Text array) | ($lType=Time array))
				OBJ_Get_4DArray($oObject; $tKey; $pValue)
				
			Else 
				TRACE  //Developer error
				
		End case 
		
		
End case 
