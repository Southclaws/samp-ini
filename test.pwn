#define RUN_TESTS

#include <YSI\y_testing>
#include "ini.inc"

Test:OpenNew() {
    new open_ret = ini_open("OpenNew.ini");
    ASSERT(open_ret == 0);

    new close_ret = ini_close();
    ASSERT(close_ret == 0);
}

Test:OpenSetCommit() {
    new open_ret = ini_open("OpenSetIntCommit.ini");
    ASSERT(open_ret == 0);

    ini_set_str("key", "value");
    ini_set_int("key", 1);
    ini_set_float("key", 1.1);

    new commit_ret = ini_commit();
    ASSERT(commit_ret == 0);
}

Test:OpenGetClose() {
    new ret = ini_open("OpenSetIntCommit.ini");
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
