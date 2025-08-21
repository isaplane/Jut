
Insert_String_Array_Literal_As_Argument_Setup_Data :: struct
{
    target_file: string;
    write_file: string;
    workspace: Workspace;
}

insert_string_array_literal_as_argument_setup :: ()
{
    using setup := New(Insert_String_Array_Literal_As_Argument_Setup_Data);

    set_working_directory("tests/insert_string_array_literal_as_argument_tests/");
    workspace = compiler_create_workspace("target");
    options := get_build_options(workspace);
    options.output_type = .NO_OUTPUT;
    set_build_options(options, workspace);

    write_file = "string_array_write_file.jai";

    if file_exists(write_file) file_delete(write_file);

    context.setup_data = setup;
} @Setup

insert_string_array_literal_as_argument_teardown :: ()
{
    using setup := context.setup_data.(*Insert_String_Array_Literal_As_Argument_Setup_Data);
    defer free(setup);

    if file_exists(write_file) file_delete(write_file);
} @Teardown

// -----------------------------------------------------------------------------

Insert_String_Array_Literal_As_Argument_Test_Case :: struct
{
    parent_proc: string;
    target_proc: string;
    call_type: enum {SIMPLE_DECLARATION; COMPOUND_DECLARATION; ASSIGNMENT;};
    expected_file_string: string;
}

insert_string_array_literal_as_argument_tests: [] Insert_String_Array_Literal_As_Argument_Test_Case = .[
    .{parent_proc = "string_array_write_file_1",   target_proc = "string_array_write_string_1", call_type = .SIMPLE_DECLARATION, expected_file_string = "Found lvalues [\"foo\"]!\n"},
    .{parent_proc = "string_array_write_file_2",   target_proc = "string_array_write_string_2", call_type = .COMPOUND_DECLARATION, expected_file_string = "Found lvalues [\"foo\", \"bar\"]!\n"},
];

insert_string_array_literal_as_argument_test :: (c: Insert_String_Array_Literal_As_Argument_Test_Case)
{
    using setup := context.setup_data.(*Insert_String_Array_Literal_As_Argument_Setup_Data);

    compiler_begin_intercept(workspace);

    add_build_file("target.jai", workspace);

    while true
    {
        message := compiler_wait_for_message();
        if message.kind ==
        {
            case .TYPECHECKED;
            {
                tc := cast(*Message_Typechecked) message;
                procs := ASTist.find_procedure_decl_by_name_from_message(tc, c.parent_proc);

                if procs.count == 0 continue;

                assert(procs.count == 1);
                proc := procs[0];
                
                if ASTist.proc_has_been_modified(proc) continue;

                results := ASTist.find_procedure_calls_by_name(proc, c.target_proc);

                if c.call_type ==
                {
                    case .SIMPLE_DECLARATION;
                    {
                        assert(results.simple_declarations.count == 1);

                        decl := results.simple_declarations[0];
                        call := decl.expression.(*Code_Procedure_Call);

                        ident := ASTist.get_lvalue_from_simple_declaration(decl);
                        new_call := ASTist.insert_string_array_literal_as_argument(call, ident.name);

                        call.* = new_call;
                    }

                    case .COMPOUND_DECLARATION;
                    {
                        assert(results.compound_declarations.count == 1);

                        decl := results.compound_declarations[0];
                        call := decl.declaration_properties.expression.(*Code_Procedure_Call);

                        idents := ASTist.get_lvalues_from_compound_declaration(decl);
                        new_call := ASTist.insert_string_array_literal_as_argument(call, ..Array_Helpers.map(idents, x => x.name));

                        call.* = new_call;
                    }
                }

                compiler_modify_procedure(workspace, proc);
                add_build_string(tprint("#run %();\n", c.parent_proc), workspace);
            }

            case .COMPLETE; break;
        }
    }

    compiler_end_intercept(workspace);

    file, ok_open := file_open(write_file);
    Verifai.is_true(ok_open);

    contents, ok_read := read_entire_file(file);
    Verifai.is_true(ok_read);

    Verifai.are_equal(c.expected_file_string, contents);
} @Test

#scope_file
ASTist  :: #import "ASTist";
Verifai :: #import "Verifai";
Array_Helpers :: #import "Array_Helpers";
#import "Compiler";
#import "File_Utilities";
#import "Basic";
