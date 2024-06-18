//%attributes = {"folder":"Objects","lang":"en"}
//This method tests most of the OBJ_ commands. Testing of setting/getting records is not done
//here but could be added for a specific database.

C_OBJECT($oObject; $oChildObject; $oCopyByRef; $oCopyByCopy; $oNotValid; $oLoaded)
C_TEXT($tBlobSHA; $tSVGRef; $tRef; $tFilePath; $tJSON)
C_DATE($dDate)
C_TIME($hTime)
C_BOOLEAN($fAssertStatus)
C_BLOB($xOriginalBlob; $xTestBlob; $xBlob)
C_PICTURE($gOriginalPicture; $gTestPicture)
C_LONGINT($x)
ARRAY TEXT($at; 0)
ARRAY BOOLEAN($af; 0)
ARRAY DATE($ad; 0)
ARRAY LONGINT($al; 0)
ARRAY PICTURE($ag; 0)
ARRAY REAL($ar; 0)
ARRAY TEXT($at; 0)
ARRAY OBJECT($ao; 0)
ARRAY TIME($ah; 0)
ARRAY BLOB($ax; 0)
ARRAY LONGINT($al2D; 0; 0)

$fAssertStatus:=Get assert enabled  //Remember for later
SET ASSERT ENABLED(True; *)  //Make sure assertions are enabled for the following code

//Set up "original" variables. These won't change during the test and are used for comparing.
$tSVGRef:=SVG_New(100; 100; "Test"; "A test."; True; Truncated non centered)
$tRef:=SVG_New_rect($tSVGRef; 10; 10; 80; 80; 0; 0; "Green"; "Purple"; 4)
$gOriginalPicture:=SVG_Export_to_picture($tSVGRef)
CONVERT PICTURE($gOriginalPicture; ".png")
SVG_CLEAR($tSVGRef)
SET BLOB SIZE($xOriginalBlob; 100; 45)
$tBlobSHA:=Generate digest($xOriginalBlob; SHA1 digest)

//Test creation of object
ASSERT(OBJ_IsValid($oObject)=False; "Object validity detection failed")
$oObject:=OBJ_Create
ASSERT(OBJ_IsValid($oObject)=True; "Object validity detection failed")

//Test setting and getting at the top level
APPEND TO ARRAY($at; "1")
APPEND TO ARRAY($at; "2")
OBJ_Set_Array($oObject; "textarray"; ->$at)
APPEND TO ARRAY($ar; 1.1)
APPEND TO ARRAY($ar; 2.2)
OBJ_Set_Array($oObject; "realarray"; ->$ar)
APPEND TO ARRAY($al; 1)
APPEND TO ARRAY($al; 2)
OBJ_Set_Array($oObject; "longarray"; ->$al)
APPEND TO ARRAY($af; False)
APPEND TO ARRAY($af; True)
OBJ_Set_Array($oObject; "boolarray"; ->$af)
$oChildObject:=OBJ_Create
OBJ_Set_Text($oChildObject; "test1"; "test1")
APPEND TO ARRAY($ao; $oChildObject)
$oChildObject:=OBJ_Create
OBJ_Set_Text($oChildObject; "test2"; "test2")
APPEND TO ARRAY($ao; $oChildObject)
OBJ_Set_Array($oObject; "objectarray"; ->$ao)
APPEND TO ARRAY($ad; !2000-12-25!)
APPEND TO ARRAY($ad; !00-00-00!)
OBJ_Set_Array($oObject; "datearray"; ->$ad)
APPEND TO ARRAY($ah; ?01:45:23?)
APPEND TO ARRAY($ah; ?00:00:00?)
OBJ_Set_Array($oObject; "timearray"; ->$ah)
APPEND TO ARRAY($ag; $gOriginalPicture)
APPEND TO ARRAY($ag; $gOriginalPicture)
OBJ_Set_Array($oObject; "picturearray"; ->$ag)
APPEND TO ARRAY($ax; $xOriginalBlob)
APPEND TO ARRAY($ax; $xOriginalBlob)
OBJ_Set_Array($oObject; "blobarray"; ->$ax)
ARRAY LONGINT($al2D; 2; 2)
$al2D{0}{1}:=1
$al2D{1}{2}:=2
$al2D{1}{1}:=3
OBJ_Set_Array($oObject; "array2D"; ->$al2D)

OBJ_Set_Blob($oObject; "blob"; $xOriginalBlob)
OBJ_Set_Bool($oObject; "boolean"; True)
OBJ_Set_Date($oObject; "date"; Current date)
OBJ_Set_DateTimeLocal($oObject; "datetime"; Current date; ?06:45:00?)
OBJ_Set_Long($oObject; "long"; 35)
OBJ_Set_Null($oObject; "null")
$oChildObject:=OBJ_Create
OBJ_Set_Text($oChildObject; "test"; "test")
OBJ_Set_Object($oObject; "object"; $oChildObject)
OBJ_Set_Picture($oObject; "picture"; $gOriginalPicture; ".png")
OBJ_Set_Real($oObject; "real"; 45.982)
OBJ_Set_Text($oObject; "text"; "This is a test")
OBJ_Set_Time($oObject; "time"; ?06:45:00?)

