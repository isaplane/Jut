Write_File_From_Target_Setup_Data :: struct
{
    filename:   string;
    file_string: string;
    workspace:   Workspace;
}

write_file_from_target_setup_tests :: ()
{
    using setup := New(Write_File_From_Target_Setup_Data);

    workspace = compiler_create_workspace("target");
    options := get_build_options(workspace);
    options.output_type = .NO_OUTPUT;
    set_build_options(options, workspace);

    filename   = "write_file_from_target_generated.jai";
    file_string = "Hello from the test file!"; 

    if file_exists(filename) file_delete(filename);
    context.setup_data = setup;

} @Setup

write_file_from_target_teardown_tests :: ()
{
    using setup := context.setup_data.(*Write_File_From_Target_Setup_Data);
    defer free(setup);

    if file_exists(filename) file_delete(filename);
} @Teardown

write_file_from_target_no_file_test :: ()
{
    using setup := context.setup_data.(*Write_File_From_Target_Setup_Data);

    compiler_begin_intercept(workspace);
    compiler_end_intercept(workspace);

    Verifai.is_true(true);
} @Test

write_file_from_target_create_file_test :: ()
{
    using setup := context.setup_data.(*Write_File_From_Target_Setup_Data);

    compiler_begin_intercept(workspace);

    add_build_file("write_file_from_target.jai", workspace);
    add_build_string(tprint("#run write_file(\"%\", \"%\");\n", filename, file_string), workspace);

    while true
    {
        message := compiler_wait_for_message();
        if message.kind == .COMPLETE break;
    }

    compiler_end_intercept(workspace);

    file, ok_open := file_open(filename);
    Verifai.is_true(ok_open);

    contents, ok_read := read_entire_file(file);
    Verifai.is_true(ok_read);

    Verifai.are_equal(file_string, contents);
} @Test

#scope_file
Verifai :: #import "Verifai";
ASTist  :: #import "ASTist";
#import "Compiler";
#import "File";
#import "File_Utilities";

