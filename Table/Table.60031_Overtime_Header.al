table 60031 "Overtime Header"
{
    DataClassification = CustomerContent;
    LookupPageId = "Overtime List";
    DrillDownPageId = "Overtime List";

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            trigger
            OnValidate()
            begin
                if "No." <> xRec."No." then
                    NoSeriesMgt.TestManual(GetNoSeriesCode());
            end;
        }
        field(2; "No. Series"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Reference Date"; Date)
        {
            DataClassification = CustomerContent;

            trigger
            OnValidate()
            var
                Line: Record "Overtime Line";
            begin
                TestField(Status, Status::Open);

                if "Reference Date" <> xRec."Reference Date" then begin
                    //kosongkan range tanggal di header
                    "Overtime Start Date" := 0D;
                    "Overtime End Date" := 0D;

                    //kosongkan range tanggal di lines juga durationnya
                    Line.Reset();
                    Line.SetRange("Document No.", "No.");
                    if line.FindSet() then
                        repeat
                            Line."Emp. Overtime Starting Date" := 0D;
                            Line."Emp. Overtime Ending Date" := 0D;
                            Line.Duration := 0;
                            Line.Modify();
                        until Line.Next() = 0;

                    TanggalParameter(true, "Reference Date");
                end;
            end;
        }
        field(4; "Overtime Start Date"; Date)
        {
            DataClassification = CustomerContent;

            trigger
            OnValidate()
            begin
                TestField(Status, Status::Open);
                TestField("Reference Date");
                "Overtime End Date" := 0D;

                cekRangeTanggal("Overtime Start Date");
            end;
        }
        field(5; "Overtime End Date"; Date)
        {
            DataClassification = CustomerContent;

            trigger
            OnValidate()
            begin
                TestField(Status, Status::Open);
                TestField("Reference Date");
                TestField("Overtime Start Date");

                if "Overtime End Date" <> 0D then begin
                    cekRangeTanggal("Overtime End Date");

                    if "Overtime Start Date" > "Overtime End Date" then
                        Error('OVERTIME END DATE must be at least the same as OVERTIME START DATE');

                    /*
                    if "Overtime Start Date" >= Tanggal16 then
                        if not ("Overtime End Date" >= Tanggal16) then
                            Error('OVERTIME START DATE is within SECOND period of payroll payment. \' +
                                  'OVERTIME END DATE needs to be between %1 and %2',
                                  format(Tanggal16, 0, '<Day> <Month Text> <Year4>'), format(AkhirBulan, 0, '<Day> <Month Text> <Year4>'));

                    if ("Overtime Start Date" >= Tanggal1) and ("Overtime Start Date" <= Tanggal15) then
                        if not (("Overtime End Date" >= Tanggal1) and ("Overtime End Date" <= Tanggal15)) then
                            Error('OVERTIME START DATE is within FIRST period of payroll payment. \' +
                                  'OVERTIME END DATE needs to be between %1 and %2',
                                  format(Tanggal1, 0, '<Day> <Month Text> <Year4>'), format(Tanggal15, 0, '<Day> <Month Text> <Year4>'));
                    */
                end;
            end;
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
        OvertimeLine: Record "Overtime Line";
    begin
        TestField(Status, Status::Open);

        OvertimeLine.Reset();
        OvertimeLine.SetRange("Document No.", "No.");
        if OvertimeLine.FindSet() then
            OvertimeLine.DeleteAll();
    end;

    trigger OnInsert()
    begin
        "Reference Date" := Today;

        TanggalParameter(false, Today);

        if "No." = '' then
            // NoSeriesMgt.InitSeries(GetNoSeriesCode(), xRec."No. Series",
            // "Reference Date", "No.", "No. Series");
            "No." := NoSeriesMgt.GetNextNo(GetNoSeriesCode(), "Reference Date", false);
    end;

    procedure cekRangeTanggal(tanggalCek: Date)
    begin
        if (tanggalCek < Tanggal1) or (tanggalCek > AkhirBulan) then
            Error('The date must be between %1 and %2', format(Tanggal1, 0, '<Day> <Month Text> <Year4>'),
            format(AkhirBulan, 0, '<Day> <Month Text> <Year4>'));
    end;

    procedure TanggalParameter(Update: Boolean; Tanggalnya: Date)
    begin
        Tanggal1 := CalcDate('<-CM>', Tanggalnya);
        Tanggal15 := Tanggal1 + 14;
        Tanggal16 := Tanggal1 + 15;
        AkhirBulan := CalcDate('<CM>', Tanggalnya);

        if Update then
            Modify();
    end;

    procedure GetTanggalParameter(__tanggal1: Date; __tanggal15: Date; __tanggal16: Date;
    __akhirBulan: Date)
    begin
        __tanggal1 := Tanggal1;
        __tanggal15 := Tanggal15;
        __tanggal16 := Tanggal16;
        __akhirBulan := AkhirBulan;
    end;

    procedure AssistEdit(OldOvertimeHeader: Record "Overtime Header"): Boolean;
    var
        OvertimeHeader: Record "Overtime Header";
    begin
        OvertimeHeader := Rec;

        if NoSeriesMgt.LookupRelatedNoSeries(GetNoSeriesCode(), OldOvertimeHeader."No. Series",
           "No. Series") then begin
            "No." := NoSeriesMgt.GetNextNo(GetNoSeriesCode(), "Reference Date", false);
            Rec := OvertimeHeader;
            exit(true);
        end;

        exit(false);
    end;

    procedure GetNoSeriesCode(): Code[10];
    begin
        PayrollGenSetup.Get();

        PayrollGenSetup.TestField("Overtime Nos.");
        exit(PayrollGenSetup."Overtime Nos.");
    end;
}