ASSERT(OBJ_Get_ArraySize($oObject; "textarray")=2)
ASSERT(OBJ_Get_ArraySize($oObject; "realarray")=2)
ASSERT(OBJ_Get_ArraySize($oObject; "longarray")=2)
ASSERT(OBJ_Get_ArraySize($oObject; "boolarray")=2)
ASSERT(OBJ_Get_ArraySize($oObject; "objectarray")=2)
ASSERT(OBJ_Get_ArraySize($oObject; "datearray")=2)
ASSERT(OBJ_Get_ArraySize($oObject; "timearray")=2)
ASSERT(OBJ_Get_ArraySize($oObject; "picturearray")=2)
ASSERT(OBJ_Get_ArraySize($oObject; "blobarray")=2)

DELETE FROM ARRAY($at; 1; 2)
OBJ_Get_Array($oObject; "textarray"; ->$at)
ASSERT(Size of array($at)=2)
ASSERT($at{1}="1")
ASSERT($at{2}="2")

DELETE FROM ARRAY($ar; 1; 2)
OBJ_Get_Array($oObject; "realarray"; ->$ar)
ASSERT(Size of array($ar)=2)
ASSERT($ar{1}=1.1)
ASSERT($ar{2}=2.2)

DELETE FROM ARRAY($al; 1; 2)
OBJ_Get_Array($oObject; "longarray"; ->$al)
ASSERT(Size of array($al)=2)
ASSERT($al{1}=1)
ASSERT($al{2}=2)

DELETE FROM ARRAY($af; 1; 2)
OBJ_Get_Array($oObject; "boolarray"; ->$af)
ASSERT(Size of array($af)=2)
ASSERT($af{1}=False)
ASSERT($af{2}=True)

DELETE FROM ARRAY($ao; 1; 2)
OBJ_Get_Array($oObject; "objectarray"; ->$ao)
ASSERT(Size of array($ao)=2)
ASSERT(OBJ_Get_Text($ao{1}; "test1")="test1")
ASSERT(OBJ_Get_Text($ao{2}; "test2")="test2")

DELETE FROM ARRAY($ad; 1; 2)
OBJ_Get_Array($oObject; "datearray"; ->$ad)
ASSERT(Size of array($ad)=2)
ASSERT($ad{1}=!2000-12-25!)
ASSERT($ad{2}=!00-00-00!)

DELETE FROM ARRAY($ah; 1; 2)
OBJ_Get_Array($oObject; "timearray"; ->$ah)
ASSERT(Size of array($ah)=2)
ASSERT($ah{1}=?01:45:23?)
ASSERT($ah{2}=?00:00:00?)

DELETE FROM ARRAY($ag; 1; 2)
OBJ_Get_Array($oObject; "picturearray"; ->$ag; ".png")
ASSERT(Size of array($ag)=2)
ASSERT(Picture size($ag{1})=Picture size($gOriginalPicture))
ASSERT(Picture size($ag{2})=Picture size($gOriginalPicture))

DELETE FROM ARRAY($ax; 1; 2)
OBJ_Get_Array($oObject; "blobarray"; ->$ax)
ASSERT(Size of array($ax)=2)
ASSERT(Generate digest($ax{1}; SHA1 digest)=$tBlobSHA)
ASSERT(Generate digest($ax{2}; SHA1 digest)=$tBlobSHA)

ARRAY LONGINT($al2D; 0; 0)
OBJ_Get_Array($oObject; "array2D"; ->$al2D)
ASSERT(Size of array($al2D)=2)
ASSERT(Size of array($al2D{0})=2)
ASSERT(Size of array($al2D{1})=2)
ASSERT(Size of array($al2D{2})=2)
ASSERT($al2D{0}{1}=1)
ASSERT($al2D{1}{2}=2)
ASSERT($al2D{1}{1}=3)

$xTestBlob:=OBJ_Get_Blob($oObject; "blob")
ASSERT(Generate digest($xTestBlob; SHA1 digest)=$tBlobSHA)
ASSERT(OBJ_Get_Bool($oObject; "boolean")=True)
ASSERT(OBJ_Get_Date($oObject; "date")=Current date)
$dDate:=OBJ_Get_DateTimeLocal($oObject; "datetime"; ->$hTime)
ASSERT($dDate=Current date)
ASSERT($hTime=?06:45:00?)
ASSERT(OBJ_Get_Long($oObject; "long")=35)
ASSERT(OBJ_Get_Null($oObject; "null")=True)
ASSERT(OBJ_Get_Null($oObject; "blob")=False)
$oChildObject:=OBJ_Get_Object($oObject; "object")
ASSERT(OBJ_IsValid($oChildObject)=True)
ASSERT(OBJ_Get_Text($oChildObject; "test")="test")
$gTestPicture:=OBJ_Get_Picture($oObject; "picture"; ".png")
ASSERT(Picture size($gTestPicture)=Picture size($gOriginalPicture))
ASSERT(OBJ_Get_Real($oObject; "real")=45.982)
ASSERT(OBJ_Get_Text($oObject; "text")="This is a test")
ASSERT(OBJ_Get_Time($oObject; "time")=?06:45:00?)



