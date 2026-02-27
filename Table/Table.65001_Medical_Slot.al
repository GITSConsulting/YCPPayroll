table 65001 "Medical Slot"
{
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Employee No."; Code[10])
        {

        }
        field(2; "Medical Code"; Code[20])
        {
            TableRelation = "Medical Values".Code;
        }

        field(3; "Line No."; Integer)
        {
        }
        field(4; "Medical Type"; enum "Type Medical")
        {
        }
        field(5; "Daily rate - room"; Boolean)
        {

        }
        field(6; "Rawat Inat Type"; Enum "Rawat Inap Type")
        {

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