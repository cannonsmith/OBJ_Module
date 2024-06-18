//%attributes = {}
//================================================================================================================
//  Introduction
//================================================================================================================

//This module is a light-weight wrapper for 4D's object which adds dot notation, some clarity between reference
//counted and copied objects, the ability to store more kinds of data in objects (including all types of arrays,
//2D arrays, pictures, blobs, etc.), and some convenience methods.

//================================================================================================================
//  Dot Notation
//================================================================================================================

//Dot notation was the main reason this module was written since 4D does not include it natively. Because native
//objects are ref-counted, it was possible to add support for dot notation while keeping object manipulation fast
//and memory efficient.

//Keys can be accessed directly like this: "person.address.zip". Keys can be created in the same way.
//Inner objects don't already have to exist as the module will automatically create objects as needed. For example,
//if we started with an empty object and called OBJ_Set_Text($oObject;"person.address.zip;"...") the "person" and
//"address" objects would automatically be created before the "zip" key was added.

//Dot notation also supports direct access to array elements by appending key elements with a [x]. For example,
//"person.phone[2].number" would point to the "number" key in the second element of the "person.phone" object array.
//Another example: "object.sortOrder[3]" would point to the 3rd element of the sortOrder array (assume it is a long array)
//The following rules apply when using this feature:
// - The [x] characters must be appended to the end of the key element it belongs to.
// - The [x] characters must only be used with object arrays unless associated with the last key in a key path.
// - x in [x] must be >= 1
// - When associated with the last key in a key path, the following methods are not supported:
//   - OBJ_Get/Set_Array (it doesn't make sense to use [x] with these commands. Instead, you would use one of the other
//     other OBJ_Get/Set commands directly. For example, if the array is a long array, you would use OBJ_Get_Long with
//     [x] to access an element of the long array)
//   - OBJ_Get/Set_4DArray (same reason as above)
//   - OBJ_Get/Set_Record
//   - OBJ_Get/Set_Selection
//   - OBJ_DoesKeyExist
//   - OBJ_ListKeys
//   - OBJ_RemoveKey
//All other OBJ_Get/Set methods support this notation for the last key in a keypath.

//Note that if you set an element in an array where the array is smaller than the element you are setting, the array
//will automatically be resized up to fit the element. Any new elements created in this process will be left untouched
//with whatever values 4D gives them by default.

//Warning: If you plan on iterating through an array, it will be far more efficient to pull the array out of the
//object using OBJ_Get_Array, iterating over it, and then, if needed, putting it back using OBJ_Set_Array. Using the
//[x] notation is convenient, but 4D doesn't provide native access to array elements inside a C_Object, so this module
//is simply pulling arrays out of the object and putting them back in (when it makes sense) in the background. In other
//words, this is convenient, but may be slower than other methods if you are accessing more than one element of an
//array at a time.

//================================================================================================================
//  Native Objects
//================================================================================================================

//Just to be clear, only native 4D objects are used in the module. Native 4D commands are simply wrapped up in what,
//for me, is a more straight forward way of working with objects.

//================================================================================================================
//  Top Level Object vs Array
//================================================================================================================

//A JSON object can be an object ("{}") or an array ("[]") at the top level. In my own use it hasn't ever made sense
//to have an array at the top level. Even if an array of something is the predominant part of the JSON, I still wrap
//it in a top level object. So you need to know that this module assumes an object at the top level. If a JSON string
//with an array at the top level is loaded, the module automatically wraps it in a top level object ("OBJ"). If you
//really need arrays as top level objects, this module probably will not work for you. For me it simplified the code
//enough that it was worth it.

//================================================================================================================
//  Reference Counting vs Copying
//================================================================================================================

//Native 4D objects are reference counted. This is a good thing because it increases speed and saves on memory for
//typical operations. But it can also be a bit confusing if you're not used to it. With ref counting, when an object
//is assigned to another object (including when being passed as a parameter), only the reference is passed. Think of
//it like a pointer. For example, if you have an object $oObject, you might do this: $oDuplicate:=$oObject. If it was
//like most other 4D types we are used to, there would now be two objects and if we made a change to $oObject it would
//not affect $oDuplicate. But this is not the case with objects. $oObject and $oDuplicate both point to the same actual
//object in memory. Making a change to $oObject effectively changes $oDuplicate as well. Often you want to use objects
//this way (ref counting), but sometimes you want an actual copy and 4D provides a way to do this with OB Copy.

//This module attempts to make this a bit more natural by doing the most likely thing by default, but providing a way
//to do the other thing as an option for the methods where this makes sense. For example, OBJ_Set_Object and
//OBJ_Get_Object both have an option to set/get the object by reference or by copying.


//================================================================================================================
//  Speed
//================================================================================================================