//Test creating all the same keys at a second level
ARRAY TEXT($at; 0)
ARRAY BOOLEAN($af; 0)
ARRAY DATE($ad; 0)
ARRAY LONGINT($al; 0)
ARRAY PICTURE($ag; 0)
ARRAY REAL($ar; 0)
ARRAY TEXT($at; 0)
ARRAY OBJECT($ao; 0)
ARRAY TIME($ah; 0)
ARRAY BLOB($ax; 0)
ARRAY LONGINT($al2D; 0; 0)

APPEND TO ARRAY($at; "1")
APPEND TO ARRAY($at; "2")
OBJ_Set_Array($oObject; "object.textarray"; ->$at)
APPEND TO ARRAY($ar; 1.1)
APPEND TO ARRAY($ar; 2.2)
OBJ_Set_Array($oObject; "object.realarray"; ->$ar)
APPEND TO ARRAY($al; 1)
APPEND TO ARRAY($al; 2)
OBJ_Set_Array($oObject; "object.longarray"; ->$al)
APPEND TO ARRAY($af; False)
APPEND TO ARRAY($af; True)
OBJ_Set_Array($oObject; "object.boolarray"; ->$af)
$oChildObject:=OBJ_Create
OBJ_Set_Text($oChildObject; "test1"; "test1")
APPEND TO ARRAY($ao; $oChildObject)
$oChildObject:=OBJ_Create
OBJ_Set_Text($oChildObject; "test2"; "test2")
APPEND TO ARRAY($ao; $oChildObject)
OBJ_Set_Array($oObject; "object.objectarray"; ->$ao)
APPEND TO ARRAY($ad; !2000-12-25!)
APPEND TO ARRAY($ad; !00-00-00!)
OBJ_Set_Array($oObject; "object.datearray"; ->$ad)
APPEND TO ARRAY($ah; ?01:45:23?)
APPEND TO ARRAY($ah; ?00:00:00?)
OBJ_Set_Array($oObject; "object.timearray"; ->$ah)
APPEND TO ARRAY($ag; $gOriginalPicture)
APPEND TO ARRAY($ag; $gOriginalPicture)
OBJ_Set_Array($oObject; "object.picturearray"; ->$ag)
APPEND TO ARRAY($ax; $xOriginalBlob)
APPEND TO ARRAY($ax; $xOriginalBlob)
OBJ_Set_Array($oObject; "object.blobarray"; ->$ax)
ARRAY LONGINT($al2D; 2; 2)
$al2D{0}{1}:=1
$al2D{1}{2}:=2
$al2D{1}{1}:=3
OBJ_Set_Array($oObject; "object.array2D"; ->$al2D)

OBJ_Set_Blob($oObject; "object.blob"; $xOriginalBlob)
OBJ_Set_Bool($oObject; "object.boolean"; True)
OBJ_Set_Date($oObject; "object.date"; Current date)
OBJ_Set_DateTimeLocal($oObject; "object.datetime"; Current date; ?06:45:00?)
OBJ_Set_Long($oObject; "object.long"; 35)
OBJ_Set_Null($oObject; "object.null")
$oChildObject:=OBJ_Create
OBJ_Set_Text($oChildObject; "test"; "test")
OBJ_Set_Object($oObject; "object.object"; $oChildObject)
OBJ_Set_Picture($oObject; "object.picture"; $gOriginalPicture; ".png")
OBJ_Set_Real($oObject; "object.real"; 45.982)
OBJ_Set_Text($oObject; "object.text"; "This is a test")
OBJ_Set_Time($oObject; "object.time"; ?06:45:00?)

DELETE FROM ARRAY($at; 1; 2)
OBJ_Get_Array($oObject; "object.textarray"; ->$at)
ASSERT(Size of array($at)=2)
ASSERT($at{1}="1")
ASSERT($at{2}="2")

DELETE FROM ARRAY($ar; 1; 2)
OBJ_Get_Array($oObject; "object.realarray"; ->$ar)
ASSERT(Size of array($ar)=2)
ASSERT($ar{1}=1.1)
ASSERT($ar{2}=2.2)

DELETE FROM ARRAY($al; 1; 2)
OBJ_Get_Array($oObject; "object.longarray"; ->$al)
ASSERT(Size of array($al)=2)
ASSERT($al{1}=1)
ASSERT($al{2}=2)

DELETE FROM ARRAY($af; 1; 2)
OBJ_Get_Array($oObject; "object.boolarray"; ->$af)
ASSERT(Size of array($af)=2)
ASSERT($af{1}=False)
ASSERT($af{2}=True)

DELETE FROM ARRAY($ao; 1; 2)
OBJ_Get_Array($oObject; "object.objectarray"; ->$ao)
ASSERT(Size of array($ao)=2)
ASSERT(OBJ_Get_Text($ao{1}; "test1")="test1")
ASSERT(OBJ_Get_Text($ao{2}; "test2")="test2")

