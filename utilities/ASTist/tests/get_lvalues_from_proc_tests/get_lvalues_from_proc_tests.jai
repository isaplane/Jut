Get_Lvalues_From_Proc_Setup_Data :: struct
{
    target_file: string;
    workspace: Workspace;
}

get_lvalues_from_proc_setup :: ()
{
    using setup := New(Get_Lvalues_From_Proc_Setup_Data);

    workspace = compiler_create_workspace("target");
    options := get_build_options(workspace);
    options.output_type = .NO_OUTPUT;
    set_build_options(options, workspace);

    target_file = "target.jai";

    context.setup_data = setup;
} @Setup

get_lvalues_from_proc_teardown :: ()
{
    using setup := context.setup_data.(*Get_Lvalues_From_Proc_Setup_Data);
    defer free(setup);
} @Teardown

// -----------------------------------------------------------------------------

Get_LValues_From_Proc_Test_Case :: struct
{
    parent_proc: string;
    target_proc: string;
    call_type: enum {SIMPLE_DECLARATION; COMPOUND_DECLARATION; ASSIGNMENT;};
    expected_lvalues: [] string;
}

get_lvalues_from_proc_tests: [] Get_LValues_From_Proc_Test_Case = .[
    .{parent_proc = "layout",   target_proc = "cut_rect",   call_type = .COMPOUND_DECLARATION,  expected_lvalues = .["foo", "bar"]},
    .{parent_proc = "layout_2", target_proc = "cut_rect",   call_type = .COMPOUND_DECLARATION,  expected_lvalues = .["fuzz", "_"]},
    .{parent_proc = "layout_3", target_proc = "cut_rect",   call_type = .COMPOUND_DECLARATION,  expected_lvalues = .["fah", "baz"]},
    .{parent_proc = "layout_4", target_proc = "check_rect", call_type = .ASSIGNMENT,            expected_lvalues = .["fuh"]},
    .{parent_proc = "layout_5", target_proc = "check_rect", call_type = .SIMPLE_DECLARATION,    expected_lvalues = .["foh"]},
];

get_lvalues_from_proc_test :: (c: Get_LValues_From_Proc_Test_Case)
{
    using setup := context.setup_data.(*Get_Lvalues_From_Proc_Setup_Data);

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

                    if c.call_type == 
                    {
                        case .SIMPLE_DECLARATION;
                        {
                            assert(results.simple_declarations.count == 1);

                            ident := ASTist.get_lvalue_from_simple_declaration(results.simple_declarations[0]);
                            Verifai.are_equal(ident.name, c.expected_lvalues[0]);
                        }

                        case .COMPOUND_DECLARATION;
                        {
                            assert(results.compound_declarations.count == 1);

                            idents := ASTist.get_lvalues_from_compound_declaration(results.compound_declarations[0]);
                            names: [] string = Array_Helpers.map(idents, x => x.name);
                            Verifai.are_equal(names, c.expected_lvalues, #procedure_of_call Array_Helpers.arrays_are_equal(string.[], string.[]));
                        }

                        case .ASSIGNMENT;
                        {
                            assert(results.assignments.count == 1);

                            idents := ASTist.get_lvalues_from_assignment(results.assignments[0]);
                            names: [] string = Array_Helpers.map(idents, x => x.name);
                            Verifai.are_equal(names, c.expected_lvalues, #procedure_of_call Array_Helpers.arrays_are_equal(string.[], string.[]));
                        }
                    }
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
Array_Helpers :: #import "Array_Helpers";
