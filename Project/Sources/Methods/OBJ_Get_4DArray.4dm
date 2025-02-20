//%attributes = {"folder":"Objects Get and Set","lang":"en"}
//Returns an array. Works the same as OBJ_Get_Array, but it also restores the additional
//information 4D keeps about its arrays: the zero element and the selected element. The
//array must have previously been added using OBJ_Set_4DArray for this extra information
//to be retrieved. Thanks to Keith Goebel for the idea and code.

//NOTE: You must use OBJ_Set_4DArray to set and array that will be retrieved with this method.

//Works with any kind of 4D array, including 2D arrays.
//The array should have originally been set with OBJ_Set_Array or at least have the same
//format as OBJ_Set_Array would have used.

C_OBJECT($1; $oObject)
C_TEXT($2; $tKey)  //Can use dot notation
C_POINTER($3; $pArray)
C_TEXT($4; $tCodec)  //Used with picture arrays. Extension (".png") or mime type ("image/jpeg")

$oObject:=$1
$tKey:=$2
$pArray:=$3
If (Count parameters>3)
	$tCodec:=$4
Else 
	$tCodec:=".png"  //Default for picture arrays
End if 

C_TEXT($tLastKey)
C_LONGINT($y; $lSize; $l2DColCount; $lIndex)
C_OBJECT($oSubObject; $o2DObject; $o4DArrayObject)
C_BLOB($xBlob)
ARRAY TEXT($atJSONArray; 0)
ARRAY TEXT($at; 0)
ARRAY LONGINT($al; 0)
ARRAY REAL($ar; 0)
ARRAY DATE($ad; 0)
ARRAY BOOLEAN($af; 0)
ARRAY PICTURE($ag; 0)
ARRAY BLOB($ax; 0)
ARRAY TIME($ah; 0)
ARRAY OBJECT($ao; 0)

//Make sure the array is empty by default
$lSize:=Size of array($pArray->)
DELETE FROM ARRAY($pArray->; 1; $lSize)
If (Type($pArray->)=Array 2D)
	$lSize:=Size of array($pArray->{0})
	DELETE FROM ARRAY($pArray->{0}; 1; $lSize)
End if 

