stock bool:ini_is_key(key[]) {
	if(!ini_is_open()) {
		return false;
	}

	return false;
}

stock ini_remove(key[]) {
	if(!ini_is_open()) {
		return INI_ERR_NOT_OPEN;
	}

	return 0;
}
