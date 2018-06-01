// writes a set of keys and values to the given file handle encoded in key=value format
stock ini_write(File:handle, Map:map) {
	new records = MAP_count(map);

	if(records >= MAX_RECORDS - 1) {
		err("attempt to write ini cache with too many records",
			_i("records", records));
		records = MAX_RECORDS - 1;
	}

	dbg("ini", "writing ini", _i("records", records));

	new
		key[MAX_KEY_LENGTH],
		val[MAX_VAL_LENGTH],
		keySize,
		valSize,
		buffer[MAX_RECORD_LENGTH];

	MAP_foreach(k => v : map) {
		keySize = MEM_get_size(k);
		valSize = MEM_get_size(v);

		MEM_get_arr(k, _, key, keySize);
		MEM_get_arr(v, _, val, valSize);

		format(buffer, MAX_RECORD_LENGTH, "%s=%s\n", key, val);
		fwrite(handle, buffer);

		dbg("ini", "wrote record",
			_s("key", key),
			_s("value", val));
	}

	return 0;
}
