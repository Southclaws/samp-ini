// writes a set of keys and values to the given file handle encoded in key=value format
stock ini_write(File:handle, Map:map) {
	new records = MAP_count(map);

	if(records >= MAX_RECORDS - 1) {
		Logger_Err("attempt to write ini cache with too many records",
			Logger_I("records", records));
		records = MAX_RECORDS - 1;
	}

	Logger_Dbg("ini", "writing ini", Logger_I("records", records));

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

		Logger_Dbg("ini", "wrote record",
			Logger_S("key", key),
			Logger_S("value", val));
	}

	return 0;
}
