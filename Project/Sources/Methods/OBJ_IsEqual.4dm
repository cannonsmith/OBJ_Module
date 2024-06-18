//%attributes = {"folder":"Objects General","lang":"en"}
//Compares two objects. If they are the same (ie. they have exactly the same elements and values),
//the method returns true. Thanks to Vincent de Lachaux for the original code which has been changed
//slightly to more closely match my style.

C_OBJECT($1; $oFirst)
C_OBJECT($2; $oSecond)
C_BOOLEAN($0; $fIsEqual)

$oFirst:=$1
$oSecond:=$2
$fIsEqual:=False  //Defaul to false

C_TEXT($tItem1; $tItem2)
C_LONGINT($x; $y; $lFirstItemCount; $lSecondItemCount; $lFirstPropertyCount; $lSecondPropertyCount)
ARRAY LONGINT($alFirstType; 0)
ARRAY TEXT($atFirstProperty; 0)
ARRAY LONGINT($alSecondType; 0)
ARRAY TEXT($atSecondProperty; 0)

OB GET PROPERTY NAMES($oFirst; $atFirstProperty; $alFirstType)
OB GET PROPERTY NAMES($oSecond; $atSecondProperty; $alSecondType)
$lFirstPropertyCount:=Size of array($atFirstProperty)
$lSecondPropertyCount:=Size of array($atSecondProperty)

If ($lFirstPropertyCount=$lSecondPropertyCount)  //They won't be equal if they have different property counts
	If ($lFirstPropertyCount>0)
		//Sort arrays because the properties could be in a different order
		SORT ARRAY($atFirstProperty; $alFirstType)
		SORT ARRAY($atSecondProperty; $alSecondType)
		
		//Now compare each property
		For ($x; 1; $lFirstPropertyCount)
			
			Case of 
				: (Length($atFirstProperty{$x})#Length($atSecondProperty{$x}))  //If the property names aren't the same length
					$fIsEqual:=False
					
				: (Position($atFirstProperty{$x}; $atSecondProperty{$x}; *)#1)  //Check property name (case sensitive)
					$fIsEqual:=False
					
				: ($alFirstType{$x}#$alSecondType{$x})  //Check property type
					$fIsEqual:=False
					
				: ($alFirstType{$x}=Is object)
					//compare the two objects
					$fIsEqual:=OBJ_IsEqual(\
						OB Get($oFirst; $atFirstProperty{$x}; Is object); \
						OB Get($oSecond; $atFirstProperty{$x}; Is object))
					
				: (($alFirstType{$x}=Object array) | ($alFirstType{$x}=Is collection))
					//In an object array we can massage all the array types back into text except object themselves.
					//So we get two sets of arrays, one text and the other objects. Then we can deal with either kind
					//as we walk through each element.
					
					ARRAY OBJECT($aoFirst; 0)  //Reset arrays
					ARRAY TEXT($atFirst; 0)
					ARRAY OBJECT($aoSecond; 0)
					ARRAY TEXT($atSecond; 0)
					OB GET ARRAY($oFirst; $atFirstProperty{$x}; $aoFirst)  //Get text and object types
					OB GET ARRAY($oFirst; $atFirstProperty{$x}; $atFirst)
					OB GET ARRAY($oSecond; $atFirstProperty{$x}; $aoSecond)
					OB GET ARRAY($oSecond; $atFirstProperty{$x}; $atSecond)
					
					$lFirstItemCount:=Size of array($aoFirst)
					$lSecondItemCount:=Size of array($aoSecond)
					If ($lFirstItemCount=$lSecondItemCount)
						For ($y; 1; $lFirstItemCount; 1)
							If ((OB Is defined($aoFirst{$y})) & (OB Is defined($aoSecond{$y})))  //If they are both objects
								$fIsEqual:=OBJ_IsEqual($aoFirst{$y}; $aoSecond{$y})
							Else   //Compare text
								$tItem1:=$atFirst{$y}
								$tItem2:=$atSecond{$y}
								$fIsEqual:=((Length($tItem1)=Length($tItem2)) & (Position($tItem1; $tItem2; *)=1))  //Make comparison case sensitive //($atFirst{$y}=$atSecond{$y})
							End if 
							If ($fIsEqual=False)
								$y:=$lFirstItemCount+1  //Abort loop
							End if 
						End for 
					Else 
						$fIsEqual:=False
					End if 
					
				: ($alFirstType{$x}=Is text)  //We want a case-sensitive comparison for text
					$tItem1:=OB Get($oFirst; $atFirstProperty{$x})
					$tItem2:=OB Get($oSecond; $atFirstProperty{$x})
					If (Length($tItem1)=Length($tItem2))
						If (Length($tItem1)=0)  //Needed for an empty string
							$fIsEqual:=True
						Else 
							$fIsEqual:=(Position($tItem1; $tItem2; *)=1)  //If not an empty string, is it exactly the same string (this check doesn't work for an empty string)
						End if 
					Else 
						$fIsEqual:=False
					End if 
					
				Else   //For any other object type, we simply compare the values
					$fIsEqual:=(OB Get($oFirst; $atFirstProperty{$x})=OB Get($oSecond; $atFirstProperty{$x}))
					
			End case 
			
			If ($fIsEqual=False)
				$x:=$lFirstPropertyCount+1  //Abort loop
			End if 
			
		End for 
		
	Else   //If there are not elements in either one, they are both equal
		$fIsEqual:=True
	End if 
End if 

$0:=$fIsEqual
