page 60007 "Employee List HR"
{

    PageType = Worksheet;
    //ApplicationArea = All;
    SourceTable = Employee;
    UsageCategory = Lists;
    CardPageId = "Employee Card HR";
    Caption = 'Monthly Payroll';
    PromotedActionCategories = 'Processing';
    SourceTableView = where("First Name" = filter('<>MSI'));
    InsertAllowed = false;
    DeleteAllowed = false;
    //ModifyAllowed = false;
    //Editable = false;
    RefreshOnActivate = true;


    layout
    {
        area(Content)
        {
            group(atas)
            {
                ShowCaption = false;
                field(Displaying; Displaying)
                {
                    ApplicationArea = all;
                    ShowCaption = false;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field(HariBulanLalu; HariBulanLalu)
                {
                    ShowCaption = false;
                    ApplicationArea = all;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field(HariKerjaBulanLalu; HariKerjaBulanLalu)
                {
                    ShowCaption = false;
                    ApplicationArea = all;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field(HariLiburBulanLalu; HariLiburBulanLalu)
                {
                    ShowCaption = false;
                    ApplicationArea = all;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = true;

                    trigger
                    OnDrillDown()
                    var
                        HRSetup: Record "Payroll General Setup";
                        NonWorkingDates: Page "Non Working Dates";
                        BaseCalendarChange: Record "Base Calendar Change";
                    begin
                        HRSetup.Get();
                        HRSetup.TestField("Base Calendar Code");
                        BaseCalendarChange.Reset();
                        BaseCalendarChange.SetRange("Base Calendar Code", HRSetup."Base Calendar Code");
                        BaseCalendarChange.SetRange(Date, AwalBulanLalu, AkhirBulanLalu);
                        if BaseCalendarChange.FindSet() then begin
                            NonWorkingDates.SetTableView(BaseCalendarChange);
                            NonWorkingDates.Run();
                        end;
                    end;
                }
                field(FilterList; FilterList)
                {
                    Caption = 'Filter Records';
                    ApplicationArea = all;
                    Style = Strong;
                    StyleExpr = true;

                    trigger
                    OnValidate()
                    begin
                        case FilterList of
                            FilterList::All:
                                begin
                                    Rec.Reset();
                                    if not Rec.FindSet() then
                                        Error('There is no data with such filter')
                                    else
                                        Rec.FindSet();

                                    CurrPage.Update(false);
                                end;
                            FilterList::"All Active":
                                begin
                                    Rec.Reset();
                                    Rec.SetRange(Status, Rec.Status::Active);
                                    if not Rec.FindSet() then
                                        Error('There is no data with such filter')
                                    else
                                        Rec.FindSet();

                                    CurrPage.Update(false);
                                end;
                            FilterList::"All Inactive":
                                begin
                                    Rec.Reset();
                                    Rec.SetRange(Status, Rec.Status::Inactive);
                                    if not Rec.FindSet() then
                                        Error('There is no data with such filter')
                                    else
                                        Rec.FindSet();

                                    CurrPage.Update(false);
                                end;
                        end;
                    end;
                }
                field(StrAkhirTahun; StrAkhirTahun)
                {
                    ShowCaption = false;
                    ApplicationArea = all;
                    Editable = false;
                    StyleExpr = true;
                    Style = Unfavorable;
                    MultiLine = true;
                }
            }
            repeater(Group)
            {

                ShowCaption = false;

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                    StyleExpr = NggaAktif;
                    Editable = false;

                    trigger
                    OnDrillDown()
                    var
                        PegawaiHR: Record Employee;
                        CardPegawaiHR: page "Employee Card HR";
                    begin
                        CardPegawaiHR.SetRecord(Rec);
                        CardPegawaiHR.FilterCard(FilterList);
                        CardPegawaiHR.Run();
                    end;
                }
                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = all;
                    Style = Unfavorable;
                    StyleExpr = NggaAktif;
                    Editable = false;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = all;
                    Style = Unfavorable;
                    StyleExpr = NggaAktif;
                    Editable = false;
                }
                field("MSI_HRIS BPJS TK Paid by YCP"; Rec."MSI_HRIS BPJS TK Paid by YCP")
                {
                    ApplicationArea = all;
                    Editable = false;
                    //Visible = false;
                }
                field("MSI_HRIS BPJS Kes. Paid by YCP"; Rec."MSI_HRIS BPJS Kes. Paid by YCP")
                {
                    ApplicationArea = all;
                    Editable = false;
                    //Visible = false;
                }
                field("MSI_HRIS AKDHK Paid by YCP"; Rec."MSI_HRIS AKDHK Paid by YCP")
                {
                    ApplicationArea = all;
                    Editable = false;
                    //Visible = false;
                }
                field("MSI_HRIS BPJS TK YCP Staff"; Rec."MSI_HRIS BPJS TK YCP Staff")
                {
                    ApplicationArea = all;
                    Editable = false;
                    //Visible = false;
                }
                field("MSI_HRIS BPJS Kes. YCP Staff"; Rec."MSI_HRIS BPJS Kes. YCP Staff")
                {
                    ApplicationArea = all;
                    Editable = false;
                    //Visible = false;
                }
                field("MSI_HRIS PTKP Kode"; Rec."MSI_HRIS PTKP Kode")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Kode PTKP';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                /*
                field("Inactive Status"; Rec."Inactive Status")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = InactiveStatus;
                }
                field("MSI_HRIS Leave Balance"; Rec."MSI_HRIS Leave Balance")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Kehadiran; Kehadiran)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Attendance a Month Before';
                    trigger
                    OnAssistEdit()
                    var
                        EmployeeAbsenceLine: Record "Employee Absence Line";
                        PageAbsenceLine: Page "Employee Absence Lines";
                    begin
                        Clear(PageAbsenceLine);
                        EmployeeAbsenceLine.Reset();
                        EmployeeAbsenceLine.SetRange("Employee No.", Rec."No.");
                        EmployeeAbsenceLine.SetRange(Date, AwalBulanLalu, AkhirBulanLalu);
                        if EmployeeAbsenceLine.FindFirst() then begin
                            PageAbsenceLine.LookupMode(true);
                            PageAbsenceLine.SetTableView(EmployeeAbsenceLine);
                            PageAbsenceLine.Run();
                        end;
                    end;
                }
                field(KehadiranSekarang; KehadiranSekarang)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Attendance This Month';
                    trigger
                    OnAssistEdit()
                    var
                        EmployeeAbsenceLine: Record "Employee Absence Line";
                        PageAbsenceLine: Page "Employee Absence Lines";
                    begin
                        Clear(PageAbsenceLine);
                        EmployeeAbsenceLine.Reset();
                        EmployeeAbsenceLine.SetRange("Employee No.", Rec."No.");
                        EmployeeAbsenceLine.SetRange(Date, AwalBulanSekarang, AkhirBulanSekarang);
                        if EmployeeAbsenceLine.FindFirst() then begin
                            PageAbsenceLine.LookupMode(true);
                            PageAbsenceLine.SetTableView(EmployeeAbsenceLine);
                            PageAbsenceLine.Run();
                        end;
                    end;
                }
                field(CutiBolos; CutiBolos)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Unpaid Leave a Month Before';

                    trigger
                    OnAssistEdit()
                    var
                        UnpaidLeaveRequest: Record "Posted Leave Request";
                        ListUnpaidLeave: page "Posted Unpaid Leave Drilldown";
                    begin
                        //bingung, ambil dari unpaid atau postednya
                        //besok kerjain

                        UnpaidLeaveRequest.Reset();
                        UnpaidLeaveRequest.SetRange("Leave Type", UnpaidLeaveRequest."Leave Type"::Unpaid);
                        UnpaidLeaveRequest.SetRange("Employee No.", Rec."No.");
                        UnpaidLeaveRequest.SetFilter("Starting Date", '>=%1', AwalBulanLalu);
                        UnpaidLeaveRequest.SetFilter("Ending Date", '<=%1', AkhirBulanLalu);
                        if UnpaidLeaveRequest.FindFirst() then begin
                            ListUnpaidLeave.LookupMode(true);
                            ListUnpaidLeave.SetTableView(UnpaidLeaveRequest);
                            ListUnpaidLeave.Run();
                        end;
                    end;
                }
                field(DuitPotonganBolos; DuitPotonganBolos)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Salary Deduction a Month Before';
                    trigger
                    OnAssistEdit()
                    var
                        UnpaidLeaveRequest: Record "Posted Leave Request";
                        ListUnpaidLeave: page "Posted Unpaid Leave Drilldown";
                    begin
                        //bingung, ambil dari unpaid atau postednya
                        //besok kerjain

                        UnpaidLeaveRequest.Reset();
                        UnpaidLeaveRequest.SetRange("Leave Type", UnpaidLeaveRequest."Leave Type"::Unpaid);
                        UnpaidLeaveRequest.SetRange("Employee No.", Rec."No.");
                        UnpaidLeaveRequest.SetFilter("Starting Date", '>=%1', AwalBulanLalu);
                        UnpaidLeaveRequest.SetFilter("Ending Date", '<=%1', AkhirBulanLalu);
                        UnpaidLeaveRequest.SetRange(Reversed, false);
                        if UnpaidLeaveRequest.FindFirst() then begin
                            ListUnpaidLeave.LookupMode(true);
                            ListUnpaidLeave.SetTableView(UnpaidLeaveRequest);
                            ListUnpaidLeave.Run();
                        end;
                    end;
                }
                field(LeaveValue; Rec.LeaveValue())
                {
                    Caption = 'Leave Balance (Value)';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(BayarkanCuti; BayarkanCuti)
                {
                    Caption = 'Bayarkan Cuti';
                    ApplicationArea = all;
                    trigger
                    OnDrillDown()
                    begin
                        Rec.TestField(Status, Rec.Status::Active);

                        if Rec.LeaveValue() <= 0 then
                            Error('There is no leave value balance for employee %1',
                            Rec.FullName());

                        if not Rec."Bayarkan Cuti" then
                            Rec."Bayarkan Cuti" := true
                        else
                            if not (Rec."Inactive Status" = Rec."Inactive Status"::Resigned) then
                                Rec."Bayarkan Cuti" := false
                            else
                                Error('Employee % is set to resigned. The leave will be paid.');

                        CurrPage.Update();
                    end;
                }
                */
                field(PeriodePenghasilan; PeriodePenghasilan)
                {
                    Caption = 'Periode Penghasilan';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(BasicSalary; BasicSalary)
                {
                    Caption = 'Basic Salary';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("MSI_HRIS Total Allowance Fix"; Rec."MSI_HRIS Total Allowance Fix")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("MSI_HRIS Total Allownc. NonFix"; Rec."MSI_HRIS Total Allownc. NonFix")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(AdjustmentProrate; AdjustmentProrate)
                {
                    Caption = 'Adjustment Prorate';
                    ApplicationArea = all;
                    Editable = false;
                }
                /*
                field("Uang Pisah"; Rec."Uang Pisah")
                {
                    Caption = 'Uang Pisah/Pesangon';
                    ApplicationArea = all;
                    Editable = false;
                }
                */
                field("MSI_HRIS Overtime"; Rec."MSI_HRIS Overtime")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                /*
                field("Cuti Dibayar"; Rec."Cuti Dibayar")
                {
                    Caption = 'Paid Annual Leave';
                    ApplicationArea = all;
                    Editable = false;
                }
                */
                field(TotalIncome; TotalIncome)
                {
                    Caption = 'Total Income';
                    ApplicationArea = all;
                    Editable = false;
                }
                /*
                field("MSI_HRIS Allowance Tangg. YCP"; Rec."MSI_HRIS Allowance Tangg. YCP")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                */

                /*
                field("Total Allowance"; Rec."MSI_HRIS Total Allowance")
                {
                    Caption = 'Total Premium YCP Portion';
                    ApplicationArea = all;
                    Editable = false;
                    Visible = false;
                }
                */
                field(TotalPremiumTaxed; TotalPremiumTaxed)
                {
                    Caption = 'Total Premium Taxed';
                    ApplicationArea = all;
                    Editable = false;
                    DecimalPlaces = 0 : 0;
                    Visible = false;
                }
                field("MSI_HRIS Total Allowance Taxed"; Rec."MSI_HRIS Total Allowance Taxed")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                /*
                field(GrossIncIncludingTHR; GrossIncIncludingTHR)
                {
                    Caption = 'Gross Income incl. THR';
                    Editable = false;
                    ApplicationArea = all;
                }
                */
                field(GrossIncome; GrossIncome)
                {
                    Caption = 'Gross Income';
                    Editable = false;
                    ApplicationArea = all;
                    //DecimalPlaces = 0 : 0;
                }

                /*
                field("MSI_HRIS Deduction Paid Empl."; Rec."MSI_HRIS Deduction Paid Empl.")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Total Deduction"; Rec."MSI_HRIS Total Deduction")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                */

                field(IuranPensiunTHTJHT; IuranPensiunTHTJHT)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Iuran Pensiun atau Iuran THT/JHT';
                    DecimalPlaces = 0 : 0;
                    Visible = false;
                }

                field("MSI_HRIS Total Deduction Taxed"; Rec."MSI_HRIS Total Deduction Taxed")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Iuran Pensiun atau Iuran THT/JHT';
                    DecimalPlaces = 0 : 0;
                }
                field(RegulerSetahun; RegulerSetahun)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Reguler Setahun';
                }
                /*
                field(SalaryBeforeTaxInclTHR; SalaryBeforeTaxInclTHR)
                {
                    Caption = 'Salary Before Tax incl. THR';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(SalaryBeforeTax; SalaryBeforeTax)
                {
                    Caption = 'Salary Before Tax';
                    ApplicationArea = all;
                    Editable = false;
                }
                */

                /*
                field(BiayaJabatan; BiayaJabatan)
                {
                    Caption = 'Biaya Jabatan';
                    ApplicationArea = all;
                    Editable = false;
                }
                */
                field(BijabReguler; BijabReguler)
                {
                    Editable = false;
                    ApplicationArea = all;
                    Caption = 'Bijab Reguler';
                    DecimalPlaces = 0 : 0;
                }
                field(PensiunJHTTHTSetahun; PensiunJHTTHTSetahun)
                {
                    Caption = 'Iuran Pensiun atau Iuran THT/JHT Setahun';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(JumlahPengurangan; JumlahPengurangan)
                {
                    Caption = 'Jumlah Pengurangan';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(PenghasilanNettoSetahun; PenghasilanNettoSetahun)
                {
                    Caption = 'Penghasilan Netto Setahun/Disetahunkan';
                    ApplicationArea = all;
                    Editable = false;
                }
                /*
                field(YearlyIncomeInclTHR; YearlyIncomeInclTHR)
                {
                    Caption = 'Yearly Income incl. THR';
                    ApplicationArea = all;
                    Editable = false;
                }
                
                field(GrossIncomeForTax; GrossIncomeForTax)
                {
                    Caption = 'Gross Income for Tax';
                    ApplicationArea = all;
                    Editable = false;
                }*/


                /*
                field(YearlyIncomeCorrect; YearlyIncomeCorrect)
                {
                    Caption = 'Yearly Income';
                    ApplicationArea = all;
                    Editable = false;
                }*/
                field("MSI_HRIS PTKP Baru"; Rec."MSI_HRIS PTKP Baru")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                /*
                field(NetYearlyPKPInclTHR; NetYearlyPKPInclTHR)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Net Yearly PKP incl. THR';
                }
                */

                field(PKPCorrect; PKPCorrect)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'PKP';
                }
                /*
                field(NetYearlyPKPInclTHRRoundedDown; NetYearlyPKPInclTHRRoundedDown)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Net Yearly PKP incl. THR (Rounded Down)';
                }
                field(NetYearlyPKPRoundedDown; NetYearlyPKPRoundedDown)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Net Yearly PKP (Rounded Down)';
                }
                field(TaxPerYearInclTHR; TaxPerYearInclTHR)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Tax Per Year incl. THR';
                }
                field(THRTax; THRTax)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'THR Tax';
                }
                field(UangPisahTax; UangPisahTax)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Uang Pisah Tax';
                    Visible = false;
                }
                */


                /*
                field("MSI_HRIS Tax Per Year"; Rec."MSI_HRIS Tax Per Year")
                {
                    ApplicationArea = all;
                    Editable = false;
                }*/

                field(TaxPerYear; TaxPerYear)
                {
                    Caption = 'Tax Per Year';
                    ApplicationArea = all;
                    Editable = false;

                    trigger
                    OnDrillDown()
                    var
                        TabelPajakTahunan: Record "Tarif PPh21 Entry Tahunan";
                        PagePajakTahunan: Page "Tarif PPh21 Entries Tahunan";

                        TabelPajakBiasa: Record "Tarif PPh21 Entry";
                        PagePajakBiasa: page "Tarif PPh21 Entries";
                    begin
                        if BulanAkhirTahun = 12 then begin
                            Clear(PagePajakTahunan);
                            TabelPajakTahunan.Reset();
                            TabelPajakTahunan.SetRange("Employee No.", Rec."No.");
                            TabelPajakTahunan.SetRange("Posting Date December Payroll", TanggalFilter);
                            if TabelPajakTahunan.FindSet() then begin
                                PagePajakTahunan.SetTableView(TabelPajakTahunan);
                                PagePajakTahunan.Run();
                            end;
                        end else begin
                            Clear(PagePajakBiasa);
                            TabelPajakBiasa.Reset();
                            TabelPajakBiasa.SetRange("Employee No.", Rec."No.");
                            TabelPajakBiasa.SetRange("Posting Date Payroll", TanggalFilter);
                            if TabelPajakBiasa.FindSet() then begin
                                PagePajakBiasa.SetTableView(TabelPajakBiasa);
                                PagePajakBiasa.Run();
                            end;
                        end;
                    end;
                }

                field(TaxPerMonth; TaxPerMonth)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Tax Per Month';
                }
                field("MSI_HRIS BPJS Kesehatan Staff"; Rec."MSI_HRIS BPJS Kesehatan Staff")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("MSI_HRIS Last Payroll"; Rec."MSI_HRIS Last Payroll")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(NetSalary; NetSalary)
                {
                    Caption = 'Nett Salary';
                    ApplicationArea = all;
                    Editable = false;
                    DecimalPlaces = 0 : 0;
                }
                field(UnpaidLeaveDeduction; UnpaidLeaveDeduction)
                {
                    Caption = 'Unpaid Leave Deduction';
                    ApplicationArea = all;
                    Editable = false;
                    DecimalPlaces = 0 : 0;
                }
                field(OtherDeduction; OtherDeduction)
                {
                    Caption = 'Other Deduction';
                    ApplicationArea = all;
                    Editable = false;
                    DecimalPlaces = 0 : 0;
                }
                field(TakeHomePay; TakeHomePay)
                {
                    Caption = 'Take Home Pay';
                    ApplicationArea = all;
                    Editable = false;
                    DecimalPlaces = 0 : 0;
                }
                /*
                field(SalaryAfterTax; SalaryAfterTax)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Salary After Tax';
                }
                */
                /*
                field(UangPisahShouldBePaid; UangPisahShouldBePaid)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Uang Pisah/Pesangon Should Be Paid';
                    Visible = false;
                }
                */
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Process Payroll")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = CalculateCost;
                ApplicationArea = all;

                trigger OnAction();
                var
                    EmployeeActive: Record Employee;
                    ProcessPayrollCutiDibayar: Record "Process Payroll Cuti Dibayar";
                    Windows: Dialog;
                    LineNo: Integer;
                begin
                    //CurrPage.SetSelectionFilter(EmployeeSelected);
                    /*
                    EmployeeActive.Reset();
                    EmployeeActive.SetRange(Status, EmployeeActive.Status::Active);
                    EmployeeActive.FindSet();

                    PostingPayrollPage.GetSelectedEmployee(EmployeeActive, false);
                    PostingPayrollPage.LookupMode(true);*/
                    Windows.Open('Preparing...');
                    ProcessPayrollCutiDibayar.DeleteAll();

                    EmployeeActive.Reset();
                    EmployeeActive.SetRange("Bayarkan Cuti", true);
                    if EmployeeActive.FindSet() then
                        repeat
                            ProcessPayrollCutiDibayar.Reset();
                            if ProcessPayrollCutiDibayar.FindLast() then
                                LineNo := LineNo + ProcessPayrollCutiDibayar."Line No."
                            else
                                LineNo := 1;

                            ProcessPayrollCutiDibayar.Init();
                            ProcessPayrollCutiDibayar."Secondary Key" := '';
                            ProcessPayrollCutiDibayar."Line No." := LineNo;
                            ProcessPayrollCutiDibayar."Employee No." := EmployeeActive."No.";
                            EmployeeActive.CalcFields("MSI_HRIS Leave Balance");
                            ProcessPayrollCutiDibayar."Leave Balance" := EmployeeActive."MSI_HRIS Leave Balance";
                            ProcessPayrollCutiDibayar."Leave Balance (Value)" := EmployeeActive.LeaveValue();
                            ProcessPayrollCutiDibayar.Insert();
                        until EmployeeActive.Next() = 0;

                    Windows.Close();
                    PostingPayrollPage.Run();
                    //CurrPage.Update();

                    CurrPage.Close();
                end;
            }
            action("Set Pay Leave for All Eligible")
            {
                Image = PaymentDays;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = all;
                Visible = false;

                trigger
                OnAction()
                var
                    EmployeeCekCuti: Record Employee;
                begin
                    EmployeeCekCuti.Reset();
                    EmployeeCekCuti.SetFilter("MSI_HRIS Leave Balance", '>0');
                    EmployeeCekCuti.SetRange(Status, EmployeeCekCuti.Status::Active);
                    if EmployeeCekCuti.FindSet() then
                        EmployeeCekCuti.ModifyAll("Bayarkan Cuti", true);
                    CurrPage.Update();
                end;
            }
            // fadhil
            action("Salary Report")
            {
                Visible = false;
                Image = Print;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ApplicationArea = all;
                trigger OnAction()
                begin
                    Report.run(Report::"Payroll Slip Big", true, false);
                end;
            }
            // fadhil
            action("Undo Set Pay Leave")
            {
                Image = Undo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = all;
                Visible = false;

                trigger
                OnAction()
                var
                    EmployeeCekCuti: Record Employee;
                begin
                    EmployeeCekCuti.Reset();
                    EmployeeCekCuti.SetFilter("MSI_HRIS Leave Balance", '>0');
                    EmployeeCekCuti.SetRange(Status, EmployeeCekCuti.Status::Active);
                    EmployeeCekCuti.SetRange("Inactive Status", EmployeeCekCuti."Inactive Status"::"--");
                    if EmployeeCekCuti.FindSet() then
                        EmployeeCekCuti.ModifyAll("Bayarkan Cuti", false);
                    CurrPage.Update();
                end;
            }
            action("Clear Transaction")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Delete;
                ApplicationArea = all;
                //Visible = false;

                trigger
                OnAction()
                var
                    PayrollLedgerEntry: Record "Payroll Ledger Entry";
                    Detailed: Record "Detailed Payroll Ledger Entry";
                    TarifPPh21Entry: Record "Tarif PPh21 Entry";
                    overtime: Record "Overtime Ledger Entry";
                    tarif: Record "Tarif PKP Ledger Entry";
                    GenPayment: Record "Advance Header";


                    OvertimeHeader: Record "Overtime Header";
                    OvertimeLine: Record "Overtime Line";

                    PostedOvertimeHeader: Record "Posted Overtime Header";
                    PostedOvertimeLine: Record "Posted Overtime Line";

                    THRAccrualLedger: Record "THR Accrual Ledger Entry";
                    SeveranceAccrualLedger: Record "Severance Accrual Ledger Entry";
                    SisaCutiDibayarAccrualLedger: Record "Sisa Cuti Accrual Ledger Entry";

                    EmployeeLast: Record Employee;

                    PostedUnpaidLeave: Record "Posted Leave Request";
                    UnpaidLeave: Record "Leave Request";
                    EmployeeListHR: page "Employee List HR";
                    Window: Dialog;
                    AdvanceHeader: Record "Advance Header";
                    THRLedgerEntryCekHapus: Record "THR Ledger Entry";
                    PayrollLedgerEntryCekHapus: Record "Payroll Ledger Entry";
                    AdaLinkTHR: Boolean;
                    PayrollProcessedEntryCek: Record "Payroll Processed Entry";
                    AdvanceHeaderCek: Record "Advance Header";
                    GenJnlLine: Record "Gen. Journal Line";
                begin
                    if not confirm('Continue to clear payrol transaction for date ' +
                        format(TanggalFilter, 0, '<Day> <Month Text> <Year4>') + '?') then
                        exit;

                    CurrPage.Close();

                    Window.Open('Clearing data, please wait...');

                    PayrollProcessedEntryCek.Get(TanggalFilter);
                    if PayrollProcessedEntryCek."GP Document No." <> '' then begin
                        AdvanceHeaderCek.Reset();
                        AdvanceHeaderCek.SetRange("Document Type", AdvanceHeaderCek."Document Type"::"General Payment");
                        AdvanceHeaderCek.SetRange("No.", PayrollProcessedEntryCek."GP Document No.");
                        AdvanceHeaderCek.SetRange("Voucher Type", AdvanceHeaderCek."Voucher Type"::" ");
                        AdvanceHeaderCek.SetRange(Status, AdvanceHeaderCek.Status::Open);
                        if not AdvanceHeaderCek.FindFirst() then
                            Error('There is a GP no %1 linked to payroll %2, and it is already processed.\' +
                                  'So you cannot clear this transaction.', PayrollProcessedEntryCek."GP Document No.",
                                  TanggalFilter);
                    end;

                    if PayrollProcessedEntryCek."GP For BPJS TK" <> '' then begin
                        AdvanceHeaderCek.Reset();
                        AdvanceHeaderCek.SetRange("Document Type", AdvanceHeaderCek."Document Type"::"General Payment");
                        AdvanceHeaderCek.SetRange("No.", PayrollProcessedEntryCek."GP For BPJS TK");
                        AdvanceHeaderCek.SetRange("Voucher Type", AdvanceHeaderCek."Voucher Type"::" ");
                        AdvanceHeaderCek.SetRange(Status, AdvanceHeaderCek.Status::Open);
                        if not AdvanceHeaderCek.FindFirst() then
                            Error('There is a GP no %1 linked to payroll %2, and it is already processed.\' +
                                  'So you cannot clear this transaction.', PayrollProcessedEntryCek."GP For BPJS TK",
                                  TanggalFilter);
                    end;


                    AdaLinkTHR := false;

                    PayrollLedgerEntryCekHapus.Reset();
                    PayrollLedgerEntryCekHapus.SetRange("Posting Date", TanggalFilter);
                    if PayrollLedgerEntryCekHapus.FindFirst() then
                        repeat
                            THRLedgerEntryCekHapus.Reset();
                            THRLedgerEntryCekHapus.SetRange("Payroll Ledger Entry No.",
                            PayrollLedgerEntryCekHapus."Entry No.");
                            if THRLedgerEntryCekHapus.FindFirst() then
                                AdaLinkTHR := true;
                        until PayrollLedgerEntryCekHapus.Next() = 0;


                    if not AdaLinkTHR then begin
                        PayrollLedgerEntry.Reset();
                        PayrollLedgerEntry.SetRange("Posting Date", TanggalFilter);
                        if PayrollLedgerEntry.FindSet() then begin
                            PayrollLedgerEntry.DeleteAll();
                        end;
                    end else
                        Error('Payroll date %1 is linked to a THR transaction.\' +
                              'If you still want to delete this transaction, you have to delete THR transaction first',
                              TanggalFilter);


                    TarifPPh21Entry.Reset();
                    TarifPPh21Entry.SetRange("Posting Date Payroll", TanggalFilter);
                    if TarifPPh21Entry.FindSet() then
                        TarifPPh21Entry.DeleteAll();

                    Detailed.Reset();
                    Detailed.SetRange("Posting Date", TanggalFilter);
                    if Detailed.FindSet() then
                        Detailed.DeleteAll();

                    overtime.Reset();
                    overtime.SetRange("Payroll Posting Date", TanggalFilter);
                    if overtime.FindSet() then
                        overtime.DeleteAll();

                    tarif.Reset();
                    tarif.SetRange("Posting Date", TanggalFilter);
                    if tarif.FindSet() then
                        tarif.DeleteAll();


                    if PayrollProcessedEntry.Get(TanggalFilter) then begin
                        //Hapus GP Payroll
                        if PayrollProcessedEntry."GP Document No." <> '' then begin
                            AdvanceHeader.Reset();
                            AdvanceHeader.SetRange("Document Type", AdvanceHeader."Document Type"::"General Payment");
                            AdvanceHeader.SetRange("No.", PayrollProcessedEntry."GP Document No.");
                            if AdvanceHeader.FindFirst() then
                                if AdvanceHeader.Status = AdvanceHeader.Status::Open then begin
                                    AdvanceHeader."Delete via HR" := true;
                                    AdvanceHeader.Modify();

                                    GenJnlLine.Reset();
                                    GenJnlLine.SetRange("Journal Template Name", AdvanceHeader."Journal Template Name");
                                    GenJnlLine.SetRange("Journal Batch Name", AdvanceHeader."Journal Batch Name");
                                    if GenJnlLine.FindSet() then
                                        GenJnlLine.ModifyAll("Delete via HR", true);

                                    AdvanceHeader.Delete(true);
                                end;
                        end;

                        //Hapus GP Payroll Tax
                        if PayrollProcessedEntry."GP For Tax" <> '' then begin
                            AdvanceHeader.Reset();
                            AdvanceHeader.SetRange("Document Type", AdvanceHeader."Document Type"::"General Payment");
                            AdvanceHeader.SetRange("No.", PayrollProcessedEntry."GP For Tax");
                            if AdvanceHeader.FindFirst() then
                                if AdvanceHeader.Status = AdvanceHeader.Status::Open then begin
                                    AdvanceHeader."Delete via HR" := true;
                                    AdvanceHeader.Modify();

                                    GenJnlLine.Reset();
                                    GenJnlLine.SetRange("Journal Template Name", AdvanceHeader."Journal Template Name");
                                    GenJnlLine.SetRange("Journal Batch Name", AdvanceHeader."Journal Batch Name");
                                    if GenJnlLine.FindSet() then
                                        GenJnlLine.ModifyAll("Delete via HR", true);

                                    AdvanceHeader.Delete(true);
                                end;
                        end;


                        //Hapus GP Payroll BPJS TK
                        if PayrollProcessedEntry."GP For BPJS TK" <> '' then begin
                            AdvanceHeader.Reset();
                            AdvanceHeader.SetRange("Document Type", AdvanceHeader."Document Type"::"General Payment");
                            AdvanceHeader.SetRange("No.", PayrollProcessedEntry."GP For BPJS TK");
                            if AdvanceHeader.FindFirst() then
                                if AdvanceHeader.Status = AdvanceHeader.Status::Open then begin
                                    AdvanceHeader."Delete via HR" := true;
                                    AdvanceHeader.Modify();

                                    GenJnlLine.Reset();
                                    GenJnlLine.SetRange("Journal Template Name", AdvanceHeader."Journal Template Name");
                                    GenJnlLine.SetRange("Journal Batch Name", AdvanceHeader."Journal Batch Name");
                                    if GenJnlLine.FindSet() then
                                        GenJnlLine.ModifyAll("Delete via HR", true);

                                    AdvanceHeader.Delete(true);
                                end;
                        end;


                        PayrollProcessedEntry.Delete();
                    end;


                    //pindahin isi posted overtime ke dokumen overtime biasa.
                    PostedOvertimeHeader.Reset();
                    PostedOvertimeHeader.SetRange("Payroll Date", TanggalFilter);
                    if PostedOvertimeHeader.FindFirst() then
                        repeat
                            OvertimeHeader.Init();
                            OvertimeHeader.TransferFields(PostedOvertimeHeader);
                            OvertimeHeader.Status := OvertimeHeader.Status::Released;
                            OvertimeHeader.Insert();

                            PostedOvertimeLine.Reset();
                            PostedOvertimeLine.SetRange("Document No.", PostedOvertimeHeader."No.");
                            if PostedOvertimeLine.FindFirst() then
                                repeat
                                    OvertimeLine.Init();
                                    OvertimeLine.TransferFields(PostedOvertimeLine);
                                    OvertimeLine.Insert();
                                until PostedOvertimeLine.Next() = 0;
                        until PostedOvertimeHeader.Next() = 0;


                    //hapusin postednya
                    PostedOvertimeHeader.Reset();
                    PostedOvertimeHeader.SetRange("Payroll Date", TanggalFilter);
                    if PostedOvertimeHeader.FindFirst() then
                        repeat
                            PostedOvertimeHeader.Delete(true);
                        until PostedOvertimeHeader.Next() = 0;


                    //pindahin isi posted ke dokumen unpaid leave biasa
                    PostedUnpaidLeave.Reset();
                    PostedUnpaidLeave.SetRange("Leave Type", PostedUnpaidLeave."Leave Type"::Unpaid);
                    PostedUnpaidLeave.SetRange("Payroll Posting Date", TanggalFilter);
                    if PostedUnpaidLeave.FindFirst() then
                        repeat
                            UnpaidLeave.Init();
                            UnpaidLeave.TransferFields(PostedUnpaidLeave);
                            UnpaidLeave.Status := UnpaidLeave.Status::Released;
                            UnpaidLeave.Insert();
                        until PostedUnpaidLeave.Next() = 0;

                    //Hapus postednya
                    PostedUnpaidLeave.Reset();
                    PostedUnpaidLeave.SetRange("Leave Type", PostedUnpaidLeave."Leave Type"::Unpaid);
                    PostedUnpaidLeave.SetRange("Payroll Posting Date", TanggalFilter);
                    if PostedUnpaidLeave.FindSet() then
                        PostedUnpaidLeave.DeleteAll();


                    THRAccrualLedger.Reset();
                    THRAccrualLedger.SetRange("Payroll Date", TanggalFilter);
                    if THRAccrualLedger.FindSet() then
                        THRAccrualLedger.DeleteAll();

                    SeveranceAccrualLedger.Reset();
                    SeveranceAccrualLedger.SetRange("Payroll Date", TanggalFilter);
                    if SeveranceAccrualLedger.FindSet() then
                        SeveranceAccrualLedger.DeleteAll();

                    SisaCutiDibayarAccrualLedger.Reset();
                    SisaCutiDibayarAccrualLedger.SetRange("Payroll Date", TanggalFilter);
                    if SisaCutiDibayarAccrualLedger.FindSet() then
                        SisaCutiDibayarAccrualLedger.DeleteAll();



                    Window.Close();
                    Message('Payroll data for %1 successfully cleared.',
                    Format(TanggalFilter, 0, '<Day> <Month Text> <Year>'));

                    EmployeeListHR.Run();
                end;
            }
            action("Calculate Income Tax")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = TaxPayment;
                ApplicationArea = all;
                Visible = false;

                trigger
                OnAction()
                begin
                    HitungTaxLagi(Rec."No.", PKPCorrect, TanggalFilter);
                    Message('Done.');
                end;
            }

        }
    }

    var
        AdjustmentProrate: Decimal;
        UnpaidLeaveDeduction: Decimal;
        TakeHomePay: Decimal;
        CutiBolos: Decimal;
        Kehadiran: Integer;
        KehadiranSekarang: Integer;
        DuitPotonganBolos: Decimal;
        ShowWithInactive: Boolean;
        BayarkanCuti: Boolean;
        //Gaji: Decimal;
        StrTanggalFilter: Text[30];
        TanggalFilter: date;
        PayrollLedgerEntry: Record "Payroll Ledger Entry";

        PostingPayrollPage: page "Process Payroll Page";
        NggaAktif: Boolean;
        InactiveStatus: Boolean;
        SalaryBeforeTax: Decimal;
        TaxPerMonth: Decimal;
        PostPayroll: Codeunit "Payroll Post";
        BiayaJabatan: Decimal;
        TotalIncome: Decimal;
        GrossIncIncludingTHR: Decimal;
        GrossIncome: Decimal;
        SalaryBeforeTaxInclTHR: Decimal;
        YearlyIncomeInclTHR: Decimal;
        YearlyIncome: Decimal;
        NetYearlyPKPInclTHR: Decimal;
        NetYearlyPKP: Decimal;

        NetYearlyPKPInclTHRRoundedDown: Decimal;
        NetYearlyPKPRoundedDown: Decimal;
        TaxPerYearInclTHR: Decimal;
        TaxPerYear: Decimal;
        THRTax: Decimal;
        UangPisahTax: Decimal;
        SalaryAfterTax: Decimal;
        UangPisahShouldBePaid: Decimal;
        Misc: Codeunit Miscellaneous;
        StartingLalu: Date;
        AwalBulanLalu: Date;
        AkhirBulanLalu: Date;
        AwalBulanSekarang: Date;
        AkhirBulanSekarang: Date;
        Displaying: Text[100];
        HariBulanLalu: Text[100];
        HariKerjaBulanLalu: Text[100];
        HariLiburBulanLalu: Text[100];
        JumlahHari: Integer;
        JumlahHariKerja: Integer;
        JumlahHariLibur: Integer;
        AdjustmentProRateDRE: Decimal;
        EmployeeKurangKehadiran: Integer;
        GrossIncomeForTax: Decimal;
        YearlyIncomeCorrect: Decimal;
        Pengurang: Decimal;
        PositionLedgerEntry: Record "Position Ledger Entry";
        PeriodePenghasilan: Integer;
        RegulerSetahun: Decimal;
        BijabReguler: Decimal;
        PensiunJHTTHTSetahun: Decimal;
        IuranPensiunTHTJHT: Decimal;
        JumlahPengurangan: Decimal;
        PenghasilanNettoSetahun: Decimal;
        PKPCorrect: Decimal;
        TarifPPh21Entry: Record "Tarif PPh21 Entry";
        LessOverDeductTax: Decimal;
        TotalPremiumTaxed: Decimal;
        NetSalary: Decimal;
        FilterList: Option All,"All Active","All Inactive";
        BasicSalary: Decimal;
        StrAkhirTahun: Text;
        PayrollProcessedEntry: Record "Payroll Processed Entry";
        BulanAkhirTahun: Integer;
        TahunAkhirTahun: Integer;
        OtherDeduction: Decimal;

    trigger
    OnAfterGetRecord()
    var
        EmployeeAttendance: Record Employee;
        EmployeeAttendanceSekarang: Record Employee;
        ContractDetail: Record "Contract Detail";
        PostedUnpaidLeave: Record "Posted Leave Request";
    begin
        clear(SalaryBeforeTax);
        Clear(TaxPerMonth);
        //Clear(Gaji);
        Clear(BiayaJabatan);
        Clear(TotalIncome);
        Clear(GrossIncIncludingTHR);
        clear(GrossIncome);
        Clear(SalaryBeforeTax);
        Clear(SalaryBeforeTaxInclTHR);
        Clear(YearlyIncome);
        Clear(YearlyIncomeInclTHR);
        Clear(NetYearlyPKP);
        Clear(NetYearlyPKPInclTHR);
        Clear(NetYearlyPKPInclTHRRoundedDown);
        clear(NetYearlyPKPRoundedDown);
        Clear(TaxPerYearInclTHR);
        clear(TaxPerYear);
        Clear(THRTax);
        clear(SalaryAfterTax);
        Clear(UangPisahShouldBePaid);
        Clear(CutiBolos);
        Clear(Kehadiran);
        clear(KehadiranSekarang);
        clear(DuitPotonganBolos);
        Clear(AdjustmentProRateDRE);
        Clear(EmployeeKurangKehadiran);
        Clear(GrossIncomeForTax);
        Clear(YearlyIncomeCorrect);
        Clear(Pengurang);
        Clear(PeriodePenghasilan);
        Clear(RegulerSetahun);
        Clear(BijabReguler);
        Clear(PensiunJHTTHTSetahun);
        Clear(JumlahPengurangan);
        Clear(PenghasilanNettoSetahun);
        Clear(PKPCorrect);
        Clear(LessOverDeductTax);
        Clear(TotalPremiumTaxed);
        Clear(NetSalary);
        Clear(UnpaidLeaveDeduction);
        Clear(TakeHomePay);
        Clear(BasicSalary);
        Clear(OtherDeduction);
        Clear(AdjustmentProrate);

        if Rec."Bayarkan Cuti" then
            BayarkanCuti := true
        else
            BayarkanCuti := false;

        StrTanggalFilter := Rec.GetFilter("Date Filter");
        Evaluate(TanggalFilter, StrTanggalFilter);

        Displaying := 'Displaying data for payroll date = ' +
        FORMAT(TanggalFilter, 0, '<Day> <Month Text> <Year4>');


        if TanggalFilter <> 0D then begin

            BulanAkhirTahun := Date2DMY(TanggalFilter, 2);

            if BulanAkhirTahun = 12 then begin
                TahunAkhirTahun := Date2DMY(TanggalFilter, 3);
                PayrollProcessedEntry.Reset();
                PayrollProcessedEntry.SetRange("Posting Date Salary", TanggalFilter);
                PayrollProcessedEntry.SetRange("Year End Process",
                PayrollProcessedEntry."Year End Process"::"Awaiting Process");
                if PayrollProcessedEntry.FindFirst() then begin
                    StrAkhirTahun := 'Year-end monthly payroll for year ' + Format(TahunAkhirTahun) + ' is already processed. ' +
                    'Now awaiting YEAR END PPH CALCULATION to be applied to payroll date ' +
                    FORMAT(TanggalFilter, 0, '<Day> <Month Text> <Year4>') + '.' +
                    ' Please proceed accordingly.';
                end else begin
                    TahunAkhirTahun := Date2DMY(TanggalFilter, 3);
                    PayrollProcessedEntry.Reset();
                    PayrollProcessedEntry.SetRange("Posting Date Salary", TanggalFilter);
                    PayrollProcessedEntry.SetRange("Year End Process",
                    PayrollProcessedEntry."Year End Process"::Processed);
                    if PayrollProcessedEntry.FindFirst() then begin
                        StrAkhirTahun := 'Year-end process completed.';
                    end else
                        StrAkhirTahun := '';
                end;
            end;


            StartingLalu := CalcDate('<-1M>', TanggalFilter);
            //nyari data bolos
            Rec.UnpaidLeave(StartingLalu, CutiBolos, DuitPotonganBolos);

            //nyari kehadiran employee
            EmployeeAttendance.Get(Rec."No.");
            AwalBulanLalu := CalcDate('-CM', StartingLalu);
            AkhirBulanLalu := CalcDate('CM', StartingLalu);

            Misc.CheckCalendar(AwalBulanLalu, JumlahHari, JumlahHariLibur);

            HariBulanLalu := 'Total days from ' + FORMAT(AwalBulanLalu, 0, '<Day> <Month Text> <Year4>')
            + ' to ' + FORMAT(AkhirBulanLalu, 0, '<Day> <Month Text> <Year4>') + ' = ' +
            format(JumlahHari);

            HariKerjaBulanLalu := 'Total working days from ' + FORMAT(AwalBulanLalu, 0, '<Day> <Month Text> <Year4>')
            + ' to ' + FORMAT(AkhirBulanLalu, 0, '<Day> <Month Text> <Year4>') + ' = ' +
            format(JumlahHari - JumlahHariLibur);

            HariLiburBulanLalu := 'Total non-working days from ' + FORMAT(AwalBulanLalu, 0, '<Day> <Month Text> <Year4>')
            + ' to ' + FORMAT(AkhirBulanLalu, 0, '<Day> <Month Text> <Year4>') + ' = ' +
            format(JumlahHariLibur);

            EmployeeAttendance.SetRange("Date Filter", AwalBulanLalu, AkhirBulanLalu);
            EmployeeAttendance.CalcFields(Attendance);
            Kehadiran := EmployeeAttendance.Attendance;

            AwalBulanSekarang := CalcDate('-CM', Today);
            AkhirBulanSekarang := CalcDate('CM', Today);

            EmployeeAttendanceSekarang.Get(Rec."No.");
            EmployeeAttendanceSekarang.SetRange("Date Filter", AwalBulanSekarang, AkhirBulanSekarang);
            EmployeeAttendanceSekarang.CalcFields(Attendance);
            KehadiranSekarang := EmployeeAttendanceSekarang.Attendance;

            //tadinya pake ini
            //PostPayroll.HitungBulanKerja(EmployeeAttendanceSekarang, PeriodePenghasilan, TanggalFilter);
            ContractDetail.GetPeriodePenghasilan(EmployeeAttendanceSekarang, TanggalFilter, PeriodePenghasilan);

            if Rec.Status = Rec.Status::Active then
                if DuitPotonganBolos <> 0 then
                    AdjustmentProRateDRE := Rec."MSI_HRIS Basic Salary" - DuitPotonganBolos;
        end;


        PayrollLedgerEntry.Reset();
        PayrollLedgerEntry.SetRange("Employee No.", Rec."No.");
        PayrollLedgerEntry.SetRange("Posting Date", TanggalFilter);
        if PayrollLedgerEntry.FindSet() then begin
            Rec.CalcFields("MSI_HRIS Total Allowance");
            Rec.CalcFields("MSI_HRIS Total Deduction");
            Rec.CalcFields("MSI_HRIS Total Allowance Taxed");
            Rec.CalcFields("MSI_HRIS Total Deduction Taxed");
            Rec.CalcFields("MSI_HRIS PPh 21");
            Rec.CalcFields("MSI_HRIS Overtime Processed");
            Rec.CalcFields("MSI_HRIS Bijab Reguler");
            //Rec.CalcFields("MSI_HRIS PTKP");
            Rec.CalcFields("MSI_HRIS PTKP Baru");
            Rec.CalcFields("MSI_HRIS Overtime");
            Rec.CalcFields("MSI_HRIS THR Ledger");


            Rec.CalcFields("MSI_HRIS Total Allowance Fix");
            Rec.CalcFields("MSI_HRIS Total Allownc. NonFix");
            Rec.CalcFields("MSI_HRIS BPJS Kesehatan Staff");

            TotalPremiumTaxed := round(Rec."MSI_HRIS Total Allowance Taxed", 1, '=');
            IuranPensiunTHTJHT := round(rec."MSI_HRIS Total Deduction Taxed");

            PostedUnpaidLeave.Reset();
            PostedUnpaidLeave.SetRange("Employee No.", Rec."No.");
            PostedUnpaidLeave.SetRange("Payroll Ledger Entry No.",
            PayrollLedgerEntry."Entry No.");
            if PostedUnpaidLeave.FindFirst() then
                UnpaidLeaveDeduction := round(PostedUnpaidLeave."Salary Deduction", 1, '=');


            TotalIncome := PayrollLedgerEntry."Total Income";
            GrossIncome := PayrollLedgerEntry."Gross Income";
            RegulerSetahun := PayrollLedgerEntry."Reguler Setahun";
            BiayaJabatan := PayrollLedgerEntry."Biaya Jabatan";
            BijabReguler := PayrollLedgerEntry."Bijab Reguler";
            PensiunJHTTHTSetahun := PayrollLedgerEntry."Pensiun JHT THT Setahun";
            JumlahPengurangan := PayrollLedgerEntry."Jumlah Pengurangan";
            PenghasilanNettoSetahun := PayrollLedgerEntry."Penghasilan Netto Setahun";
            PKPCorrect := PayrollLedgerEntry."PKP Correct";
            LessOverDeductTax := PayrollLedgerEntry."Less/Over Deduct Tax";
            OtherDeduction := PayrollLedgerEntry."Other Deduction";
            AdjustmentProrate := PayrollLedgerEntry."Adjustment Prorate";

            //ljsadlkfajsdf

            Rec.CalcFields("MSI_HRIS Tax Per Year");
            Rec.CalcFields("MSI_HRIS Tax Per Year End");
            Rec.CalcFields("MSI_HRIS PPh 21 Terutang");

            if BulanAkhirTahun = 12 then begin
                TaxPerYear := Rec."MSI_HRIS Tax Per Year End";
                TaxPerMonth := Rec."MSI_HRIS PPh 21 Terutang";
            end else begin
                TaxPerYear := Rec."MSI_HRIS Tax Per Year";

                if not Rec."MSI_HRIS Last Payroll" then
                    if PayrollLedgerEntry."Periode Penghasilan" <> 0 then
                        TaxPerMonth := Round(Rec."MSI_HRIS Tax Per Year" /
                                                PayrollLedgerEntry."Periode Penghasilan", 1)
                    else
                        TaxPerMonth := 0
                else
                    TaxPerMonth := LessOverDeductTax;
            end;

            NetSalary := round(TotalIncome + Rec."MSI_HRIS BPJS Kesehatan Staff" +
            IuranPensiunTHTJHT - TaxPerMonth, 1, '=');

            TakeHomePay := round(NetSalary - UnpaidLeaveDeduction - OtherDeduction, 1, '=');

            UangPisahShouldBePaid := Rec."Uang Pisah" - UangPisahTax;
            BasicSalary := PayrollLedgerEntry."Basic Salary";

        end else begin
            //Gaji := 0;
            //NetPTKP := 0;
            SalaryBeforeTax := 0;
            TaxPerMonth := 0;
            TotalIncome := 0;
            GrossIncIncludingTHR := 0;
            GrossIncome := 0;
            SalaryBeforeTaxInclTHR := 0;
            SalaryBeforeTax := 0;
            YearlyIncome := 0;
            YearlyIncomeInclTHR := 0;
            NetYearlyPKP := 0;
            NetYearlyPKPInclTHR := 0;
            NetYearlyPKPInclTHRRoundedDown := 0;
            NetYearlyPKPRoundedDown := 0;
            TaxPerYearInclTHR := 0;
            TaxPerYear := 0;
            THRTax := 0;
            UangPisahTax := 0;
            SalaryAfterTax := 0;
            UangPisahShouldBePaid := 0;
            BasicSalary := Rec."MSI_HRIS Basic Salary";
        end;


        if Rec.Status <> Rec.Status::Active then
            NggaAktif := true
        else
            NggaAktif := false;

        if (Rec."Inactive Status" = Rec."Inactive Status"::"Contract Terminated") or
            (Rec."Inactive Status" = Rec."Inactive Status"::Resigned) then
            InactiveStatus := true
        else
            InactiveStatus := false;
    end;

    trigger
    OnOpenPage()
    var
        PayrollLedgerEntry: Record "Payroll Ledger Entry";

    begin
        FilterList := FilterList::"All Active";
        Rec.SetRange(Status, Rec.Status::Active);
        if Rec.FindSet() then;


        PayrollLedgerEntry.Reset();
        PayrollLedgerEntry.SetCurrentKey("Posting Date");
        if PayrollLedgerEntry.FindLast() then begin
            Rec.SetFilter("Date Filter", format(PayrollLedgerEntry."Posting Date"));
        end;

        StrTanggalFilter := Rec.GetFilter("Date Filter");
        Evaluate(TanggalFilter, StrTanggalFilter);

        Displaying := 'Displaying data for payroll date: ' +
        FORMAT(TanggalFilter, 0, '<Day> <Month Text> <Year>');

        if TanggalFilter <> 0D then
            BulanAkhirTahun := Date2DMY(TanggalFilter, 2);

        if BulanAkhirTahun = 12 then begin
            TahunAkhirTahun := Date2DMY(TanggalFilter, 3);
            PayrollProcessedEntry.Reset();
            PayrollProcessedEntry.SetRange("Posting Date Salary", TanggalFilter);
            PayrollProcessedEntry.SetRange("Year End Process",
            PayrollProcessedEntry."Year End Process"::"Awaiting Process");
            if PayrollProcessedEntry.FindFirst() then begin
                StrAkhirTahun := 'Year-end monthly payroll for year ' + Format(TahunAkhirTahun) + ' is already processed. ' +
                'Now awaiting YEAR END PPH CALCULATION to be applied to payroll date ' +
                FORMAT(TanggalFilter, 0, '<Day> <Month Text> <Year4>') + '.' +
                ' Please proceed accordingly.';
            end else begin
                TahunAkhirTahun := Date2DMY(TanggalFilter, 3);
                PayrollProcessedEntry.Reset();
                PayrollProcessedEntry.SetRange("Posting Date Salary", TanggalFilter);
                PayrollProcessedEntry.SetRange("Year End Process",
                PayrollProcessedEntry."Year End Process"::Processed);
                if PayrollProcessedEntry.FindFirst() then begin
                    StrAkhirTahun := 'Year-end process completed.';
                end else
                    StrAkhirTahun := '';
            end;
        end;
    end;

    procedure HitungTax(EmpGitu: Record Employee; NetPKP: Decimal; var _DuitPPh21: Decimal);
    var
        TarifPPh21Setup: Record "Tariff PPh 21 Setup";
        Selesai: Boolean;
        PayrollPost: Codeunit "Payroll Post";
        _TarifYangDipake: Decimal;
        TempTax: Decimal;

    begin
        Clear(_DuitPPh21);

        TarifPPh21Setup.Reset();
        TarifPPh21Setup.FindFirst();
        repeat
            _TarifYangDipake := PayrollPost.GetTarifNPWP(EmpGitu, TarifPPh21Setup);
            Clear(TempTax);

            if (TarifPPh21Setup."Upper Limit" <> 0) and (TarifPPh21Setup."Upper Limit" < NetPKP) then begin
                TempTax := (_TarifYangDipake / 100) * TarifPPh21Setup."Upper Limit";
                NetPKP := NetPKP - TarifPPh21Setup."Upper Limit";
            end else begin
                TempTax := (_TarifYangDipake / 100) * NetPKP;
                Selesai := true;
            end;

            //InsertTarifPPh21Entry(EmpGitu, TempTax);

            _DuitPPh21 := _DuitPPh21 + TempTax;
        until (Selesai) or (TarifPPh21Setup.Next() = 0);
    end;


    procedure HitungTaxLagi(KodeEmp: Code[20]; NetPKP: Decimal; PostingDateGajian: Date);
    var
        TarifPPh21Setup: Record "Tariff PPh 21 Setup";
        Selesai: Boolean;
        PayrollPost: Codeunit "Payroll Post";
        _TarifYangDipake: Decimal;
        TempTax: Decimal;
        Monyet: Record Employee;
        TarifPPh21Entry: Record "Tarif PPh21 Entry";
    begin
        Monyet.Get(KodeEmp);

        TarifPPh21Setup.Reset();
        TarifPPh21Setup.FindFirst();
        repeat
            _TarifYangDipake := PayrollPost.GetTarifNPWP(Monyet, TarifPPh21Setup);

            if (TarifPPh21Setup."Upper Limit" <> 0) and
                (TarifPPh21Setup."Nilai Pengali Tarif" < NetPKP) then begin
                TarifPPh21Entry.InsertTarifPPh21Entry(Monyet, TarifPPh21Setup."Nilai Pengali Tarif",
                _TarifYangDipake, PostingDateGajian);
                NetPKP := NetPKP - TarifPPh21Setup."Nilai Pengali Tarif";
            end else begin
                TarifPPh21Entry.InsertTarifPPh21Entry(Monyet, NetPKP, _TarifYangDipake,
                PostingDateGajian);
                Selesai := true;
            end;

        until (Selesai) or (TarifPPh21Setup.Next() = 0);
    end;



    procedure HitungTaxLagiTahunan(KodeEmp: Code[20]; NetPKP: Decimal; PostingDateGajian: Date);
    var
        TarifPPh21Setup: Record "Tariff PPh 21 Setup";
        Selesai: Boolean;
        PayrollPost: Codeunit "Payroll Post";
        _TarifYangDipake: Decimal;
        TempTax: Decimal;
        Monyet: Record Employee;
        TarifPPh21EntryTahunan: Record "Tarif PPh21 Entry Tahunan";
    begin
        Monyet.Get(KodeEmp);

        TarifPPh21Setup.Reset();
        TarifPPh21Setup.FindFirst();
        repeat
            _TarifYangDipake := PayrollPost.GetTarifNPWP(Monyet, TarifPPh21Setup);

            if (TarifPPh21Setup."Upper Limit" <> 0) and
                (TarifPPh21Setup."Nilai Pengali Tarif" < NetPKP) then begin
                TarifPPh21EntryTahunan.InsertTarifPPh21EntryTahunan(Monyet, TarifPPh21Setup."Nilai Pengali Tarif",
                _TarifYangDipake, PostingDateGajian);
                NetPKP := NetPKP - TarifPPh21Setup."Nilai Pengali Tarif";
            end else begin
                TarifPPh21EntryTahunan.InsertTarifPPh21EntryTahunan(Monyet, NetPKP, _TarifYangDipake,
                PostingDateGajian);
                Selesai := true;
            end;

        until (Selesai) or (TarifPPh21Setup.Next() = 0);
    end;
}