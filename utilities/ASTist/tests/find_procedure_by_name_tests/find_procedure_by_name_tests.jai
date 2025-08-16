Find_Procedures_By_Name_Setup_Data :: struct
{
    target_file: string;
    workspace: Workspace;
}

find_procedures_by_name_setup :: ()
{
    using setup := New(Find_Procedures_By_Name_Setup_Data);

    workspace = compiler_create_workspace("target");
    options := get_build_options(workspace);
    options.output_type = .NO_OUTPUT;
    set_build_options(options, workspace);

    target_file = "target.jai";

    context.setup_data = setup;
} @Setup

find_procedures_by_name_teardown :: ()
{
    using setup := context.setup_data.(*Find_Procedures_By_Name_Setup_Data);
    defer free(setup);
} @Teardown

// -----------------------------------------------------------------------------

Find_Procedures_By_Name_Test_Case :: struct
{
    proc_target: string;
    found_procs_count: int;
}

find_procedures_by_name_test_cases: [] Find_Procedures_By_Name_Test_Case = .[
    .{"layout", 1},
    .{"test", 0},
    .{"Layout", 0}
];

find_procedures_by_name_test :: (c: Find_Procedures_By_Name_Test_Case)
{
    using setup := context.setup_data.(*Find_Procedures_By_Name_Setup_Data);

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
                procs := ASTist.find_procedure_by_name_from_message(tc, c.proc_target);
                array_add(*all_procs, ..procs);
            }                

            case .PHASE;
            {
                phase_message := cast (*Message_Phase) message;
                phase := phase_message.phase;

                if phase == .TYPECHECKED_ALL_WE_CAN 
                {
                    Verifai.are_equal(c.found_procs_count, all_procs.count);
                    if all_procs.count > 0 
                        Verifai.are_equal(c.proc_target, all_procs[0].header.name);
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

