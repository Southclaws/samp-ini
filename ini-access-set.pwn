stock ini_set_str(key[], value[]) {
	if(!ini_is_open()) {
		return INI_ERR_NOT_OPEN;
	}

	return 0;
}

stock ini_set_int(key[], value) {
	if(!ini_is_open()) {
		return INI_ERR_NOT_OPEN;
	}

	return 0;
}

stock ini_set_float(key[], Float:value) {
	if(!ini_is_open()) {
		return INI_ERR_NOT_OPEN;
	}

	return 0;
}
