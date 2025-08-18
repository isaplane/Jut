Found_Calls :: struct
{
    // result := my_proc();
    simple_declarations: [..] *Code_Declaration;

    // result1, result2 := my_proc()
    // result1:, result2 = my_proc()
    // result1, result2 = my_proc()
    compound_declarations: [..] *Code_Compound_Declaration;

    // result = my_proc();
    assignments:  [..] *Code_Binary_Operator;

    // my_call();
    calls:        [..] *Code_Procedure_Call;
}

// find "proc_name :: ()" during typechecking
find_procedure_decl_by_name_from_message :: (tc: *Message_Typechecked, proc_name: string) -> [] *Code_Procedure_Body
{
    return find_procedure_decl_by_name(Array_Helpers.map(tc.procedure_bodies, x => x.expression), proc_name);
}

// find each call to proc_name in body
find_procedure_calls_by_name :: (body: *Code_Procedure_Body, proc_name: string) -> Found_Calls
{
    results: Found_Calls;

    if !body.block
    {
        log_error("Bad body block.\n");
        return results;
    }

    for stmt: body.block.statements
    {
        if stmt.kind ==
        {
            case .DECLARATION;
            {
                decl_stmt := cast(*Code_Declaration) stmt;
                rhs := decl_stmt.expression;

                if !rhs || rhs.kind != .PROCEDURE_CALL continue;

                call   := cast(*Code_Procedure_Call) rhs;
                header := cast(*Code_Procedure_Header) call.resolved_procedure_expression;
                if header.name == proc_name array_add(*results.simple_declarations, decl_stmt);
            }

            case .COMPOUND_DECLARATION;
            {
                decl_stmt := cast(*Code_Compound_Declaration) stmt;
                rhs := decl_stmt.declaration_properties.expression;

                if !rhs || rhs.kind != .PROCEDURE_CALL continue;

                call   := cast(*Code_Procedure_Call) rhs;
                header := cast(*Code_Procedure_Header) call.resolved_procedure_expression;
                if header.name == proc_name array_add(*results.compound_declarations, decl_stmt);
            }

            case .BINARY_OPERATOR;
            {
                assign_stmt := cast(*Code_Binary_Operator) stmt;
                rhs := assign_stmt.right;

                if assign_stmt.operator_type != #char "=" || rhs.kind != .PROCEDURE_CALL continue;

                call   := cast(*Code_Procedure_Call) rhs;
                header := cast(*Code_Procedure_Header) call.resolved_procedure_expression;
                if header.name == proc_name array_add(*results.assignments, assign_stmt);
            }

            case .PROCEDURE_CALL;
            {
                call   := cast(*Code_Procedure_Call) stmt;
                header := cast(*Code_Procedure_Header) call.resolved_procedure_expression;
                if header.name == proc_name array_add(*results.calls, call);
            }
        }
    }

    return results;
}

// decl -> foo := my_call()
// gets "foo" ident
get_lvalue_from_simple_declaration :: (decl: *Code_Declaration) -> *Code_Ident
{
    ident := New(Code_Ident);
    ident.kind = .IDENT;
    ident.name = decl.name;
    ident.location = decl.location;

    return ident;
}

// decl -> foo, bar := my_call()
// decl -> foo, bar  = my_call()
// gets "foo, bar" idents
get_lvalues_from_compound_declaration :: (decl: *Code_Compound_Declaration) -> [..] *Code_Ident
{
    lvalues: [..] *Code_Ident;

    args := decl.comma_separated_assignment.arguments;
    for arg: args
    {
        ident := cast(*Code_Ident) arg.node;
        array_add(*lvalues, ident);
    }

    return lvalues;
}

// assignment -> foo = my_call()
// gets "foo" idents
get_lvalues_from_assignment :: (assignment: *Code_Binary_Operator) -> [..] *Code_Ident
{
    lvalues: [..] *Code_Ident;

    if assignment.operator_type != #char "="
    {
        log_error("Bad operator. Expected \"=\".\n");
        return lvalues;
    }

    lhs := assignment.left;

    if lhs.kind ==
    {
        case .COMMA_SEPARATED_ARGUMENTS;
        {
            args := cast(*Code_Comma_Separated_Arguments) lhs;
            for arg: args.arguments
            {
                ident := cast(*Code_Ident) arg.node;
                array_add(*lvalues, ident);
            }
        }

        case .IDENT;
        {
            ident := cast(*Code_Ident) lhs;
            array_add(*lvalues, ident);
        }
    }

    return lvalues;
}

insert_string_as_argument :: (call: *Code_Procedure_Call, args: ..string) -> *Code_Procedure_Call
{
    new_args: [..] Code_Argument;
    array_add(*new_args, ..call.arguments_unsorted);

    for arg: args
    {
        lit := make_string_literal(arg);
        array_add(*new_args, .{expression = lit});
    }

    new_call := New(Code_Procedure_Call);
    new_call.base = call.base;
    new_call.base.kind = .PROCEDURE_CALL;
    new_call.procedure_expression = call.procedure_expression;
    new_call.arguments_unsorted = new_args;

    return new_call;
}

proc_has_been_modified :: (body: *Code_Procedure_Body) -> bool
{
    return xx (body.body_flags & .ALREADY_MODIFIED);
}

#scope_file

// Returns an array, since we search by name and the proc may have overloads
find_procedure_decl_by_name :: (bodies: [] *Code_Procedure_Body, proc_name: string) -> [] *Code_Procedure_Body
{
    matching: [..] *Code_Procedure_Body;

    for body: bodies
    {
        if body.header.name == proc_name
            array_add(*matching, body);
    }

    return matching;
}

#import "Compiler";
#import "Basic";
Array_Helpers :: #import "Array_Helpers";
