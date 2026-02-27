tableextension 65004 "Base Calendar Change Custome" extends "Base Calendar Change"
{
    fields
    {
        field(65000; WFH; Boolean)
        {
            DataClassification = ToBeClassified;
            // InitValue = true;
            trigger OnValidate()
            begin

            end;
        }
    }
}