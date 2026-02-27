page 65016 "Attendance Registration Card"
{
    PageType = Document;
    caption = 'Attendance Registration Card';
    RefreshOnActivate = true;
    SourceTable = "Employee Attendance Header";
    UsageCategory = Documents;
    ApplicationArea = all;

    // fadhil
    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    trigger
                    OnAssistEdit()
                    begin
                        errorModify();
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Other Attendance Your Handle"; rec."Other Attendance Your Handle")
                {
                    ApplicationArea = all;
                    Visible = false;
                    trigger OnValidate()
                    begin
                        if rec."Other Attendance Your Handle" = true then
                            frz_HandleTrue := false else
                            frz_HandleTrue := true;
                        CurrPage.Update();
                    end;
                }
                field("Employee No."; rec."Employee No.")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        rec_Employee: Record Employee;
                    begin
                        rec.TestField("No.");
                        errorModify();
                        CheckUserIDnya(rec."Employee No.");
                        rec_Employee.Reset();
                        rec_Employee.SetRange("No.", rec."Employee No.");
                        if rec_Employee.FindFirst() then begin
                            rec."Name Employee" := rec_Employee.FullName();
                        end;
                        if rec."Effective Date" <> 0D then
                            rec.CekEffektivDate(rec."Effective Date", rec."No.", rec."Employee No.");
                        CurrPage.Update();
                    end;
                }
                field("Effective Date"; rec."Effective Date")
                {
                    Caption = 'Effective Date';
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        attendaceLine: Record "Employee Absence Line";
                        rec_AttendaceLine: Record "Employee Absence Line";
                        rec_AttendaceLine2: Record "Employee Absence Line";
                        rec_AttendanceHeader: Record "Employee Attendance Header";
                        frz_CodeUnitMonth: Codeunit "Month Picker";
                    begin
                        errorModify();
                        rec_AttendaceLine.Reset();
                        rec_AttendaceLine.SetRange("Document No.", rec."No.");
                        if rec_AttendaceLine.FindFirst() then
                            repeat

                                if (Date2DMY(rec_AttendaceLine.Date, 2) <> Date2DMY(rec."Effective Date", 2)) then begin
                                    rec_AttendaceLine2.SetRange("Document No.", rec_AttendaceLine."Document No.");
                                    if rec_AttendaceLine2.FindFirst() then
                                        rec_AttendaceLine2.Delete();
                                end;
                                rec_AttendaceLine."Activity Date" := rec."Effective Date";
                                rec_AttendaceLine.Modify();

                            until rec_AttendaceLine.Next = 0;

                        if rec."Effective Date" <> 0D then
                            rec.CekEffektivDate(rec."Effective Date", rec."No.", rec."Employee No.");
                        rec.Year := Date2DMY(rec."Effective Date", 3);
                        rec.Month := frz_CodeUnitMonth.getNameMonth(Date2DMY(rec."Effective Date", 2));

                        CurrPage.Update();
                    end;
                }
                field(Month; rec.Month)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Year; rec.Year)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Name Employee"; rec."Name Employee")
                {
                    caption = 'Employee Name';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Office Location Code"; rec."Office Location Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                    TableRelation = "Dimension Value".Code where("Dimension Code" = filter('AREA'));
                    trigger OnValidate()
                    begin
                        if frz_CodeUnit.CheckLocationCode(UserId) <> rec."Office Location Code" then
                            Error('Office Location Code different with Office Location Employee');

                        if rec."Effective Date" <> 0D then
                            rec.CekEffektivDate(rec."Effective Date", rec."No.", rec."Office Location Code");
                    end;
                }
                field("Description By Employee"; rec."Description By Employee")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        errorModify()
                    end;
                }
                field(Day; rec.Day)
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = all;
                }
                field(Status; rec.Status)
                {
                    Editable = false;
                    ApplicationArea = all;
                }
            }
            part(Lines; "Employee Absence Subform")
            {
                ApplicationArea = all;
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;

            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Release")
            {
                ApplicationArea = All;
                Image = Post;
                Visible = visibleCheck;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    rec_AttendanceLine: Record "Employee Absence Line";
                    EmployeeAbsenceLine: Record "Employee Absence Line";
                    frz_codeUnitDate: Codeunit "Date Management";
                begin
                    rec.TestField(Rec."No.");
                    rec.TestField(Rec."Effective Date");

                    //Andre 17Sep21
                    //start
                    EmployeeAbsenceLine.Reset();
                    EmployeeAbsenceLine.SetRange("Document No.", Rec."No.");
                    if EmployeeAbsenceLine.FindSet() then
                        repeat
                            if (EmployeeAbsenceLine."Time From Line" = 0T) OR (EmployeeAbsenceLine."Time To Line" = 0T) then
                                error('Check Time From or Time To there are can not be null %1', EmployeeAbsenceLine.Date);
                            EmployeeAbsenceLine.CheckLeaveSync(EmployeeAbsenceLine.Date,
                            EmployeeAbsenceLine."Employee No.");
                        until EmployeeAbsenceLine.Next() = 0;
                    //end-Andre
                    rec_AttendanceLine.Reset();
                    rec_AttendanceLine.SetRange("Document No.", Rec."No.");
                    if rec_AttendanceLine.FindFirst() then begin
                        rec.Status := rec.Status::Released;
                    end else begin
                        Error('Lines Must be have Value');
                    end;

                    frz_codeUnitDate.CheckingDate(rec."No.", rec."Effective Date", rec."Office Location Code");
                end;
            }
            action("Reopen")
            {
                ApplicationArea = All;
                Image = ReOpen;
                Promoted = true;
                Visible = visibleCheck2;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    rec.Status := rec.Status::Open;
                end;
            }
            action("Description of Attendance")
            {
                ApplicationArea = All;
                Image = AbsenceCalendar;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    page.Run(Page::"Description of Attendance Card", Rec);
                end;
            }
            action("Posting")
            {
                ApplicationArea = All;
                Image = PostingEntries;
                Promoted = true;
                Visible = false;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    frz_RecPostedAttendance: Record "Posted Employee Attendance";
                    frz_RecPostedAttendanceLine: Record "Posted Employee Absence Line";

                    frz_RecAttendance: Record "Employee Attendance Header";
                    frz_RecAttendanceLine: Record "Employee Absence Line";

                    // frz_AttendanceLedger: Record "Attendance Ledger Entry";
                    // frz_AttendanceLedgerLast: Record "Attendance Ledger Entry";
                    NoLast: Integer;

                    frz_RecAttendanceDelete: Record "Employee Attendance Header";
                    frz_RecAttendanceLineDelete: Record "Employee Absence Line";
                begin
                    if Rec.Status = rec.Status::Released then begin

                        frz_RecAttendance.SetRange("No.", rec."No.");
                        if frz_RecAttendance.FindFirst() then begin

                            frz_RecPostedAttendance.Init();
                            frz_RecPostedAttendance.TransferFields(frz_RecAttendance);
                            frz_RecPostedAttendance.Insert();

                            // if frz_AttendanceLedgerLast.FindLast() then
                            //     NoLast := frz_AttendanceLedgerLast."Entry No." + 1 else
                            //     NoLast := 0;

                            frz_RecAttendanceLine.SetRange("Document No.", rec."No.");
                            if frz_RecAttendanceLine.FindFirst() then begin
                                repeat
                                // frz_RecPostedAttendanceLine.Init();
                                // frz_RecPostedAttendanceLine.TransferFields(frz_RecAttendanceLine);
                                // frz_RecPostedAttendanceLine.Insert();

                                // frz_AttendanceLedger.Init();
                                // frz_AttendanceLedger.TransferFields(frz_RecAttendanceLine);
                                // frz_AttendanceLedger."Entry Type" := frz_AttendanceLedger."Entry Type"::Positive;
                                // frz_AttendanceLedger."Entry No." += NoLast;
                                // frz_AttendanceLedger.Insert();
                                until frz_RecAttendanceLine.Next = 0;

                                frz_RecAttendanceDelete.Reset();
                                frz_RecAttendanceDelete.SetRange("No.", rec."No.");
                                if frz_RecAttendanceDelete.FindFirst() then begin
                                    frz_RecAttendanceLineDelete.Reset();
                                    frz_RecAttendanceLineDelete.SetRange("Document No.", frz_RecAttendanceDelete."No.");
                                    if frz_RecAttendanceLineDelete.FindFirst() then
                                        repeat
                                            frz_RecAttendanceLineDelete.Delete();
                                        until frz_RecAttendanceLineDelete.Next() = 0;
                                    frz_RecAttendanceDelete.Delete();
                                end;
                                Message('Success Send to Posted');

                            end;
                        end;
                    end else
                        Error('Status must be equal to `Realead`');
                end;
            }
            action("Import Excel")
            {
                ApplicationArea = All;
                Image = Excel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    frz_ImportExcel: codeunit "Import Excel Attendance";
                begin
                    frz_ImportExcel.ImportExcelnya(rec."No.");
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
                    employeeRec2: Record Employee;
                begin
                    // CurrPage.SetSelectionFilter(employeeRec);
                    employeeRec.Reset();
                    employeeRec.SetRange("No.", Rec."Employee No.");
                    if employeeRec.FindFirst() then begin
                        employeeRec2.reset;
                        employeeRec2.SetRange("No.", employeeRec."No.");
                        if employeeRec2.FindFirst() then
                            Report.run(Report::"Attendance Sheet", true, false, employeeRec2)
                        else
                            Error('There is no employee filter');
                    end;
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        if rec.Status = rec.Status::Released then begin
            visibleCheck := false;
            visibleCheck2 := true;
        end else begin
            visibleCheck := true;
            visibleCheck2 := false;
        end;
    end;

    trigger OnOpenPage()

    begin
        if rec."Other Attendance Your Handle" = true then
            frz_HandleTrue := false else
            frz_HandleTrue := true;
        frz_EmployeeGlobal := getEmployee();

        rec.SetFilter(rec."Employee Filter", frz_EmployeeGlobal);

    end;

    procedure CheckUserIDnya(Nonya: Code[20])
    var
        frz_rec_Employee: Record Employee;
        frz_rec_Employee2: Record Employee;
        frz_CodeUnit: Codeunit "User Setup Custome";
    begin
        if frz_CodeUnit.AttendanceAdminCheck(UserId) = false then begin

            frz_rec_Employee.Reset();
            frz_rec_Employee.SetRange("User ID", UserId);
            if frz_rec_Employee.FindFirst() then begin
                if frz_rec_Employee."No." <> Nonya then begin

                    frz_rec_Employee2.Reset();
                    frz_rec_Employee2.SetRange("No.", Nonya);
                    if frz_rec_Employee2.FindFirst() then begin
                        if frz_rec_Employee2."MSI_HRIS Admin By" <> UserId then begin
                            error('This Employee not match for your user id');
                        end;
                    end;

                end;

            end else begin
                frz_rec_Employee2.Reset();
                frz_rec_Employee2.SetRange("No.", Nonya);
                if frz_rec_Employee2.FindFirst() then begin
                    if frz_rec_Employee2."MSI_HRIS Admin By" <> UserId then begin
                        error('This Employee not match for your user id');
                    end;
                end;
            end;
        end;
    end;

    local procedure getEmployee(): Text
    var
        frz_Employee: Record Employee;
        frz_Employee_2: Record Employee;
        frz_dataEmployee: Text;
        frz_dataEmployee_2: Text;
    begin
        frz_dataEmployee := '';
        frz_Employee.Reset();
        frz_Employee.SetFilter("MSI_HRIS Admin By", '= %1', UserId);
        if frz_Employee.FindFirst() then begin
            repeat
                if frz_dataEmployee = '' then
                    frz_dataEmployee := frz_Employee."No." else
                    frz_dataEmployee := frz_dataEmployee + '|' + frz_Employee."No.";

            until frz_Employee.Next() = 0;
        end;

        frz_dataEmployee_2 := '';
        frz_Employee_2.Reset();
        frz_Employee_2.SetFilter("User ID", '= %1', UserId);
        if frz_Employee_2.FindFirst() then begin
            repeat
                if frz_dataEmployee_2 = '' then
                    frz_dataEmployee_2 := frz_Employee_2."No." else
                    frz_dataEmployee_2 := frz_dataEmployee_2 + '|' + frz_Employee_2."No.";
            until frz_Employee_2.Next() = 0;
        end;
        if frz_dataEmployee = '' then begin
            exit(frz_dataEmployee_2);
        end else
            exit(frz_dataEmployee + '|' + frz_dataEmployee_2);
    end;

    procedure errorModify()
    begin
        if rec.Status = rec.Status::Released then
            Error('The Document Can Not Update Because Status is Release');
    end;

    var
        Employee: Record Employee;
        StatusBolean: Boolean;
        visibleCheck: Boolean;
        visibleCheck2: Boolean;
        frz_UserId: Code[50];
        frz_CodeUnit: Codeunit "User Setup Custome";
        frz_HandleTrue: Boolean;
        frz_EmployeeGlobal: text;
        frz_BaseCalendar: Record "Base Calendar Change";
}