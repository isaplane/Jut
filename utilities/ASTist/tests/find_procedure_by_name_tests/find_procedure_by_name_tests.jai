Find_Procedures_By_Name_Setup_Data :: struct
{
    target_file: string;
    workspace: Workspace;
}

find_procedures_by_name_setup :: ()
{
    using setup := New(Write_File_From_Target_Setup_Data);

    workspace = compiler_create_workspace("target");
    options := get_build_options(workspace);
    options.output_type = .NO_OUTPUT;
    set_build_options(options, workspace);

    context.setup_data = setup;
} @Setup

find_procedures_by_name_teardown :: ()
{
    using setup := context.setup_data.(*Find_Procedures_By_Name_Setup_Data);
    defer free(setup);
} @Teardown

Find_Procedures_By_Name_Test_Case :: struct
{
    
}

find_procedures_by_name_test_cases: [] Find_Procedures_By_Name_Test_Case = .[

];
