#define RUN_TESTS
#define LIGHT_TEST_REPORT

#include "ini.inc"
#include <YSI\y_testing>

Test:OpenNew() {
	logger_debug("ini", true);

	new open_ret = ini_open("OpenNew.ini");
	ASSERT(open_ret == 0);

	new close_ret = ini_close();
	ASSERT(close_ret == 0);
}

makeRecord(k[], v[], d) {
	new result[E_CACHE_STRUCT];
	strcat(result[E_CACHE_KEY], k, MAX_KEY_LENGTH);
	strcat(result[E_CACHE_VALUE], v, MAX_VAL_LENGTH);
	result[E_CACHE_DELETED] = d;
	return result;
}

new TEST_CACHE[MAX_RECORDS][E_CACHE_STRUCT];

Test:BinarySearchSuccess() {
	TEST_CACHE[0] = makeRecord("key1", "value1", 0);
	TEST_CACHE[1] = makeRecord("key2", "value2", 0);
	TEST_CACHE[2] = makeRecord("key3", "value3", 0);
	TEST_CACHE[3] = makeRecord("key4", "value4", 0);
	TEST_CACHE[4] = makeRecord("key5", "value5", 0);
	TEST_CACHE[5] = makeRecord("key6", "value6", 0);
	TEST_CACHE[6] = makeRecord("key7", "value7", 0);
	TEST_CACHE[7] = makeRecord("key8", "value8", 0);
	new records = 8;

	ASSERT(_ini_getIdx("key1", TEST_CACHE, records) == 0);
	ASSERT(_ini_getIdx("key2", TEST_CACHE, records) == 1);
	ASSERT(_ini_getIdx("key3", TEST_CACHE, records) == 2);
	ASSERT(_ini_getIdx("key4", TEST_CACHE, records) == 3);
	ASSERT(_ini_getIdx("key5", TEST_CACHE, records) == 4);
	ASSERT(_ini_getIdx("key6", TEST_CACHE, records) == 5);
	ASSERT(_ini_getIdx("key7", TEST_CACHE, records) == 6);
	ASSERT(_ini_getIdx("key8", TEST_CACHE, records) == 7);
}

Test:BinarySearchFail() {
	TEST_CACHE[0] = makeRecord("key1", "value1", 0);
	TEST_CACHE[1] = makeRecord("key2", "value2", 0);
	TEST_CACHE[2] = makeRecord("key3", "value3", 0);
	TEST_CACHE[3] = makeRecord("key4", "value4", 0);
	TEST_CACHE[4] = makeRecord("key5", "value5", 0);
	TEST_CACHE[5] = makeRecord("key6", "value6", 0);
	TEST_CACHE[6] = makeRecord("key7", "value7", 0);
	TEST_CACHE[7] = makeRecord("key8", "value8", 0);
	new records = 8;

	ASSERT(_ini_getIdx("KEY6", TEST_CACHE, records) == -1);
	ASSERT(_ini_getIdx("key9", TEST_CACHE, records) == -1);
	ASSERT(_ini_getIdx("", TEST_CACHE, records) == -1);
}

Test:SetNewInt() {
	printf("\n\n- SetNewInt\n\n");

	ASSERT(ini_open("SetNewInt.ini") == 0);
	ASSERT(ini_setInt("key", 1) == 0);
	ASSERT(ini_commit() == 0);

	ASSERT(fexist("SetNewInt.ini") == 1);

	new int;

	ASSERT(ini_open("SetNewInt.ini") == 0);
	ASSERT(ini_isKey("key") == 1);
	ASSERT(ini_getInt("key", int) == 0);
	ASSERT(int == 1);
	ASSERT(ini_close() == 0);

	fremove("SetNewInt.ini");
}