$oSubObject:=OBJP_GetSubObject($oObject; $tKey; ->$tLastKey; ->$lIndex; False)
If ((OBJ_IsValid($oSubObject)=True) & ($tLastKey#""))
	$o4DArrayObject:=OB Get($oSubObject; $tLastKey; Is object)
	Case of 
		: (Type($pArray->)=Text array)
			OB GET ARRAY($o4DArrayObject; "Array"; $pArray->)
			$pArray->{0}:=OBJ_Get_Text($o4DArrayObject; "ZeroElementValue")
			$pArray->:=OBJ_Get_Long($o4DArrayObject; "CurrentIndex")
			
		: (Type($pArray->)=Real array)
			OB GET ARRAY($o4DArrayObject; "Array"; $pArray->)
			$pArray->{0}:=OBJ_Get_Real($o4DArrayObject; "ZeroElementValue")
			$pArray->:=OBJ_Get_Long($o4DArrayObject; "CurrentIndex")
			
		: (Type($pArray->)=LongInt array)
			OB GET ARRAY($o4DArrayObject; "Array"; $pArray->)
			$pArray->{0}:=OBJ_Get_Long($o4DArrayObject; "ZeroElementValue")
			$pArray->:=OBJ_Get_Long($o4DArrayObject; "CurrentIndex")
			
		: (Type($pArray->)=Boolean array)
			OB GET ARRAY($o4DArrayObject; "Array"; $pArray->)
			$pArray->{0}:=OBJ_Get_Bool($o4DArrayObject; "ZeroElementValue")
			$pArray->:=OBJ_Get_Long($o4DArrayObject; "CurrentIndex")
			
		: (Type($pArray->)=Object array)
			OB GET ARRAY($o4DArrayObject; "Array"; $pArray->)
			$pArray->{0}:=OBJ_Get_Object($o4DArrayObject; "ZeroElementValue")
			$pArray->:=OBJ_Get_Long($o4DArrayObject; "CurrentIndex")
			
		: (Type($pArray->)=Date array)
			OB GET ARRAY($o4DArrayObject; "Array"; $atJSONArray)  //"YYYY-MM-DD"
			$lSize:=Size of array($atJSONArray)
			INSERT IN ARRAY($pArray->; 1; $lSize)
			For ($y; 1; $lSize)
				$pArray->{$y}:=OBJP_ConvertToDate($atJSONArray{$y})
			End for 
			$pArray->{0}:=OBJ_Get_Date($o4DArrayObject; "ZeroElementValue")
			$pArray->:=OBJ_Get_Long($o4DArrayObject; "CurrentIndex")
			
		: (Type($pArray->)=Time array)
			OB GET ARRAY($o4DArrayObject; "Array"; $atJSONArray)  //"HH:MM:SS"
			$lSize:=Size of array($atJSONArray)
			INSERT IN ARRAY($pArray->; 1; $lSize)
			For ($y; 1; $lSize)
				$pArray->{$y}:=Time($atJSONArray{$y})
			End for 
			$pArray->{0}:=OBJ_Get_Time($o4DArrayObject; "ZeroElementValue")
			$pArray->:=OBJ_Get_Long($o4DArrayObject; "CurrentIndex")
			
		: (Type($pArray->)=Picture array)
			OB GET ARRAY($o4DArrayObject; "Array"; $atJSONArray)  //Base64 Encoded
			$lSize:=Size of array($atJSONArray)
			INSERT IN ARRAY($pArray->; 1; $lSize)
			For ($y; 1; $lSize)
				CONVERT FROM TEXT($atJSONArray{$y}; "US-ASCII"; $xBlob)
				BASE64 DECODE($xBlob)
				BLOB TO PICTURE($xBlob; $pArray->{$y}; $tCodec)
			End for 
			$pArray->{0}:=OBJ_Get_Picture($o4DArrayObject; "ZeroElementValue"; $tCodec)
			$pArray->:=OBJ_Get_Long($o4DArrayObject; "CurrentIndex")
			
		: (Type($pArray->)=Blob array)
			OB GET ARRAY($o4DArrayObject; "Array"; $atJSONArray)  //Base64 Encoded
			$lSize:=Size of array($atJSONArray)
			INSERT IN ARRAY($pArray->; 1; $lSize)
			For ($y; 1; $lSize)
				CONVERT FROM TEXT($atJSONArray{$y}; "US-ASCII"; $xBlob)
				BASE64 DECODE($xBlob)
				$pArray->{$y}:=$xBlob
			End for 
			$pArray->{0}:=OBJ_Get_Blob($o4DArrayObject; "ZeroElementValue")
			$pArray->:=OBJ_Get_Long($o4DArrayObject; "CurrentIndex")
			
		: (Type($pArray->)=Array 2D)
			$o2DObject:=OBJ_Get_Object($oObject; $tKey)
			If (OBJ_IsValid($o2DObject)=True)
				$l2DColCount:=OBJ_Get_Long($o2DObject; "LastColumn")
				INSERT IN ARRAY($pArray->; 1; $l2DColCount)
				$pArray->:=OBJ_Get_Long($o2DObject; "CurrentIndex")
				For ($y; 0; $l2DColCount)
					Case of 
						: (Type($pArray->{0})=Text array)
							OBJ_Get_4DArray($o2DObject; "Col_"+String($y); ->$at)
							COPY ARRAY($at; $pArray->{$y})
						: (Type($pArray->{0})=LongInt array)
							OBJ_Get_4DArray($o2DObject; "Col_"+String($y); ->$al)
							COPY ARRAY($al; $pArray->{$y})
						: (Type($pArray->{0})=Real array)
							OBJ_Get_4DArray($o2DObject; "Col_"+String($y); ->$ar)
							COPY ARRAY($ar; $pArray->{$y})
						: (Type($pArray->{0})=Date array)
							OBJ_Get_4DArray($o2DObject; "Col_"+String($y); ->$ad)
							COPY ARRAY($ad; $pArray->{$y})
						: (Type($pArray->{0})=Boolean array)
							OBJ_Get_4DArray($o2DObject; "Col_"+String($y); ->$af)
							COPY ARRAY($af; $pArray->{$y})
						: (Type($pArray->{0})=Picture array)
							OBJ_Get_4DArray($o2DObject; "Col_"+String($y); ->$ag; $tCodec)
							COPY ARRAY($ag; $pArray->{$y})
						: (Type($pArray->{0})=Blob array)
							OBJ_Get_4DArray($o2DObject; "Col_"+String($y); ->$ax)
							COPY ARRAY($ax; $pArray->{$y})
						: (Type($pArray->{0})=Time array)
							OBJ_Get_4DArray($o2DObject; "Col_"+String($y); ->$ah)
							COPY ARRAY($ah; $pArray->{$y})
						: (Type($pArray->{0})=Object array)
							OBJ_Get_4DArray($o2DObject; "Col_"+String($y); ->$ao)
							COPY ARRAY($ao; $pArray->{$y})
					End case 
				End for 
			End if 
			
	End case 
	
End if 