DELETE FROM ARRAY($ad; 1; 2)
OBJ_Get_Array($oObject; "object.datearray"; ->$ad)
ASSERT(Size of array($ad)=2)
ASSERT($ad{1}=!2000-12-25!)
ASSERT($ad{2}=!00-00-00!)

DELETE FROM ARRAY($ah; 1; 2)
OBJ_Get_Array($oObject; "object.timearray"; ->$ah)
ASSERT(Size of array($ah)=2)
ASSERT($ah{1}=?01:45:23?)
ASSERT($ah{2}=?00:00:00?)

DELETE FROM ARRAY($ag; 1; 2)
OBJ_Get_Array($oObject; "object.picturearray"; ->$ag; ".png")
ASSERT(Size of array($ag)=2)
ASSERT(Picture size($ag{1})=Picture size($gOriginalPicture))
ASSERT(Picture size($ag{2})=Picture size($gOriginalPicture))

DELETE FROM ARRAY($ax; 1; 2)
OBJ_Get_Array($oObject; "object.blobarray"; ->$ax)
ASSERT(Size of array($ax)=2)
ASSERT(Generate digest($ax{1}; SHA1 digest)=$tBlobSHA)
ASSERT(Generate digest($ax{2}; SHA1 digest)=$tBlobSHA)

ARRAY LONGINT($al2D; 0; 0)
OBJ_Get_Array($oObject; "object.array2D"; ->$al2D)
ASSERT(Size of array($al2D)=2)
ASSERT(Size of array($al2D{0})=2)
ASSERT(Size of array($al2D{1})=2)
ASSERT(Size of array($al2D{2})=2)
ASSERT($al2D{0}{1}=1)
ASSERT($al2D{1}{2}=2)
ASSERT($al2D{1}{1}=3)

$xTestBlob:=OBJ_Get_Blob($oObject; "object.blob")
ASSERT(Generate digest($xTestBlob; SHA1 digest)=$tBlobSHA)
ASSERT(OBJ_Get_Bool($oObject; "object.boolean")=True)
ASSERT(OBJ_Get_Date($oObject; "object.date")=Current date)
$dDate:=OBJ_Get_DateTimeLocal($oObject; "object.datetime"; ->$hTime)
ASSERT($dDate=Current date)
ASSERT($hTime=?06:45:00?)
ASSERT(OBJ_Get_Long($oObject; "object.long")=35)
ASSERT(OBJ_Get_Null($oObject; "object.null")=True)
ASSERT(OBJ_Get_Null($oObject; "object.blob")=False)
$oChildObject:=OBJ_Get_Object($oObject; "object.object")
ASSERT(OBJ_IsValid($oChildObject)=True)
ASSERT(OBJ_Get_Text($oChildObject; "test")="test")
$gTestPicture:=OBJ_Get_Picture($oObject; "object.picture"; ".png")
ASSERT(Picture size($gTestPicture)=Picture size($gOriginalPicture))
ASSERT(OBJ_Get_Real($oObject; "object.real")=45.982)
ASSERT(OBJ_Get_Text($oObject; "object.text")="This is a test")
ASSERT(OBJ_Get_Time($oObject; "object.time")=?06:45:00?)

//Test OBJ_AppendToArray with Copy
ARRAY OBJECT($ao; 0)
$oChildObject:=OBJ_Create
For ($x; 1; 5)
	OBJ_Clear($oChildObject)
	OBJ_Set_Long($oChildObject; "element"; $x)
	OBJ_AppendToArray($oChildObject; ->$ao; "Copy")
End for 
OBJ_Set_Array($oObject; "MyObjectArray"; ->$ao)
ARRAY OBJECT($ao; 0)
OBJ_Get_Array($oObject; "MyObjectArray"; ->$ao)
ASSERT(OBJ_Get_Long($ao{3}; "element")=3)

//Test OBJ_AppendToArray with Reference
ARRAY OBJECT($ao; 0)
$oChildObject:=OBJ_Create
For ($x; 1; 5)
	OBJ_Clear($oChildObject)
	OBJ_Set_Long($oChildObject; "element"; $x)
	OBJ_AppendToArray($oChildObject; ->$ao; "Reference")
End for 
OBJ_Set_Array($oObject; "MyObjectArray"; ->$ao)
ARRAY OBJECT($ao; 0)
OBJ_Get_Array($oObject; "MyObjectArray"; ->$ao)
ASSERT(OBJ_Get_Long($ao{3}; "element")=5)

//Test copy by reference and OBJ_Copy
OBJ_Set_Long($oObject; "testcopy"; 100)
$oCopyByRef:=$oObject
$oCopyByCopy:=OBJ_Copy($oObject)
OBJ_Set_Long($oObject; "testcopy"; 50)
ASSERT(OBJ_Get_Long($oCopyByRef; "testcopy")=50)
ASSERT(OBJ_Get_Long($oCopyByCopy; "testcopy")=100)

//Test compare objects
ASSERT(OBJ_IsEqual($oObject; $oCopyByCopy)=False)
OBJ_Set_Long($oObject; "testcopy"; 100)
ASSERT(OBJ_IsEqual($oObject; $oCopyByCopy)=True)

