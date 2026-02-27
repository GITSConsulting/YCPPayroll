page 60006 "Employee Card HR"
{
    PageType = Card;
    //ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Employee;
    Caption = 'Employee Payroll Card';
    layout
    {
        area(Content)
        {
            group("Payroll Data")
            {
                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = all;
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    ApplicationArea = all;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = all;
                }
                field("Birth Date"; Rec."Birth Date")
                {
                    ApplicationArea = all;
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = all;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ApplicationArea = all;
                }
                field("Marital Status"; Rec."MSI_HRIS Marital Status")
                {
                    ApplicationArea = all;
                }
                field("Marital Date"; Rec."MSI_HRIS Marital Date")
                {
                    ApplicationArea = all;
                }
                field("NPWP No."; Rec."MSI_HRIS NPWP No.")
                {
                    ApplicationArea = all;
                }
                field("Basic Salary"; Rec."MSI_HRIS Basic Salary")
                {
                    ApplicationArea = all;
                }
                field("MSI_HRIS Old Basic Salary"; Rec."MSI_HRIS Old Basic Salary")
                {
                    ApplicationArea = all;
                }
                field("MSI_HRIS Shortcut Dimension Code"; Rec."MSI_HRIS Shortcut Dim Code")
                {
                    CaptionClass = _StrDimension;
                    ApplicationArea = all;
                }
                field("MSI_HRIS Bank Code 1"; Rec."MSI_HRIS Bank Code 1")
                {
                    ApplicationArea = all;
                }
                field("MSI_HRIS Bank Code 2"; Rec."MSI_HRIS Bank Code 2")
                {
                    ApplicationArea = all;
                }
                field("MSI_HRIS ID Card"; Rec."MSI_HRIS ID Card")
                {
                    ApplicationArea = all;
                }
                field("BPJS Kesehatan No."; Rec."BPJS Kesehatan No.")
                {
                    ApplicationArea = all;
                }
                field("BP Jamsostek No."; Rec."BP Jamsostek No.")
                {
                    ApplicationArea = all;
                }

                field("MSI_HRIS Leave Balance"; Rec."MSI_HRIS Leave Balance")
                {
                    Caption = 'Leave Balance as per Contract';
                    ApplicationArea = all;
                    Editable = false;
                    DecimalPlaces = 3;
                }
                field("MSI_HRIS Leave Eligbl. Balance"; Rec."MSI_HRIS Leave Eligbl. Balance")
                {
                    ApplicationArea = all;
                    Editable = false;
                    DecimalPlaces = 3;
                    Style = Unfavorable;
                    StyleExpr = Merah;
                }
                /*
                field(LeaveValue; Rec.LeaveValue())
                {
                    Caption = 'Leave Balance (Value)';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Total Medical Amount Balance"; rec."Total Medical Amount Balance")
                {
                    //fadhil
                    Caption = 'Medical claim balance';
                    ApplicationArea = all;
                    Editable = false;
                }*/
                field("MSI_HRIS CTO Balance"; CTOBalance)
                {
                    ApplicationArea = all;
                    Caption = 'CTO Balance';
                    Editable = false;
                    trigger OnDrillDown()
                    var
                        CTOLEdgerEntryPage: page "CTO Ledger Entries";
                        CTOLEdgerEntry: record "CTO Ledger Entry";
                    begin
                        CTOLEdgerEntry.SetRange("Employee No.", rec."No.");
                        CTOLEdgerEntryPage.SetTableView(CTOLEdgerEntry);
                        CTOLEdgerEntryPage.Run();
                    end;
                }
                /*
                field("THR Amount"; Rec."THR Amount")
                {
                    ApplicationArea = all;
                }*/
                field("MSI_HRIS THR Apply to Old"; Rec."MSI_HRIS THR Apply to Old")
                {
                    ApplicationArea = all;
                }
                field("MSI_HRIS THR Accrual"; Rec."MSI_HRIS THR Accrual")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("MSI_HRIS Total Severance Accr."; Rec."MSI_HRIS Total Severance Accr.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Cuti Dibayar Accrual"; Rec."Cuti Dibayar Accrual")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("MSI_HRIS SafeSec Accrual"; Rec."MSI_HRIS SafeSec Accrual")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Visible = false;
                }
                field("MSI_HRIS Welfare Accrual"; Rec."MSI_HRIS Welfare Accrual")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Adjustment Prorate"; Rec."Adjustment Prorate")
                {
                    ApplicationArea = all;
                }
                field("MSI_HRIS Other Deduction"; Rec."MSI_HRIS Other Deduction")
                {
                    ApplicationArea = all;
                }
                /*
                field("Uang Pisah"; Rec."Uang Pisah")
                {
                    ApplicationArea = all;
                }*/
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field("Inactive Status"; Rec."Inactive Status")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Inactive Date"; Rec."Inactive Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("MSI_HRIS Department"; rec."MSI_HRIS Department")
                {
                    Caption = 'Department';
                    ApplicationArea = all;
                }
                field("Status Point Code"; rec."Status Point Code")
                {
                    Caption = 'Status Point Code';
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        number: Integer;
                        rec_Family: Record "Employee Family Entry";
                        rec_StatusPoint: Record "Master Point Status";
                    begin
                        rec_Family.SetRange("Employee No.", rec."No.");
                        rec_Family.SetRange(Dependent, true);
                        number := rec_Family.Count;
                        rec_StatusPoint.SetRange(Code, rec."Status Point Code");
                        if rec_StatusPoint.FindFirst() then begin
                            if rec_StatusPoint.Status = Rec."MSI_HRIS Marital Status" then
                                if rec_StatusPoint.Kid = number then
                                    Rec."Status Point Code" := rec."Status Point Code" else
                                    Error('Point dependents are not the same as family dependents Value is not same with employee Kids.');
                            //else
                            //Error('Marital status here is not same as Employee marital status.');
                        end;
                    end;
                }
                field("Nomor Rekening Bank"; Rec."Nomor Rekening Bank")
                {
                    ApplicationArea = all;
                }
                field("Nama Bank Tujuan"; rec."Nama Bank Tujuan")
                {
                    ApplicationArea = all;
                }
                field("Nama Pemilik Rekening"; Rec."Nama Pemilik Rekening")
                {
                    ApplicationArea = all;
                }
                field("With Muslim THR Disbursement"; Rec."With Muslim THR Disbursement")
                {
                    ApplicationArea = all;
                }
                field("MSI_HRIS THR Compensation"; Rec."MSI_HRIS THR Compensation")
                {
                    ApplicationArea = all;
                }
                field("MSI_HRIS Severance"; Rec."MSI_HRIS Severance")
                {
                    ApplicationArea = all;
                }
                field("MSI_HRIS PTKP Entry No."; Rec."MSI_HRIS PTKP Entry No.")
                {
                    ApplicationArea = all;
                    Caption = 'Pilih PTKP';
                    trigger
                    OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("MSI_HRIS PTKP Kode"; Rec."MSI_HRIS PTKP Kode")
                {
                    Caption = 'Kode PTKP';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("MSI_HRIS PTKP Desc."; Rec."MSI_HRIS PTKP Desc.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("MSI_HRIS Last Payroll"; Rec."MSI_HRIS Last Payroll")
                {
                    ApplicationArea = all;
                }
                field("MSI_HRIS Less/Over Deduct Tax"; Rec."MSI_HRIS Less/Over Deduct Tax")
                {
                    ApplicationArea = all;
                    Editable = Rec."MSI_HRIS Last Payroll";
                }
                field("Alt. Address Code"; rec."Alt. Address Code")
                {
                    Caption = 'Contact Darurat';
                    ApplicationArea = all;
                }
                field("MSI_HRIS Shift Schedule"; rec."MSI_HRIS Shift Schedule")
                {
                    Caption = 'Shift Schedule';
                    ApplicationArea = all;
                }
            }
            group("Medical Balance")
            {
                // medical balance
                part("Medical Kacamata Balance"; "Medical Kacamata Balance")
                {
                    SubPageLink = "Employee No." = field("No.");
                    ApplicationArea = all;
                }
                part("Medical Persalinan Balance"; "Medical Persalinan Balance")
                {
                    SubPageLink = "Employee No." = field("No.");
                    ApplicationArea = all;
                }
                part("Medical Rawat Jalan Balance"; "Medical Rawat Jalan Balance")
                {
                    SubPageLink = "Employee No." = field("No.");
                    ApplicationArea = all;
                }
                part("Medical Rawat Inap - Pembedahan"; "Rawat Inap Balance Pembedahan")
                {
                    SubPageLink = "Employee No." = field("No.");
                    ApplicationArea = all;
                }
                part("Medical Rawat Inap - Biaya Jasa Perawatan"; "Rawat Inap Balance Perawatan")
                {
                    SubPageLink = "Employee No." = field("No.");
                    ApplicationArea = all;
                }
                part("Medical Rawat Inap - Daily Rate Room"; "Medical Rawat Inap Balance")
                {
                    SubPageLink = "Employee No." = field("No.");
                    ApplicationArea = all;
                }

            }
            part(subform; "Employee Salary Components")
            {
                SubPageLink = "Employee No." = field("No.");
                Caption = 'Components Setup';
                ApplicationArea = all;
            }
            part(subform4; "Medical Slot")
            {
                SubPageLink = "Employee No." = field("No.");
                Caption = 'Medical Slot';
                ApplicationArea = all;
                Visible = false;
            }
            part(subform2; "Employee Family Entries")
            {
                SubPageLink = "Employee No." = field("No.");
                Caption = 'Family Entries';
                ApplicationArea = all;
            }
            part(subform3; "Career Entries")
            {
                SubPageLink = "Employee No." = field("No.");
                Caption = 'Active Contract';
                ApplicationArea = all;
            }
            part(sunform4; "Upcoming Contract")
            {
                SubPageLink = "Employee No." = field("No.");
                ApplicationArea = all;
                Visible = false;
            }
        }
        area(FactBoxes)
        {
            part(Page; "Employee Picture")
            {
                SubPageLink = "No." = field("No.");
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Re-hire this employee")
            {
                Image = EmployeeAgreement;
                Visible = Rec.Status = Rec.Status::Inactive;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = all;
                trigger
                OnAction()
                var
                    EmployeeBaru: Record Employee;
                    EmployeeBaru2: Record Employee;
                begin
                    Rec.TestField(Status, Rec.Status::Inactive);
                    if not Confirm('Are you sure to re-hire this employee?') then exit;

                    EmployeeBaru.Init();
                    EmployeeBaru.Validate("No.", '');
                    EmployeeBaru.Insert(true);

                    EmployeeBaru2.Get(EmployeeBaru."No.");
                    EmployeeBaru2.TransferFields(Rec);
                    //EmployeeBaru2.Validate("No.", ' ');
                    EmployeeBaru2.Validate(Status, EmployeeBaru2.Status::Active);
                    EmployeeBaru2."Inactive Status" := EmployeeBaru2."Inactive Status"::"--";
                    EmployeeBaru2."Inactive Date" := 0D;
                    EmployeeBaru2.Modify(true);

                    Message('New employee created no %1', EmployeeBaru."No.");
                end;
            }
            action("Resigned")
            {
                Image = CoupledCustomer;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = all;
                trigger
                OnAction()
                begin
                    Rec.TestField(Status, Rec.Status::Active);
                    Rec.TestField("Inactive Status", Rec."Inactive Status"::"--");

                    if not Confirm('This process will set employee inactive status to resigned\' +
                        'Are you sure to continue?') then
                        exit;

                    Rec."Inactive Status" := Rec."Inactive Status"::Resigned;
                    Rec."Inactive Date" := Today;

                    if Rec."MSI_HRIS Leave Balance" > 0 then
                        Rec."Bayarkan Cuti" := true;

                    Rec.Modify();
                    CurrPage.Update();
                end;
            }
            action("Contract Terminated")
            {
                Image = ClearLog;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = all;
                trigger
                OnAction()
                begin
                    Rec.TestField(Status, Rec.Status::Active);
                    Rec.TestField("Inactive Status", Rec."Inactive Status"::"--");

                    if not Confirm('This process will terminate the contract\' +
                        'and uang pisah for this employee will be created\' +
                        'Are you sure to continue?') then
                        exit;

                    Rec."Inactive Status" := Rec."Inactive Status"::"Contract Terminated";
                    Rec."Inactive Date" := Today;
                    Rec.TestField("MSI_HRIS Basic Salary");
                    Rec."Uang Pisah" := Rec."MSI_HRIS Basic Salary";
                    Rec."Uang Pisah Entered Date" := Today;
                    Rec.Modify();
                    CurrPage.Update();
                end;
            }
            action("Reset Medical Balance")
            {
                Image = ClearLog;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = all;
                trigger
                OnAction()
                var
                    ProsesMedical: Codeunit "Proses Medical Reimbersement";
                begin
                    if not Confirm('Are you sure to reset medical balance ?') then
                        exit;
                    ProsesMedical.MedicalResetBalanceEmployee(rec."No.");
                    CurrPage.Update();
                end;
            }
            action("Undo Inactive Status")
            {
                Image = Undo;
                Visible = not (Rec."Inactive Status" = Rec."Inactive Status"::"--");
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = all;
                trigger
                OnAction()
                begin
                    Rec.TestField(Status, Rec.Status::Active);

                    if Rec."Inactive Status" = Rec."Inactive Status"::"Contract Terminated" then begin
                        Rec."Uang Pisah" := 0;
                        Rec."Uang Pisah Entered Date" := 0D;
                    end else
                        if Rec."Inactive Status" = Rec."Inactive Status"::Resigned then
                            Rec."Bayarkan Cuti" := false;

                    Rec."Inactive Status" := Rec."Inactive Status"::"--";
                    Rec."Inactive Date" := 0D;

                    Rec.Modify();
                    CurrPage.Update();
                end;
            }
            action("Leave Slot")
            {
                Image = ProfileCalendar;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = all;
                trigger OnAction()
                var
                    NewEmployeeLeaveSlot: Page "New Employee Leave Slot";
                begin
                    NewEmployeeLeaveSlot.SetEmployee(Rec."No.");
                    NewEmployeeLeaveSlot.Run();
                    CurrPage.Update();
                end;
            }
            // fadhil
            action("Medical Slot")
            {
                ApplicationArea = all;
                Caption = 'Medical Slot';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Medical List Contract";
                trigger OnAction()
                var
                    MedicalListPage: Page "Medical List Contract";
                begin
                    MedicalListPage.Contract(Rec."No.");
                    MedicalListPage.Run();
                end;
            }
            action("PAR Report")
            {
                Image = Print;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ApplicationArea = all;
                trigger OnAction()
                var
                    employeeRec: Record Employee;
                begin
                    CurrPage.SetSelectionFilter(employeeRec);
                    Report.run(Report::PAR, true, false, employeeRec);
                end;
            }
            action(Clearance)
            {
                Image = Print;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ApplicationArea = all;
                Visible = false;
                trigger OnAction()
                var
                    employeeRec: Record Employee;
                begin
                    CurrPage.SetSelectionFilter(employeeRec);
                    Report.run(Report::Clearance, true, false, employeeRec);
                end;
            }
            action("Exit Questionnaire")
            {
                Image = Print;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ApplicationArea = all;
                Visible = false;
                trigger OnAction()
                var
                    employeeRec: Record Employee;
                begin
                    CurrPage.SetSelectionFilter(employeeRec);
                    Report.run(Report::"Exit Questionnaire", true, false, employeeRec);
                end;
            }
            action("Employee Data")
            {
                Image = Print;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ApplicationArea = all;
                trigger OnAction()
                var
                    employeeRec: Record Employee;
                begin
                    CurrPage.SetSelectionFilter(employeeRec);
                    Report.run(Report::"Employee Data", true, false, employeeRec);
                end;
            }
            action("Payroll Slip")
            {
                Image = Print;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ApplicationArea = all;
                trigger OnAction()
                var
                    employeeRec: Record Employee;
                begin
                    CurrPage.SetSelectionFilter(employeeRec);
                    Report.run(Report::"Payroll Slip", true, false, employeeRec);
                end;
            }

            action("Send Payroll Slip")
            {
                Image = SendEmailPDF;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ApplicationArea = all;
                trigger OnAction()
                begin
                    SendSlipByEmail();
                end;
            }
            action("Payroll Slip Severence")
            {
                Image = Print;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ApplicationArea = all;
                trigger OnAction()
                var
                    employeeRec: Record Employee;
                begin
                    CurrPage.SetSelectionFilter(employeeRec);
                    Report.run(Report::"Payroll Slip Severance", true, false, employeeRec);
                end;
            }
            action("Attendance Sheet")
            {
                Image = Print;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ApplicationArea = all;
                trigger OnAction()
                var
                    employeeRec: Record Employee;
                begin
                    CurrPage.SetSelectionFilter(employeeRec);
                    Report.run(Report::"Attendance Sheet", true, false, employeeRec);
                end;
            }
            action("Attendance Print")
            {
                Image = Print;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Visible = false;
                ApplicationArea = all;
                trigger OnAction()
                var
                    employeeRec: Record Employee;
                begin
                    CurrPage.SetSelectionFilter(employeeRec);
                    Report.run(Report::"Attendance for Print", true, false, employeeRec);
                end;
            }
            // fadhil
        }
    }

    trigger OnOpenPage()
    var
        AwalTahunSekarang: Date;
        AkhirTahunSekarang: Date;
        _Employee: Record Employee;

    begin
        Rec.Reset();
        case FilterList of
            FilterList::"All Active":
                begin
                    Rec.SetRange(Status, Rec.Status::Active);
                end;
            FilterList::"All Inactive":
                begin
                    Rec.SetRange(Status, Rec.Status::Inactive);
                end;
        end;

        //untuk filter leave, hanya munculkan di range tahun yang sedang aktif sekarang
        AwalTahunSekarang := CALCDATE('<-CY>', Today);
        AkhirTahunSekarang := CALCDATE('<CY>', Today);
        Rec.SetRange("Date Filter", AwalTahunSekarang, AkhirTahunSekarang);

        Rec.CalcFields("MSI_HRIS Shortcut Dim No.");
        Rec.GeneralLedgerDimensionSetup(_StrDimension, Rec."MSI_HRIS Shortcut Dim No.");
        BalanceCTO := 'Click for Information';


    end;

    trigger OnAfterGetRecord()
    var
        CTOLedgerEntry: Record "CTO Ledger Entry";
    begin
        Rec.Reset();
        case FilterList of
            FilterList::"All Active":
                begin
                    Rec.SetRange(Status, Rec.Status::Active);
                end;
            FilterList::"All Inactive":
                begin
                    Rec.SetRange(Status, Rec.Status::Inactive);
                end;
        end;

        rec.CalcFields(Rec."MSI_HRIS Leave Eligbl. Balance");
        if Rec."MSI_HRIS Leave Eligbl. Balance" < 0 then
            Merah := true else
            Merah := false;

        // fadhil 
        CTOLedgerEntry.Reset();
        CTOLedgerEntry.setrange("Employee No.", rec."No.");
        CTOLedgerEntry.setrange(Expired, false);
        CTOLedgerEntry.CalcSums("Day Balance");
        CTOBalance := CTOLedgerEntry."Day Balance";
        // fadhil //
    end;

    trigger OnClosePage()
    var
        EmployeeSalaryComponent: Record "Employee Salary Component";
        PositionLedgerEntry: Record "Position Ledger Entry";
    begin
        if Rec."Newly Hired" then begin
            Rec.TestField("Birth Date");

            //if Rec."MSI_HRIS Marital Status" = Rec."MSI_HRIS Marital Status"::Married then
            //Rec.TestField("MSI_HRIS Marital Date");

            EmployeeSalaryComponent.Reset();
            EmployeeSalaryComponent.SetRange("Employee No.", Rec."No.");
            EmployeeSalaryComponent.FindFirst();

            PositionLedgerEntry.Reset();
            PositionLedgerEntry.SetRange("Employee No.", Rec."No.");
            PositionLedgerEntry.FindFirst();
            PositionLedgerEntry.TestField("Contract Start Date");
            PositionLedgerEntry.TestField("Contract End Date");
        end;
    end;

    trigger OnModifyRecord(): Boolean
    var
        _Employee: Record Employee;
    begin
        gVisible := false;
        _Employee.SetRange("User ID", USERID);
        if _Employee.FindFirst() then begin
            if not (_Employee."Division Code" in ['HR', 'IT']) then
                Error('Only HR and IT can modify employee card');
        end;

    end;

    procedure FilterCard(FilterListKirim: Option All,"All Active","All Inactive")
    begin
        FilterList := FilterListKirim;
    end;

    local procedure SendSlipByEmail()
    var
        _TempBlob: Codeunit "Temp Blob";
        _OutS: OutStream;
        _InS: InStream;
        _EmailMsg: Codeunit "Email Message";
        _Email: Codeunit Email;
        _FileName, _ParamsXml : Text;
        _EmployeeEmail: Text;
        _RecordRef: RecordRef;
        _EmployeeRec: Record Employee;
    begin
        // 1️⃣ Validate email
        _EmployeeEmail := Rec."E-Mail";
        if _EmployeeEmail = '' then
            Error('Employee email is empty.');
        CurrPage.SetSelectionFilter(_EmployeeRec);
        _RecordRef.GetTable(_EmployeeRec);

        // 2️⃣ Create PDF into TempBlob (SaaS-safe)
        _TempBlob.CreateOutStream(_OutS);

        _ParamsXml :=
                Report.RunRequestPage(
                    Report::"Payroll Slip",
                    '<?xml version="1.0" standalone="yes"?>' +
                    '<ReportParameters>' +
                    '<Options>' +
                    '<PostingDate>' + Format(20250331D) + '</PostingDate>' +
                    '</Options>' +
                    '</ReportParameters>');

        Report.SaveAs(
            Report::"Payroll Slip",   // your report object
            _ParamsXml,
            ReportFormat::Pdf,
            _OutS,
            _RecordRef);

        // 3️⃣ Prepare attachment
        _TempBlob.CreateInStream(_InS);

        _FileName :=
            StrSubstNo(
                'PayrollSlip_%1_%2.pdf',
                Rec."No.",
                Format(Today, 0, '<Year4><Month,2><Day,2>'));

        // 4️⃣ Create email
        _EmailMsg.Create(
            _EmployeeEmail,
            'Your Payroll Slip',
            'Dear ' + Rec.FullName() + '<br><br>' +
            'Please find attached your payroll slip.<br><br>' +
            'Best regards,<br>HR Department',
            true);

        _EmailMsg.AddAttachment(_FileName, 'application/pdf', _InS);

        // 5️⃣ Send email
        _Email.Send(_EmailMsg);

        Message('Payroll slip sent to %1', _EmployeeEmail);

        // DownloadFromStream(
        //         _InS,
        //         'Save Payroll Slip',
        //         '',
        //         'PDF files (*.pdf)|*.pdf',
        //         _FileName);
    end;


    var
        _StrDimension: Code[20];
        BalanceCTO: Text;
        LeaveValue: Decimal;
        Merah: Boolean;
        FilterList: Option All,"All Active","All Inactive";
        CTOBalance: Integer;
        gVisible: Boolean;
}