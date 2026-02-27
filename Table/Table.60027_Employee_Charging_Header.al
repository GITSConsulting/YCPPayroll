table 60027 "Employee Charging Header"
{
    DataClassification = CustomerContent;
    LookupPageId = "Employee Charging List";
    DrillDownPageId = "Employee Charging List";

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
        field(2; "Posting Date"; Date)
        {
            //TableRelation = "Payroll Processed Entry"
            //                where("Charging Processed" = const(false));

            trigger
            OnValidate()
            begin
                //PayrollProcessedEntry.Reset();
                //PayrollProcessedEntry.SetRange("Posting Date Salary", "Posting Date");
                //PayrollProcessedEntry.SetRange("Charging Processed", false);
                //PayrollProcessedEntry.FindFirst();

                HariTerakhir := CalcDate('CM', "Posting Date");
                Validate("Posting Date Charging", HariTerakhir);
                //"Payroll Processed Entry No." := PayrollProcessedEntry."Entry No.";
            end;
        }
        field(3; "No. Series"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Posting Date Charging"; Date)
        {
            DataClassification = CustomerContent;

            trigger
            OnValidate()
            var
                startingDate: Date;
                endingDate: Date;
            begin
                TestField("Posting Date");
                startingDate := CalcDate('<CM>', "Posting Date");
                endingDate := startingDate - 1;
            end;
        }
        field(5; "Payroll Processed Entry No."; Integer)
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

    var
        PayrollProcessedEntry: Record "Payroll Processed Entry";
        PayrollGenSetup: Record "Payroll General Setup";
        NoSeriesMgt: Codeunit "No. Series";
        HariTerakhir: Date;

    trigger
    OnDelete()
    var
        Line: Record "Employee Charging Line";
    begin
        Line.Reset();
        Line.SetRange("Document No.", "No.");
        if Line.FindSet() then
            Line.DeleteAll();
    end;

    trigger OnInsert()
    begin
        if "No." = '' then
            // NoSeriesMgt.InitSeries(GetNoSeriesCode(), xRec."No. Series",
            // "Posting Date Charging", "No.", "No. Series");
            "No." := NoSeriesMgt.GetNextNo(GetNoSeriesCode(), "Posting Date Charging", false);

        PayrollProcessedEntry.Reset();
        PayrollProcessedEntry.SetRange("Charging Processed", false);
        PayrollProcessedEntry.SetFilter("Posting Date Salary", '>01/01/2022');
        PayrollProcessedEntry.FindFirst();

        Validate("Posting Date", PayrollProcessedEntry."Posting Date Salary");
    end;

    procedure AssistEdit(OldEmpChargeHeader: Record "Employee Charging Header"): Boolean;
    var
        EmpChargeHeader: Record "Employee Charging Header";
    begin
        EmpChargeHeader := Rec;

        if NoSeriesMgt.LookupRelatedNoSeries(GetNoSeriesCode(), OldEmpChargeHeader."No. Series",
           "No. Series") then begin
            //NoSeriesMgt.SetSeries("No.");
            "No." := NoSeriesMgt.GetNextNo(GetNoSeriesCode(), "Posting Date Charging", false);
            Rec := EmpChargeHeader;
            exit(true);
        end;

        exit(false);
    end;

    procedure GetNoSeriesCode(): Code[10];
    begin
        PayrollGenSetup.Get();

        PayrollGenSetup.TestField("Employee Charging Nos.");
        exit(PayrollGenSetup."Employee Charging Nos.");
    end;
}