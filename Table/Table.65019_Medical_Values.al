table 65019 "Medical Values"
{
    DataClassification = ToBeClassified;
    fields
    {
        field(1; Code; code[20]) { }
        field(2; "Medical Type"; Enum "Type Medical") { }
        field(3; Description; text[100]) { }
        field(4; Plafon; Decimal) { }
        field(5; "Status Update"; Boolean) { }
        field(6; Quantity; Integer) { }
        field(7; Percentage; decimal) { }
        field(8; "Daily rate - room"; Boolean) { }
        field(9; "Rawat Inat Type"; Enum "Rawat Inap Type") { }
        field(10; "Update for Slot Medical"; Boolean) { }
        field(11; "Quantity 2"; Decimal) { }
    }
    keys
    {
        key(PK; "Medical Type", "Rawat Inat Type", Code)
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