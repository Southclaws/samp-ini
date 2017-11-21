#include "strcpy.pwn"


ini_parse(File:handle, keys[MAX_RECORDS][MAX_KEY_LENGTH], values[MAX_RECORDS][MAX_VAL_LENGTH]) {
	new
		i,
		endline,
		delim,
		offset,
		buffer[MAX_RECORD_LENGTH];

	while(fread(handle, buffer) && (i < MAX_RECORDS)) {

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
				if(buffer[delim + (offset - 1)] != '=' && buffer[delim + (offset - 1)] != ' ' && buffer[delim + (offset - 1)] != '\t') {
					break;
				}

				offset--;
			}

			ini_strcpy(keys[i], buffer, delim + offset + 1);

			offset = 0;
			while(offset < MAX_VAL_LENGTH) {
				if(buffer[delim + (offset)] != '=' && buffer[delim + (offset)] != ' ' && buffer[delim + (offset)] != '\t') {
					break;
				}

				offset++;
			}

			ini_strcpy(values[i], buffer[delim + offset], MAX_VAL_LENGTH);
		} else {
			keys[i][0] = 0;
			ini_strcpy(values[i], buffer, MAX_VAL_LENGTH);
		}

		i++;
	}

	return 0;
}