//Test DoesKeyExist
ASSERT(OBJ_DoesKeyExist($oObject; "testcopy")=True)
ASSERT(OBJ_DoesKeyExist($oObject; "testcopy123")=False)
ASSERT(OBJ_DoesKeyExist($oObject; "object.time")=True)
ASSERT(OBJ_DoesKeyExist($oObject; "nothing.everything")=False)

//Test validity
ASSERT(OBJ_IsValid($oObject)=True)
ASSERT(OBJ_IsValid($oNotValid)=False)

//Rest removing keys
OBJ_RemoveKey($oObject; "testcopy")
ASSERT(OBJ_DoesKeyExist($oObject; "testcopy")=False)
OBJ_RemoveKey($oObject; "object.time")
ASSERT(OBJ_DoesKeyExist($oObject; "object.time")=False)

//Test listing keys
OBJ_Clear($oChildObject)
OBJ_Set_Long($oChildObject; "test"; 1)
OBJ_Set_Long($oChildObject; "test2"; 2)
OBJ_Set_Long($oChildObject; "test.l2"; 3)
OBJ_ListKeys($oChildObject; ""; ->$at)
ASSERT(Size of array($at)=2)
ASSERT($at{1}="test")
ASSERT($at{2}="test2")
OBJ_ListKeys($oChildObject; "test"; ->$at)
ASSERT(Size of array($at)=1)
ASSERT($at{1}="l2")

//Test saving and loading
$tJSON:=OBJ_Save_ToText($oObject)
$oLoaded:=OBJ_Load_FromText($tJSON)
ASSERT(JSON Stringify($oObject)=JSON Stringify($oLoaded))

$xBlob:=OBJ_Save_ToBlob($oObject)
$oLoaded:=OBJ_Load_FromBlob($xBlob)
ASSERT(JSON Stringify($oObject)=JSON Stringify($oLoaded))

OBJ_Save_ToClipboard($oObject)
$oLoaded:=OBJ_Load_FromClipboard
ASSERT(JSON Stringify($oObject)=JSON Stringify($oLoaded))

$tFilePath:=Temporary folder+Generate UUID+".json"
OBJ_Save_ToFile($oObject; $tFilePath)
$oLoaded:=OBJ_Load_FromFile($tFilePath)
ASSERT(JSON Stringify($oObject)=JSON Stringify($oLoaded))
DELETE DOCUMENT($tFilePath)

$xBlob:=OBJ_Save_ToGZIP($oObject)
$oLoaded:=OBJ_Load_FromGZIP($xBlob)
ASSERT(JSON Stringify($oObject)=JSON Stringify($oLoaded))

//Test the 4D array variants of setting and getting
ARRAY TEXT($at; 0)
ARRAY BOOLEAN($af; 0)
ARRAY DATE($ad; 0)
ARRAY LONGINT($al; 0)
ARRAY PICTURE($ag; 0)
ARRAY REAL($ar; 0)
ARRAY TEXT($at; 0)
ARRAY OBJECT($ao; 0)
ARRAY TIME($ah; 0)
ARRAY BLOB($ax; 0)
ARRAY LONGINT($al2D; 0; 0)

$at{0}:="5"
APPEND TO ARRAY($at; "1")
APPEND TO ARRAY($at; "2")
$at:=2
OBJ_Set_4DArray($oObject; "textarray"; ->$at)
$ar{0}:=5
APPEND TO ARRAY($ar; 1.1)
APPEND TO ARRAY($ar; 2.2)
$ar:=2
OBJ_Set_4DArray($oObject; "realarray"; ->$ar)
$al{0}:=5
APPEND TO ARRAY($al; 1)
APPEND TO ARRAY($al; 2)
$al:=2
OBJ_Set_4DArray($oObject; "longarray"; ->$al)
$af{0}:=True
APPEND TO ARRAY($af; False)
APPEND TO ARRAY($af; True)
$af:=2
OBJ_Set_4DArray($oObject; "boolarray"; ->$af)
$oChildObject:=OBJ_Create
OBJ_Set_Text($oChildObject; "test5"; "test5")
$ao{0}:=OB Copy($oChildObject)
$oChildObject:=OBJ_Create
OBJ_Set_Text($oChildObject; "test1"; "test1")
APPEND TO ARRAY($ao; $oChildObject)
$oChildObject:=OBJ_Create
OBJ_Set_Text($oChildObject; "test2"; "test2")
APPEND TO ARRAY($ao; $oChildObject)
$ao:=2
OBJ_Set_4DArray($oObject; "objectarray"; ->$ao)
$ad{0}:=!2005-05-05!
APPEND TO ARRAY($ad; !2000-12-25!)
APPEND TO ARRAY($ad; !00-00-00!)
$ad:=2
OBJ_Set_4DArray($oObject; "datearray"; ->$ad)
$ah{0}:=?05:05:05?
APPEND TO ARRAY($ah; ?01:45:23?)
APPEND TO ARRAY($ah; ?00:00:00?)
$ah:=2
OBJ_Set_4DArray($oObject; "timearray"; ->$ah)
$ag{0}:=$gOriginalPicture
APPEND TO ARRAY($ag; $gOriginalPicture)
APPEND TO ARRAY($ag; $gOriginalPicture)
$ag:=2
OBJ_Set_4DArray($oObject; "picturearray"; ->$ag)
$ax{0}:=$xOriginalBlob
APPEND TO ARRAY($ax; $xOriginalBlob)
APPEND TO ARRAY($ax; $xOriginalBlob)
$ax:=2
OBJ_Set_4DArray($oObject; "blobarray"; ->$ax)
ARRAY LONGINT($al2D; 2; 2)
$al2D{0}{1}:=1
$al2D{1}{2}:=2
$al2D{1}{1}:=3
$al2D:=1
OBJ_Set_4DArray($oObject; "array2D"; ->$al2D)

