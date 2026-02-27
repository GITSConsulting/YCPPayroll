table 60049 "PTKP Setup"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "PTKP Setup List";

    fields
    {
        field(1; Kode; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(2; Golongan; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(3; Description; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Tarif PTKP"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 0;
        }
        field(5; "Entry No."; Integer)
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

    trigger
    OnInsert()
    var
        PTKPSetup: Record "PTKP Setup";
        EntryNo: Integer;
    begin
        PTKPSetup.LockTable();
        PTKPSetup.Reset();
        if PTKPSetup.FindLast() then
            EntryNo := PTKPSetup."Entry No." + 1
        else
            EntryNo := 1;

        "Entry No." := EntryNo;
    end;
}