//I created a similar module several years ago that was based on XML instead of objects. Most of the higher level
//commands are almost identical so it was easy to test the difference in speed. With small objects, the difference
//isn't worth noting unless you were in a tight loop. But with larger objects, the speed difference becomes quite
//large. The largest test I did was with an object that contained 26,000 total keys spread in both dimensions (ie.
//several levels of depth). Running compiled, here are the results:

//                               XML          Object
//                         =============  ==============
//Creating the object:     1,021.320 sec       0.359 sec  (with all 26,000 keys)
//2000 lookups:               55.968 sec       0.018 sec  (the lookups were spread evenly throughout the object)
//File size:                   1.3   MB        0.38  MB   (both saved with no compression; no pretty print for object)


//================================================================================================================
//  Typical Usage
//================================================================================================================

C_OBJECT($oObject; $oChildObject)  //Declaring a few vars for the examples below (more readable if not commented out)
C_TEXT($tJSONString; $tName)
C_LONGINT($lCount)

//Here is an example of creating an empty object (assume C_OBJECT($oObject) happened earlier):
$oObject:=OBJ_Create  //Makes sure the object has an empty object at the top level

//Here is an example of creating an object from a JSON string:
$oObject:=OBJ_Load_FromText($tJSONString)

//And saving back to a text variable:
$tJSONString:=OBJ_Save_ToText($oObject)  //We could pass an option for whether it is pretty printed

//Examples of setting a value in an object
OBJ_Set_Long($oObject; "machines"; 100)
OBJ_Set_Text($oObject; "person.firstname"; "Gerry")
OBJ_Set_Object($oObject; "person.address"; $oChildObject)  //Copies by default. There is an option to just reference it.

//And retrieving
$lCount:=OBJ_Get_Long($oObject; "machines")
$tName:=OBJ_Get_Text($oObject; "person.firstname")
$oChildObject:=OBJ_Get_Object($oObject; "person.address")  //Reference by default. There is an option to copy it.


//================================================================================================================
//  Module Methods: Loading/Saving
//================================================================================================================

//There are several convenience methods to make loading and saving objects simple. Objects can be saved in these
//formats:

//- A blob (OBJ_Save_ToBlob/OBJ_Load_FromBlob). Simply saves the 4D native object into a blob. No translation to JSON.
//  When loaded, the reverse happens.

//- Clipboard (OBJ_Save_ToClipboard/OBJ_LoadFromClipboard). Converts the object to a JSON string (can be pretty printed
//  or not) and places it in the clipboard. When loaded, expects a JSON string in the clipboard. Nice for testing.

//- A file (OBJ_Save_ToFile/OBJ_Load_FromFile). Converts the object to a JSON string (pretty print is an option) and
//  writes the string to the passed in file, overwriting the file if it already exists. When loaded, expects a file
//  containing a JSON string.

//- GZIP (OBJ_Save_ToGZIP/OBJ_Load_FROM_GZIP). Converts an object to a JSON string, then to a blob so it can be
//  compressed using GZIP. The blob could then be sent across the internet. When loaded, the reverse happens.

//- To text (OBJ_Save_ToText/OBJ_Load_FromText). Converts an object to a JSON string (can be pretty printed) and places
//  in a 4D text variable. Loading does the opposite.

//- From a URL. This is for loading, only, obviously. Takes a URL and downloads the file. It assumes the file will be
//  a JSON string and converts it into an object. Not a lot of options are exposed here and there could be more error
//  handling, depending on where the URLs you are using are pointing to.


//================================================================================================================
//  Module Methods: General
//================================================================================================================

//OBJ_Create: creates a new object with an empty object ("{}") at the top level.

//OBJ_Copy: $oCopy:=$oOriginal results in both variables pointing to the same object (ref counting). If a change is
//                             made, both objects will get the change.
//          $oCopy:=OBJ_Copy($oOriginal) makes an actual copy so there are two different objects to work with.
//Both are useful, depending on the situation.

//OBJ_IsValid: It is a good idea to use this to check the validity of an object after trying to load or get an object
//    in case something went wrong.

//OBJ_Clear: removes all keys in an object so it is in the same state as if OBJ_Create was just called. Useful if you
//    are reusing an object and want to start out in a known state. Also useful if you want to reduce the memory used
//    by an object while it is still in scope.

//OBJ_DoesKeyExist: A fast way to see if a key exists in the object.

//OBJ_ListKeys: If you want a list of keys at a certain level, use this command. It will return a list of key names
//    at the passed in level (not the full dot notation key, just the key name itself). Optionally, it can return a
//    list of key types. However, these are the 4D types, so they don't always reflect the module types since the
//    module can handle more types by encapsulating them in strings or objects.

//OBJ_RemoveKey: Use to remove a specific key completely.

//OBJ_AppendToArray: Useful method to use if you are building child objects and adding them to an object array
//    before embedding the array into a main object. The usefullness comes because you get the option to add the
//    object to the array by reference or by copy using the same method.

