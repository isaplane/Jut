get_filename_from_location_test :: ()
{
    location := #location(test_file_foo);
    Verifai.are_equal("test_file.jai", File_Helpers.get_basename_from_location(location));
} @Test

#scope_file
Verifai      :: #import "Verifai";
File_Helpers :: #import "File_Helpers";
#import "Basic";
