#if defined _strcpy_included
	#endinput
#endif
#define _strcpy_included

// strcpy - string copy implementation using strcat
ini_strcpy(dest[], const source[], maxlength=sizeof dest) {
	dest[0] = EOS;
	return strcat(dest, source, maxlength);
}
