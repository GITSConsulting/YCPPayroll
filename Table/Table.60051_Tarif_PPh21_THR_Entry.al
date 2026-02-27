table 60051 "Tarif PPh21 THR Entry"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "Tarif PPh21 THR Entries";

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
        field(3; Amount; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(4; "Used Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(5; Tax; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Posting Date THR"; Date)
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


    procedure InsertTarifPPh21THREntry(Karyawan: Record Employee; Duitnya: Decimal; Persen: Decimal;
    TanggalPosting: Date)
    var
        TarifPPh21THREntry: Record "Tarif PPh21 THR Entry";
        TarifPPh21THREntry2: Record "Tarif PPh21 THR Entry";
        EntryNo: Integer;
    begin
        TarifPPh21THREntry2.LockTable();
        TarifPPh21THREntry2.Reset();
        if TarifPPh21THREntry2.FindLast() then
            EntryNo := TarifPPh21THREntry2."Entry No." + 1
        else
            EntryNo := 1;

        TarifPPh21THREntry.Init();
        TarifPPh21THREntry."Entry No." := EntryNo;
        TarifPPh21THREntry."Employee No." := Karyawan."No.";
        TarifPPh21THREntry.Amount := Duitnya;
        TarifPPh21THREntry."Used Percentage" := Persen;
        TarifPPh21THREntry.Tax := Duitnya * (Persen / 100);
        TarifPPh21THREntry."Posting Date THR" := TanggalPosting;
        TarifPPh21THREntry.Insert();
    end;
}