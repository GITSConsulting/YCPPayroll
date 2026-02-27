table 65002 "Medical Reimbursement Header"
{
    //dre
    Permissions = tabledata "Approval Entry" = rimd;


    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "No." <> xRec."No." then
                    NoSeriesMgt.TestManual(GetNoSeriesCode());
            end;
        }
        field(2; "Revision Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Employee No."; Code[20])
        {
            TableRelation = Employee."No." where(Status = const(Active));
            DataClassification = CustomerContent;
        }
        field(4; "Name Employee"; text[100])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Date of Claim"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(30; "Document Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(6; Gender; Enum "Medical Gender")
        {
            DataClassification = CustomerContent;
        }
        field(7; "Status Patient"; Enum "Status Employee")
        {
            DataClassification = CustomerContent;
        }
        field(8; "Age of Patient"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Name of Hospital"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(10; "Address of hospital"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(12; "Status"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Open,Released,"Pending Approval",Void;
        }
        field(13; "Hospital Benefit"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(14; "From Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(15; "To Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(16; "Place of Accident"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(17; "Time"; Time)
        {
            DataClassification = CustomerContent;
        }
        field(18; "Rekening no."; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(19; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(21; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(22; "Created User ID"; text[100])
        {
            DataClassification = CustomerContent;
        }
        field(23; "Total Allowance"; Decimal)
        {
            Caption = 'Total Amount Allowance';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Medical Reimbursement Line"."Paid Amount" where("Document No." = field("No.")));
        }
        field(24; "Medical Type 1"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(25; "Medical Type 2"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(26; "Medical Type 3"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(27; "Medical Type 4"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(28; "Approver ID"; code[50])
        {
            //dre change "Table ID" = const(50046) >> "Table ID" = const(65002) 
            FieldClass = FlowField;
            CalcFormula = lookup("Approval Entry"."Approver ID" where("Document No." = field("No."),
            "Table ID" = const(65002), Status = const(Open)));
        }
        field(29; "Expired Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(31; "Approval Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(32; "Posted Document"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(33; Opbal; Boolean)
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

    trigger OnInsert()
    var
        Employee: Record Employee;
    begin
        ErrorEdit();
        // IF "No." = '' THEN BEGIN
        //     TestNoSeries;
        //     NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", "Posting Date", "No.", "No. Series");
        // END;
        "Document Date" := Today;
        if "No." = '' then
            // NoSeriesMgt.InitSeries(GetNoSeriesCode(), xRec."No. Series",
            // "Document Date", "No.", "No. Series");
            "No." := NoSeriesMgt.GetNextNo(GetNoSeriesCode(), "Document Date", false);

        Employee.SETRANGE("User ID", USERID);
        Employee.FINDFIRST;
        "Created User ID" := UserId;
        "Posting Date" := Today;
    end;

    trigger OnModify()
    begin
        ErrorEdit();
    end;

    trigger OnDelete()
    var
        ApprovalEntry: Record "Approval Entry";
        MedicalLine: record "Medical Reimbursement Line";
    begin
        ErrorEdit();

        //DRE
        ApprovalEntry.Reset();
        ApprovalEntry.SetRange("Document No.", "No.");
        if ApprovalEntry.FindSet() then
            ApprovalEntry.DeleteAll();

        MedicalLine.Reset();
        MedicalLine.SetRange("Document No.", "No.");
        if MedicalLine.FindSet() then
            MedicalLine.DeleteAll();
    end;

    trigger OnRename()
    begin

    end;

    procedure ErrorEdit()
    begin
        if rec.Status <> Status::Open then
            Error('Status must be equal to Open');
    end;

    procedure NamaEmployee(_noEmp: Code[20]): Text
    var
        employee: Record Employee;
    begin
        if employee.Get(_noEmp) then
            exit(employee.FullName());
    end;

    procedure AssistEdit(OldCTOHeader: Record "Medical Reimbursement Header"): Boolean;
    var
        CTOHeader: Record "Medical Reimbursement Header";
    begin
        CTOHeader := Rec;

        // if NoSeriesMgt.SelectSeries(GetNoSeriesCode(), OldCTOHeader."No. Series",
        //    "No. Series") then begin
        if NoSeriesMgt.LookupRelatedNoSeries(GetNoSeriesCode(), OldCTOHeader."No. Series",
           "No. Series") then begin
            // NoSeriesMgt.SetSeries(rec."No.");
            Rec."No." := NoSeriesMgt.GetNextNo(GetNoSeriesCode(), "Document Date", false);
            Rec := CTOHeader;
            exit(true);
        end;

        exit(false);
    end;

    procedure GetNoSeriesCode(): Code[10];
    begin
        PayrollGenSetup.Get();
        PayrollGenSetup.TestField("Medical Reimbursement Nos.");
        exit(PayrollGenSetup."Medical Reimbursement Nos.");
    end;


    local procedure GetSalesSetup()
    begin
        SalesSetup.Get;
    end;

    var
        PayrollGenSetup: Record "Payroll General Setup";
        NoSeriesMgt: Codeunit "No. Series";
        SalesSetup: Record "Inventory Setup";
        SelectNoSeriesAllowed: Boolean;

}