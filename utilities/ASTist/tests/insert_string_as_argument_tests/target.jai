write_file_1 :: ()
{
    foo := write_string_1(0);
}

write_string_1 :: (test_param: int) -> bool
{
    print("This is not the procedure you are looking for!\n");
    return false;
}

write_string_1 :: (test_param: int, lvalue: string) -> bool
{
    write_entire_file("write_file.jai", tprint("Found lvalue %!\n", lvalue));
    return true;
}

#scope_file
#import "Basic";
#import "File";
