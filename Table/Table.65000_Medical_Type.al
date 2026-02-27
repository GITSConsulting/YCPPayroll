table 65000 "Medical Type"
{
    LookupPageId = "Medical List";
    DrillDownPageId = "Medical List";
    fields
    {
        field(1; Code; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; text[50]) { }
        field(3; Note; text[50]) { }
        field(4; "Entry No."; integer) { }
        field(5; outpatient; Boolean) { }
    }
    keys
    {
        key(PK; Code, "Entry No.")
        {
            Clustered = true;
        }
    }
    trigger OnRename()
    var
        recMedicalValue: Record "Medical Type Value";
    begin
        recMedicalValue.SetRange("Medical Type", rec.Code);
        if recMedicalValue.FindFirst() then begin
            repeat
                recMedicalValue."Medical Type" := Rec.Code;
                recMedicalValue.Modify();
            until recMedicalValue.Next = 0;
        end;
    end;

    trigger OnModify()
    var
        recMedicalValue: Record "Medical Type Value";
    begin
        recMedicalValue.SetRange("Medical Type", rec.Code);
        if recMedicalValue.FindFirst() then begin
            repeat
                recMedicalValue."Medical Type" := Rec.Code;
                recMedicalValue.Modify();

            until recMedicalValue.Next = 0;
        end;
    end;
}