//%attributes = {"folder":"Objects Get and Set","lang":"en"}
//Creates or updates a key with the passed in array. Works the same as OBJ_Set_Array,
//but it also stores the additional information 4D keeps about its arrays: the zero
//element and the selected element. Thanks to Keith Goebel for the idea and code.

//NOTE: You must use OBJ_Get_4DArray to retrieve and array set with this method.

//Accepts any kind of 4D array, including 2D arrays. The following go through
//special conversion and will look like strings in the actual JSON:
//   Date --> "YYYY-MM-DD" (same as OBJ_Set_Date)
//   Time --> "HH:MM:SS" (same as OBJ_Set_Time)
//   Picture --> becomes a base64 string. Remember to pass in the codec.
//   Blob --> becomes a base64 string.
//   2D arrays --> becomes an object of arrays.

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
ARRAY TEXT($at; 0)
ARRAY LONGINT($al; 0)
ARRAY REAL($ar; 0)
ARRAY DATE($ad; 0)
ARRAY BOOLEAN($af; 0)
ARRAY PICTURE($ag; 0)
ARRAY BLOB($ax; 0)
ARRAY TIME($ah; 0)
ARRAY OBJECT($ao; 0)

$oSubObject:=OBJP_GetSubObject($oObject; $tKey; ->$tLastKey; ->$lIndex; True)
If ((OBJ_IsValid($oSubObject)=True) & ($tLastKey#""))
	$o4DArrayObject:=OBJ_Create
	Case of 
		: (Type($pArray->)=Text array)
			OBJ_Set_Long($o4DArrayObject; "CurrentIndex"; $pArray->)
			OBJ_Set_Text($o4DArrayObject; "ZeroElementValue"; $pArray->{0})
			OB SET ARRAY($o4DArrayObject; "Array"; $pArray->)
			
		: (Type($pArray->)=Real array)
			OBJ_Set_Long($o4DArrayObject; "CurrentIndex"; $pArray->)
			OBJ_Set_Real($o4DArrayObject; "ZeroElementValue"; $pArray->{0})
			OB SET ARRAY($o4DArrayObject; "Array"; $pArray->)
			
		: (Type($pArray->)=LongInt array)
			OBJ_Set_Long($o4DArrayObject; "CurrentIndex"; $pArray->)
			OBJ_Set_Long($o4DArrayObject; "ZeroElementValue"; $pArray->{0})
			OB SET ARRAY($o4DArrayObject; "Array"; $pArray->)
			
		: (Type($pArray->)=Boolean array)
			OBJ_Set_Long($o4DArrayObject; "CurrentIndex"; $pArray->)
			OBJ_Set_Bool($o4DArrayObject; "ZeroElementValue"; $pArray->{0})
			OB SET ARRAY($o4DArrayObject; "Array"; $pArray->)
			
		: (Type($pArray->)=Object array)
			OBJ_Set_Long($o4DArrayObject; "CurrentIndex"; $pArray->)
			OBJ_Set_Object($o4DArrayObject; "ZeroElementValue"; $pArray->{0})
			OB SET ARRAY($o4DArrayObject; "Array"; $pArray->)
			
		: (Type($pArray->)=Date array)
			$lSize:=Size of array($pArray->)
			ARRAY TEXT($atConvertedArray; $lSize)
			For ($y; 1; $lSize)
				$atConvertedArray{$y}:=String(Year of($pArray->{$y}); "0000")+"-"+String(Month of($pArray->{$y}); "00")+"-"+String(Day of($pArray->{$y}); "00")
			End for 
			OBJ_Set_Long($o4DArrayObject; "CurrentIndex"; $pArray->)
			OBJ_Set_Date($o4DArrayObject; "ZeroElementValue"; $pArray->{0})
			OB SET ARRAY($o4DArrayObject; "Array"; $atConvertedArray)  //"YYYY-MM-DD"
			
		: (Type($pArray->)=Time array)
			$lSize:=Size of array($pArray->)
			ARRAY TEXT($atConvertedArray; $lSize)
			For ($y; 1; $lSize)
				$atConvertedArray{$y}:=String(($pArray->{$y}+0)\3600; "00")+":"+String((($pArray->{$y}+0)\60)%60; "00")+":"+String(($pArray->{$y}+0)%60; "00")
			End for 
			OBJ_Set_Long($o4DArrayObject; "CurrentIndex"; $pArray->)
			OBJ_Set_Time($o4DArrayObject; "ZeroElementValue"; $pArray->{0})
			OB SET ARRAY($o4DArrayObject; "Array"; $atConvertedArray)  //"HH:MM:SS"
			
		: (Type($pArray->)=Picture array)
			$lSize:=Size of array($pArray->)
			ARRAY TEXT($atConvertedArray; $lSize)
			For ($y; 1; $lSize)
				PICTURE TO BLOB($pArray->{$y}; $xBlob; $tCodec)
				BASE64 ENCODE($xBlob)
				$atConvertedArray{$y}:=Convert to text($xBlob; "US-ASCII")
			End for 
			OBJ_Set_Long($o4DArrayObject; "CurrentIndex"; $pArray->)
			OBJ_Set_Picture($o4DArrayObject; "ZeroElementValue"; $pArray->{0}; $tCodec)
			OB SET ARRAY($o4DArrayObject; "Array"; $atConvertedArray)  //Base64 Encoded
			
		: (Type($pArray->)=Blob array)
			$lSize:=Size of array($pArray->)
			ARRAY TEXT($atConvertedArray; $lSize)
			For ($y; 1; $lSize)
				$xBlob:=$pArray->{$y}  //Copy so don't mess up passed in array contents
				BASE64 ENCODE($xBlob)
				$atConvertedArray{$y}:=Convert to text($xBlob; "US-ASCII")
			End for 
			OBJ_Set_Long($o4DArrayObject; "CurrentIndex"; $pArray->)
			OBJ_Set_Blob($o4DArrayObject; "ZeroElementValue"; $pArray->{0})
			OB SET ARRAY($o4DArrayObject; "Array"; $atConvertedArray)  //Base64 Encoded
			
		: (Type($pArray->)=Array 2D)
			$l2DColCount:=Size of array($pArray->)
			$o2DObject:=OBJ_Create
			OBJ_Set_Long($o2DObject; "LastColumn"; $l2DColCount)
			OBJ_Set_Long($o2DObject; "CurrentIndex"; $pArray->)
			For ($y; 0; $l2DColCount)
				Case of 
					: (Type($pArray->{$y})=Text array)
						COPY ARRAY($pArray->{$y}; $at)
						OBJ_Set_4DArray($o2DObject; "Col_"+String($y); ->$at)
					: (Type($pArray->{$y})=LongInt array)
						COPY ARRAY($pArray->{$y}; $al)
						OBJ_Set_4DArray($o2DObject; "Col_"+String($y); ->$al)
					: (Type($pArray->{$y})=Real array)
						COPY ARRAY($pArray->{$y}; $ar)
						OBJ_Set_4DArray($o2DObject; "Col_"+String($y); ->$ar)
					: (Type($pArray->{$y})=Date array)
						COPY ARRAY($pArray->{$y}; $ad)
						OBJ_Set_4DArray($o2DObject; "Col_"+String($y); ->$ad)
					: (Type($pArray->{$y})=Boolean array)
						COPY ARRAY($pArray->{$y}; $af)
						OBJ_Set_4DArray($o2DObject; "Col_"+String($y); ->$af)
					: (Type($pArray->{$y})=Picture array)
						COPY ARRAY($pArray->{$y}; $ag)
						OBJ_Set_4DArray($o2DObject; "Col_"+String($y); ->$ag; $tCodec)
					: (Type($pArray->{$y})=Blob array)
						COPY ARRAY($pArray->{$y}; $ax)
						OBJ_Set_4DArray($o2DObject; "Col_"+String($y); ->$ax)
					: (Type($pArray->{$y})=Time array)
						COPY ARRAY($pArray->{$y}; $ah)
						OBJ_Set_4DArray($o2DObject; "Col_"+String($y); ->$ah)
					: (Type($pArray->{$y})=Object array)
						COPY ARRAY($pArray->{$y}; $ao)
						OBJ_Set_4DArray($o2DObject; "Col_"+String($y); ->$ao)
				End case 
			End for 
			$o4DArrayObject:=$o2DObject
	End case 
	
	OB SET($oSubObject; $tLastKey; $o4DArrayObject)
	
	
End if 