Test:SetExistingInt() {
	printf("\n\n- SetExistingInt\n\n");

	ASSERT(ini_open("SetExistingInt.ini") == 0);
	ASSERT(ini_setInt("key", 1) == 0);
	ASSERT(ini_commit() == 0);

	ASSERT(fexist("SetExistingInt.ini") == 1);

	ASSERT(ini_open("SetExistingInt.ini") == 0);
	ASSERT(ini_isKey("key") == 1);
	ASSERT(ini_setInt("key", 1000) == 0);
	ASSERT(ini_commit() == 0);

	new int;

	ASSERT(ini_open("SetExistingInt.ini") == 0);
	ASSERT(ini_isKey("key") == 1);
	ASSERT(ini_getInt("key", int) == 0);
	ASSERT(int == 1000);
	ASSERT(ini_close() == 0);

	fremove("SetExistingInt.ini");
}

Test:SetMultipleInts() {
	printf("\n\n- SetMultipleInts\n\n");

	ASSERT(ini_open("SetMultipleInts.ini") == 0);
	ASSERT(ini_setInt("key1", 1) == 0);
	ASSERT(ini_setInt("key2", 2) == 0);
	ASSERT(ini_setInt("key3", 3) == 0);
	ASSERT(ini_commit() == 0);

	ASSERT(fexist("SetMultipleInts.ini") == 1);

	new int;

	ASSERT(ini_open("SetMultipleInts.ini") == 0);

	ASSERT(ini_isKey("key1") == 1);
	ASSERT(ini_getInt("key1", int) == 0);
	ASSERT(int == 1);

	ASSERT(ini_isKey("key2") == 1);
	ASSERT(ini_getInt("key2", int) == 0);
	ASSERT(int == 2);

	ASSERT(ini_isKey("key3") == 1);
	ASSERT(ini_getInt("key3", int) == 0);
	ASSERT(int == 3);

	ASSERT(ini_close() == 0);

	fremove("SetMultipleInts.ini");
}

Test:SetNewFloat() {
	printf("\n\n- SetNewFloat\n\n");

	ASSERT(ini_open("SetNewFloat.ini") == 0);
	ASSERT(ini_setFloat("key", 1.5) == 0);
	ASSERT(ini_commit() == 0);

	ASSERT(fexist("SetNewFloat.ini") == 1);

	new Float:val;

	ASSERT(ini_open("SetNewFloat.ini") == 0);
	ASSERT(ini_isKey("key") == 1);
	ASSERT(ini_getFloat("key", val) == 0);
	ASSERT(val == 1.5);
	ASSERT(ini_close() == 0);

	fremove("SetNewFloat.ini");
}

Test:SetExistingFloat() {
	printf("\n\n- SetExistingFloat\n\n");

	ASSERT(ini_open("SetExistingFloat.ini") == 0);
	ASSERT(ini_setFloat("key", 1.5) == 0);
	ASSERT(ini_commit() == 0);

	ASSERT(fexist("SetExistingFloat.ini") == 1);

	ASSERT(ini_open("SetExistingFloat.ini") == 0);
	ASSERT(ini_isKey("key") == 1);
	ASSERT(ini_setFloat("key", 1000.5) == 0);
	ASSERT(ini_commit() == 0);

	new Float:val;

	ASSERT(ini_open("SetExistingFloat.ini") == 0);
	ASSERT(ini_isKey("key") == 1);
	ASSERT(ini_getFloat("key", val) == 0);
	ASSERT(val == 1000.5);
	ASSERT(ini_close() == 0);

	fremove("SetExistingFloat.ini");
}

Test:SetMultipleFloats() {
	printf("\n\n- SetMultipleFloats\n\n");

	ASSERT(ini_open("SetMultipleFloats.ini") == 0);
	ASSERT(ini_setFloat("key1", 1.5) == 0);
	ASSERT(ini_setFloat("key2", 2.5) == 0);
	ASSERT(ini_setFloat("key3", 3.5) == 0);
	ASSERT(ini_commit() == 0);

	ASSERT(fexist("SetMultipleFloats.ini") == 1);

	new Float:val;

	ASSERT(ini_open("SetMultipleFloats.ini") == 0);

	ASSERT(ini_isKey("key1") == 1);
	ASSERT(ini_getFloat("key1", val) == 0);
	ASSERT(val - 1.5 < 0.0001);

	ASSERT(ini_isKey("key2") == 1);
	ASSERT(ini_getFloat("key2", val) == 0);
	ASSERT(val - 2.5 < 0.0001);

	ASSERT(ini_isKey("key3") == 1);
	ASSERT(ini_getFloat("key3", val) == 0);
	ASSERT(val - 3.5 < 0.0001);

	ASSERT(ini_close() == 0);

	fremove("SetMultipleFloats.ini");
}

