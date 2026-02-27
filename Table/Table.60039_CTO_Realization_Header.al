table 60039 "CTO Realization Header"
{
    Permissions = tabledata "Approval Entry" = rimd;

    DataClassification = CustomerContent;
    DrillDownPageId = "CTO Realization List";
    LookupPageId = "CTO Realization List";

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
        field(2; "Document Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(3; "No. Series"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee where(Status = const(Active));
        }
        field(5; Status; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Open,Released,"Pending Approval";
        }
        field(6; "Employee No. Replacement"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee where(Status = const(Active));
        }

        field(10; "Starting Date"; Date)
        {
            DataClassification = CustomerContent;

            trigger
            OnValidate()
            begin
                if ("Ending Date" <> 0D) and ("Starting Date" <> 0D) then
                    validate("Total Number of Days", "Ending Date" - "Starting Date" + 1);
            end;
        }
        field(11; "Ending Date"; Date)
        {
            DataClassification = CustomerContent;

            trigger
            OnValidate()
            begin
                if ("Ending Date" <> 0D) and ("Starting Date" <> 0D) then
                    validate("Total Number of Days", "Ending Date" - "Starting Date" + 1);
            end;
        }
        field(12; "Total Number of Days"; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;

            trigger
            OnValidate()
            var
                TotalDays: Decimal;
                strErr: Text[10];
            begin
                if Rec."Total Number of Days" <> xRec."Total Number of Days" then begin
                    TestField("Ending Date");
                    TestField("Starting Date");

                    TotalDays := "Ending Date" - "Starting Date" + 1;

                    if "Total Number of Days" > 1 then
                        strErr := 'days are'
                    else
                        strErr := 'day is';

                    if "Total Number of Days" > TotalDays then
                        Error('Total number of %1 not valid.');

                    CalcFields("Employee CTO Balance");
                    if "Total Number of Days" > "Employee CTO Balance" then
                        Error('Total number of days cannot exceeds employee CTO balance.');
                end;

                /*
                Clear(TotalDays);
                Clear(KuranginStengah);

                if Rec."Total Number of Days" <> xRec."Total Number of Days" then begin
                    TestField("Ending Date");
                    TestField("Starting Date");

                    TotalDays := "Ending Date" - "Starting Date" + 1;
                    KuranginStengah := TotalDays - 0.5;

                    if ("Total Number of Days" <> TotalDays) and
                       ("Total Number of Days" <> KuranginStengah) then
                        Error('Total Number of Days is not valid.');
                end;
                */
            end;
        }
        field(13; "Employee CTO Balance"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = sum("CTO Ledger Entry"."Day Balance"
            where("Employee No." = field("Employee No.")));
        }
        field(15; "Approver ID"; code[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Approval Entry"."Approver ID" where("Document No." = field("No."),
            "Table ID" = const(60039), Status = const(Open)));
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
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.Reset();
        ApprovalEntry.SetRange("Document No.", "No.");
        if ApprovalEntry.FindSet() then
            ApprovalEntry.DeleteAll();
    end;


    trigger OnInsert()
    begin
        "Document Date" := Today;

        if "No." = '' then
            // NoSeriesMgt.InitSeries(GetNoSeriesCode(), xRec."No. Series",
            // "Document Date", "No.", "No. Series");
            "No." := NoSeriesMgt.GetNextNo(GetNoSeriesCode(), "Document Date", false);
    end;


    var
        PayrollGenSetup: Record "Payroll General Setup";
        NoSeriesMgt: Codeunit "No. Series";

    procedure NamaEmployee(_noEmp: Code[20]): Text
    var
        employee: Record Employee;
    begin
        if employee.Get(_noEmp) then
            exit(employee.FullName());
    end;

    procedure AssistEdit(OldCTORealizeHeader: Record "CTO Realization Header"): Boolean;
    var
        CTORealizeHeader: Record "CTO Realization Header";
    begin
        CTORealizeHeader := Rec;

        if NoSeriesMgt.LookupRelatedNoSeries(GetNoSeriesCode(), OldCTORealizeHeader."No. Series",
           "No. Series") then begin
            "No." := NoSeriesMgt.GetNextNo(GetNoSeriesCode(), "Document Date", false);
            Rec := CTORealizeHeader;
            exit(true);
        end;

        exit(false);
    end;

    procedure GetNoSeriesCode(): Code[10];
    begin
        PayrollGenSetup.Get();
        PayrollGenSetup.TestField("CTO Realization Nos.");
        exit(PayrollGenSetup."CTO Realization Nos.");
    end;
}