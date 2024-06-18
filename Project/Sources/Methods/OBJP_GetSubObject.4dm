//%attributes = {}
//4D doesn't handle dot notation or direct array element access ([x]) in object key paths. This
//method handles the bulk of parsing this information out and is used by the main methods in this
//module to get access to the correct subobject in a C_Object. The main object and keypath are
//passed in. A reference to the subobject is returned. In addition, the name of the last key
//in the keypath is returned and the index associated with the the last key. If there is no
//index, it will be zero. This way the calling method can work directly with the subobject and
//the key as well as know if the key references an array that needs to be pulled out to access
//in indexed element in it. Finally, if this method is called with the $fSetting paramater set
//to true, at any point in the keypath chain where an array element is indicated, if the index
//is higher than the size of the array, the array will be resized to be large enough for the index.

//It should be understood that any intermidiary keys with [x] notation associated with them are
//object arrays. For example, in "contacts[3].phone[2].number", the contacts and phone keys must
//be object arrays. Only the last key in a keypath can be any type of array when [x] is included.

C_OBJECT($1; $oObject)
C_TEXT($2; $tKey)
C_POINTER($3; $pLastKey)  //The name of the last key in the keypath is returned here. [x] will be stripped if there.
C_POINTER($4; $pIndex)  //The index associated with the last key in the keypath is returned here. It will be 0 if no index.
C_BOOLEAN($5; $fSetting)  //If true, we are setting a value and arrays will be resized if necessary
C_OBJECT($0; $oSubObject)  //We return the subobject in the object tree that matches the keypath.

$oObject:=$1
$tKey:=$2
$pLastKey:=$3
$pIndex:=$4
$fSetting:=$5

C_LONGINT($lPos; $lSize; $lIndex; $lIndexPos; $lLastLevel; $x)
C_TEXT($tSubKey; $tLastKey)
C_OBJECT($oParent)
ARRAY TEXT($atKeyLevel; 0)
ARRAY LONGINT($alIndex; 0)
ARRAY OBJECT($aoObjectArray; 0)

//Parse out the keyapth, adding to the $atKeyLevel and $alIndex arrays for each key in the keypath.
Repeat 
	$lPos:=Position("."; $tKey)
	If ($lPos>0)
		$tSubKey:=Substring($tKey; 1; $lPos-1)
		If ($tSubKey[[Length($tSubKey)]]="]")  //Then we need to pull out the index
			$lIndexPos:=Position("["; $tSubKey)
			$lIndex:=Num(Substring($tSubKey; $lIndexPos+1; Length($tSubKey)-$lIndexPos))
			$tSubKey:=Substring($tSubKey; 1; $lIndexPos-1)
		Else 
			$lIndex:=0
		End if 
		APPEND TO ARRAY($atKeyLevel; $tSubKey)
		APPEND TO ARRAY($alIndex; $lIndex)
		$tKey:=Substring($tKey; $lPos+1)
	Else 
		If ($tKey#"")
			If ($tKey[[Length($tKey)]]="]")  //Then we need to pull out the index
				$lIndexPos:=Position("["; $tKey)
				$lIndex:=Num(Substring($tKey; $lIndexPos+1; Length($tKey)-$lIndexPos))
				$tKey:=Substring($tKey; 1; $lIndexPos-1)
			Else 
				$lIndex:=0
			End if 
			APPEND TO ARRAY($atKeyLevel; $tKey)
			APPEND TO ARRAY($alIndex; $lIndex)
			$tKey:=""
		End if 
	End if 
Until ($tKey="")

//Loop through the key levels, looking for a reference for the actual subobject referenced. If
//we are setting, we also resize arrays as needed.
$lLastLevel:=Size of array($atKeyLevel)
$oSubObject:=$oObject  //Start with reference to passed in object
For ($x; 1; $lLastLevel)
	If ($x<$lLastLevel)
		If ($alIndex{$x}=0)  //No [x] is appended, so just get directly
			$oParent:=$oSubObject  //Remember the parent in case we need it again
			$oSubObject:=OB Get($oParent; $atKeyLevel{$x}; Is object)
			If ((OBJ_IsValid($oSubObject)=False) & ($fSetting=True))
				$oSubObject:=OBJ_Create
				OB SET($oParent; $atKeyLevel{$x}; $oSubObject)
			End if 
		Else   //We assume this is an object array
			OB GET ARRAY($oSubObject; $atKeyLevel{$x}; $aoObjectArray)  //If the object array doesn't exist, this will be empty
			If (Size of array($aoObjectArray)>=$alIndex{$x})  //Then safe either way
				$oSubObject:=$aoObjectArray{$alIndex{$x}}
			Else   //[x] refers to an index that is higher than the size of the array
				If ($fSetting=False)  //Not setting, so we just return an empty subobject
					$oSubObject:=OBJ_Create
				Else   //They are setting, so we need to resize the array
					INSERT IN ARRAY($aoObjectArray; Size of array($aoObjectArray)+1; \
						$alIndex{$x}-Size of array($aoObjectArray))
					$aoObjectArray{$alIndex{$x}}:=OBJ_Create
					OB SET ARRAY($oSubObject; $atKeyLevel{$x}; $aoObjectArray)  //Place back into object
					$oSubObject:=$aoObjectArray{$alIndex{$x}}
				End if 
			End if 
		End if 
	Else 
		$tLastKey:=$atKeyLevel{$x}
		$lIndex:=$alIndex{$x}  //We return the index of the last key in the path
	End if 
End for 

$pLastKey->:=$tLastKey
$pIndex->:=$lIndex
$0:=$oSubObject
