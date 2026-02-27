table 60056 "Cuti Dibayar Header"
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
        field(5; "Total Cuti Dibayar (Value)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Cuti Dibayar Line"."Cuti Dibayarkan (Value)" where("Document No." = field("No.")));
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
    var
        CutiDibayarHeader: Record "Cuti Dibayar Header";
    begin
        CutiDibayarHeader.Reset();
        if CutiDibayarHeader.FindFirst() then
            Error('There is an existing Unused Leave document no %1.\' +
                  'Please post that document before creating a new one.', CutiDibayarHeader."No.");

        "Document Date" := Today;

        if "No." = '' then
            // NoSeriesMgt.InitSeries(GetNoSeriesCode(), xRec."No. Series",
            // "Document Date", "No.", "No. Series");
            "No." := NoSeriesMgt.GetNextNo(GetNoSeriesCode(), "Document Date", false);
    end;


    trigger OnDelete()
    var
        CutiDibayarLine: Record "Cuti Dibayar Line";
    begin
        //Rec.TestField(Status, Status::Open);
        CutiDibayarLine.Reset();
        CutiDibayarLine.SetRange("Document No.", "No.");
        if CutiDibayarLine.FindSet() then
            CutiDibayarLine.DeleteAll();
    end;

    procedure AssistEdit(OldCutiDibayarHeader: Record "Cuti Dibayar Header"): Boolean;
    var
        CutiDibayarHeader: Record "Cuti Dibayar Header";
    begin
        CutiDibayarHeader := Rec;

        if NoSeriesMgt.LookupRelatedNoSeries(GetNoSeriesCode(), OldCutiDibayarHeader."No. Series",
           "No. Series") then begin
            "No." := NoSeriesMgt.GetNextNo(GetNoSeriesCode(), "Document Date", false);
            Rec := CutiDibayarHeader;
            exit(true);
        end;

        exit(false);
    end;

    procedure GetNoSeriesCode(): Code[20];
    begin
        PayrollGenSetup.Get();
        PayrollGenSetup.TestField("Cuti Dibayar Nos.");
        exit(PayrollGenSetup."Cuti Dibayar Nos.");
    end;

    var
        PayrollGenSetup: Record "Payroll General Setup";
        NoSeriesMgt: Codeunit "No. Series";
}