/*==============================================================================


	Southclaw's INI File System

		Do whatever you want with it
		But keep my name on it :)


==============================================================================*/


#define MAX_FILE_NAME       (256)
#define MAX_RECORDS         (999)
#define MAX_KEY_LENGTH      (128)
#define MAX_VAL_LENGTH      (256)
#define MAX_RECORD_LENGTH   (MAX_KEY_LENGTH + MAX_VAL_LENGTH + 2)

#define __isnull(%0)        (%0[0] == 0||(%0[0] == 1&&%0[1] == 0))

// Error values are non-zero positive
enum {
	INI_ERR_EXISTS = 1,
	INI_ERR_NOT_EXISTS,
	INI_ERR_OPEN,
	INI_ERR_NOT_OPEN,
}

static
		ini_CurrentFileName[MAX_FILE_NAME],
bool:	ini_FileOpen,
		ini_KeyData[MAX_RECORDS][MAX_KEY_LENGTH],
		ini_ValData[MAX_RECORDS][MAX_VAL_LENGTH];


forward ini_open(filename[], len = sizeof filename);
forward ini_commit();
forward ini_close();

forward ini_get_str(key[], dest[], len = sizeof(dest));
forward ini_get_int(key[], &dest);
forward ini_get_float(key[], &Float:dest);

forward ini_set_str(key[], value[]);
forward ini_set_int(key[], value);
forward ini_set_float(key[], Float:value);

forward file_RemoveKey(key[]);
forward file_IsKey(key[]);


#include "strcpy.pwn"
#include "ini-parser.pwn"
#include "ini-writer.pwn"
#include "ini-access-get.pwn"
#include "ini-access-set.pwn"
#include "ini-access-util.pwn"


stock ini_open(filename[], len = sizeof filename) {
	if(ini_FileOpen) {
		return INI_ERR_OPEN;
	}

	new
		File:handle,
		ret;

	if(fexist(filename)) {
		handle = fopen(filename, io_read);
		ret = ini_parse(handle, ini_KeyData, ini_ValData);
		fclose(handle);
	}

	ini_strcpy(ini_CurrentFileName, filename, len);
	ini_FileOpen = true;

	return ret;
}

stock ini_commit() {
	if(!fexist(ini_CurrentFileName)) {
		return INI_ERR_NOT_EXISTS;
	}

	if(!ini_FileOpen) {
		return INI_ERR_NOT_OPEN;
	}

	new File:handle = fopen(ini_CurrentFileName, io_write);

	new ret = ini_write(handle, ini_KeyData, ini_ValData);

	ini_close();

	return ret;
}

stock ini_close() {
	if(!ini_FileOpen) {
		return INI_ERR_NOT_OPEN;
	}

	ini_FileOpen = false;

	return 0;
}

stock ini_is_open() {
	return ini_FileOpen;
}