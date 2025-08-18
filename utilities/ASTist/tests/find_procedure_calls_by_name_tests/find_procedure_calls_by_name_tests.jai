Find_Procedure_Calls_By_Name_Setup_Data :: struct
{
    target_file: string;
    workspace: Workspace;
}

find_procedure_calls_by_name_setup :: ()
{
    using setup := New(Find_Procedure_Calls_By_Name_Setup_Data);

    workspace = compiler_create_workspace("target");
    options := get_build_options(workspace);
    options.output_type = .NO_OUTPUT;
    set_build_options(options, workspace);

    target_file = "target.jai";

    context.setup_data = setup;
} @Setup

find_procedure_calls_by_name_teardown :: ()
{
    using setup := context.setup_data.(*Find_Procedure_Calls_By_Name_Setup_Data);
    defer free(setup);
} @Teardown

// -----------------------------------------------------------------------------

Find_Procedure_Calls_By_Name_Test_Case :: struct
{
    parent_proc: string;
    target_proc: string;

    found_calls_count: struct
    {
        simple_decls:   int;
        compound_decls:   int;
        assigns: int;
        calls:   int;
    };
}

find_procedure_calls_by_name_test_cases: [] Find_Procedure_Calls_By_Name_Test_Case = .[
    .{parent_proc = "find_procedure_calls_by_name_layout", target_proc = "find_procedure_calls_by_name_cut_rect", found_calls_count = .{0, 3, 0, 0}},
    .{parent_proc = "find_procedure_calls_by_name_second_layout", target_proc = "find_procedure_calls_by_name_check_rect", found_calls_count = .{0, 0, 0, 3}},
    .{parent_proc = "find_procedure_calls_by_name_third_layout", target_proc = "find_procedure_calls_by_name_return_rect", found_calls_count = .{0, 0, 3, 0}},
    .{parent_proc = "find_procedure_calls_by_name_fourth_layout", target_proc = "find_procedure_calls_by_name_cut_rect", found_calls_count = .{0, 3, 0, 0}},
    .{parent_proc = "find_procedure_calls_by_name_fifth_layout", target_proc = "find_procedure_calls_by_name_cut_rect", found_calls_count = .{0, 3, 0, 0}},
    .{parent_proc = "find_procedure_calls_by_name_sixth_layout", target_proc = "find_procedure_calls_by_name_return_rect", found_calls_count = .{3, 0, 0, 0}},
];

find_procedure_calls_by_name_test :: (c: Find_Procedure_Calls_By_Name_Test_Case)
{
    using setup := context.setup_data.(*Find_Procedure_Calls_By_Name_Setup_Data);

    compiler_begin_intercept(workspace);
    add_build_file(target_file, workspace);

    all_procs: [..] *Code_Procedure_Body;
    while true
    {
        message := compiler_wait_for_message();
        if message.kind ==
        {
            case .TYPECHECKED;
            {
                tc := cast(*Message_Typechecked) message;
                procs := ASTist.find_procedure_decl_by_name_from_message(tc, c.parent_proc);
                array_add(*all_procs, ..procs);
            }                

            case .PHASE;
            {
                phase_message := cast (*Message_Phase) message;
                phase := phase_message.phase;

                if phase == .TYPECHECKED_ALL_WE_CAN 
                {
                    assert(all_procs.count == 1);
                    proc := all_procs[0];

                    results := ASTist.find_procedure_calls_by_name(proc, c.target_proc);

                    Verifai.are_equal(c.found_calls_count.simple_decls, results.simple_declarations.count);
                    Verifai.are_equal(c.found_calls_count.compound_decls, results.compound_declarations.count);
                    Verifai.are_equal(c.found_calls_count.assigns, results.assignments.count);
                    Verifai.are_equal(c.found_calls_count.calls, results.calls.count);
                }
            }

            case .COMPLETE; break;
        }
    }

    compiler_end_intercept(workspace);
} @Test

#scope_file

#import "Basic";
#import "Compiler";
Verifai :: #import "Verifai";
ASTist  :: #import "ASTist";
