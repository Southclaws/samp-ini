/*==============================================================================


	Southclaw's INI File System

		Do whatever you want with it
		But keep my name on it :)


==============================================================================*/

/*
	Functions:

native file_Create(filename[])
native file_Delete(filename[])
native _
native file_Open(filename[])
native file_Save(filename[])
native file_Close()
native _
native file_SetStr(key[], value[])
native file_SetVal(key[], value)
native file_SetFloat(key[], Float:value)
native file_RemoveKey(key[])
native file_IncVal(key[], value)
native file_RenameKey(key[], newname[MAX_KEY_LENGTH])
native _
native file_GetStr(key[], dest[])
native file_GetVal(key[])
native file_GetFloat(key[])
native file_IsKey(key[])
native _
native file_dGetStr(filename[], key[], dest[])
native file_dGetVal(filename[], key[])
native file_dGetFloat(filename[], key[])
native _
native file_PrintAll()

*/

#define MAX_RECORDS         (999)
#define MAX_KEY_LENGTH      (128)
#define MAX_VAL_LENGTH      (256)
#define MAX_RECORD_LENGTH   (MAX_KEY_LENGTH + MAX_VAL_LENGTH + 2)

#define __isnull(%0)        (%0[0] == 0||(%0[0] == 1&&%0[1] == 0))
#define __strcpy(%0,%1,%2)  strcat((%0[0] = '\0', %0), %1, %2)
#define file_IncVal(%1,%2)  file_SetVal(%1, file_GetVal(%1) + %2)

enum
{
	WINDOWS,
	LINUX
}


static
File:	ini_CurrentFile,
		ini_Temp[MAX_RECORD_LENGTH],
bool:	ini_FileOpen,
		ini_KeyData[MAX_RECORDS][MAX_KEY_LENGTH],
		ini_ValData[MAX_RECORDS][MAX_VAL_LENGTH];


/*==============================================================================

	File Management

==============================================================================*/


stock file_Create(filename[])
{
	if(fexist(filename))
	{
		printf("ERROR CREATING FILE : '%s' : FILE ALREADY EXISTS", filename);
		return 0;
	}

	ini_CurrentFile = fopen(filename, io_write);
	fclose(ini_CurrentFile);

	return 1;
}

stock file_Delete(filename[])
{
	fremove(filename);

	return 1;
}


/*==============================================================================

	Open and Close

==============================================================================*/


stock file_Open(filename[])
{
	if(ini_FileOpen)
	{
		print("ERROR: file_Open: File already open.");
		return 0;
	}

	if(!fexist(filename))
	{
		printf("ERROR: file_Open: File '%s' not found.", filename);
		return 0;
	}
	else
	{
		ini_CurrentFile = fopen(filename, io_read);
	}

	new
		i,
		delim,
		endpos;

	while(fread(ini_CurrentFile, ini_Temp) && (i < MAX_RECORDS))
	{
		endpos = strfind(ini_Temp, "\r"); // if windows

		if(endpos == -1) // if linux
			endpos = strfind(ini_Temp, "\n");

		if(endpos == -1) // single line file
			endpos = strlen(ini_Temp);

		ini_Temp[endpos] = EOS;

		delim = strfind(ini_Temp, "=");

		if(delim != -1)
		{
			__strcpy(ini_KeyData[i], ini_Temp, delim + 1);
			__strcpy(ini_ValData[i], ini_Temp[delim + 1], MAX_VAL_LENGTH);

			if(ini_KeyData[i][delim - 1] == ' ')
				strdel(ini_KeyData[i], delim - 1, delim);

			if(!ini_ValData[i][0])
				strdel(ini_ValData[i], -1, 0);
		}
		else
		{
			ini_KeyData[i][0] = 0;
			__strcpy(ini_ValData[i], ini_Temp, MAX_VAL_LENGTH);
		}

		i++;
	}

	ini_FileOpen = true;
	ini_Temp[0] = '\0';

	fclose(ini_CurrentFile);

	return 1;
}

stock file_Save(filename[])
{
	if(!fexist(filename))
	{
		printf("Error: file_Save: File '%s' not found.", filename);
		return 0;
	}

	if(!ini_FileOpen)
	{
		print("Error: file_Save: No file has been opened.");
		return 0;
	}

	new i;

	ini_CurrentFile = fopen(filename, io_write);

	while(i < MAX_RECORDS)
	{
		if(file_IsLineNull(i))
			break;

		if(file_IsLineMarkedToSkip(i))
			continue;

		if(file_IsLineComment(i))
		{
			__strcpy(ini_Temp, ini_ValData[i], MAX_RECORD_LENGTH);
		}
		else
		{
			format(ini_Temp, MAX_RECORD_LENGTH, "%s = %s\n", ini_KeyData[i], ini_ValData[i]);
		}

		fwrite(ini_CurrentFile, ini_Temp);

		i++;
	}

	fclose(ini_CurrentFile);

	return 1;
}

stock file_Close()
{
	for(new i; i < MAX_RECORDS; i++)
	{
		ini_KeyData[i][0] = '\0';
		ini_ValData[i][0] = '\0';
	}

	ini_FileOpen = false;
	ini_CurrentFile = File:0;
	ini_Temp[0] = '\0';

	return 1;
}


/*==============================================================================

	Writing

==============================================================================*/


