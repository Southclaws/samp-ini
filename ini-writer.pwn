// writes a set of keys and values to the given file handle encoded in key=value format
ini_write(File:handle, cache[MAX_RECORDS][E_CACHE_STRUCT], records) {
	if(records >= MAX_RECORDS - 1) {
		err("attempt to write ini cache with too many records, data will be lost",
			_i("records", records));
		records = MAX_RECORDS - 1;
	} else if(records <= 0) {
		err("attempt to write ini cache with zero or negative amount of records",
			_i("records", records));
		return 1;
	}

	new
		buffer[MAX_RECORD_LENGTH],
		i = 0;

	while(i < records) {
		if(_ini_isNull(cache[i][E_CACHE_KEY]) && _ini_isNull(cache[i][E_CACHE_VALUE])) {
			continue;
		}

		if(cache[i][E_CACHE_DELETED]) {
			continue;
		}

		// if the key is null but the value is not, the record is a comment and not key-value data.
		if(_ini_isNull(cache[i][E_CACHE_KEY]) && !_ini_isNull(cache[i][E_CACHE_VALUE])) {
			_ini_strcpy(buffer, cache[i][E_CACHE_VALUE], MAX_RECORD_LENGTH);
		} else {
			format(buffer, MAX_RECORD_LENGTH, "%s=%s\n", cache[i][E_CACHE_KEY], cache[i][E_CACHE_VALUE]);
		}

		fwrite(handle, buffer);
		i++;
	}

	return 0;
}