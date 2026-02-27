table 60021 "Posted Leave Request"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Leave Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = ,Paid,Unpaid,"Other Attendance";
        }
        field(2; "No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(3; "No. Series"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee;
        }
        field(6; "Job Title"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(7; "Global Dimension 1 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(8; "Paid Leave Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = ,Annual,Sick,Other;
            OptionCaption = ' ,Annual,Sick,Other';
        }
        field(9; "Unpaid Leave Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = ,"Leave Without Pay","Absence Without Pay";
            OptionCaption = ', Leave Without Pay, Absence Without Pay';
        }
        field(10; "Starting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(11; "Ending Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(12; "Total Number of Days"; Decimal)
        {
            DecimalPlaces = 1;
            DataClassification = CustomerContent;
        }
        field(13; "Employee No. Replacement"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee;
        }
        field(16; Reversed; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(17; Processed; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(19; "Adjustment Prorate"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(18; "Salary Deduction"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(20; "Employee Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(23; "Payroll Ledger Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(24; "Payroll Posting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(65000; "Document Type"; Enum "Document Type Leave")
        {
            DataClassification = CustomerContent;
        }
        field(65001; "Leave Type Code"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "Master Leave Unconditional".Code where("Document Type" = field("Document Type"));
        }
        field(65002; "Leave-1"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(65003; "Leave-2"; Boolean)
        {
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; "Leave Type", "No.")
        {
            Clustered = true;
        }
    }

    var
        Employee: Record Employee;
        PayrollGenSetup: Record "Payroll General Setup";
        NoSeriesMgt: Codeunit "No. Series";

}