#if defined _ini_included
	#endinput
#endif
#define _ini_included

#include <a_samp>
#include <logger>


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
		err("attempt to open ini while file already open", _s("filename", filename));
		return INI_ERR_OPEN;
	}

	new ret;

	if(fexist(filename)) {
		new File:handle = fopen(filename, io_read);
		if(!handle) {
			err("failed to open file for reading", _s("filename", ini_fileName));
			return INI_ERR_IO_FAIL;
		}

		ret = ini_parse(handle, ini_recordsRead);
		fclose(handle);
	} else {
		ini_recordsRead = 0;
	}

	_ini_strcpy(ini_fileName, filename, len);
	ini_fileOpen = true;

	return ret;
}

stock ini_commit() {
	if(!ini_fileOpen) {
		err("attempt to commit ini with no open file");
		return INI_ERR_NOT_OPEN;
	}

	new File:handle = fopen(ini_fileName, io_write);
	if(!handle) {
		err("failed to open file for writing", _s("filename", ini_fileName));
		return INI_ERR_IO_FAIL;
	}

	dbg("ini", "writing records",
		_i("read", ini_recordsRead),
		_i("added", ini_recordsAdded));

	new ret = ini_write(handle, ini_recordsRead + ini_recordsAdded);
	fclose(handle);

	ini_close();

	return ret;
}

stock ini_close() {
	if(!ini_fileOpen) {
		return INI_ERR_NOT_OPEN;
	}

	ini_fileOpen = false;
	ini_recordsRead = 0;
	ini_recordsAdded = 0;
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

_ini_sortByKey(left, right) {
	new
		tmp_left = left,
		tmp_right = right,
		pivot = (left + right) / 2;

	while(tmp_left <= tmp_right) {
		while(strcmp(ini_cache[tmp_left][E_CACHE_KEY], ini_cache[pivot][E_CACHE_KEY]) < 0) {
			tmp_left++;
		}
		while(strcmp(ini_cache[tmp_left][E_CACHE_KEY], ini_cache[pivot][E_CACHE_KEY]) > 0) {
			tmp_right--;
		}
		if(tmp_left <= tmp_right) {
			_ini_swap(tmp_left, tmp_right);
			tmp_left++;
			tmp_right--;
		}
	}

	if(left < tmp_right) {
		_ini_sortByKey(left, tmp_right);
	}

	if(tmp_left < right) {
		_ini_sortByKey(tmp_left, right);
	}
}

_ini_swap(left, right) {
	new tmp[E_CACHE_STRUCT];

	_ini_strcpy(tmp[E_CACHE_KEY], ini_cache[left][E_CACHE_KEY], MAX_KEY_LENGTH);
	_ini_strcpy(tmp[E_CACHE_VALUE], ini_cache[left][E_CACHE_VALUE], MAX_VAL_LENGTH);

	_ini_strcpy(ini_cache[left][E_CACHE_KEY], ini_cache[right][E_CACHE_KEY], MAX_KEY_LENGTH);
	_ini_strcpy(ini_cache[left][E_CACHE_VALUE], ini_cache[right][E_CACHE_VALUE], MAX_VAL_LENGTH);

	_ini_strcpy(ini_cache[right][E_CACHE_KEY], ini_cache[left][E_CACHE_KEY], MAX_KEY_LENGTH);
	_ini_strcpy(ini_cache[right][E_CACHE_VALUE], ini_cache[left][E_CACHE_VALUE], MAX_VAL_LENGTH);
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
