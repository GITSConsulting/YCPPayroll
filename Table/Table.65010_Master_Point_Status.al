table 65010 "Master Point Status"
{
    // LookupPageId = "Medical List";
    // DrillDownPageId = "Medical List";
    fields
    {

        field(1; "Code"; Code[50]) { }
        field(2; "Entry No."; integer) { }
        field(3; "Status"; Enum "Marital Status") { }
        field(4; "Kid"; Integer) { }
        field(5; "Point"; Integer) { }
    }
    keys
    {
        key(PK; Code, "Entry No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin

    end;
}