#include "/usr/local/bundle/gems/ceedling-0.31.1/vendor/unity/src/unity.h"
#include "src/module.h"


void SetUp(void) {}



void TearDown(void) {}



void test_1(void) {

    do {if (!(is_adult(20))) {} else {UnityFail( ((" Expected FALSE Was TRUE")), (UNITY_UINT)((UNITY_UINT)(9)));}} while(0);

    do {if ((is_adult(22))) {} else {UnityFail( ((" Expected TRUE Was FALSE")), (UNITY_UINT)((UNITY_UINT)(10)));}} while(0);



}