DELETE FROM ARRAY($at; 1; 2)
OBJ_Get_4DArray($oObject; "textarray"; ->$at)
ASSERT(Size of array($at)=2)
ASSERT($at{1}="1")
ASSERT($at{2}="2")

DELETE FROM ARRAY($ar; 1; 2)
OBJ_Get_4DArray($oObject; "realarray"; ->$ar)
ASSERT(Size of array($ar)=2)
ASSERT($ar{1}=1.1)
ASSERT($ar{2}=2.2)

DELETE FROM ARRAY($al; 1; 2)
OBJ_Get_4DArray($oObject; "longarray"; ->$al)
ASSERT(Size of array($al)=2)
ASSERT($al{1}=1)
ASSERT($al{2}=2)

DELETE FROM ARRAY($af; 1; 2)
OBJ_Get_4DArray($oObject; "boolarray"; ->$af)
ASSERT(Size of array($af)=2)
ASSERT($af{1}=False)
ASSERT($af{2}=True)

DELETE FROM ARRAY($ao; 1; 2)
OBJ_Get_4DArray($oObject; "objectarray"; ->$ao)
ASSERT(Size of array($ao)=2)
ASSERT(OBJ_Get_Text($ao{1}; "test1")="test1")
ASSERT(OBJ_Get_Text($ao{2}; "test2")="test2")

DELETE FROM ARRAY($ad; 1; 2)
OBJ_Get_4DArray($oObject; "datearray"; ->$ad)
ASSERT(Size of array($ad)=2)
ASSERT($ad{1}=!2000-12-25!)
ASSERT($ad{2}=!00-00-00!)

DELETE FROM ARRAY($ah; 1; 2)
OBJ_Get_4DArray($oObject; "timearray"; ->$ah)
ASSERT(Size of array($ah)=2)
ASSERT($ah{1}=?01:45:23?)
ASSERT($ah{2}=?00:00:00?)

DELETE FROM ARRAY($ag; 1; 2)
OBJ_Get_4DArray($oObject; "picturearray"; ->$ag; ".png")
ASSERT(Size of array($ag)=2)
ASSERT(Picture size($ag{1})=Picture size($gOriginalPicture))
ASSERT(Picture size($ag{2})=Picture size($gOriginalPicture))

DELETE FROM ARRAY($ax; 1; 2)
OBJ_Get_4DArray($oObject; "blobarray"; ->$ax)
ASSERT(Size of array($ax)=2)
ASSERT(Generate digest($ax{1}; SHA1 digest)=$tBlobSHA)
ASSERT(Generate digest($ax{2}; SHA1 digest)=$tBlobSHA)

ARRAY LONGINT($al2D; 0; 0)
OBJ_Get_4DArray($oObject; "array2D"; ->$al2D)
ASSERT(Size of array($al2D)=2)
ASSERT(Size of array($al2D{0})=2)
ASSERT(Size of array($al2D{1})=2)
ASSERT(Size of array($al2D{2})=2)
ASSERT($al2D{0}{1}=1)
ASSERT($al2D{1}{2}=2)
ASSERT($al2D{1}{1}=3)
ASSERT($al2D=1)

//Test [x] notation on the first level
$oObject:=OBJ_Create
OBJ_Set_Blob($oObject; "blob[2]"; $xOriginalBlob)
OBJ_Set_Bool($oObject; "boolean[2]"; True)
OBJ_Set_Date($oObject; "date[2]"; Current date)
OBJ_Set_DateTimeLocal($oObject; "datetime[2]"; Current date; ?06:45:00?)
OBJ_Set_Long($oObject; "long[2]"; 35)
$oChildObject:=OBJ_Create
OBJ_Set_Text($oChildObject; "test"; "test")
OBJ_Set_Object($oObject; "object[2]"; $oChildObject)
OBJ_Set_Picture($oObject; "picture[2]"; $gOriginalPicture; ".png")
OBJ_Set_Real($oObject; "real[2]"; 45.982)
OBJ_Set_Text($oObject; "text[2]"; "This is a test")
OBJ_Set_Time($oObject; "time[2]"; ?06:45:00?)

