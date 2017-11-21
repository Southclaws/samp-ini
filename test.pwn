#define RUN_TESTS

#include <YSI\y_testing>
#include "ini.inc"

Test:OpenNew() {
    new ret = ini_open("tests/OpenNew.ini");
    ASSERT(ret == 0);

    ret = ini_close();
    ASSERT(ret == 0);
}

Test:OpenExisting() {
    new ret = ini_open("tests/OpenExisting.ini");
    ASSERT(ret == 0);

    ret = ini_close();
    ASSERT(ret == 0);
}

Test:OpenSetCommit() {
    new ret = ini_open("tests/OpenSetIntCommit.ini");
    ASSERT(ret == 0);

    ini_set_str("key", "value");
    ini_set_int("key", 1);
    ini_set_float("key", 1.1);

    ret = ini_commit();
    ASSERT(ret == 0);
}


Test:OpenGetClose() {
    new ret = ini_open("tests/OpenSetIntCommit.ini");
    ASSERT(ret == 0);

    new str[128];
    ini_get_str("key", str);

    new int;
    ini_get_int("key", int);

    new Float:flt;
    ini_get_float("key", flt);

    ret = ini_close();
    ASSERT(ret == 0);
}
