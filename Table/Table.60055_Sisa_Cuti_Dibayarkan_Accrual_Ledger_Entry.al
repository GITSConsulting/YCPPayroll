table 60055 "Sisa Cuti Accrual Ledger Entry"
{
    DataClassification = CustomerContent;
    Caption = 'Annual Leave Accrual Ledger Entry';
    DrillDownPageId = "Sisa Cuti Accr. Ledger Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee;
        }
        field(3; "Payroll Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(4; "Accrual Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(5; Disbursed; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Disbursement Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(7; "Payroll Ledger Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(8; "Leave Quantity Disbursed"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Month No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(10; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(11; "Contract ID"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(12; "Month Slot"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(13; "Year Slot"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(14; "Leave Eligible Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 3;
        }
        field(15; "Entry Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "",Positive,Negative;
        }
        field(16; Description; Text[150])
        {
            DataClassification = CustomerContent;
        }
        field(17; "Period Start"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(18; "Period End"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(20; Quantity; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(21; "Hangus Reversed"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(22; "Payment Delayed"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(23; "Actual Payment Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(24; "GP No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
    }


    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }
}