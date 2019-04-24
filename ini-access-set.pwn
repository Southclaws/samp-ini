stock ini_setString(const key[], const value[]) {
	if(!ini_isOpen()) {
		return INI_ERR_NOT_OPEN;
	}

	MAP_insert_str_str(ini_cache, key, value);

	return 0;
}

stock ini_setInt(const key[], value) {
	if(!ini_isOpen()) {
		return INI_ERR_NOT_OPEN;
	}

	new valueString[MAX_VAL_LENGTH];
	format(valueString, MAX_VAL_LENGTH, "%d", value);
	MAP_insert_str_str(ini_cache, key, valueString);

	return 0;
}

stock ini_setFloat(const key[], Float:value) {
	if(!ini_isOpen()) {
		return INI_ERR_NOT_OPEN;
	}

	new valueString[MAX_VAL_LENGTH];
	format(valueString, MAX_VAL_LENGTH, "%f", value);
	MAP_insert_str_str(ini_cache, key, valueString);

	return 0;
}
