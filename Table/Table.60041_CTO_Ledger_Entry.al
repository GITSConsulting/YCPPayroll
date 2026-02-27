table 60041 "CTO Ledger Entry"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "CTO Ledger Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Document Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee;
        }
        field(4; "Description"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(7; "Day Balance"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(10; "CTO Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = ,Request,Realization;
        }
        field(11; "Request Approval Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(12; "Request Expired Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(13; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(14; "Reversed By Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = "CTO Ledger Entry";
        }
        field(15; "Reversal Entry"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(16; Expired; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(17; "CTO Realization Approval Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(18; "Entry Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = ,Positive,Negative;
        }
        field(19; Reversed; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(20; "Task ID"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(21; "Task Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(22; Used; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(24; "Document Use For"; Code[20])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(SK; "Employee No.")
        {
            SumIndexFields = "Day Balance";
        }
        key(SK2; "CTO Type", "Document No.")
        {
            SumIndexFields = "Day Balance";
        }
        key(SK3; "CTO Type", "Document No.", "Task Date")
        {
            SumIndexFields = "Day Balance";
        }
    }

    trigger
    OnDelete()
    var
        DetailedCTOLedgerEntry: Record "Detailed CTO Ledger Entry";
    begin
        DetailedCTOLedgerEntry.Reset();
        DetailedCTOLedgerEntry.SetRange("CTO Ledger Entry No.", "Entry No.");
        if DetailedCTOLedgerEntry.FindFirst() then
            DetailedCTOLedgerEntry.DeleteAll();
    end;
}