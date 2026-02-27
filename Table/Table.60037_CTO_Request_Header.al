table 60037 "CTO Request Header"
{
    Permissions = tabledata "Approval Entry" = rimd;

    DataClassification = CustomerContent;
    DrillDownPageId = "CTO Request List";
    LookupPageId = "CTO Request List";

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
            OptionMembers = Open,Released,"Pending Approval",Void;
        }
        field(6; "CTO Realization Processing"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(7; "Expired Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(8; Expired; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(9; "CTO Balance"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = sum("CTO Ledger Entry"."Day Balance" where("Document No." = field("No."),
            "Employee No." = field("Employee No.")));
            Editable = false;
        }
        field(10; "Projected CTO Balance"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(11; "Projected Calculated"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(12; "Approval Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        /*
        field(13; Rejected; Boolean)
        {
            DataClassification = CustomerContent;
        }*/

        //field(14; Ditolak; Boolean)
        //{
        //    Caption = 'Rejected';
        //    DataClassification = CustomerContent;
        //}
        field(15; "Approver ID"; code[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Approval Entry"."Approver ID" where("Document No." = field("No."),
            "Table ID" = const(60037), Status = const(Open)));
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
    OnInsert()
    begin
        "Document Date" := Today;

        if "No." = '' then
            // NoSeriesMgt.InitSeries(GetNoSeriesCode(), xRec."No. Series",
            // "Document Date", "No.", "No. Series");
            "No." := NoSeriesMgt.GetNextNo(GetNoSeriesCode(), "Document Date", false);
    end;

    trigger OnDelete()
    var
        CTOLine: Record "CTO Request Line";
        ApprovalEntry: Record "Approval Entry";
    begin
        TestField(Status, Status::Open);
        CTOLine.Reset();
        CTOLine.SetRange("Document No.", "No.");
        if CTOLine.FindSet() then
            CTOLine.DeleteAll();

        ApprovalEntry.Reset();
        ApprovalEntry.SetRange("Document No.", "No.");
        if ApprovalEntry.FindSet() then
            ApprovalEntry.DeleteAll();
    end;

    trigger
    OnModify()
    begin
        TestField(Status, Status::Open);
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

    procedure AssistEdit(OldCTOHeader: Record "CTO Request Header"): Boolean;
    var
        CTOHeader: Record "CTO Request Header";
    begin
        CTOHeader := Rec;

        if NoSeriesMgt.LookupRelatedNoSeries(GetNoSeriesCode(), OldCTOHeader."No. Series",
           "No. Series") then begin
            "No." := NoSeriesMgt.GetNextNo(GetNoSeriesCode(), "Document Date", false);
            Rec := CTOHeader;
            exit(true);
        end;

        exit(false);
    end;

    procedure GetNoSeriesCode(): Code[10];
    begin
        PayrollGenSetup.Get();
        PayrollGenSetup.TestField("CTO Nos.");
        exit(PayrollGenSetup."CTO Nos.");
    end;
}