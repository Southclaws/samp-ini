# samp-ini

[![https://shields.southcla.ws/badge/sampctl-samp--ini-2f2f2f.svg?style=for-the-badge](https://shields.southcla.ws/badge/sampctl-samp--ini-2f2f2f.svg?style=for-the-badge)](https://github.com/Southclaws/samp-ini)

A super simple and fast ini reader and writer Pawn package.

Not as feature rich as y_ini but has a simpler API. Suitable for configuration, cookies, small user systems, etc.

## Installation

Simply install to your project:

```bash
sampctl package install Southclaws/samp-ini
```

Include in your code and begin using the library:

```pawn
#include <ini>
```

## Usage

This library uses a simple open-modify-close design. Open an ini format file with `ini_open`, modify it with `ini_get*` and save it with `ini_commit`.

If you just need to read values, skip `ini_commit` and use `ini_close`.

### Reading

Below is an example of reading a string, integer and float value from a file with proper error handling, that looks like:

```ini
keyString=hello
keyInteger=3
keyFloat=3.3
```

```pawn
ini_open("file.ini");

new valueString[32];
new error = ini_getString("keyString", valueString);
if(error != 0) {
    err("failed to get ini value", _i("errorCode", error));
}

new valueInteger;
new error = ini_getInt("keyInteger", valueInteger);
if(error != 0) {
    err("failed to get ini value", _i("errorCode", error));
}

new Float:valueFloat;
new error = ini_getFloat("keyFloat", valueFloat);
if(error != 0) {
    err("failed to get ini value", _i("errorCode", error));
}

ini_close();
```

### Writing

Below is an example of writing a string, integer and float value to a file with proper error handling.

```pawn
ini_open("file.ini");

new valueString[32] = {"hello world"};
new error = ini_setString("keyString", valueString);
if(error != 0) {
    err("failed to set ini value", _i("errorCode", error));
}

new valueInteger = 5;
new error = ini_setInt("keyInteger", valueInteger);
if(error != 0) {
    err("failed to set ini value", _i("errorCode", error));
}

new Float:valueFloat = 5.5;
new error = ini_setFloat("keyFloat", valueFloat);
if(error != 0) {
    err("failed to set ini value", _i("errorCode", error));
}

ini_commit();
```

### More Examples

Please see the unit test script for examples of every function's usage. You can run these unit tests by simply using `sampctl package run --forceBuild --forceEnsure`.

## Testing

To test, simply run the package:

```bash
sampctl package run
```

And observe the y_testing unit test output
