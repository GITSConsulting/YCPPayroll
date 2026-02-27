table 60068 "Contract Detail"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Hiring Information Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(4; "Tahun Fiskal Pajak"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Jumlah Bulan Contract"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(7; "Periode Penghasilan"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(8; "Fiskal Pajak Start"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Fiskal Pajak End"; Date)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Hiring Information Entry No.", "Entry No.")
        {
            Clustered = true;
        }
    }

    procedure GetPeriodePenghasilan(Pegawai: Record Employee; TanggalPayroll: Date; var Periode: Integer)
    var
        ContractDetail: Record "Contract Detail";
        TahunPajak: Integer;
    begin
        TahunPajak := Date2DMY(TanggalPayroll, 3);

        ContractDetail.Reset();
        ContractDetail.SetRange("Employee No.", Pegawai."No.");
        ContractDetail.SetRange("Tahun Fiskal Pajak", TahunPajak);
        ContractDetail.SetFilter("Fiskal Pajak Start", '<=%1', TanggalPayroll);
        ContractDetail.SetFilter("Fiskal Pajak End", '>=%1', TanggalPayroll);
        if ContractDetail.FindFirst() then
            Periode := ContractDetail."Periode Penghasilan"
        else
            Periode := 0;
    end;
}