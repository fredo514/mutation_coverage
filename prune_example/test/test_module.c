#include "module.h"
#include "unity.h"

void SetUp(void) {}

void TearDown(void) {}

void test_1(void) { 
    TEST_ASSERT_FALSE(is_adult(20)); 
    TEST_ASSERT_TRUE(is_adult(22)); 
    // TEST_ASSERT_TRUE(is_adult(21)); 
}