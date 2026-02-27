table 60060 "Severance Header"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            trigger
            OnValidate()
            begin
                if "No." <> xRec."No." then
                    NoSeriesMgt.TestManual(GetNoSeriesCode());
            end;
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
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        "Document Date" := Today;

        if "No." = '' then
            // NoSeriesMgt.InitSeries(GetNoSeriesCode(), xRec."No. Series",
            // "Document Date", "No.", "No. Series");
            "No." := NoSeriesMgt.GetNextNo(GetNoSeriesCode(), "Document Date", false);
    end;


    trigger OnDelete()
    var
        SeveranceLine: Record "Severance Line";
    begin
        Rec.TestField(Status, Status::Open);
        SeveranceLine.Reset();
        SeveranceLine.SetRange("Document No.", "No.");
        if SeveranceLine.FindSet() then
            SeveranceLine.DeleteAll();
    end;

    procedure AssistEdit(OldSeveranceHeader: Record "Severance Header"): Boolean;
    var
        SeveranceHeader: Record "Severance Header";
    begin
        SeveranceHeader := Rec;

        if NoSeriesMgt.LookupRelatedNoSeries(GetNoSeriesCode(), OldSeveranceHeader."No. Series",
           "No. Series") then begin
            "No." := NoSeriesMgt.GetNextNo(GetNoSeriesCode(), "Document Date", false);
            Rec := SeveranceHeader;
            exit(true);
        end;

        exit(false);
    end;

    procedure GetNoSeriesCode(): Code[20];
    begin
        PayrollGenSetup.Get();
        PayrollGenSetup.TestField("Severance Nos.");
        exit(PayrollGenSetup."Severance Nos.");
    end;

    var
        PayrollGenSetup: Record "Payroll General Setup";
        NoSeriesMgt: Codeunit "No. Series";
}