page 60112 "Input THR Date for Calculation"
{
    PageType = StandardDialog;
    //ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Calculate THR Amount';

    layout
    {
        area(Content)
        {
            field(PleaseBeInformed; PleaseBeInformed)
            {
                ShowCaption = false;
                Editable = false;
                ApplicationArea = all;
                Style = StrongAccent;
                StyleExpr = true;
            }
            group(GroupName)
            {
                field(THRDatePlan; THRDatePlan)
                {
                    Caption = 'THR/Compensation Date Plan';
                    ApplicationArea = All;
                }
                field(Tipe; Tipe)
                {
                    ApplicationArea = all;
                    Caption = 'Type';
                    Editable = false;
                }

                field(StrTanpaFilter; StrTanpaFilter)
                {
                    ShowCaption = false;
                    ApplicationArea = all;
                    Visible = TanpaFilter;
                    Style = Unfavorable;
                    StyleExpr = true;
                }
            }
        }
    }

    var
        THRDatePlan: Date;
        Window: Dialog;
        PegawaiLoS: Record Employee;
        PositionLedgerEntry: Record "Position Ledger Entry";
        WithMuslimDisbursement: Boolean;
        TanpaFilter: Boolean;
        StrTanpaFilter: Text;

    trigger
    OnQueryClosePage(CloseAction: Action): Boolean
    var
        THRLoS: Decimal;
        THRCalcBasedOnLoS: Decimal;
        TotalHariLengthOfService: Integer;
        Employee: Record Employee;
        TotalIncome: Decimal;
        THRLedgerEntry: Record "THR Ledger Entry";
        TanggalAwalKalkulasiProrata: Date;
        StrConfirm: Text;
        ProcessTHRSetupTable: Record "Process THR Setup Table";
        ProcessTHRCompensation: Record "Process THR Compensation Table";
        PayrollGeneralSetup: Record "Payroll General Setup";
        THRThreshold: Integer;
        TanggalAwalEligible: Date;
        TaggedResigned: Boolean;
        TaggedContractNotExtended: Boolean;
        TanggalBatasAkhirProrata: Date;
        ContractStartDate: Date;
        Contract: Record "Position Ledger Entry";
        BasicSalary: Decimal;
        PayrollLedgerEntry: Record "Payroll Ledger Entry";
        TanggalMonyet: Date;
    begin
        if CloseAction = CloseAction::OK then begin
            PayrollGeneralSetup.Get();

            if Tipe = Tipe::" " then
                Error('Please choose the type.');

            case Tipe of
                Tipe::"THR Compensation":
                    StrConfirm := 'You are calculating THR Amount for processing compensation,\' +
                                  'Proceed?';
                Tipe::"With Muslim Disbursement":
                    StrConfirm := 'You are calculating THR Amount with Muslim Disbursement,\' +
                                  'Proceed?';
                Tipe::"With Non Muslim Disbursement":
                    StrConfirm := 'You are calculating THR Amount with NON-Muslim Disbursement,\' +
                                  'Proceed?';
            end;

            if Tipe <> Tipe::"THR Compensation" then begin
                if THRDatePlan = 0D then
                    Error('Please fill the planned THR date.');

                if THRDatePlan < GajianTerakhirDate then
                    Error('Planned THR date must be bigger than last payroll date.');

                //Jadi pake 365 hari spt di bawah. Pokoknya setahun ke belakang
                //Sebelunya pake setup
                //tanggal awal eligible untuk umum, alias THR biasa
                TanggalAwalEligible := THRDatePlan - 365;
            end;


            if not Confirm(StrConfirm) then exit;

            Window.Open('Calculating, please wait..');


            TanggalMonyet := THRDatePlan;

            PegawaiLoS.Reset();
            PegawaiLoS.SetRange(Status, PegawaiLoS.Status::Active);
            case Tipe of
                Tipe::"THR Compensation":
                    PegawaiLoS.SetRange("MSI_HRIS THR Compensation", true);
                Tipe::"With Muslim Disbursement":
                    PegawaiLoS.SetRange("With Muslim THR Disbursement", true);
                Tipe::"With Non Muslim Disbursement":
                    PegawaiLoS.SetRange("With Muslim THR Disbursement", false);
            end;
            PegawaiLoS.FindFirst();
            repeat



                Clear(THRLoS);
                Clear(THRCalcBasedOnLoS);
                Clear(TotalHariLengthOfService);
                Clear(TotalIncome);
                EndingDateCalculation := 0D;
                TanggalAwalKalkulasiProrata := 0D;
                TanggalBatasAkhirProrata := 0D;
                ContractStartDate := 0D;


                TaggedContractNotExtended := false;
                TaggedResigned := false;
                AdaTerimaTHR := false;

                PositionLedgerEntry.Reset();
                PositionLedgerEntry.SetRange("Employee No.", PegawaiLoS."No.");
                PositionLedgerEntry.FindLast();
                PositionLedgerEntry.TestField("Contract Start Date");
                PositionLedgerEntry.TestField("Contract End Date");

                ContractStartDate := PositionLedgerEntry."Contract Start Date";

                if PegawaiLoS."MSI_HRIS Last Payroll" then
                    PositionLedgerEntry.TestField("Resign Date");

                THRDatePlan := TanggalMonyet;

                if Tipe = Tipe::"THR Compensation" then begin
                    THRDatePlan := 0D;
                    //tanggal 29 Des, Pak Erwin bilang....kalo kompensasi, dia harus plus satu.
                    //baik resign maupun kontrak berakhir
                    if PositionLedgerEntry."Resign Date" <> 0D then
                        THRDatePlan := PositionLedgerEntry."Resign Date" + 1
                    else
                        THRDatePlan := PositionLedgerEntry."Contract End Date" + 1;
                end;

                if (PositionLedgerEntry."Resign Date" <> 0D) and
                    (PositionLedgerEntry."Resign Date" <= THRDatePlan) then begin
                    EndingDateCalculation := PositionLedgerEntry."Resign Date" + 1;
                    TaggedResigned := true;


                    if TaggedResigned then
                        THRDatePlan := PositionLedgerEntry."Resign Date";

                end else begin
                    if (PositionLedgerEntry."Resign Date" = 0D) and PegawaiLoS."MSI_HRIS Last Payroll"
                        then begin
                        TaggedContractNotExtended := true;
                    end;
                    EndingDateCalculation := PositionLedgerEntry."Contract End Date" + 1;
                end;

                if Tipe = Tipe::"THR Compensation" then begin
                    TanggalAwalEligible := 0D;
                    TanggalAwalEligible := EndingDateCalculation - 365;
                end;

                //semua variable ContractStartDate di bawah ini,
                //tadinya langsung ambil dari table, jadi PositionLedgerEntry."Contract Start Date"
                //tapi jadi bug saat line contract ada lebih dari satu, 
                //ngga boleh langsung ambil contract terakhir, harus cek ke contract lama dulu
                //untuk mengakomodir data THR itu masih tercover dalam kontrak lama tersebut

                //cek dulu kontrak2 lama, sebelumnya
                if PositionLedgerEntry.Count > 1 then begin
                    Contract.Reset();
                    Contract.SetRange("Employee No.", PegawaiLoS."No.");
                    Contract.FindFirst();
                    ContractStartDate := Contract."Contract Start Date";
                end;

                THRLedgerEntry.Reset();
                THRLedgerEntry.SetRange("Employee No.", PegawaiLoS."No.");
                if THRLedgerEntry.FindLast() then
                    TanggalAwalKalkulasiProrata := THRLedgerEntry."Posting Date"
                else
                    TanggalAwalKalkulasiProrata := ContractStartDate;


                if (EndingDateCalculation > THRDatePlan) and
                   (EndingDateCalculation - ContractStartDate >= 360) then begin
                    //ini untuk hitungan normal

                    TotalHariLengthOfService := ExcelDays360_V2(TanggalAwalKalkulasiProrata, THRDatePlan);

                    TaggedContractNotExtended := false;
                    TaggedResigned := false;

                    //if PegawaiLoS."No." = 'E0091' then
                    //Message('start=%1 end=%2', TanggalAwalKalkulasiProrata, THRDatePlan);
                end else begin
                    if EndingDateCalculation <= THRDatePlan then
                        TanggalBatasAkhirProrata := EndingDateCalculation
                    else
                        TanggalBatasAkhirProrata := THRDatePlan;

                    //ini untuk prorata. Jadi karyawan resign/abis kontrak sebelum lebaran
                    if (TanggalAwalEligible <= EndingDateCalculation) /*and (THRDatePlan >= EndingDateCalculation)*/ then
                        TotalHariLengthOfService := ExcelDays360_V2(TanggalAwalKalkulasiProrata, TanggalBatasAkhirProrata)
                    else
                        TotalHariLengthOfService := 0;

                end;



                if Tipe = Tipe::"THR Compensation" then begin
                    //tadinya pake EndingDateCalculation
                    //ganti jadi pake THRDatePlan
                    TotalHariLengthOfService := ExcelDays360_V2(TanggalAwalKalkulasiProrata, THRDatePlan);
                    //Message('masuk tiga');
                end;


                //if PegawaiLoS."No." = 'E0053' then begin
                //Message('start=%1 end=%2 totalHari=%3', TanggalAwalKalkulasiProrata, THRDatePlan, TotalHariLengthOfService);
                //end;

                THRLoS := (TotalHariLengthOfService / 360 * 12) / 12;

                //if PegawaiLoS."No." = 'E0091' then
                //Message('TotalHariLength=%1 THRLos=%2', TotalHariLengthOfService, THRLoS);

                if THRLoS > 1 then
                    THRCalcBasedOnLoS := 1
                else
                    THRCalcBasedOnLoS := THRLoS;

                Employee.Reset();
                Employee.SetRange("No.", PegawaiLoS."No.");
                Employee.SetRange("Date Filter", GajianTerakhirDate);
                Employee.FindFirst();

                Clear(BasicSalary);
                if Employee."MSI_HRIS THR Apply to Old" then begin
                    Employee.TestField("MSI_HRIS Old Basic Salary");
                    BasicSalary := Employee."MSI_HRIS Old Basic Salary";
                end else begin
                    Employee.TestField("MSI_HRIS Basic Salary");
                    BasicSalary := Employee."MSI_HRIS Basic Salary";
                end;

                Employee.CalcFields("MSI_HRIS Total Allowance Fix");

                TotalIncome := BasicSalary + Employee."MSI_HRIS Total Allowance Fix";

                PegawaiLoS.TotalHariLengthOfService := TotalHariLengthOfService;
                PegawaiLoS."MSI_HRIS THR LoS" := THRLoS;
                PegawaiLoS."MSI_HRIS THR Calc. LoS" := THRCalcBasedOnLoS;
                PegawaiLoS."THR Amount" := TotalIncome * THRCalcBasedOnLoS;

                if TaggedContractNotExtended then
                    PegawaiLoS."MSI_HRIS Termination Status" :=
                    PegawaiLoS."MSI_HRIS Termination Status"::"Contract Not Extended";

                if TaggedResigned then
                    PegawaiLoS."MSI_HRIS Termination Status" :=
                    PegawaiLoS."MSI_HRIS Termination Status"::"Resigned/Terminated";

                PegawaiLoS."MSI_HRIS Los Newly Calc." := true;
                PegawaiLoS.Modify();

            until PegawaiLoS.Next() = 0;


            //Jika yg diproses itu THR Compensation, maka
            if Tipe = Tipe::"THR Compensation" then begin
                //Update ke tabel Process THR Compensation
                PayrollLedgerEntry.Reset();
                PayrollLedgerEntry.FindLast();

                ProcessTHRCompensation.Reset();
                if not ProcessTHRCompensation.Get() then begin
                    ProcessTHRCompensation.Init();
                    ProcessTHRCompensation.PostingDate := PayrollLedgerEntry."Posting Date";
                    ProcessTHRCompensation.Insert();
                end else begin
                    ProcessTHRCompensation.PostingDate := PayrollLedgerEntry."Posting Date";
                    ProcessTHRCompensation.Modify();
                end;
            end else begin
                //Jika THR biasa, maka
                //Update ke tabel Process THR Setup Table
                ProcessTHRSetupTable.Reset();
                if not ProcessTHRSetupTable.Get() then begin
                    ProcessTHRSetupTable.Init();
                    ProcessTHRSetupTable.PostingDate := THRDatePlan;
                    ProcessTHRSetupTable.Insert();
                end else begin
                    ProcessTHRSetupTable.PostingDate := THRDatePlan;
                    ProcessTHRSetupTable.Modify();
                end;
            end;

            Window.Close();
            Message('THR Amount calculated successfully.');

        end else begin
            Message('You did not process the calculation.');
        end;
    end;

    trigger
    OnOpenPage()
    begin
        PleaseBeInformed := 'Baseline for calculation is last payroll date: ' +
                            Format(GajianTerakhirDate, 0, '<Day> <Month Text> <Year4>');

        TanpaFilter := false;
        StrTanpaFilter := '';

        case FilterListCui of
            FilterListCui::"Muslim THR":
                Tipe := Tipe::"With Muslim Disbursement";
            FilterListCui::"Non-Muslim THR":
                Tipe := Tipe::"With Non Muslim Disbursement";
            FilterListCui::"THR Compensation":
                Tipe := Tipe::"THR Compensation";
            else begin
                    Tipe := Tipe::" ";
                    TanpaFilter := true;
                    StrTanpaFilter := 'Please choose the THR type from the dashboard first.'
                end;
        end
    end;

    procedure ExcelDays360(StartDate: Date; EndDate: Date): Integer;
    var
        StartDay: Integer;
        StartMonth: Integer;
        StartYear: Integer;

        EndDay: Integer;
        EndMonth: Integer;
        EndYear: Integer;

        Hasil: Integer;
    //DeprCalc: Codeunit "Depreciation Calculation";
    begin
        //coba pake ini tapi makin ngaco
        //Hasil := DeprCalc.DeprDays(StartDate, EndDate, true);

        StartDay := Date2DMY(StartDate, 1);
        StartMonth := Date2DMY(StartDate, 2);
        StartYear := Date2DMY(StartDate, 3);

        EndDay := Date2DMY(EndDate, 1);
        EndMonth := Date2DMY(EndDate, 2);
        EndYear := Date2DMY(EndDate, 3);

        if (StartDay = 31) or (IsLastDayOfFebruary(StartDate)) then
            StartDay := 30;

        //ini baru ditambah
        if ((EndDay = 31) or (EndDay = 30)) and (IsLastDayOfFebruary(EndDate)) then
            EndDay := 30;

        //awalnya yg dipake adalah blok IF berikut
        //if (StartDay = 30) and (EndDay = 31) then
        //    EndDay := 30;

        if (EndDay = 31) then
            EndDay := 30;

        Hasil := ((EndYear - StartYear) * 360) + ((EndMonth - StartMonth) * 30) +
                 (EndDay - StartDay);

        exit(Hasil);
    end;

    procedure ExcelDays360_V2(StartDate: Date; EndDate: Date): Integer;
    var
        StartDay: Integer;
        StartMonth: Integer;
        StartYear: Integer;

        EndDay: Integer;
        EndMonth: Integer;
        EndYear: Integer;

        Hasil: Integer;

        Original_StartDay: Integer;
        Original_EndDay: Integer;
    begin
        Original_StartDay := Date2DMY(StartDate, 1);
        Original_EndDay := Date2DMY(EndDate, 1);

        StartDay := Date2DMY(StartDate, 1);
        StartMonth := Date2DMY(StartDate, 2);
        StartYear := Date2DMY(StartDate, 3);

        EndDay := Date2DMY(EndDate, 1);
        EndMonth := Date2DMY(EndDate, 2);
        EndYear := Date2DMY(EndDate, 3);

        if (StartDay = 31) or (IsLastDayOfFebruary(StartDate)) then
            StartDay := 30;

        //ini baru ditambah
        if ((EndDay = 31) or (EndDay = 30)) or (IsLastDayOfFebruary(EndDate)) then
            EndDay := 30;

        if Original_StartDay = 31 then
            Original_StartDay := 30;

        Hasil := ((EndYear - StartYear) * 360) + ((((EndMonth - StartMonth) - 1)) * 30) +
                 (EndDay + (30 - Original_StartDay));

        exit(Hasil);
    end;

    local procedure IsLastDayOfFebruary(TanggalCurigaFeb: Date): Boolean
    var
        Bulannya: Integer;
        HariTerakhirFeb: Integer;
    begin
        Bulannya := Date2DMY(TanggalCurigaFeb, 2);
        HariTerakhirFeb := Date2DMY(TanggalCurigaFeb, 1);

        if (Bulannya = 2) and ((HariTerakhirFeb = 28) or (HariTerakhirFeb = 29)) then
            exit(true)
        else
            exit(false);
    end;

    procedure TanggalGajianTerakhir(Tanggalnya: Date;
    _FilterList: Option All,"All Active","Muslim THR","Non-Muslim THR","THR Compensation")
    begin
        GajianTerakhirDate := Tanggalnya;
        FilterListCui := _FilterList;
    end;

    var
        AdaTerimaTHR: Boolean;
        FilterListCui: Option All,"All Active","Muslim THR","Non-Muslim THR","THR Compensation";
        GajianTerakhirDate: date;
        PleaseBeInformed: Text;
        EndingDateCalculation: Date;
        Tipe: Option " ","With Muslim Disbursement","With Non Muslim Disbursement","THR Compensation";
}