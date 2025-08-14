find_procedure_by_name_from_message :: (tc: *Message_Typechecked, proc_name: string) -> [] *Code_Procedure_Body
{
    map :: (array: [] $T, f: (T) -> $S) -> [..] S 
    {
        results: [..] S;
        for array array_add(*results, f(it));
        return results;
    }

    return find_procedure_by_name(map(tc.procedure_bodies, x => x.expression), proc_name);
}

get_lvalue_names :: (call_site: Code) -> [] string
{

}

#scope_file
find_procedure_by_name :: (bodies: [] *Code_Procedure_Body, proc_name: string) -> [] *Code_Procedure_Body
{
    matching_bodies: [..] *Code_Procedure_Body;

    for body: tc.procedure_bodies
    {
        if body.expression.header.name == name
            array_add(*matching_bodies, body.expression);
    }

    return matching_bodies;
}

#import "Compiler";
#import "Basic";
