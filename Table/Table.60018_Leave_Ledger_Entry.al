table 60018 "Leave Ledger Entry"
{
    DrillDownPageId = "Leave Ledger Entries";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        { DataClassification = CustomerContent; }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee;
            DataClassification = CustomerContent;
        }
        field(3; "Posting Date"; Date)
        { DataClassification = CustomerContent; }
        field(4; Type; Option)
        {
            OptionMembers = ,Positive,Negative;
            DataClassification = CustomerContent;
        }
        field(5; Description; Text[100])
        { DataClassification = CustomerContent; }
        field(6; Quantity; Decimal)
        { DataClassification = CustomerContent; }
        field(20; "Quantity Eligible"; Decimal)
        { DataClassification = CustomerContent; }
        field(21; Eligible; Boolean)
        { DataClassification = CustomerContent; }
        field(7; "Global Dimension 1 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(8; "Global Dimension 2 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(9; "Document No."; Code[20])
        { DataClassification = CustomerContent; }
        field(10; "Leave Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = ,Paid,Unpaid,Value;
        }
        field(11; "Paid Leave Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = ,Annual,Sick,Other;
        }
        field(12; "Unpaid Leave Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = ,"Leave Without Pay","Absence Without Pay";
        }
        field(13; "Starting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(14; "Ending Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(15; "Employee No. Replacement"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee;
        }
        field(16; Reversed; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(17; "Reversed by Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(18; "Reverse Entry"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(19; Amount; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(22; "Year Period"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(23; "Hiring Information Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(24; "Period Start"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(25; "Period End"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(26; "Maximum Times of Accrual"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(27; "Maximum Leave Disburtion"; Integer)
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
    }
}