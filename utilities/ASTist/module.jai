find_procedure_by_name_from_message :: (tc: *Message_Typechecked, proc_name: string) -> [] *Code_Procedure_Body
{
    return find_procedure_by_name(Array_Helpers.map(tc.procedure_bodies, x => x.expression), proc_name);
}



#scope_file
find_procedure_by_name :: (bodies: [] *Code_Procedure_Body, proc_name: string) -> [] *Code_Procedure_Body
{
    matching_bodies: [..] *Code_Procedure_Body;

    for body: bodies
    {
        if body.header.name == proc_name
            array_add(*matching_bodies, body);
    }

    return matching_bodies;
}

#import "Compiler";
#import "Basic";
Array_Helpers :: #import "Array_Helpers";