stock file_SetStr(key[], value[])
{
	if(!ini_FileOpen)
	{
		printf("Error: file_SetStr: No file was opened.");
		return 0;
	}

	new i = file_FindLine(key);

	__strcpy(ini_KeyData[i], key, MAX_KEY_LENGTH);
	__strcpy(ini_ValData[i], value, MAX_VAL_LENGTH);

	return 1;
}

stock file_SetVal(key[], value)
{
	if(!ini_FileOpen)
	{
		printf("Error: file_SetVal: No file was opened.");
		return 0;
	}

	new i = file_FindLine(key);

	__strcpy(ini_KeyData[i], key, MAX_KEY_LENGTH);
	format(ini_ValData[i], MAX_VAL_LENGTH, "%d", value);

	return 1;
}

stock file_SetFloat(key[], Float:value)
{
	if(!ini_FileOpen)
	{
		printf("Error: file_SetFloat: No file was opened.");
		return 0;
	}

	new i = file_FindLine(key);

	__strcpy(ini_KeyData[i], key, MAX_KEY_LENGTH);
	format(ini_ValData[i], MAX_VAL_LENGTH, "%f", value);

	return 1;
}

stock file_RemoveKey(key[])
{
	if(!ini_FileOpen)
	{
		printf("Error: file_RemoveKey: No file was opened.");
		return 0;
	}

	new i;

	while(i < MAX_RECORDS)
	{
		if(file_IsLineNull(i))
			return 0;

		if(!strcmp(ini_KeyData[i], key))
		{
			ini_KeyData[i][0] = 0x1E;
			ini_ValData[i][0] = 0x1E;

			break;
		}
		i++;
	}

	return 1;
}

stock file_RenameKey(key[], newname[MAX_KEY_LENGTH])
{
	if(!ini_FileOpen)
	{
		printf("Error: file_RenameKey: No file was opened.");
		return 1;
	}

	new i;

	while(i < MAX_RECORDS)
	{
		if(file_IsLineNull(i))
			return 0;;

		if(!strcmp(ini_KeyData[i], key))
			break;

		i++;
	}

	__strcpy(ini_KeyData[i], newname, MAX_KEY_LENGTH);

	return 1;
}


/*==============================================================================

	Reading

==============================================================================*/


stock file_GetStr(key[], dest[], len = sizeof(dest))
{
	if(!ini_FileOpen)
	{
		printf("Error: file_GetStr: No file was opened.");
		return 0;
	}

	for(new i; i < MAX_RECORDS; i++)
	{
		if(file_IsLineNull(i))
			break;

		if(!strcmp(ini_KeyData[i], key, false, MAX_KEY_LENGTH))
		{
			dest[0] = EOS;
			strcat(dest, ini_ValData[i], len);
			return 1;
		}
	}

	return 0;
}

stock file_GetVal(key[])
{
	if(!ini_FileOpen)
	{
		printf("Error: file_GetVal: No file was opened.");
		return 0;
	}

	for(new i; i < MAX_RECORDS; i++)
	{
		if(file_IsLineNull(i))
			break;

		if(!strcmp(ini_KeyData[i], key, false, MAX_KEY_LENGTH))
			return strval(ini_ValData[i]);
	}

	return 0;
}

stock Float:file_GetFloat(key[])
{
	if(!ini_FileOpen)
	{
		printf("Error: file_GetFloat: No file was opened.");
		return 0.0;
	}

	for(new i; i < MAX_RECORDS; i++)
	{
		if(file_IsLineNull(i))
			break;

		if(!strcmp(ini_KeyData[i], key, false, MAX_KEY_LENGTH))
			return floatstr(ini_ValData[i]);
	}

	return Float:0.0;
}

stock file_IsKey(key[])
{
	if(!ini_FileOpen)
	{
		printf("Error: file_IsKey: No file was opened.");
		return 0;
	}

	for(new i; i < MAX_RECORDS; i++)
	{
		if(file_IsLineNull(i))
			break;

		if(!strcmp(ini_KeyData[i], key, false, MAX_KEY_LENGTH))
			return true;
	}

	return false;
}


/*==============================================================================

	Internal Functions

==============================================================================*/


stock file_PrintAll()
{
	if(!ini_FileOpen)
	{
		printf("Error: file_PrintAll: No file was opened.");
		return 0;
	}

	new i;

	while(i<MAX_RECORDS)
	{
		if(file_IsLineMarkedToSkip(i))
			continue;

		if(file_IsLineNull(i))
			break;

		printf("[ID:%d] %s = %s", i, ini_KeyData[i], ini_ValData[i]);

		i++;
	}

	return 1;
}

stock file_IsLineNull(id)
{
	if(__isnull(ini_KeyData[id]) && __isnull(ini_ValData[id]))
		return 1;

	return 0;
}

stock file_IsLineMarkedToSkip(id)
{
	if(ini_KeyData[id][0] == 0x1E)
		return 1;

	return 0;
}

stock file_IsLineComment(id)
{
	if(__isnull(ini_KeyData[id]) && !__isnull(ini_ValData[id]))
		return 1;

	return 0;
}

stock file_FindLine(key[])
{
	new i;

	while(i < MAX_RECORDS)
	{
		if(file_IsLineMarkedToSkip(i))
			continue;

		if(file_IsLineNull(i))
			break;

		if(!strcmp(ini_KeyData[i], key, false, MAX_KEY_LENGTH))
			break;

		i++;
	}

	return i;
}
