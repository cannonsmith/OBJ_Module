//%attributes = {}
//Public methods
C_OBJECT(OBJ_Create; $0)

C_OBJECT(OBJ_Clear; $1)

C_OBJECT(OBJ_RemoveKey; $1)
C_TEXT(OBJ_RemoveKey; $2)

C_OBJECT(OBJ_IsValid; $1)
C_BOOLEAN(OBJ_IsValid; $0)

C_OBJECT(OBJ_DoesKeyExist; $1)
C_TEXT(OBJ_DoesKeyExist; $2)
C_BOOLEAN(OBJ_DoesKeyExist; $0)

C_OBJECT(OBJ_Copy; $1)
C_OBJECT(OBJ_Copy; $0)

C_OBJECT(OBJ_IsEqual; $1)
C_OBJECT(OBJ_IsEqual; $2)
C_BOOLEAN(OBJ_IsEqual; $0)

C_OBJECT(OBJ_ListKeys; $1)
C_TEXT(OBJ_ListKeys; $2)
C_POINTER(OBJ_ListKeys; $3)
C_POINTER(OBJ_ListKeys; $4)

C_OBJECT(OBJ_AppendToArray; $1)
C_POINTER(OBJ_AppendToArray; $2)
C_TEXT(OBJ_AppendToArray; $3)

C_OBJECT(OBJ_Get_4DArray; $1)
C_TEXT(OBJ_Get_4DArray; $2)
C_POINTER(OBJ_Get_4DArray; $3)
C_TEXT(OBJ_Get_4DArray; $4)

C_OBJECT(OBJ_Get_Array; $1)
C_TEXT(OBJ_Get_Array; $2)
C_POINTER(OBJ_Get_Array; $3)
C_TEXT(OBJ_Get_Array; $4)

C_OBJECT(OBJ_Get_Blob; $1)
C_TEXT(OBJ_Get_Blob; $2)
C_BLOB(OBJ_Get_Blob; $0)

C_OBJECT(OBJ_Get_Bool; $1)
C_TEXT(OBJ_Get_Bool; $2)
C_BOOLEAN(OBJ_Get_Bool; $0)

C_OBJECT(OBJ_Get_Bool_iOS; $1)
C_TEXT(OBJ_Get_Bool_iOS; $2)
C_BOOLEAN(OBJ_Get_Bool_iOS; $0)

C_OBJECT(OBJ_Get_Date; $1)
C_TEXT(OBJ_Get_Date; $2)
C_DATE(OBJ_Get_Date; $0)

C_OBJECT(OBJ_Get_DateTimeLocal; $1)
C_TEXT(OBJ_Get_DateTimeLocal; $2)
C_POINTER(OBJ_Get_DateTimeLocal; $3)
C_DATE(OBJ_Get_DateTimeLocal; $0)

C_OBJECT(OBJ_Get_Picture; $1)
C_TEXT(OBJ_Get_Picture; $2)
C_TEXT(OBJ_Get_Picture; $3)
C_PICTURE(OBJ_Get_Picture; $0)

C_OBJECT(OBJ_Get_Real; $1)
C_TEXT(OBJ_Get_Real; $2)
C_REAL(OBJ_Get_Real; $0)

C_OBJECT(OBJ_Get_Long; $1)
C_TEXT(OBJ_Get_Long; $2)
C_LONGINT(OBJ_Get_Long; $0)

C_OBJECT(OBJ_Get_Null; $1)
C_TEXT(OBJ_Get_Null; $2)
C_BOOLEAN(OBJ_Get_Null; $0)

C_OBJECT(OBJ_Get_Object; $1)
C_TEXT(OBJ_Get_Object; $2)
C_TEXT(OBJ_Get_Object; $3)
C_OBJECT(OBJ_Get_Object; $0)

C_OBJECT(OBJ_Get_Record; $1)
C_TEXT(OBJ_Get_Record; $2)
C_POINTER(OBJ_Get_Record; $3)
C_TEXT(OBJ_Get_Record; $4)

C_OBJECT(OBJ_Get_Selection; $1)
C_TEXT(OBJ_Get_Selection; $2)
C_POINTER(OBJ_Get_Selection; $3)

C_OBJECT(OBJ_Get_Text; $1)
C_TEXT(OBJ_Get_Text; $2)
C_TEXT(OBJ_Get_Text; $0)

C_OBJECT(OBJ_Get_Time; $1)
C_TEXT(OBJ_Get_Time; $2)
C_TIME(OBJ_Get_Time; $0)


C_OBJECT(OBJ_Set_4DArray; $1)
C_TEXT(OBJ_Set_4DArray; $2)
C_POINTER(OBJ_Set_4DArray; $3)
C_TEXT(OBJ_Set_4DArray; $4)

C_OBJECT(OBJ_Set_Array; $1)
C_TEXT(OBJ_Set_Array; $2)
C_POINTER(OBJ_Set_Array; $3)
C_TEXT(OBJ_Set_Array; $4)

C_OBJECT(OBJ_Set_Blob; $1)
C_TEXT(OBJ_Set_Blob; $2)
C_BLOB(OBJ_Set_Blob; $3)