//OBJ_IsEqual: Used to see if two objects are identical. Ie. they both have exactly the same keys and values
//    although the keys at any one level may not be in the same order. Thanks to Vincent de Lachaux for this code.


//================================================================================================================
//  Module Methods: Set/Get
//================================================================================================================

//Note that if you try to get a value for a key that doesn't exist, or if a conversion can't happen correctly for
//some reason, an empty value/array will be returned for all the get methods. This fits my coding style well. If
//you prefer to have an error occur or have the OK variable set, you will have to add this yourself.

//- Arrays: Use OBJ_Set_Array to put any kind of array into an object. This includes 2D arrays. Some arrays are
//    added to the object directly. Others are translated as needed. For example, if a date array is detected, we
//    don't allow 4D to place it directly as 4D uses this format: "YYYY-MM-DDTHH:MM:SSZ" which would be fine except
//    the time always shows "06:00:00" instead of "00:00:00". I don't know why, but it seemed that extra information
//    was being added that shouldn't be there. So we convert to "YYYY-MM-DD" instead. When using OBJ_Get_Array, the
//    module checks the array type and, if it would have previously converted for that type, expects the correct format
//    to exist for converting back. You need to pass a codec for picture arrays.
//    Use OBJ_Set/Get_Array for arrays that need to be sent or received from non-4D systems or where you don't care
//    to track 4D's additional array info (current index and zero element). Use the OBJ_Set/Get_4DArray where you
//    do care about this additional information and the object stays in 4D systems. Don't try to mix the two. Thanks to
//    Keith Goebel for the idea for the _4DArray variants.

//- Blob: The blob is base64 encoded to get it into a JSON string.

//- Bool: becomes a JSON "true" or "false". Note for iOS users: because there isn't an NSBool type, NSJSONSerialization
//    converts JSON booleon values to an NSNumber with the value 0 or 1. We don't have to worry about that when sending
//    JSON to an iOS device, but when it comes back we have to keep that in mind. You can use OBJ_Get_Bool_iOS when
//    you know you are reading what is supposed to be a boolean type key that has come from an iOS device.

//- Date: converts the date to a JSON string with this format: "YYYY-MM-DD"

//- DateTimeLocal: converts a date and time to a JSON string with this format: "YYYY-MM-DDTHH:MM:SSZ"

//- Long: becomes a JSON number

//- Null: becomes a JSON null value. Use OBJ_Get_Null to find out whether the value for a key is a null or not. This
//    is, of course, different than checking whether a key exists.

//- Object: embeds an object into another object. By default it copies the object, but there is an option to set it
//    by reference if you like. When using OBJ_Get_Object, the opposite is true. By default you will get a reference
//    to the object, but you have the option of getting a copy instead.

//- Picture: converts a picture to a blob (you must pass in a codec) and then converts it to a base64 encoded JSON
//    string. OBJ_Get_Picture does the opposite and you are expected to know the codec here as well.

//- Real: becomes a JSON number

//- Record: takes the current record of the passed in table and stores all the fields in an object which is embedded
//    in the main object. Field names become table names. OBJ_Get_Record does the opposite and expects a record to
//    be loaded. It is up to you to ensure that fields names haven't changed, that the record is saved, etc. If it
//    encounters a field that doesn't have a corresponding key, the field will not be touched.

//- Selection: Takes a selection in a table and creates an array of record objects. You can also use OBJ_FromRecord
//    to manually place a record into an object if you want. OBJ_Get_Selection does not put all the records in the
//    table and save them. Instead, it returns an object array with one element for each record. You can cycle through
//    them, check on primary keys, use OBJ_ToRecord, etc.: whatever makes sense in your situation.

//- Text: becomes a JSON string

//- Time: converts the time to a JSON string with this format: "HH:MM:SS"

//================================================================================================================
//  Module Methods: ToRecord and FromRecord
//================================================================================================================

//There are two methods for converting a record into an object and back again that are used internally when working
//with records and selections that are also helpful by themselves:

//- OBJ_FromRecord: returns an object based on the loaded record for a table. All fields will be placed in the
//    object, using the field name as the key.
//- OBJ_ToRecord: takes an object, usually created with OBJ_FromRecord, and updates the fields in the loaded
//    record based on the keys in the object.

//================================================================================================================
//  Unit Test
//================================================================================================================

//OBJ__UnitTest can be used to test most of the methods in the module. The only exception (unless I've forgotten
//something) are the OBJ_Set_Record/OBJ_Get_Record methods. These could be added easily, but it is hard to add a
//generic test that involves the data structure and make it easy to drop these methods into any database.


//================================================================================================================
//  Module Use
//================================================================================================================

//Feel free to use/modify this code however you like. If you find bugs, have suggestions, or want to send back
//enhancements, please email me (Cannon Smith) at cannon@synergyfarmsolutions.com. Thanks!


