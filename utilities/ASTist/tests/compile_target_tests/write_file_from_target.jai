write_file_from_target_main :: ()
{
    print("Hello from write_file_from_target\n");
}

write_file :: (filename: string, file_string: string)
{
    write_entire_file(filename, file_string);    
}

#scope_file
#import "File";
#import "Basic";
