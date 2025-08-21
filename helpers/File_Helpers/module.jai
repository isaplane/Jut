get_basename_from_location :: (loc: Source_Code_Location) -> string
{
    return get_basename_from_location(loc.fully_pathed_filename);
}

get_basename_from_location :: (full_path: string) -> string
{
    using path := parse_path(full_path);
    if words.count > 0 return words[words.count - 1];
    return "";
}

#scope_file
#import "File_Utilities";
#import "Compiler";
