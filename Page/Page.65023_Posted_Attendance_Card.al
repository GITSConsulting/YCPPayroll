page 65023 "Posted Attendance Card"
{
    PageType = Document;
    caption = 'Attendance Registration Card';
    RefreshOnActivate = true;
    SourceTable = "Posted Employee Attendance";
    UsageCategory = Documents;
    // ApplicationArea = all;
    Editable = false;
    // created by fadhil 
    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Employee No."; rec."Employee No.")
                {
                    ApplicationArea = all;
                    caption = 'Created By No.';
                    trigger OnValidate()
                    var
                        rec_Employee: Record Employee;
                    begin
                        errorModify();
                        rec_Employee.Reset();
                        rec_Employee.SetRange("No.", rec."Employee No.");
                        rec_Employee.FindFirst();
                        rec."Name Employee" := rec_Employee.FullName();
                    end;
                }
                field("Name Employee"; rec."Name Employee")
                {
                    ApplicationArea = All;
                    caption = 'Created By Name';
                    Editable = false;
                }
                field("Effective Date"; rec."Effective Date")
                {
                    Caption = 'Effective Date';
                    Editable = true;
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        attendaceLine: Record "Employee Absence Line";
                        rec_AttendaceLine: Record "Employee Absence Line";
                        rec_AttendaceLine2: Record "Employee Absence Line";
                        rec_AttendanceHeader: Record "Employee Attendance Header";
                    begin
                        errorModify();
                        rec_AttendaceLine.SetRange("Document No.", rec."No.");
                        if rec_AttendaceLine.FindFirst() then
                            repeat

                                if (Date2DMY(rec_AttendaceLine.Date, 2) <> Date2DMY(rec."Effective Date", 2)) then begin
                                    rec_AttendaceLine2.SetRange("Document No.", rec_AttendaceLine."Document No.");
                                    if rec_AttendaceLine2.FindFirst() then
                                        rec_AttendaceLine2.Delete();
                                end;

                            until rec_AttendaceLine.Next = 0;

                        rec_AttendanceHeader.SetRange("Employee No.", rec."Employee No.");
                        if rec_AttendanceHeader.FindFirst() then
                            repeat
                                if (Date2DMY(rec_AttendanceHeader."Effective Date", 2) = Date2DMY(rec."Effective Date", 2)) AND
                                 (Date2DMY(rec_AttendanceHeader."Effective Date", 3) = Date2DMY(rec."Effective Date", 3)) then
                                    Error('the month on the effective date field already exists in the employee`s document');
                            until rec_AttendanceHeader.Next = 0;
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
            part(Lines; "Posted Attendance Subform")
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
                    dateMonth: Integer;
                    EmployeeAbsenceLine: Record "Employee Absence Line";
                begin
                    dateMonth := Date2DMY(rec."Effective Date", 2);
                    rec.TestField(Rec."No.");
                    rec.TestField(Rec."Effective Date");

                    //Andre 17Sep21
                    //start
                    EmployeeAbsenceLine.Reset();
                    EmployeeAbsenceLine.SetRange("Document No.", Rec."No.");
                    if EmployeeAbsenceLine.FindSet() then
                        repeat
                            EmployeeAbsenceLine.CheckLeaveSync(EmployeeAbsenceLine.Date,
                            EmployeeAbsenceLine."Employee No.");
                        until EmployeeAbsenceLine.Next() = 0;
                    //end-Andre

                    rec_AttendanceLine.SetRange("Document No.", Rec."No.");
                    if rec_AttendanceLine.FindFirst() then begin
                        rec.Status := rec.Status::Released;
                    end else begin
                        Error('Lines Must be have Value');
                    end;
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
}