table 65005 "Medical Reim Ledger Entries"
{
    DataClassification = CustomerContent;
    // DrillDownPageId = "CTO Ledger Entries";

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
            TableRelation = "Medical Reim Ledger Entries";
        }
        field(15; "Reversal Entry"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(16; Expired; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(17; "MR Realization Approval Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(18; "Entry Type"; Option)
        {
            OptionMembers = ,Positive,Negative;
        }
        field(19; Reversed; Boolean)
        {

        }
        field(20; Amount; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(21; "Medical Value"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "Medical Values".Code;
        }
        field(22; "Medical Type"; Enum "Type Medical")
        {
            DataClassification = CustomerContent;
        }
        field(23; Day; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(24; "Daily rate - room"; Boolean)
        {

        }
        field(25; "Basic Amount"; Decimal)
        {

        }
        field(26; "Rawat Inat Type"; Enum "Rawat Inap Type")
        {

        }
        field(27; "expired date optical"; Date) { }
        field(28; "Quantity 2"; Decimal)
        {
            Caption = 'Quantity';
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;
}