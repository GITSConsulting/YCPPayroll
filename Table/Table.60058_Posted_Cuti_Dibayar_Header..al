table 60058 "Posted Cuti Dibayar Header"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "No. Series"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(3; Status; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Open,Released;
        }
        field(4; "Document Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Total Cuti Dibayar (Value)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Posted Cuti Dibayar Line"."Cuti Dibayarkan (Value)" where("Document No." = field("No.")));
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        CutiDibayarLine: Record "Posted Cuti Dibayar Line";
    begin
        CutiDibayarLine.Reset();
        CutiDibayarLine.SetRange("Document No.", "No.");
        if CutiDibayarLine.FindSet() then
            CutiDibayarLine.DeleteAll();
    end;


}