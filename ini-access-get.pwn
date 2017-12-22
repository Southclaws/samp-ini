stock ini_getString(key[], dest[], len = sizeof(dest)) {
	if(!ini_isOpen()) {
		return INI_ERR_NOT_OPEN;
	}

	new idx = _ini_getIdx(key, ini_cache, ini_recordsRead);

	if(idx == -1) {
		return INI_ERR_NO_KEY;
	}

	_ini_strcpy(dest, ini_cache[idx][E_CACHE_VALUE], len);

	return 0;
}

stock ini_getInt(key[], &dest) {
	if(!ini_isOpen()) {
		return INI_ERR_NOT_OPEN;
	}

	new idx = _ini_getIdx(key, ini_cache, ini_recordsRead);

	if(idx == -1) {
		return INI_ERR_NO_KEY;
	}

	dest = strval(ini_cache[idx][E_CACHE_VALUE]);

	return 0;
}

stock ini_getFloat(key[], &Float:dest) {
	if(!ini_isOpen()) {
		return INI_ERR_NOT_OPEN;
	}

	new idx = _ini_getIdx(key, ini_cache, ini_recordsRead);

	if(idx == -1) {
		return INI_ERR_NO_KEY;
	}

	dest = floatstr(ini_cache[idx][E_CACHE_VALUE]);

	return 0;
}
