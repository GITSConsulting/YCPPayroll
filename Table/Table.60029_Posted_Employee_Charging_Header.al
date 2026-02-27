table 60029 "Posted Employee Charg. Header"
{
    DataClassification = CustomerContent;
    LookupPageId = "Posted Employee Charging List";
    DrillDownPageId = "Posted Employee Charging List";

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;

        }
        field(2; "Posting Date"; Date)
        {
            TableRelation = "Payroll Processed Entry"
                            where("Charging Processed" = const(true));
        }
        field(3; "No. Series"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Posting Date Charging"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Payroll Processed Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Ignore Error On Cancelation"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    trigger
    OnDelete()
    var
        Line: Record "Posted Employee Charging Line";
    begin
        Line.Reset();
        Line.SetRange("Document No.", "No.");
        if Line.FindSet() then
            Line.DeleteAll();
    end;
}