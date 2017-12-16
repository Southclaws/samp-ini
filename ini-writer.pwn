// writes a set of keys and values to the given file handle encoded in key=value format
ini_write(File:handle, keys[MAX_RECORDS][MAX_KEY_LENGTH], values[MAX_RECORDS][MAX_VAL_LENGTH]) {
	new
		buffer[MAX_RECORD_LENGTH],
		i = 0;

	while(i < MAX_RECORDS) {
		// if the key is null and the value is null, we've reached the end of the available records.
		if(_ini_isNull(keys[i]) && _ini_isNull(values[i])) {
			break;
		}

		// record has been marked to skip
		if(keys[i][0] == 0x1E) {
			continue;
		}

		// if the key is null but the value is not, the record is a comment and not key-value data.
		if(_ini_isNull(keys[i]) && !_ini_isNull(values[i])) {
			_ini_strcpy(buffer, values[i], MAX_RECORD_LENGTH);
		} else {
			format(buffer, MAX_RECORD_LENGTH, "%s=%s\n", keys[i], values[i]);
		}

		fwrite(handle, buffer);
		i++;
	}

	return 0;
}