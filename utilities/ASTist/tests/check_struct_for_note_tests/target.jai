Baked_Struct :: struct @Bake {}
bs: Baked_Struct;

Base_Struct :: struct {}

As_Struct :: struct @As 
{
    using #as base: Base_Struct;
}
