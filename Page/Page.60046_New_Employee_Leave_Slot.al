page 60046 "New Employee Leave Slot"
{
    PageType = Card;
    Caption = 'Employee Leave Slot';
    //ApplicationArea = All;
    UsageCategory = Administration;
    //SaveValues = true;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(EmployeeNo; EmployeeNo)
                {
                    Caption = 'Employee No.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(EmployeeName; EmployeeName)
                {
                    Caption = 'Employee Name';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(JatahCuti; JatahCuti)
                {
                    DecimalPlaces = 3;
                    Caption = 'Leave Slot';
                    ApplicationArea = all;
                    Editable = false;
                }
            }
            group("Monthly Eligible Leave")
            {
                field(PeriodeCutiEligible; PeriodeCutiEligible)
                {
                    Caption = 'Eligible Leave Period';
                    ApplicationArea = all;
                    trigger
                    OnValidate()
                    var
                        ContractInfo: Record "Position Ledger Entry";
                        TanggalResign: Integer;

                        TanggalMulaiContract: Integer;
                        TanggalSelesaiContract: Integer;

                        BulanPeriodeCutiEligible: Integer;
                        TahunPeriodeCutiEligible: Integer;

                        BulanMulaiContract: Integer;
                        TahunMulaiContract: Integer;

                        BulanSelesaiContract: Integer;
                        TahunSelesaiContract: Integer;

                        TahunTanggalResign: Integer;
                        BulanTanggalResign: Integer;
                    begin
                        StrPeriodCutiEligible := Format(PeriodeCutiEligible, 0, '<Month Text> <Year4>');

                        BulanPeriodeCutiEligible := Date2DMY(PeriodeCutiEligible, 2);
                        TahunPeriodeCutiEligible := Date2DMY(PeriodeCutiEligible, 3);

                        ContractInfo.Reset();
                        ContractInfo.SetRange("Employee No.", EmployeeNo);
                        ContractInfo.FindLast();

                        if ContractInfo."Resign Date" <> 0D then begin
                            BulanTanggalResign := Date2DMY(ContractInfo."Resign Date", 2);
                            TahunTanggalResign := Date2DMY(ContractInfo."Resign Date", 3);

                            if (BulanTanggalResign = BulanPeriodeCutiEligible) and
                                (TahunTanggalResign = TahunPeriodeCutiEligible) then begin
                                ResignVisible := true;
                                ResignStr := 'This employee will be resigned/terminated on ' +
                                Format(ContractInfo."Resign Date", 0, '<Day> <Month Text> <Year4>');
                                TanggalResign := Date2DMY(ContractInfo."Resign Date", 1);
                                if TanggalResign <= 15 then
                                    JatahCutiEligible := 0.625
                                else
                                    JatahCutiEligible := 1.25;

                                Message(ResignStr);
                            end else
                                JatahCutiEligible := 1.25;

                        end else begin
                            ResignVisible := false;
                            ResignStr := '';
                            BulanMulaiContract := Date2DMY(ContractInfo."Contract Start Date", 2);
                            TahunMulaiContract := Date2DMY(ContractInfo."Contract Start Date", 3);

                            BulanSelesaiContract := Date2DMY(ContractInfo."Contract End Date", 2);
                            TahunSelesaiContract := Date2DMY(ContractInfo."Contract End Date", 3);

                            //ini bagian awal contract
                            if (BulanMulaiContract = BulanPeriodeCutiEligible) and
                                (TahunMulaiContract = TahunPeriodeCutiEligible) then begin
                                TanggalMulaiContract := Date2DMY(ContractInfo."Contract Start Date", 1);
                                if TanggalMulaiContract <= 15 then
                                    JatahCutiEligible := 1.25
                                else
                                    JatahCutiEligible := 0.625;
                            end else
                                //ini bagian akhir contract
                                if (BulanSelesaiContract = BulanPeriodeCutiEligible) and
                                    (TahunSelesaiContract = TahunPeriodeCutiEligible) then begin
                                    TanggalSelesaiContract := Date2DMY(ContractInfo."Contract End Date", 1);
                                    if TanggalSelesaiContract <= 15 then
                                        JatahCutiEligible := 0.625
                                    else
                                        JatahCutiEligible := 1.25;
                                end
                                else // ini kalo di tengah2 contract
                                    JatahCutiEligible := 1.25;
                        end;

                        CurrPage.Update();
                    end;
                }
                field(StrPeriodCutiEligible; StrPeriodCutiEligible)
                {
                    Caption = 'Eligible Period Chosen';
                    Editable = false;
                    ApplicationArea = all;
                }
                field(JatahCutiEligible; JatahCutiEligible)
                {
                    Caption = 'Eligible Leave Slot';
                    DecimalPlaces = 3;
                    ApplicationArea = all;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Post Leave Slot")
            {
                ApplicationArea = All;
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    LeaveLedgerEntry: Record "Leave Ledger Entry";
                    TahunPeriodeSlot: Integer;
                begin
                    HiringInfo.Reset();
                    HiringInfo.SetRange("Employee No.", EmployeeNo);
                    HiringInfo.FindLast();

                    TahunPeriodeSlot := Date2DMY(Today, 3);

                    LeaveLedgerEntry.Reset();
                    LeaveLedgerEntry.SetRange("Employee No.", EmployeeNo);
                    LeaveLedgerEntry.SetRange("Document No.", 'OBAL');
                    LeaveLedgerEntry.SetRange(Type, LeaveLedgerEntry.Type::Positive);
                    //LeaveLedgerEntry.SetRange("Hiring Information Entry No.",
                    //HiringInfo."Entry No.");
                    LeaveLedgerEntry.SetRange("Year Period", TahunPeriodeSlot);
                    LeaveLedgerEntry.SetRange(Reversed, false);
                    if LeaveLedgerEntry.FindFirst() then
                        Error('Leave slot for %1 year %2 is already exist.',
                                EmployeeName, TahunPeriodeSlot);

                    Employee.Get(EmployeeNo);
                    LeaveMgt.PostLeaveSlot(Employee, JatahCuti);
                end;
            }
            action("Post Leave Eligible")
            {
                ApplicationArea = All;
                Image = PostedTimeSheet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger
                OnAction()
                var
                    LeaveEligibleLedger: Record "Leave Eligible Ledger Entry";
                begin
                    if PeriodeCutiEligible = 0D then
                        Error('Please input the eligible leave period.');

                    HiringInfo.Reset();
                    HiringInfo.SetRange("Employee No.", EmployeeNo);
                    HiringInfo.FindLast();
                    HiringInfo.TestField("Contract Start Date");
                    HiringInfo.TestField("Contract End Date");

                    //if HiringInfo."Contract End Date" <= Today then
                    //Error('Please update the contract of this employee.');

                    BulanEligible := Date2DMY(PeriodeCutiEligible, 2);
                    TahunEligible := Date2DMY(PeriodeCutiEligible, 3);

                    LeaveEligibleLedger.Reset();
                    LeaveEligibleLedger.SetRange("Employee No.", EmployeeNo);
                    LeaveEligibleLedger.SetRange(Type, LeaveEligibleLedger.Type::Positive);
                    LeaveEligibleLedger.SetRange("Document No.", 'ELIGIBLE');
                    LeaveEligibleLedger.SetRange("Year Eligible", TahunEligible);
                    LeaveEligibleLedger.SetRange("Month Eligible", BulanEligible);
                    LeaveEligibleLedger.SetRange(Reversed, false);
                    if LeaveEligibleLedger.FindFirst() then
                        Error('Period %1 %2 is already exist.', BulanEligible, TahunEligible);

                    Employee.Get(EmployeeNo);
                    LeaveMgt.PostLeaveSlotEligible(PeriodeCutiEligible, Employee);
                end;
            }
        }
    }


    trigger
    OnOpenPage()
    var
        PositionLedgerEntry: Record "Position Ledger Entry";
        TahunSekarang: Integer;

        HariStartingDate: Integer;
        BulanStartingDate: Integer;
        TahunStartingDate: Integer;

        HariEndingDate: Integer;
        BulanEndingDate: Integer;
        TahunEndingDate: Integer;

        JumlahBulanKerja: Integer;

        JatahCutiStarting: Decimal;
        JatahCutiEnding: Decimal;
    begin
        EmployeeNo := EmployeeNo2;
        EmployeeName := EmployeeName2;

        PositionLedgerEntry.Reset();
        PositionLedgerEntry.SetRange("Employee No.", EmployeeNo);
        PositionLedgerEntry.FindLast();

        PositionLedgerEntry.TestField("Contract Start Date");
        PositionLedgerEntry.TestField("Contract End Date");

        HariStartingDate := Date2DMY(PositionLedgerEntry."Contract Start Date", 1);
        BulanStartingDate := Date2DMY(PositionLedgerEntry."Contract Start Date", 2);
        TahunStartingDate := Date2DMY(PositionLedgerEntry."Contract Start Date", 3);

        HariEndingDate := Date2DMY(PositionLedgerEntry."Contract End Date", 1);
        BulanEndingDate := Date2DMY(PositionLedgerEntry."Contract End Date", 2);
        TahunEndingDate := Date2DMY(PositionLedgerEntry."Contract End Date", 3);

        TahunSekarang := Date2DMY(Today, 3);

        JatahCuti := 0;
        if TahunEndingDate > TahunStartingDate then begin
            JumlahBulanKerja := (((12 * (TahunEndingDate - TahunStartingDate)) + BulanEndingDate) - BulanStartingDate) + 1;

            //JumlahBulanKerja dikurangi 2 untuk bulan starting dan bulan ending
            //karena akan dihitung terpisah
            JumlahBulanKerja := JumlahBulanKerja - 2;

            JatahCuti := 1.25 * JumlahBulanKerja;
        end else begin
            JumlahBulanKerja := (BulanEndingDate - BulanStartingDate) + 1;

            //JumlahBulanKerja dikurangi 2 untuk bulan starting dan bulan ending
            //karena akan dihitung terpisah            
            JumlahBulanKerja := JumlahBulanKerja - 2;

            JatahCuti := 1.25 * JumlahBulanKerja;
        end;

        //bagian contract start
        if HariStartingDate <= 15 then
            JatahCutiStarting := 1.25
        else
            JatahCutiStarting := 0.625;

        if HariEndingDate <= 15 then
            JatahCutiEnding := 0.625
        else
            JatahCutiEnding := 1.25;

        JatahCuti := JatahCuti + JatahCutiStarting + JatahCutiEnding;

        if JatahCuti > 15 then
            JatahCuti := 15;
    end;


    procedure SetEmployee(__EmpNo: Code[20])
    var
        ___EmployeeName: Text[100];
    begin
        Employee.Get(__EmpNo);
        EmployeeNo2 := __EmpNo;
        EmployeeName2 := Employee.FullName();
    end;

    var
        ResignVisible: Boolean;
        ResignStr: Text;
        Employee: Record Employee;
        HiringInfo: Record "Position Ledger Entry";
        LeaveMgt: Codeunit "Leave Management";
        EmployeeNo: Code[20];
        EmployeeNo2: Code[20];
        EmployeeName: Text[100];
        EmployeeName2: Text[100];
        JatahCuti: Decimal;
        JatahCutiEligible: Decimal;
        PeriodeCutiEligible: Date;
        StrPeriodCutiEligible: Text;
        BulanEligible: Integer;
        TahunEligible: Integer;
}