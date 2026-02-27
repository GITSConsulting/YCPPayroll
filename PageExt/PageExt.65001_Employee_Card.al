pageextension 65001 "Employee" extends "Employee Card"
{
    Caption = 'Employee Payroll Card';
    // fadhil
    layout
    {
        modify("Job Title Group Code")
        {
            Visible = false;
        }
        modify(Initials)
        {
            Visible = false;
        }
        modify("Search Name")
        {
            Visible = false;
        }
        modify("Division Code")
        {
            Visible = false;
        }
        modify(Pager)
        {
            Visible = false;
        }
        modify("Alt. Address Start Date")
        {
            Visible = false;
        }
        modify("Alt. Address End Date")
        {
            Visible = false;
        }
        modify("Social Security No.")
        {
            Visible = false;
        }
        modify("Union Code")
        {
            Visible = false;
        }
        modify("Union Membership No.")
        {
            Visible = false;
        }
        modify("Application Method")
        {
            Visible = false;
        }
        modify("Bank Branch No.")
        {
            Visible = false;
        }
        modify("Bank Account No.")
        {
            Visible = false;
        }
        modify(IBAN)
        {
            Visible = false;
        }
        modify("SWIFT Code")
        {
            Visible = false;
        }
        modify("Grounds for Term. Code")
        {
            Visible = false;
        }
        modify("Emplymt. Contract Code")
        {
            Visible = false;
        }
        modify("Statistics Group Code")
        {
            Visible = false;
        }
        modify("Resource No.")
        {
            Visible = false;
        }
        modify("Salespers./Purch. Code")
        {
            Visible = false;
        }
        addafter(Nationality)
        {
            field("Employee Type"; Rec."Employee Type")
            {
                ApplicationArea = all;
            }
        }

        addafter("Employee Posting Group")
        {
            field("MSI_HRIS Bank Code 1"; Rec."MSI_HRIS Bank Code 1")
            {
                ApplicationArea = all;
            }
            field("MSI_HRIS Bank Code 2"; Rec."MSI_HRIS Bank Code 2")
            {
                ApplicationArea = all;
            }
            field("Nama Pemilik Rekening"; Rec."Nama Pemilik Rekening")
            {
                ApplicationArea = all;
            }
            field("Nomor Rekening Bank"; Rec."Nomor Rekening Bank")
            {
                ApplicationArea = all;
            }
            field("Nama Bank Tujuan"; Rec."Nama Bank Tujuan")
            {
                ApplicationArea = all;
            }
        }

        addafter("Birth Date")
        {
            field("MSI_HRIS ID Card"; Rec."MSI_HRIS ID Card")
            {
                ApplicationArea = all;
            }
            field("MSI_HRIS NPWP No."; Rec."MSI_HRIS NPWP No.")
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

        }

        addafter("Director User ID")
        {
            field("MSI_HRIS Admin By"; Rec."MSI_HRIS Admin By")
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

        }
        addafter("General Advance (LCY)")
        {
            field(LeaveValue; Rec.LeaveValue())
            {
                Caption = 'Leave Balance (Value)';
                ApplicationArea = all;
                Editable = false;
                Visible = false;
            }
            field("MSI_HRIS CTO Balance"; CTOBalance)
            {
                Caption = 'CTO Balance';
                ApplicationArea = all;
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
            group("Shift Schedule")
            {
                field("MSI_HRIS Shift Schedule"; rec."MSI_HRIS Shift Schedule")
                {
                    Caption = 'Shift Schedule';
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        if rec."MSI_HRIS Shift Schedule" = true then
                            shiftEditable := true else begin
                            rec."MSI_HRIS Type Shift" := rec."MSI_HRIS Type Shift"::" ";
                            shiftEditable := false;
                        end;
                        CurrPage.Update();
                    end;
                }
                field("MSI_HRIS Type Shift"; rec."MSI_HRIS Type Shift")
                {
                    Caption = 'Type Shift';
                    Editable = shiftEditable;
                    ApplicationArea = all;
                }
            }
        }
        modify("Alt. Address Code")
        {
            Caption = 'Contact Darurat';
        }
        addafter(General)
        {
            group("Medical Balance")
            {
                // medical balancebbbb
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
            // medical balance tutup
            part(subform3; "Career Entries")
            {
                SubPageLink = "Employee No." = field("No.");
                Caption = 'Hiring Information';
                ApplicationArea = all;
            }
        }

    }
    actions
    {
        modify("Assign User ID")
        {
            Visible = false;
        }
        modify("Clear User ID")
        {
            Visible = false;
        }
        modify(PayEmployee)
        {
            Visible = false;
        }
        modify("Sent Emails")
        {
            Visible = false;
        }
        modify(Email)
        {
            Visible = false;
        }
        modify("E&mployee")
        {
            Visible = false;
        }
        modify("&Confidential Information")
        {
            Visible = false;
        }
        modify(Contact)
        {
            Visible = false;
        }
        modify("&Picture")
        {
            Visible = false;
        }
        modify("Q&ualifications")
        {
            Visible = false;
        }
        modify("F&unctions")
        {
            Visible = false;
        }
        modify(Dimensions)
        {
            Visible = false;
        }
        modify("Ledger E&ntries")
        {
            Visible = false;
        }
        modify("Co&mments")
        {
            Visible = false;
        }
        modify(Attachments)
        {
            Visible = false;
        }
        modify("A&bsences")
        {
            Visible = false;
        }


        addafter(PayEmployee)
        {
            action("Medical Slot")
            {
                ApplicationArea = all;
                Caption = 'Medical Slot';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Medical Slot Employee";
                RunPageLink = "No." = FIELD("No.");
                Visible = true;
            }
            action("PAR Report")
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
                    Report.run(Report::PAR, true, false, employeeRec);
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
                Visible = false;

                trigger OnAction()
                var
                    employeeRec: Record Employee;
                begin
                    CurrPage.SetSelectionFilter(employeeRec);
                    Report.run(Report::"Payroll Slip", true, false, employeeRec);
                end;
            }
            action("Attendance Registration")
            {
                Image = RegisteredDocs;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                trigger OnAction()
                var
                    frz_Employee: Record Employee;
                    frz_Attedance: Record "Employee Attendance Header";
                    frz_CodeUnit: Codeunit "User Setup Custome";
                begin
                    if frz_CodeUnit.AttendanceAdminCheck(UserId) = false then begin

                        frz_Employee.Reset();
                        frz_Employee.SetRange("User ID", UserId);
                        if frz_Employee.FindFirst() then begin

                            if rec."No." = frz_Employee."No." then begin
                                frz_Attedance.Reset();
                                frz_Attedance.SetFilter("Employee No.", '= %1', frz_Employee."No.");
                                Page.Run(Page::"Attendance List Button", frz_Attedance);
                            end else begin
                                frz_Attedance.Reset();
                                frz_Attedance.SetRange("Created User ID", rec."MSI_HRIS Admin By");
                                Page.Run(Page::"Attendance List Button", frz_Attedance);
                            end;

                        end;
                    end else begin
                        frz_Attedance.Reset();
                        frz_Attedance.SetRange("Employee No.", Rec."No.");
                        Page.Run(Page::"Attendance List Button", frz_Attedance);
                    end;
                end;
            }
            action("Medical - Slot")
            {
                Caption = 'Medical Slot';
                Image = ProfileCalendar;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = all;
                Visible = false;
                trigger
                OnAction()
                var
                    frz_PageMedicalBalance: Page "Medical Kacamata Balance";
                begin
                    // frz_PageMedicalBalance.SetEmployee(Rec."No.");
                    frz_PageMedicalBalance.Run();
                    CurrPage.Update();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        CTOLedgerEntry: Record "CTO Ledger Entry";
    begin
        //rec.SetRange(Status, Rec.Status::Active);

        rec.CalcFields(Rec."MSI_HRIS Leave Eligbl. Balance");
        if Rec."MSI_HRIS Leave Eligbl. Balance" < 0 then
            Merah := true else
            Merah := false;

        if rec."MSI_HRIS Shift Schedule" = true then
            shiftEditable := true else
            shiftEditable := false;

        // fadhil 
        CTOLedgerEntry.Reset();
        CTOLedgerEntry.setrange("Employee No.", rec."No.");
        CTOLedgerEntry.setrange(Expired, false);
        CTOLedgerEntry.CalcSums("Day Balance");
        CTOBalance := CTOLedgerEntry."Day Balance";
        // fadhil //

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

    var
        Merah: Boolean;
        shiftEditable, gVisible : Boolean;
        CTOBalance: Integer;
}