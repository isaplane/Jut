compiler_test_arr_backing :: ()
{
    Queue   :: #import "Queue";
    Verifai.is_true(true);
} @Test

//-----------------------------------------------------------------------------------------------

compiler_test_ll_backing :: ()
{
    Queue   :: #import "Queue"(USE_LL_BACKING = true);
    Verifai.is_true(true);
} @Test

#scope_file
Verifai :: #import "Verifai";
