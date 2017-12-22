// parse the given file handle as key=value format writing output to the given destinations
ini_parse(File:handle, &records) {
	new
		endline,
		delim,
		offset,
		buffer[MAX_RECORD_LENGTH];

	while(fread(handle, buffer) && (records < MAX_RECORDS)) {

		// Checks if the file has CRLF, LF or is just a single-line file.
		// first, search for a \r since with CRLF files they come first
		endline = strfind(buffer, "\r");
		if(endline == -1) {
			// if no CR found, it's probably a LF file
			endline = strfind(buffer, "\n");
			if(endline == -1) {
				// if no LF found, it's a single-line file
				endline = strlen(buffer);
			}
		}

		// chomp the line ending
		buffer[endline] = EOS;

		// find the delimiter position
		delim = strfind(buffer, "=");

		if(delim != -1) {
			offset = 0;
			while(offset > -delim) {
				if(
					buffer[delim + (offset - 1)] != '=' && // if the char is not the delimiter
					buffer[delim + (offset - 1)] != ' ' && // and it's not whitespce
					buffer[delim + (offset - 1)] != '\t' // or a tab,
				) {
					break; // we have the offset from the delimiter to the actual key
				}

				offset--;
			}

			_ini_strcpy(ini_cache[records][E_CACHE_KEY], buffer, delim + offset + 1);

			offset = 0;
			while(offset < MAX_VAL_LENGTH) {
				if(
					buffer[delim + (offset)] != '=' &&
					buffer[delim + (offset)] != ' ' &&
					buffer[delim + (offset)] != '\t'
				) {
					break;
				}

				offset++;
			}

			_ini_strcpy(ini_cache[records][E_CACHE_VALUE], buffer[delim + offset], MAX_VAL_LENGTH);
			ini_cache[records][E_CACHE_DELETED] = false;

			dbg("ini", "read record",
				_i("record", records),
				_s("key", ini_cache[records][E_CACHE_KEY]),
				_s("value", ini_cache[records][E_CACHE_VALUE]));

			records++;
		}
	}

	return 0;
}
