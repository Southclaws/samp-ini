stock ini_get_str(key[], dest[], len = sizeof(dest)) {
	if(!ini_is_open()) {
		return INI_ERR_NOT_OPEN;
	}

	return 0;
}

stock ini_get_int(key[], &dest) {
	if(!ini_is_open()) {
		return INI_ERR_NOT_OPEN;
	}

	return 0;
}

stock ini_get_float(key[], &Float:dest) {
	if(!ini_is_open()) {
		return INI_ERR_NOT_OPEN;
	}

	return 0;
}