Test:SetNewString() {
	printf("\n\n- SetNewString\n\n");

	ASSERT(ini_open("SetNewString.ini") == 0);
	ASSERT(ini_setString("key", "Value") == 0);
	ASSERT(ini_commit() == 0);

	ASSERT(fexist("SetNewString.ini") == 1);

	new val[128];

	ASSERT(ini_open("SetNewString.ini") == 0);
	ASSERT(ini_isKey("key") == 1);
	ASSERT(ini_getString("key", val) == 0);
	ASSERT(strcmp(val, "Value") == 0);
	ASSERT(ini_close() == 0);

	fremove("SetNewString.ini");
}

Test:SetExistingString() {
	printf("\n\n- SetExistingString\n\n");

	ASSERT(ini_open("SetExistingString.ini") == 0);
	ASSERT(ini_setString("key", "Value") == 0);
	ASSERT(ini_commit() == 0);

	ASSERT(fexist("SetExistingString.ini") == 1);

	ASSERT(ini_open("SetExistingString.ini") == 0);
	ASSERT(ini_setString("key", "Valyew") == 0);
	ASSERT(ini_commit() == 0);

	new val[128];

	ASSERT(ini_open("SetExistingString.ini") == 0);
	ASSERT(ini_isKey("key") == 1);
	ASSERT(ini_getString("key", val) == 0);
	ASSERT(strcmp(val, "Valyew") == 0);
	ASSERT(ini_close() == 0);

	fremove("SetExistingString.ini");
}

Test:SetMultipleStrings() {
	printf("\n\n- SetMultipleStrings\n\n");

	ASSERT(ini_open("SetMultipleStrings.ini") == 0);
	ASSERT(ini_setString("key1", "Value1") == 0);
	ASSERT(ini_setString("key2", "Value2") == 0);
	ASSERT(ini_setString("key3", "Value3") == 0);
	ASSERT(ini_commit() == 0);

	ASSERT(fexist("SetMultipleStrings.ini") == 1);

	new val[128];

	ASSERT(ini_open("SetMultipleStrings.ini") == 0);

	ASSERT(ini_isKey("key1") == 1);
	ASSERT(ini_getString("key1", val) == 0);
	ASSERT(strcmp(val, "Value1") == 0);

	ASSERT(ini_isKey("key2") == 1);
	ASSERT(ini_getString("key2", val) == 0);
	ASSERT(strcmp(val, "Value2") == 0);

	ASSERT(ini_isKey("key3") == 1);
	ASSERT(ini_getString("key3", val) == 0);
	ASSERT(strcmp(val, "Value3") == 0);

	ASSERT(ini_close() == 0);

	fremove("SetMultipleStrings.ini");
}

Test:SetAndDelete() {
	printf("\n\n- SetAndDelete\n\n");

	ASSERT(ini_open("SetAndDelete.ini") == 0);
	ASSERT(ini_setString("key", "Value") == 0);
	ASSERT(ini_commit() == 0);

	ASSERT(fexist("SetAndDelete.ini") == 1);

	ASSERT(ini_open("SetAndDelete.ini") == 0);
	ASSERT(ini_remove("key") == 0);
	ASSERT(ini_commit() == 0);

	ASSERT(ini_open("SetAndDelete.ini") == 0);
	ASSERT(ini_isKey("key") == 0);
	ASSERT(ini_close() == 0);

	fremove("SetAndDelete.ini");
}
