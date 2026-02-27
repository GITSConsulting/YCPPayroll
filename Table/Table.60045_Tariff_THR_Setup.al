table 60045 "Tariff THR Setup"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; Kode; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Lower Limit"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 0;
            trigger
            OnValidate()
            var
                NilaiPengaliTarif: Decimal;
            begin
                NilaiPengaliTarif := "Upper Limit" - "Lower Limit";
                if "Lower Limit" mod 2 = 1 then
                    NilaiPengaliTarif := NilaiPengaliTarif + 1;

                "Nilai Pengali Tarif" := NilaiPengaliTarif;
            end;
        }
        field(3; "Upper Limit"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 0;
            trigger
            OnValidate()
            var
                NilaiPengaliTarif: Decimal;
            begin
                NilaiPengaliTarif := "Upper Limit" - "Lower Limit";
                if "Lower Limit" mod 2 = 1 then
                    NilaiPengaliTarif := NilaiPengaliTarif + 1;

                "Nilai Pengali Tarif" := NilaiPengaliTarif;
            end;
        }
        field(4; "% Tariff"; Decimal)
        {
            DataClassification = CustomerContent;

        }
        field(5; "% Tariff Non NPWP"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Nilai Pengali Tarif"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 0;
        }
    }

    keys
    {
        key(PK; Kode)
        {
            Clustered = true;
        }
    }
}