$xTestBlob:=OBJ_Get_Blob($oObject; "blob[2]")
ASSERT(Generate digest($xTestBlob; SHA1 digest)=$tBlobSHA)
ASSERT(OBJ_Get_Bool($oObject; "boolean[2]")=True)
ASSERT(OBJ_Get_Date($oObject; "date[2]")=Current date)
$dDate:=OBJ_Get_DateTimeLocal($oObject; "datetime[2]"; ->$hTime)
ASSERT($dDate=Current date)
ASSERT($hTime=?06:45:00?)
ASSERT(OBJ_Get_Long($oObject; "long[2]")=35)
$oChildObject:=OBJ_Get_Object($oObject; "object[2]")
ASSERT(OBJ_IsValid($oChildObject)=True)
ASSERT(OBJ_Get_Text($oChildObject; "test")="test")
$gTestPicture:=OBJ_Get_Picture($oObject; "picture[2]"; ".png")
ASSERT(Picture size($gTestPicture)=Picture size($gOriginalPicture))
ASSERT(OBJ_Get_Real($oObject; "real[2]")=45.982)
ASSERT(OBJ_Get_Text($oObject; "text[2]")="This is a test")
ASSERT(OBJ_Get_Time($oObject; "time[2]")=?06:45:00?)

//Text [x] notation on the second level
OBJ_Set_Blob($oObject; "object.blob[2]"; $xOriginalBlob)
OBJ_Set_Bool($oObject; "object.boolean[2]"; True)
OBJ_Set_Date($oObject; "object.date[2]"; Current date)
OBJ_Set_DateTimeLocal($oObject; "object.datetime[2]"; Current date; ?06:45:00?)
OBJ_Set_Long($oObject; "object.long[2]"; 35)
$oChildObject:=OBJ_Create
OBJ_Set_Text($oChildObject; "test"; "test")
OBJ_Set_Object($oObject; "object.object[2]"; $oChildObject)
OBJ_Set_Picture($oObject; "object.picture[2]"; $gOriginalPicture; ".png")
OBJ_Set_Real($oObject; "object.real[2]"; 45.982)
OBJ_Set_Text($oObject; "object.text[2]"; "This is a test")
OBJ_Set_Time($oObject; "object.time[2]"; ?06:45:00?)

$xTestBlob:=OBJ_Get_Blob($oObject; "object.blob[2]")
ASSERT(Generate digest($xTestBlob; SHA1 digest)=$tBlobSHA)
ASSERT(OBJ_Get_Bool($oObject; "object.boolean[2]")=True)
ASSERT(OBJ_Get_Date($oObject; "object.date[2]")=Current date)
$dDate:=OBJ_Get_DateTimeLocal($oObject; "object.datetime[2]"; ->$hTime)
ASSERT($dDate=Current date)
ASSERT($hTime=?06:45:00?)
ASSERT(OBJ_Get_Long($oObject; "object.long[2]")=35)
$oChildObject:=OBJ_Get_Object($oObject; "object.object[2]")
ASSERT(OBJ_IsValid($oChildObject)=True)
ASSERT(OBJ_Get_Text($oChildObject; "test")="test")
$gTestPicture:=OBJ_Get_Picture($oObject; "object.picture[2]"; ".png")
ASSERT(Picture size($gTestPicture)=Picture size($gOriginalPicture))
ASSERT(OBJ_Get_Real($oObject; "object.real[2]")=45.982)
ASSERT(OBJ_Get_Text($oObject; "object.text[2]")="This is a test")
ASSERT(OBJ_Get_Time($oObject; "object.time[2]")=?06:45:00?)

//Test [x] notation with arrays
OBJ_Set_Text($oObject; "object.textarray[1]"; "1")
OBJ_Set_Text($oObject; "object.textarray[2]"; "2")
OBJ_Set_Real($oObject; "object.realarray[1]"; 1.1)
OBJ_Set_Real($oObject; "object.realarray[2]"; 2.2)
OBJ_Set_Long($oObject; "object.longarray[1]"; 1)
OBJ_Set_Long($oObject; "object.longarray[2]"; 2)
OBJ_Set_Bool($oObject; "object.boolarray[1]"; False)
OBJ_Set_Bool($oObject; "object.boolarray[2]"; True)
$oChildObject:=OBJ_Create
OBJ_Set_Text($oChildObject; "test1"; "test1")
OBJ_Set_Object($oObject; "object.objectarray[1]"; $oChildObject)
$oChildObject:=OBJ_Create
OBJ_Set_Text($oChildObject; "test2"; "test2")
OBJ_Set_Object($oObject; "object.objectarray[2]"; $oChildObject)
OBJ_Set_Date($oObject; "object.datearray[1]"; !2000-12-25!)
OBJ_Set_Date($oObject; "object.datearray[2]"; !00-00-00!)
OBJ_Set_Time($oObject; "object.timearray[1]"; ?01:45:23?)
OBJ_Set_Time($oObject; "object.timearray[2]"; ?00:00:00?)
OBJ_Set_Picture($oObject; "object.picturearray[1]"; $gOriginalPicture; ".png")
OBJ_Set_Picture($oObject; "object.picturearray[2]"; $gOriginalPicture; ".png")
OBJ_Set_Blob($oObject; "object.blobarray[1]"; $xOriginalBlob)
OBJ_Set_Blob($oObject; "object.blobarray[2]"; $xOriginalBlob)

