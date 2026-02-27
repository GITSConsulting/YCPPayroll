table 60007 "Employee Family Entry"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(3; Name; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Date of Birth"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(5; Relationship; Enum "Family Relationship")
        {
            DataClassification = CustomerContent;
        }
        field(6; Dependent; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Employee No.", "Line No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

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