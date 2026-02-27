table 60062 "Posted Severance Header"
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
        field(4; "Document Date"; Date)
        {
            DataClassification = CustomerContent;
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
        PostedSeveranceLine: Record "Posted Severance Line";
    begin
        PostedSeveranceLine.Reset();
        PostedSeveranceLine.SetRange("Document No.", "No.");
        if PostedSeveranceLine.FindSet() then
            PostedSeveranceLine.DeleteAll();
    end;

}