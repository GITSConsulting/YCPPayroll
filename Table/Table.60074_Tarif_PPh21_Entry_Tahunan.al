table 60074 "Tarif PPh21 Entry Tahunan"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "Tarif PPh21 Entries Tahunan";

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
        field(7; "Posting Date December Payroll"; Date)
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


    procedure InsertTarifPPh21EntryTahunan(Karyawan: Record Employee; Duitnya: Decimal; Persen: Decimal;
    TanggalPosting: Date)
    var
        TarifPPh21EntryTahunan: Record "Tarif PPh21 Entry Tahunan";
        TarifPPh21EntryTahunan2: Record "Tarif PPh21 Entry Tahunan";
        EntryNo: Integer;
    begin
        TarifPPh21EntryTahunan2.LockTable();
        TarifPPh21EntryTahunan2.Reset();
        if TarifPPh21EntryTahunan2.FindLast() then
            EntryNo := TarifPPh21EntryTahunan2."Entry No." + 1
        else
            EntryNo := 1;


        TarifPPh21EntryTahunan.Init();
        TarifPPh21EntryTahunan."Entry No." := EntryNo;
        TarifPPh21EntryTahunan."Employee No." := Karyawan."No.";
        TarifPPh21EntryTahunan.Amount := Duitnya;
        TarifPPh21EntryTahunan."Used Percentage" := Persen;
        TarifPPh21EntryTahunan.Tax := Duitnya * (Persen / 100);
        TarifPPh21EntryTahunan."Posting Date Payroll" := TanggalPosting;
        TarifPPh21EntryTahunan.Insert();
    end;
}