compile_target_test :: ()
{
    set_build_options_dc(.{do_output = false});

    w := compiler_create_workspace("Target");
    options := get_build_options(w);
    options.output_type = .NO_OUTPUT;
    set_build_options(options, w);

    compiler_begin_intercept(w);

    add_build_file("compile_target.jai", w);
    add_build_string("#run compile_target_main();\n", w);

    compiler_end_intercept(w);

    Verifai.is_true(true);
} @Test

#scope_file
Verifai :: #import "Verifai";
ASTist :: #import "ASTist";
#import "Compiler";
