TEST_DIR :: "tests";

run_tests :: ()
{
    set_build_options_dc(.{do_output = false});

    Basic.set_working_directory(#filepath);
    options := get_build_options();

    w := Verifai.build_and_run_tests(options, TEST_DIR);
}

#run run_tests();

#import "Compiler";
Basic :: #import "Basic";
Verifai :: #import "Verifai";
