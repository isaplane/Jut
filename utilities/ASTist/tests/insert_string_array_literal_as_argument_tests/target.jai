string_array_write_file_1 :: ()
{
    foo := string_array_write_string_1(0);
}

string_array_write_string_1 :: (test_param: int) -> bool
{
    print("This is not the procedure you are looking for!\n");
    return false;
}

string_array_write_string_1 :: (test_param: int, lvalues: [] string) -> bool
{
    print("Found lvalues!: %\n", lvalues);
    write_entire_file("string_array_write_file.jai", tprint("Found lvalues %!\n", lvalues));
    return true;
}

string_array_write_file_2 :: ()
{
    foo, bar := string_array_write_string_2(0);
}

string_array_write_string_2 :: (test_param: int) -> bool, bool
{
    print("This is not the procedure you are looking for!\n");
    return false, false;
}

string_array_write_string_2 :: (test_param: int, lvalues: [] string) -> bool, bool
{
    print("Found lvalues!: %\n", lvalues);
    write_entire_file("string_array_write_file.jai", tprint("Found lvalues %!\n", lvalues));
    return true, true;
}

#scope_file
#import "Basic";
#import "File";
