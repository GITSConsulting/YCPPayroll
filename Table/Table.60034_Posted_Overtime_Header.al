table 60034 "Posted Overtime Header"
{
    DataClassification = CustomerContent;
    LookupPageId = "Posted Overtime List";
    DrillDownPageId = "Posted Overtime List";

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "No. Series"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Reference Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(4; "Overtime Start Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Overtime End Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(6; Status; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Open,Released,"Payroll Process";
        }
        field(7; Tanggal1; Date)
        {
            DataClassification = CustomerContent;
        }
        field(8; Tanggal15; Date)
        {
            DataClassification = CustomerContent;
        }
        field(9; Tanggal16; Date)
        {
            DataClassification = CustomerContent;
        }
        field(10; AkhirBulan; Date)
        {
            DataClassification = CustomerContent;
        }
        field(11; "Payroll Date"; Date)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    var
        PayrollGenSetup: Record "Payroll General Setup";
        NoSeriesMgt: Codeunit "No. Series";


    trigger OnDelete()
    var
        OvertimeLine: Record "Posted Overtime Line";
    begin
        OvertimeLine.Reset();
        OvertimeLine.SetRange("Document No.", "No.");
        if OvertimeLine.FindSet() then
            OvertimeLine.DeleteAll();
    end;


    procedure TanggalParameter(Update: Boolean; Tanggalnya: Date)
    begin
        Tanggal1 := CalcDate('<-CM>', Tanggalnya);
        Tanggal15 := Tanggal1 + 14;
        Tanggal16 := Tanggal1 + 15;
        AkhirBulan := CalcDate('<CM>', Tanggalnya);
    end;

    procedure GetTanggalParameter(__tanggal1: Date; __tanggal15: Date; __tanggal16: Date;
    __akhirBulan: Date)
    begin
        __tanggal1 := Tanggal1;
        __tanggal15 := Tanggal15;
        __tanggal16 := Tanggal16;
        __akhirBulan := AkhirBulan;
    end;
}