//Pull out the normal way...
DELETE FROM ARRAY($at; 1; 2)
OBJ_Get_Array($oObject; "object.textarray"; ->$at)
ASSERT(Size of array($at)=2)
ASSERT($at{1}="1")
ASSERT($at{2}="2")

DELETE FROM ARRAY($ar; 1; 2)
OBJ_Get_Array($oObject; "object.realarray"; ->$ar)
ASSERT(Size of array($ar)=2)
ASSERT($ar{1}=1.1)
ASSERT($ar{2}=2.2)

DELETE FROM ARRAY($al; 1; 2)
OBJ_Get_Array($oObject; "object.longarray"; ->$al)
ASSERT(Size of array($al)=2)
ASSERT($al{1}=1)
ASSERT($al{2}=2)

DELETE FROM ARRAY($af; 1; 2)
OBJ_Get_Array($oObject; "object.boolarray"; ->$af)
ASSERT(Size of array($af)=2)
ASSERT($af{1}=False)
ASSERT($af{2}=True)

DELETE FROM ARRAY($ao; 1; 2)
OBJ_Get_Array($oObject; "object.objectarray"; ->$ao)
ASSERT(Size of array($ao)=2)
ASSERT(OBJ_Get_Text($ao{1}; "test1")="test1")
ASSERT(OBJ_Get_Text($ao{2}; "test2")="test2")

DELETE FROM ARRAY($ad; 1; 2)
OBJ_Get_Array($oObject; "object.datearray"; ->$ad)
ASSERT(Size of array($ad)=2)
ASSERT($ad{1}=!2000-12-25!)
ASSERT($ad{2}=!00-00-00!)

DELETE FROM ARRAY($ah; 1; 2)
OBJ_Get_Array($oObject; "object.timearray"; ->$ah)
ASSERT(Size of array($ah)=2)
ASSERT($ah{1}=?01:45:23?)
ASSERT($ah{2}=?00:00:00?)

DELETE FROM ARRAY($ag; 1; 2)
OBJ_Get_Array($oObject; "object.picturearray"; ->$ag; ".png")
ASSERT(Size of array($ag)=2)
ASSERT(Picture size($ag{1})=Picture size($gOriginalPicture))
ASSERT(Picture size($ag{2})=Picture size($gOriginalPicture))

DELETE FROM ARRAY($ax; 1; 2)
OBJ_Get_Array($oObject; "object.blobarray"; ->$ax)
ASSERT(Size of array($ax)=2)
ASSERT(Generate digest($ax{1}; SHA1 digest)=$tBlobSHA)
ASSERT(Generate digest($ax{2}; SHA1 digest)=$tBlobSHA)

//And pull out directly
ASSERT(OBJ_Get_Text($oObject; "object.textarray[1]")="1")
ASSERT(OBJ_Get_Text($oObject; "object.textarray[2]")="2")
ASSERT(OBJ_Get_Real($oObject; "object.realarray[1]")=1.1)
ASSERT(OBJ_Get_Real($oObject; "object.realarray[2]")=2.2)
ASSERT(OBJ_Get_Long($oObject; "object.longarray[1]")=1)
ASSERT(OBJ_Get_Long($oObject; "object.longarray[2]")=2)
ASSERT(OBJ_Get_Bool($oObject; "object.boolarray[1]")=False)
ASSERT(OBJ_Get_Bool($oObject; "object.boolarray[2]")=True)
$oChildObject:=OBJ_Get_Object($oObject; "object.objectarray[1]")
ASSERT(OBJ_Get_Text($oChildObject; "test1")="test1")
$oChildObject:=OBJ_Get_Object($oObject; "object.objectarray[2]")
ASSERT(OBJ_Get_Text($oChildObject; "test2")="test2")
ASSERT(OBJ_Get_Date($oObject; "object.datearray[1]")=!2000-12-25!)
ASSERT(OBJ_Get_Date($oObject; "object.datearray[2]")=!00-00-00!)
ASSERT(OBJ_Get_Time($oObject; "object.timearray[1]")=?01:45:23?)
ASSERT(OBJ_Get_Time($oObject; "object.timearray[2]")=?00:00:00?)
$gTestPicture:=OBJ_Get_Picture($oObject; "object.picturearray[1]"; ".png")
ASSERT(Picture size($gTestPicture)=Picture size($gOriginalPicture))
$gTestPicture:=OBJ_Get_Picture($oObject; "object.picturearray[2]"; ".png")
ASSERT(Picture size($gTestPicture)=Picture size($gOriginalPicture))
$xTestBlob:=OBJ_Get_Blob($oObject; "object.blobarray[1]")
ASSERT(Generate digest($xTestBlob; SHA1 digest)=$tBlobSHA)
$xTestBlob:=OBJ_Get_Blob($oObject; "object.blobarray[2]")
ASSERT(Generate digest($xTestBlob; SHA1 digest)=$tBlobSHA)



SET ASSERT ENABLED($fAssertStatus; *)  //Set assertion status back to what it was

ALERT("The test is done. If no assert errors were shown, it passed.")
