table 60020 "Leave Request"
{
    Permissions = tabledata "Approval Entry" = rimd;

    DataClassification = CustomerContent;

    fields
    {
        field(1; "Leave Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = ,Paid,Unpaid,"Other Attendance";
            OptionCaption = ',Annual,Unpaid,Other Attendance';
        }
        field(2; "No."; Code[20])
        {
            DataClassification = CustomerContent;

            trigger
            OnValidate()
            begin
                if "No." <> xRec."No." then
                    NoSeriesMgt.TestManual(GetNoSeriesCode());
            end;
        }
        field(3; "No. Series"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee where(Status = const(Active));

            trigger OnValidate()
            var
                _Employee: Record Employee;
            begin
                if _Employee.Get("Employee No.") then
                    if _Employee."Employee Type" = _Employee."Employee Type"::TDP then
                        "Total Number of Days" := 12 else
                        "Total Number of Days" := 15;
            end;
        }
        field(6; "Job Title"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(7; "Global Dimension 1 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(8; "Paid Leave Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = ,Annual,Sick,Other;
            OptionCaption = ' ,Annual,Sick,Other';
        }
        field(9; "Unpaid Leave Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = ,"Leave Without Pay","Absence Without Pay";
            OptionCaption = ', Leave Without Pay, Absence Without Pay';
        }
        field(10; "Starting Date"; Date)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                frz_BaseCalendar: Record "Base Calendar Change";
                frz_BaseCalendar2: Record "Base Calendar Change";
                frz_ResourceDate: Record Date;
                frz_tglMerah: Integer;
                frz_SabMing: Integer;
                rec_PayrollGenSetup: Record "Payroll General Setup";
            begin
                if "Ending Date" <> 0D then
                    if "Starting Date" > "Ending Date" then
                        Error('Starting period date cannot be bigger than ending period date.');

                frz_tglMerah := 0;
                frz_SabMing := 0;
                if ("Ending Date" <> 0D) and (rec."Starting Date" <> 0D) then begin
                    rec_PayrollGenSetup.FindFirst();
                    if rec."Document Type" <> rec."Document Type"::"Other Attendance" then begin
                        frz_BaseCalendar.Reset();
                        frz_BaseCalendar.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Code");
                        frz_BaseCalendar.SetRange(Date, rec."Starting Date", rec."Ending Date");
                        frz_BaseCalendar.SetRange(Nonworking, true);
                        frz_BaseCalendar.setfilter(Day, '<> %1', frz_BaseCalendar.Day::Sunday);
                        if frz_BaseCalendar.FindFirst() then
                            repeat
                                if frz_BaseCalendar.Day <> frz_BaseCalendar.day::Saturday then
                                    frz_tglMerah += 1;
                            until frz_BaseCalendar.Next() = 0;

                        frz_ResourceDate.Reset();
                        frz_ResourceDate.SetRange("Period Start", rec."Starting Date", rec."Ending Date");
                        frz_ResourceDate.SetRange("Period Type", frz_ResourceDate."Period Type"::Date);
                        if frz_ResourceDate.FindFirst() then
                            repeat
                                frz_BaseCalendar2.Reset();
                                frz_BaseCalendar2.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Code");
                                frz_BaseCalendar2.SetRange(Date, 0D);
                                frz_BaseCalendar2.SetRange(Day, frz_ResourceDate."Period No.");
                                frz_BaseCalendar2.SetRange(Nonworking, true);
                                if frz_BaseCalendar2.FindFirst() then
                                    repeat
                                        frz_SabMing += 1;
                                    until frz_BaseCalendar2.Next() = 0;
                            until frz_ResourceDate.Next = 0;
                    end;
                    rec.validate("Total Number of Days", ((rec."Ending Date" - rec."Starting Date") + 1) - (frz_tglMerah + frz_SabMing));

                end;
                if rec."Total Number of Days" <> 0.5 then begin
                    rec."Leave-1" := false;
                    rec."Leave-2" := false;
                end;
            end;
        }
        field(11; "Ending Date"; Date)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()

            var
                frz_BaseCalendar: Record "Base Calendar Change";
                frz_BaseCalendar2: Record "Base Calendar Change";
                frz_ResourceDate: Record Date;
                frz_tglMerah: Integer;
                frz_SabMing: Integer;
                rec_PayrollGenSetup: Record "Payroll General Setup";
            begin
                if rec."Starting Date" <> 0D then
                    if "Ending Date" < "Starting Date" then
                        Error('Ending period date cannot be smaller than starting period date.');

                if (rec."Ending Date" <> 0D) and (rec."Starting Date" <> 0D) then begin
                    frz_tglMerah := 0;
                    frz_SabMing := 0;
                    rec_PayrollGenSetup.FindFirst();

                    if rec."Document Type" <> rec."Document Type"::"Other Attendance" then begin

                        frz_BaseCalendar.Reset();
                        frz_BaseCalendar.SetRange("Base Calendar Code", rec_PayrollGenSetup."Base Calendar Code");
                        frz_BaseCalendar.SetRange(Date, "Starting Date", "Ending Date");
                        frz_BaseCalendar.SetRange(Nonworking, true);
                        frz_BaseCalendar.setfilter(Day, '<> %1', frz_BaseCalendar.Day::Sunday);
                        if frz_BaseCalendar.FindFirst() then
                            repeat
                                if frz_BaseCalendar.Day <> frz_BaseCalendar.day::Saturday then
                                    frz_tglMerah += 1;
                            until frz_BaseCalendar.Next() = 0;

                        frz_ResourceDate.Reset();
                        frz_ResourceDate.SetRange("Period Start", "Starting Date", "Ending Date");
                        frz_ResourceDate.SetRange("Period Type", frz_ResourceDate."Period Type"::Date);
                        if frz_ResourceDate.FindFirst() then
                            repeat
                                frz_BaseCalendar2.Reset();
                                frz_BaseCalendar2.SetFilter("Base Calendar Code", '= %1', rec_PayrollGenSetup."Base Calendar Code");
                                frz_BaseCalendar2.SetFilter(Day, '= %1', frz_ResourceDate."Period No.");
                                frz_BaseCalendar2.SetFilter(Date, '= %1', 0D);
                                frz_BaseCalendar2.SetFilter(Nonworking, '= %1', true);
                                if frz_BaseCalendar2.FindFirst() then
                                    frz_SabMing += frz_BaseCalendar2.Count;
                            until frz_ResourceDate.Next = 0;
                    end;

                    validate("Total Number of Days", ((rec."Ending Date" - rec."Starting Date") + 1) - (frz_tglMerah + frz_SabMing));

                end;
                if rec."Total Number of Days" <> 0.5 then begin
                    rec."Leave-1" := false;
                    rec."Leave-2" := false;
                end;
            end;
        }
        field(12; "Total Number of Days"; Decimal)
        {
            DecimalPlaces = 1;
            DataClassification = CustomerContent;

            trigger
            OnValidate()
            var
                TotalDays: Decimal;
                KuranginStengah: Decimal;
                GajiHarian: Decimal;
                PayrollLedgerEntry: Record "Payroll Ledger Entry";
                TanggalGajianTerakhir: Date;
                Pegawai: Record Employee;
                EligibleBalance: Decimal;
                SetelahDikurangi: Decimal;
                Bulannya: Integer;
                SalaryDeduction: Decimal;
                FullMonthLeave: Boolean;
            begin
                Clear(TotalDays);
                Clear(KuranginStengah);
                Clear(EligibleBalance);
                Clear(SetelahDikurangi);

                if Rec."Total Number of Days" <> xRec."Total Number of Days" then begin
                    TestField("Ending Date");
                    TestField("Starting Date");


                    TotalDays := "Ending Date" - "Starting Date" + 1;
                    KuranginStengah := TotalDays - 0.5;


                    //if ("Total Number of Days" <> TotalDays) and
                    //   ("Total Number of Days" <> KuranginStengah) then
                    //    Error('Total Number of Days is not valid.');
                end;

                //menghitung potong gaji
                Employee.Get("Employee No.");
                Employee.TestField("MSI_HRIS Basic Salary");


                PayrollLedgerEntry.Reset();
                PayrollLedgerEntry.SetCurrentKey("Posting Date");
                if PayrollLedgerEntry.FindLast() then
                    TanggalGajianTerakhir := PayrollLedgerEntry."Posting Date";

                Pegawai.Get("Employee No.");
                Pegawai.SetRange("Date Filter", TanggalGajianTerakhir);
                Pegawai.CalcFields("MSI_HRIS Total Allowance Fix");

                GajiHarian := (Employee."MSI_HRIS Basic Salary" +
                               Pegawai."MSI_HRIS Total Allowance Fix") / 21;

                //ngecek apakah cutinya 30 hari bulan biasa
                //atau 28 hari bulan Februari
                FullMonthLeave := false;
                SalaryDeduction := 0;

                if "Total Number of Days" > 21 then
                    FullMonthLeave := true;
                /*
                Bulannya := Date2DMY("Starting Date", 2);
                if Bulannya = 2 then begin
                    if "Total Number of Days" = 28 then
                        FullMonthLeave := true;
                end
                else
                    if "Total Number of Days" = 30 then
                        FullMonthLeave := true;
                */

                //kalo cuti full month, maka langsung potong basic + allowance fix
                if FullMonthLeave then
                    SalaryDeduction := Employee."MSI_HRIS Basic Salary" + Pegawai."MSI_HRIS Total Allowance Fix"
                else
                    //kalo ngga full month, maka pake rumus yg biasa
                    SalaryDeduction := GajiHarian * "Total Number of Days";

                Validate("Salary Deduction", SalaryDeduction);

                //mengkalkulasi eligible balance tersisa
                Employee.CalcFields("MSI_HRIS Leave Eligbl. Balance");
                EligibleBalance := Employee."MSI_HRIS Leave Eligbl. Balance";
                if (Rec."Leave Type Code" = 'SICK') or (rec."Leave Type Code" = 'SICK LEAVE') then
                    SetelahDikurangi := EligibleBalance - 0 else
                    SetelahDikurangi := EligibleBalance - "Total Number of Days";
                "Projected Eligible Balance" := SetelahDikurangi;
                if SetelahDikurangi < 0 then
                    "Eligible Minus" := true
                else
                    "Eligible Minus" := false;

                if rec."Total Number of Days" <> 0.5 then begin
                    rec."Leave-1" := false;
                    rec."Leave-2" := false;
                end;
            end;
        }
        field(13; "Employee No. Replacement"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee where(status = const(Active));
        }
        field(14; Status; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Open,Released,"Pending Approval";
        }
        field(15; "Approver ID"; code[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Approval Entry"."Approver ID" where("Document No." = field("No."),
            "Table ID" = const(60020), Status = const(Open)));
        }
        field(16; Processed; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(17; "On Process Payroll"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(18; "Salary Deduction"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(20; "Employee Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(21; "Eligible Minus"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(22; "Projected Eligible Balance"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        // fadhil
        field(65000; "Document Type"; Enum "Document Type Leave")
        {
            DataClassification = CustomerContent;
        }
        field(65001; "Leave Type Code"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "Master Leave Unconditional".Code where("Document Type" = field("Document Type"));
            trigger OnValidate()
            var
                balanceeligable: Decimal;
            begin
                //menghitung potong gaji
                Employee.Get("Employee No.");
                Employee.TestField("MSI_HRIS Basic Salary");
                Employee.CalcFields("MSI_HRIS Leave Eligbl. Balance");
                balanceeligable := Employee."MSI_HRIS Leave Eligbl. Balance";
                if (Rec."Leave Type Code" = 'SICK') or (rec."Leave Type Code" = 'SICK LEAVE') then
                    rec."Projected Eligible Balance" := balanceeligable;
            end;
        }
        field(65002; "Leave-1"; Boolean)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if Rec."Total Number of Days" <> 0.5 then
                    Error('Total number of days must be equal = 0.5');

                if rec."Leave-1" = true then
                    rec."Leave-2" := false;
            end;
        }
        field(65003; "Leave-2"; Boolean)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if Rec."Total Number of Days" <> 0.5 then
                    Error('Total number of days must be equal = 0.5');

                if rec."Leave-2" = true then
                    rec."Leave-1" := false;
            end;
        }


    }

    keys
    {
        key(PK; "Leave Type", "No.")
        {
            Clustered = true;
        }
    }

    var
        Employee: Record Employee;
        PayrollGenSetup: Record "Payroll General Setup";
        //NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeriesMgt: Codeunit "No. Series";
        EmployeeAbsenceLine: Record "Employee Absence Line";


    trigger
    OnDelete()
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.Reset();
        ApprovalEntry.SetRange("Document No.", "No.");
        if ApprovalEntry.FindSet() then
            ApprovalEntry.DeleteAll();
    end;


    trigger OnInsert()
    var
        frz_Employee: Record Employee;
    begin
        "Posting Date" := Today;

        if "No." = '' then
            // NoSeriesMgt.InitSeries(GetNoSeriesCode(), xRec."No. Series",
            // "Posting Date", "No.", "No. Series");
            "No." := NoSeriesMgt.GetNextNo(GetNoSeriesCode(), "Posting Date", false);

        // fadhil
        frz_Employee.Reset();
        frz_Employee.SetRange("User ID", UserId);
        if frz_Employee.FindFirst() then begin
            Rec."Employee No." := frz_Employee."No.";
            Rec."Employee Name" := frz_Employee.FullName();
        end;
        // fadhil tutup
        if rec."Leave Type" = "Leave Type"::Paid then
            rec."Document Type" := "Document Type"::"Paid Leave";
        if rec."Leave Type" = "Leave Type"::Unpaid then
            rec."Document Type" := "Document Type"::"Unpaid Leave";
        if rec."Leave Type" = "Leave Type"::"Other Attendance" then
            rec."Document Type" := "Document Type"::"Other Attendance";
    end;


    procedure GetEmployeeName(isEmployee: Boolean): Text;
    var
        xEmployee: Record Employee;
        xEmployeeReplacement: Record Employee;
    begin
        if isEmployee then begin
            if xEmployee.Get(Rec."Employee No.") then
                exit(xEmployee.FullName());
        end else begin
            if xEmployeeReplacement.Get(Rec."Employee No. Replacement") then
                exit(xEmployeeReplacement.FullName());
        end;
    end;


    procedure AssistEdit(OldLeaveRequest: Record "Leave Request"): Boolean;
    var
        LeaveRequest: Record "Leave Request";
    begin
        LeaveRequest := Rec;

        if NoSeriesMgt.LookupRelatedNoSeries(GetNoSeriesCode(), OldLeaveRequest."No. Series",
           "No. Series") then begin
            //NoSeriesMgt.SetSeries("No.");
            "No." := NoSeriesMgt.GetNextNo(GetNoSeriesCode(), "Posting Date", false);
            Rec := LeaveRequest;
            exit(true);
        end;

        exit(false);
    end;

    procedure GetNoSeriesCode(): Code[10];
    begin
        PayrollGenSetup.Get();

        if "Leave Type" = "Leave Type"::Paid then begin
            PayrollGenSetup.TestField("Paid Leave Request Nos.");
            exit(PayrollGenSetup."Paid Leave Request Nos.");
        end;
        // else begin
        //     PayrollGenSetup.TestField("Unpaid Leave Request Nos.");
        //     exit(PayrollGenSetup."Unpaid Leave Request Nos.");
        // end;
        if "Leave Type" = "Leave Type"::"Other Attendance" then begin
            PayrollGenSetup.TestField("Other Attendance Request Nos.");
            exit(PayrollGenSetup."Other Attendance Request Nos.");
        end;
        if "Leave Type" = "Leave Type"::Unpaid then begin
            PayrollGenSetup.TestField("Unpaid Leave Request Nos.");
            exit(PayrollGenSetup."Unpaid Leave Request Nos.");
        end;
    end;
}