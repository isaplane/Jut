Check_Struct_For_Note_Setup_Data :: struct
{
    target_file: string;
    workspace: Workspace;
}

check_decl_for_note_setup :: ()
{
    using setup := New(Check_Struct_For_Note_Setup_Data);

    workspace = compiler_create_workspace("target");
    options := get_build_options(workspace);
    options.output_type = .NO_OUTPUT;
    set_build_options(options, workspace);

    target_file = "target.jai";

    context.setup_data = setup;
} @Setup

check_struct_for_note_teardown :: ()
{
    using setup := context.setup_data.(*Check_Struct_For_Note_Setup_Data);
    defer free(setup);
} @Teardown

// -----------------------------------------------------------------------------

Check_Struct_For_Note_Test_Case :: struct
{
    target_note: string;
    expected_structs: [] *Type_Info;
}

check_struct_for_note_test_cases: [] Check_Struct_For_Note_Test_Case = .[
    .{target_note = "Bake", expected_structs = .[type_info(Baked_Struct)]},
    .{target_note = "As", expected_structs = .[type_info(As_Struct)]},
];

check_struct_for_note_tests :: (c: Check_Struct_For_Note_Test_Case)
{
    using setup := context.setup_data.(*Check_Struct_For_Note_Setup_Data);

    compiler_begin_intercept(workspace);
    add_build_file(target_file, workspace);

    found_structs: [..] *Code_Struct;
    while true
    {
        message := compiler_wait_for_message();
        if message.kind ==
        {
            case .TYPECHECKED;
            {
                tc := cast(*Message_Typechecked) message;
                for s_tc: tc.structs
                {
                    s := s_tc.expression;
                    found_struct := ASTist.check_struct_for_note(s, c.target_note, *found_structs);
                }

            }

            case .PHASE;
            {
                phase := message.(*Message_Phase).phase;
                if phase == 
                {
                    case .TYPECHECKED_ALL_WE_CAN;
                    {
                        expected_struct_names := Array_Helpers.map(c.expected_structs, s => s.(*Type_Info_Struct).name);
                        found_struct_names := Array_Helpers.map(found_structs, s => s.defined_type.name);
                        comparator := #procedure_of_call Array_Helpers.arrays_are_equal(string.[], string.[]);
                        Verifai.are_equal(found_struct_names, expected_struct_names, comparator);
                    }
                }
            }

            case .COMPLETE; break;
        }
    }

    compiler_end_intercept(workspace);
} @Test

#scope_file
Verifai :: #import "Verifai";
ASTist  :: #import "ASTist";
Array_Helpers :: #import "Array_Helpers";
#import "Compiler";