C_OBJECT(OBJ_Set_Bool; $1)
C_TEXT(OBJ_Set_Bool; $2)
C_BOOLEAN(OBJ_Set_Bool; $3)

C_OBJECT(OBJ_Set_Date; $1)
C_TEXT(OBJ_Set_Date; $2)
C_DATE(OBJ_Set_Date; $3)

C_OBJECT(OBJ_Set_DateTimeLocal; $1)
C_TEXT(OBJ_Set_DateTimeLocal; $2)
C_DATE(OBJ_Set_DateTimeLocal; $3)
C_TIME(OBJ_Set_DateTimeLocal; $4)

C_OBJECT(OBJ_Set_Long; $1)
C_TEXT(OBJ_Set_Long; $2)
C_LONGINT(OBJ_Set_Long; $3)

C_OBJECT(OBJ_Set_Null; $1)
C_TEXT(OBJ_Set_Null; $2)

C_OBJECT(OBJ_Set_Object; $1)
C_TEXT(OBJ_Set_Object; $2)
C_OBJECT(OBJ_Set_Object; $3)
C_TEXT(OBJ_Set_Object; $4)

C_OBJECT(OBJ_Set_Picture; $1)
C_TEXT(OBJ_Set_Picture; $2)
C_PICTURE(OBJ_Set_Picture; $3)
C_TEXT(OBJ_Set_Picture; $4)

C_OBJECT(OBJ_Set_Real; $1)
C_TEXT(OBJ_Set_Real; $2)
C_REAL(OBJ_Set_Real; $3)

C_OBJECT(OBJ_Set_Record; $1)
C_TEXT(OBJ_Set_Record; $2)
C_POINTER(OBJ_Set_Record; $3)
C_TEXT(OBJ_Set_Record; $4)

C_OBJECT(OBJ_Set_Selection; $1)
C_TEXT(OBJ_Set_Selection; $2)
C_POINTER(OBJ_Set_Selection; $3)
C_TEXT(OBJ_Set_Selection; $4)

C_OBJECT(OBJ_Set_Text; $1)
C_TEXT(OBJ_Set_Text; $2)
C_TEXT(OBJ_Set_Text; $3)

C_OBJECT(OBJ_Set_Time; $1)
C_TEXT(OBJ_Set_Time; $2)
C_TIME(OBJ_Set_Time; $3)

C_POINTER(OBJ_FromRecord; $1)
C_TEXT(OBJ_FromRecord; $2)
C_OBJECT(OBJ_FromRecord; $0)

C_OBJECT(OBJ_ToRecord; $1)
C_POINTER(OBJ_ToRecord; $2)
C_TEXT(OBJ_ToRecord; $3)


C_TEXT(OBJ_Load_FromText; $1)
C_OBJECT(OBJ_Load_FromText; $0)

C_OBJECT(OBJ_Load_FromClipboard; $0)

C_BLOB(OBJ_Load_FromBlob; $1)
C_OBJECT(OBJ_Load_FromBlob; $0)

C_BLOB(OBJ_Load_FromGZIP; $1)
C_OBJECT(OBJ_Load_FromGZIP; $0)

C_TEXT(OBJ_Load_FromFile; $1)
C_OBJECT(OBJ_Load_FromFile; $0)

C_TEXT(OBJ_Load_FromURL; $1)
C_OBJECT(OBJ_Load_FromURL; $0)

C_OBJECT(OBJ_Save_ToText; $1)
C_BOOLEAN(OBJ_Save_ToText; $2)
C_TEXT(OBJ_Save_ToText; $0)

C_OBJECT(OBJ_Save_ToClipboard; $1)
C_BOOLEAN(OBJ_Save_ToClipboard; $2)

C_OBJECT(OBJ_Save_ToBlob; $1)
C_BLOB(OBJ_Save_ToBlob; $0)

C_OBJECT(OBJ_Save_ToGZIP; $1)
C_BOOLEAN(OBJ_Save_ToGZIP; $2)
C_BLOB(OBJ_Save_ToGZIP; $0)

C_OBJECT(OBJ_Save_ToFile; $1)
C_TEXT(OBJ_Save_ToFile; $2)
C_BOOLEAN(OBJ_Save_ToFile; $3)

C_OBJECT(OBJ_Get; $1)
C_TEXT(OBJ_Get; $2)
C_POINTER(OBJ_Get; $3)

C_OBJECT(OBJ_Set; $1)
C_TEXT(OBJ_Set; $2)
C_POINTER(OBJ_Set; $3)

//Private methods
C_TEXT(OBJP_ConvertToDate; $1)
C_DATE(OBJP_ConvertToDate; $0)

C_OBJECT(OBJP_GetSubObject; $1)
C_TEXT(OBJP_GetSubObject; $2)
C_POINTER(OBJP_GetSubObject; $3)
C_POINTER(OBJP_GetSubObject; $4)
C_BOOLEAN(OBJP_GetSubObject; $5)
C_OBJECT(OBJP_GetSubObject; $0)

C_OBJECT(OBJ_Get_ArraySize; $1)
C_TEXT(OBJ_Get_ArraySize; $2)
C_LONGINT(OBJ_Get_ArraySize; $0)
