Check_Decl_For_Note_Setup_Data :: struct
{
    target_file: string;
    workspace: Workspace;
}

check_struct_for_note_setup :: ()
{
    using setup := New(Check_Decl_For_Note_Setup_Data);

    workspace = compiler_create_workspace("target");
    options := get_build_options(workspace);
    options.output_type = .NO_OUTPUT;
    set_build_options(options, workspace);

    target_file = "target.jai";

    context.setup_data = setup;
} @Setup

check_decl_for_note_teardown :: ()
{
    using setup := context.setup_data.(*Check_Decl_For_Note_Setup_Data);
    defer free(setup);
} @Teardown

// -----------------------------------------------------------------------------

Check_Decl_For_Note_Test_Case :: struct
{
    target_note: string;
    expected_decl_names: [] string;
}

check_decl_for_note_test_cases: [] Check_Decl_For_Note_Test_Case = .[
    .{target_note = "Isa", expected_decl_names = .["Isa_Struct"]},
    .{target_note = "Bake", expected_decl_names = .["foo"]},
];

check_decl_for_note_tests :: (c: Check_Decl_For_Note_Test_Case)
{
    using setup := context.setup_data.(*Check_Decl_For_Note_Setup_Data);

    compiler_begin_intercept(workspace);
    add_build_file(target_file, workspace);

    found_decls: [..] *Code_Declaration;
    while true
    {
        message := compiler_wait_for_message();
        if message.kind ==
        {
            case .TYPECHECKED;
            {
                tc := cast(*Message_Typechecked) message;
                for d_tc: tc.declarations
                {
                    d := d_tc.expression;
                    found_decl := ASTist.check_decl_for_note(d, c.target_note, *found_decls);
                    // if d.notes.count > 0 print("Notes: %\n", Array_Helpers.map(d.notes, n => n.text));
                }

                bodies := ASTist.find_procedure_decl_by_name_from_message(tc, "check_decl_for_note_layout");
                for block: Array_Helpers.map(bodies, b => b.block)
                {
                    for stmt: block.statements
                    {
                        if stmt.kind == .DECLARATION
                        {
                            decl := cast(*Code_Declaration) stmt;
                            found_decl := ASTist.check_decl_for_note(decl, c.target_note, *found_decls);
                        }
                    }
                }
            }

            case .PHASE;
            {
                phase := message.(*Message_Phase).phase;
                if phase == 
                {
                    case .TYPECHECKED_ALL_WE_CAN;
                    {
                        found_decl_names := Array_Helpers.map(found_decls, d => d.name);
                        comparator := #procedure_of_call Array_Helpers.arrays_are_equal(string.[], string.[]);
                        Verifai.are_equal(found_decl_names, c.expected_decl_names, comparator);
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
