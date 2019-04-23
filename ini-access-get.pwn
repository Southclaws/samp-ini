stock ini_getString(const key[], dest[], len = sizeof(dest)) {
	if(!ini_isOpen()) {
		return INI_ERR_NOT_OPEN;
	}

	if(!MAP_contains_str(ini_cache, key)) {
		return INI_ERR_NO_KEY;
	}
	MAP_get_str_arr(ini_cache, key, dest, len);

	return 0;
}

stock ini_getInt(const key[], &dest) {
	if(!ini_isOpen()) {
		return INI_ERR_NOT_OPEN;
	}

	new str[12];
	if(!MAP_contains_str(ini_cache, key)) {
		return INI_ERR_NO_KEY;
	}
	MAP_get_str_arr(ini_cache, key, str);

	dest = strval(str);

	return 0;
}

stock ini_getFloat(const key[], &Float:dest) {
	if(!ini_isOpen()) {
		return INI_ERR_NOT_OPEN;
	}

	new str[12];
	if(!MAP_contains_str(ini_cache, key)) {
		return INI_ERR_NO_KEY;
	}
	MAP_get_str_arr(ini_cache, key, str);

	dest = floatstr(str);

	return 0;
}
