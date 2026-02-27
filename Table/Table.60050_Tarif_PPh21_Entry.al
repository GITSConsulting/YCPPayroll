table 60050 "Tarif PPh21 Entry"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "Tarif PPh21 Entries";

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
        field(6; "Posting Date Payroll"; Date)
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


    procedure InsertTarifPPh21Entry(Karyawan: Record Employee; Duitnya: Decimal; Persen: Decimal;
    TanggalPosting: Date)
    var
        TarifPPh21Entry: Record "Tarif PPh21 Entry";
        TarifPPh21Entry2: Record "Tarif PPh21 Entry";
        EntryNo: Integer;
    begin
        TarifPPh21Entry2.LockTable();
        TarifPPh21Entry2.Reset();
        if TarifPPh21Entry2.FindLast() then
            EntryNo := TarifPPh21Entry2."Entry No." + 1
        else
            EntryNo := 1;


        TarifPPh21Entry.Init();
        TarifPPh21Entry."Entry No." := EntryNo;
        TarifPPh21Entry."Employee No." := Karyawan."No.";
        TarifPPh21Entry.Amount := Duitnya;
        TarifPPh21Entry."Used Percentage" := Persen;
        TarifPPh21Entry.Tax := Duitnya * (Persen / 100);
        TarifPPh21Entry."Posting Date Payroll" := TanggalPosting;
        TarifPPh21Entry.Insert();
    end;
}