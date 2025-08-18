write_file_1 :: ()
{
    foo := write_string_1();
}

write_string_1 :: () -> bool
{
    print("This is not the procedure you are looking for!\n");
    return false;
}

write_string_1 :: (lvalue: string) -> bool
{
    write_entire_file("write_file.jai", tprint("Found lvalue %!\n", lvalue));
    return true;
}

#scope_file
#import "Basic";
#import "File";
