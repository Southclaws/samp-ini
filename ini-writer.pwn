// writes a set of keys and values to the given file handle encoded in key=value format
ini_write(File:handle, records) {
	if(records >= MAX_RECORDS - 1) {
		err("attempt to write ini cache with too many records, data will be lost",
			_i("records", records));
		records = MAX_RECORDS - 1;
	} else if(records <= 0) {
		err("attempt to write ini cache with zero or negative amount of records",
			_i("records", records));
		return 1;
	}

	new buffer[MAX_RECORD_LENGTH];

	dbg("ini", "writing cached records", _i("records", records));
	for(new i; i < records; ++i) {
		dbg("ini", "record",
			_i("index", i),
			_s("key", ini_cache[i][E_CACHE_KEY]),
			_s("value", ini_cache[i][E_CACHE_VALUE]));

		if(_ini_isNull(ini_cache[i][E_CACHE_KEY]) || _ini_isNull(ini_cache[i][E_CACHE_VALUE])) {
			continue;
		}

		if(ini_cache[i][E_CACHE_DELETED]) {
			continue;
		}

		format(buffer, MAX_RECORD_LENGTH, "%s=%s\n", ini_cache[i][E_CACHE_KEY], ini_cache[i][E_CACHE_VALUE]);
		fwrite(handle, buffer);

		dbg("ini", "wrote record",
			_i("index", i),
			_s("key", ini_cache[i][E_CACHE_KEY]),
			_s("value", ini_cache[i][E_CACHE_VALUE]),
			_s("buffer", buffer));
	}

	return 0;
}