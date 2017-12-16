stock ini_setStr(key[], value[]) {
	if(!ini_isOpen()) {
		return INI_ERR_NOT_OPEN;
	}

	return 0;
}

stock ini_setInt(key[], value) {
	if(!ini_isOpen()) {
		return INI_ERR_NOT_OPEN;
	}

	new
		idx = _ini_getIdx(key, ini_cache, ini_recordsRead),
		valueString[MAX_VAL_LENGTH];

	format(valueString, MAX_VAL_LENGTH, "%d", value);

	if(idx == -1) {
		_ini_strcpy(ini_cache[idx][E_CACHE_VALUE], valueString, MAX_VAL_LENGTH);
	} else {
		_ini_strcpy(ini_cache[ini_recordsAdded][E_CACHE_KEY], valueString, MAX_KEY_LENGTH);
		_ini_strcpy(ini_cache[ini_recordsAdded][E_CACHE_VALUE], valueString, MAX_VAL_LENGTH);
		ini_recordsAdded++;
	}

	return 0;
}

stock ini_setFloat(key[], Float:value) {
	if(!ini_isOpen()) {
		return INI_ERR_NOT_OPEN;
	}

	return 0;
}
