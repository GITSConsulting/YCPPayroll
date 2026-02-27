table 65021 "Posted MR Header"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Revision Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Employee No."; Code[20])
        {
            TableRelation = Employee."No.";
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
            CalcFormula = sum("Posted MR Line"."Paid Amount" where("Document No." = field("No.")));
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
        field(34; Reversed; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}