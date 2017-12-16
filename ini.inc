#if defined _ini_included
	#endinput
#endif
#define _ini_included

#include <a_samp>
#include <logger>
#include <md-sort>


#define MAX_FILE_NAME       (256)
#define MAX_RECORDS         (999)
#define MAX_KEY_LENGTH      (64)
#define MAX_VAL_LENGTH      (512)
#define MAX_RECORD_LENGTH   (MAX_KEY_LENGTH + MAX_VAL_LENGTH + 2)

// Error values are non-zero positive
enum {
	INI_ERR_EXISTS = 1,
	INI_ERR_NOT_EXISTS,
	INI_ERR_OPEN,
	INI_ERR_NOT_OPEN,
	INI_ERR_IO_FAIL,
	INI_ERR_NO_KEY
}

forward ini_open(filename[], len = sizeof filename);
forward ini_commit();
forward ini_close();
forward ini_isOpen();
forward ini_isKey(key[]);
forward ini_remove(key[]);

forward ini_getStr(key[], dest[], len = sizeof(dest));
forward ini_getInt(key[], &dest);
forward ini_getFloat(key[], &Float:dest);

forward ini_setStr(key[], value[]);
forward ini_setInt(key[], value);
forward ini_setFloat(key[], Float:value);

enum E_CACHE_STRUCT {
	E_CACHE_KEY[MAX_KEY_LENGTH],
	E_CACHE_VALUE[MAX_VAL_LENGTH],
	E_CACHE_ORDER,
	E_CACHE_DELETED
}

new
	ini_fileName[MAX_FILE_NAME],
	ini_cache[MAX_RECORDS][E_CACHE_STRUCT],
	ini_recordsRead, // the amount of records read when parsing
	ini_recordsAdded, // the amount of new records written
	bool:ini_fileOpen;

#include "ini-parser.pwn"
#include "ini-writer.pwn"
#include "ini-access-get.pwn"
#include "ini-access-set.pwn"
#include "ini-misc.pwn"

stock ini_open(filename[], len = sizeof filename) {
	if(ini_fileOpen) {
		return INI_ERR_OPEN;
	}

	new
		File:handle,
		ret;

	if(fexist(filename)) {
		handle = fopen(filename, io_read);
		if(!handle) {
			return INI_ERR_IO_FAIL;
		}

		ret = ini_parse(handle, ini_cache, ini_recordsRead);
		fclose(handle);
	}

	SortDeepArray(ini_cache, E_CACHE_KEY);

	_ini_strcpy(ini_fileName, filename, len);
	ini_fileOpen = true;

	return ret;
}

stock ini_commit() {
	if(!ini_fileOpen) {
		return INI_ERR_NOT_OPEN;
	}

	new File:handle = fopen(ini_fileName, io_write);
	if(!handle) {
		return INI_ERR_IO_FAIL;
	}

	SortDeepArray(ini_cache, E_CACHE_ORDER);

	new ret = ini_write(handle, ini_cache, ini_recordsRead + ini_recordsAdded);

	ini_close();

	return ret;
}

stock ini_close() {
	if(!ini_fileOpen) {
		return INI_ERR_NOT_OPEN;
	}

	ini_fileOpen = false;

	return 0;
}

stock ini_isOpen() {
	return ini_fileOpen;
}

stock ini_isKey(key[]) {
	if(!ini_is_open()) {
		return false;
	}

	return false;
}

stock ini_remove(key[]) {
	if(!ini_is_open()) {
		return INI_ERR_NOT_OPEN;
	}

	return 0;
}

_ini_getIdx(key[], const cache[MAX_RECORDS][E_CACHE_STRUCT], records) {
	if(_ini_isNull(key)) {
		return -1;
	}

	new
		comp,
		start,
		middle,
		end = records - 1;

	while(start <= end) {
		middle = ((start + end) / 2);

		comp = strcmp(key, cache[middle][E_CACHE_KEY], false, MAX_KEY_LENGTH);

		if(comp == 0) {
			return middle;
		} else if(comp < 0) {
			end = middle - 1;
		} else {
			start = middle + 1;
		}
	}

	return -1;
}
