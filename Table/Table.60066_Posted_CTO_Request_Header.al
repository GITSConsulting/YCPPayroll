table 60066 "Posted CTO Request Header"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "Posted CTO Request List";
    LookupPageId = "Posted CTO Request List";

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
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
            TableRelation = Employee;
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
        field(16; Reversed; Boolean)
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

    trigger OnDelete()
    var
        PostedCTOLine: Record "Posted CTO Request Line";
    begin
        PostedCTOLine.Reset();
        PostedCTOLine.SetRange("Document No.", "No.");
        if PostedCTOLine.FindSet() then
            PostedCTOLine.DeleteAll();
    end;


    procedure NamaEmployee(_noEmp: Code[20]): Text
    var
        employee: Record Employee;
    begin
        if employee.Get(_noEmp) then
            exit(employee.FullName());
    end;

}