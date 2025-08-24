Common_Struct :: struct {}

Isa_Struct :: #type,isa Common_Struct; @Isa
Bar_Struct :: #type,isa Common_Struct;

check_decl_for_note_layout :: ()
{
    foo: Isa_Struct; @Bake
}
