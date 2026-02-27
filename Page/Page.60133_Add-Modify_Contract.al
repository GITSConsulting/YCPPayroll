page 60133 "Add-Modify Contract"
{
    PageType = StandardDialog;
    UsageCategory = Administration;
    Caption = 'New/Modify Contract';

    layout
    {
        area(Content)
        {
            field(EmployeeInfo; EmployeeInfo)
            {
                ShowCaption = false;
                Editable = false;
                ApplicationArea = all;
                Style = StrongAccent;
                StyleExpr = true;
            }
            group(GroupName)
            {
                field(ContractStart; ContractStart)
                {
                    Caption = 'Contract Start Date';
                    ApplicationArea = All;
                }
                field(ContractEnd; ContractEnd)
                {
                    Caption = 'Contract End Date';
                    ApplicationArea = all;
                }
            }
        }
    }

    trigger
    OnOpenPage()
    var
        Employee: Record Employee;
    begin
        ContractEnd := 0D;
        ContractStart := 0D;

        Employee.Get(NomorKuli);
        EmployeeInfo := Employee."No." + ' - ' + Employee.FullName();

        if not MintanyaInput then begin
            HiringInfo.Get(NomorKuli, NomorEntryCareerInfo);
            ContractStart := HiringInfo."Contract Start Date";
            ContractEnd := HiringInfo."Contract End Date";
        end;
    end;

    trigger
    OnQueryClosePage(CloseAction: Action): Boolean
    var
        TahunStart: Integer;
        TahunEnd: Integer;
        HiringInfo2: Record "Position Ledger Entry";
        EntryNo: Integer;
        i: Integer;
        FiscalStart: Date;
        StrFiscalStart: Text;
        FiscalEnd: Date;
        TotalBulanContract: Integer;
        CariContractDetail: Record "Contract Detail";
        HapusContractDetail: Record "Contract Detail";
        HapusHiringInfo: Record "Position Ledger Entry";
        TambahHiringInfo: Record "Position Ledger Entry";
        EntryNoHiring: Integer;
        PeriodePenghasilan: Integer;
        Window: Dialog;
    begin
        if CloseAction = CloseAction::OK then begin

            Window.Open('Processing...please wait..');

            //validasi di sini
            if MintanyaInput then begin
                HiringInfo2.Reset();
                HiringInfo2.SetRange("Employee No.", HiringInfo."Employee No.");
                if HiringInfo2.FindLast() then
                    if ContractStart <= HiringInfo2."Contract End Date" then
                        Error('New contract start date must be bigger than old contract end date.');
            end;

            if ContractEnd <= ContractStart then
                Error('Contract End Date must be bigger than Contract Start Date.');

            if not MintanyaInput then begin
                //kalo bukan input baru, maka hapus dulu hiring info dan isi contract detail
                HapusHiringInfo.Get(NomorKuli, NomorEntryCareerInfo);
                HapusHiringInfo.Delete();

                HapusContractDetail.Reset();
                HapusContractDetail.SetRange("Employee No.", NomorKuli);
                HapusContractDetail.SetRange("Hiring Information Entry No.", NomorEntryCareerInfo);
                if HapusContractDetail.FindSet() then
                    HapusContractDetail.DeleteAll();
            end;

            //proses masuk ke tabel contract detail di sin
            TahunStart := Date2DMY(ContractStart, 3);
            TahunEnd := Date2DMY(ContractEnd, 3);

            TambahHiringInfo.LockTable();
            TambahHiringInfo.SetRange("Employee No.", NomorKuli);
            if TambahHiringInfo.FindLast() then
                EntryNoHiring := TambahHiringInfo."Entry No." + 1
            else
                EntryNoHiring := 1;

            TambahHiringInfo.Init();
            TambahHiringInfo."Employee No." := NomorKuli;
            TambahHiringInfo."Entry No." := EntryNoHiring;
            TambahHiringInfo."Contract Start Date" := ContractStart;
            TambahHiringInfo."Contract End Date" := ContractEnd;
            TambahHiringInfo.Insert();

            i := TahunStart;
            while i <= TahunEnd do begin
                Clear(FiscalStart);
                Clear(FiscalEnd);
                Clear(TotalBulanContract);
                Clear(PeriodePenghasilan);

                ContractDetail.LockTable();
                ContractDetail.Reset();
                ContractDetail.SetRange("Employee No.", NomorKuli);
                ContractDetail.SetRange("Hiring Information Entry No.", EntryNoHiring);
                if ContractDetail.FindLast() then
                    EntryNo := ContractDetail."Entry No." + 1
                else
                    EntryNo := 1;

                if i = TahunStart then
                    FiscalStart := ContractStart
                else begin
                    StrFiscalStart := '0101' + Format(i);
                    Evaluate(FiscalStart, StrFiscalStart);
                end;

                FiscalEnd := CalcDate('<CY>', FiscalStart);
                CountMonth(FiscalStart, FiscalEnd, TotalBulanContract);

                CariContractDetail.Reset();
                CariContractDetail.SetRange("Employee No.", NomorKuli);
                //CariContractDetail.SetRange("Hiring Information Entry No.", EntryNoHiring);
                CariContractDetail.SetRange("Tahun Fiskal Pajak", i);
                if CariContractDetail.FindLast() then
                    PeriodePenghasilan := CariContractDetail."Periode Penghasilan"
                else
                    CountMonth(FiscalStart, FiscalEnd, PeriodePenghasilan);

                ContractDetail.Init();
                ContractDetail."Employee No." := NomorKuli;
                ContractDetail."Hiring Information Entry No." := EntryNoHiring;
                ContractDetail."Entry No." := EntryNo;
                ContractDetail."Tahun Fiskal Pajak" := i;
                ContractDetail."Fiskal Pajak Start" := FiscalStart;
                ContractDetail."Fiskal Pajak End" := FiscalEnd;
                ContractDetail."Jumlah Bulan Contract" := TotalBulanContract;
                ContractDetail."Periode Penghasilan" := PeriodePenghasilan;
                ContractDetail.Insert();

                i := i + 1;
            end;

            Window.Close();

            if MintanyaInput then
                Message('Record added.')
            else
                Message('Record modified.');

        end else begin
            Message('No records updated.');
        end;
    end;

    procedure CountMonth(TanggaMulai: Date; TanggalSelesai: Date;
    var Bulannya: Integer)
    var
        Calendar: Record Date;
        TanggalMulaiAwalBulan: Date;
        TanggalSelesaiAwalBulan: Date;
    begin
        TanggalMulaiAwalBulan := CalcDate('<-CM>', TanggaMulai);
        TanggalSelesaiAwalBulan := CalcDate('<-CM>', TanggalSelesai);

        Calendar.Reset();
        Calendar.SetRange("Period Type", Calendar."Period Type"::Month);
        Calendar.SetRange("Period Start", TanggalMulaiAwalBulan, TanggalSelesaiAwalBulan);
        if Calendar.FindFirst() then
            Bulannya := Calendar.Count
        else
            Bulannya := 1;
    end;

    procedure setRecord(EmpNo: Code[20]; MaunyaInput: Boolean; HiringEntryNo: Integer)
    begin
        MintanyaInput := MaunyaInput;
        NomorKuli := EmpNo;
        NomorEntryCareerInfo := HiringEntryNo;
    end;

    var
        NomorEntryCareerInfo: Integer;
        NomorKuli: Code[20];
        ContractStart: Date;
        ContractEnd: Date;
        EmployeeInfo: Text;
        MintanyaInput: Boolean;
        HiringInfo: Record "Position Ledger Entry";
        ContractDetail: Record "Contract Detail";
}