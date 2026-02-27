table 65011 "Shift Schedules"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee."No." where(Status = const(Active), "MSI_HRIS Shift Schedule" = const(true), "MSI_HRIS Type Shift" = field("Type Shift"));
        }
        field(3; "Name Employee"; text[100])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Effective Date"; Date)
        {
            Caption = 'Effective Date';
        }
        field(5; "Created User ID"; code[50])
        {
            DataClassification = CustomerContent;
        }
        field(6; Month; text[100])
        {
            DataClassification = CustomerContent;
        }
        field(7; Year; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(8; "Base Calendar Shift-1"; Boolean)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if rec."Base Calendar Shift-1" = true then
                    rec."Base Calendar Shift-2" := false;
            end;
        }
        field(9; "Base Calendar Shift-2"; Boolean)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if rec."Base Calendar Shift-2" = true then
                    rec."Base Calendar Shift-1" := false;
            end;
        }
        field(10; "Working Start"; time)
        {
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(11; "Working Out"; time)
        {
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(12; "Type Shift"; Enum "Shift Type")
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

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        frz_employee: Record Employee;
        frz_codeUnit: Codeunit "User Setup Custome";
    // asss: page "Base Calendar Entries Subform";
    begin
        "Created User ID" := UserId;
    end;
}