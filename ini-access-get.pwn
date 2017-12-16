stock ini_getStr(key[], dest[], len = sizeof(dest)) {
	if(!ini_isOpen()) {
		return INI_ERR_NOT_OPEN;
	}

	return 0;
}

stock ini_getInt(key[], &dest) {
	if(!ini_isOpen()) {
		return INI_ERR_NOT_OPEN;
	}

	if(_ini_getIdx(key, ini_cache, ini_recordsRead) == -1) {
		return INI_ERR_NO_KEY;
	} else {
		dest = strval(ini_cache[ini_recordsAdded][E_CACHE_VALUE]);
	}

	return 0;
}

stock ini_getFloat(key[], &Float:dest) {
	if(!ini_isOpen()) {
		return INI_ERR_NOT_OPEN;
	}

	return 0;
}
