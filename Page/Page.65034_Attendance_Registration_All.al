page 65034 "Attendance Registration All"
{
    Caption = 'Attendence Registration';
    // ApplicationArea = BasicHR;
    DataCaptionFields = "Employee No.";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Employee Absence Line";
    UsageCategory = Lists;
    SourceTableView = SORTING("Document No.", "Entry No Header", "Line No.");
    // Editable = false;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Employee No."; rec."Employee No.")
                {
                    ApplicationArea = BasicHR;
                }
                field("Employee Name"; rec."Employee Name")
                {
                    ApplicationArea = BasicHR;
                }
                field(Date; rec.Date)
                {
                    ApplicationArea = BasicHR;
                }
                field("Document No."; rec."Document No.")
                {
                    ApplicationArea = BasicHR;
                }
                field("Status Doc. Header"; frz_Status)
                {
                    ApplicationArea = BasicHR;
                }
                field(Month; rec.Month)
                {
                    ApplicationArea = BasicHR;
                }
                field(Year; rec.Year)
                {
                    ApplicationArea = BasicHR;
                }
                field("Time From Line"; rec."Time From Line")
                {
                    ApplicationArea = BasicHR;
                }
                field("Time To Line"; rec."Time To Line")
                {
                    ApplicationArea = BasicHR;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = true;
            }
        }
    }
    actions
    {
        area(navigation)
        {
            group("A&bsence")
            {
                Caption = 'A&bsence';
                Image = Absence;
                // action("Co&mments")
                // {
                //     ApplicationArea = Comments;
                //     Caption = 'Co&mments';
                //     Image = ViewComments;
                //     RunObject = Page "Human Resource Comment Sheet";
                //     RunPageLink = "Table Name" = CONST("Employee Absence"),
                //                   "Table Line No." = FIELD("Entry No.");
                //     ToolTip = 'View or add comments for the record.';
                // }
                action("Release")
                {
                    ApplicationArea = All;
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        rec_AttendanceLine: Record "Employee Absence Line";
                        EmployeeAbsenceLine: Record "Employee Absence Line";
                        frz_codeUnitDate: Codeunit "Date Management";
                        frz_AttendanceHeader: Record "Employee Attendance Header";
                        frz_DaftarGagalRelease: Text;
                    begin
                        frz_DaftarGagalRelease := '';
                        frz_AttendanceHeader.Reset();
                        frz_AttendanceHeader.SetRange(Year, rec.Year);
                        frz_AttendanceHeader.SetRange(Month, rec.Month);
                        if frz_AttendanceHeader.FindFirst() then begin
                            repeat

                                if frz_AttendanceHeader.Status = frz_AttendanceHeader.Status::Open then begin

                                    frz_AttendanceHeader.TestField(frz_AttendanceHeader."No.");
                                    frz_AttendanceHeader.TestField(frz_AttendanceHeader."Effective Date");

                                    //Andre 17Sep21
                                    //start
                                    if frz_codeUnitDate.CheckingDateForRealease(frz_AttendanceHeader."No.", frz_AttendanceHeader."Effective Date",
                                    frz_AttendanceHeader."Office Location Code") = false then begin
                                        frz_AttendanceHeader.Status := frz_AttendanceHeader.Status::Released;
                                        frz_AttendanceHeader.Modify();
                                        EmployeeAbsenceLine.Reset();
                                        EmployeeAbsenceLine.SetRange("Document No.", frz_AttendanceHeader."No.");
                                        if EmployeeAbsenceLine.FindSet() then
                                            repeat
                                                if (EmployeeAbsenceLine."Time From Line" = 0T) OR (EmployeeAbsenceLine."Time To Line" = 0T) then begin
                                                    frz_AttendanceHeader.Status := frz_AttendanceHeader.Status::Open;
                                                    frz_AttendanceHeader.Modify();
                                                end;

                                                if EmployeeAbsenceLine.CheckLeaveSyncForRelase(EmployeeAbsenceLine.Date,
                                                EmployeeAbsenceLine."Employee No.") = true then begin
                                                    frz_AttendanceHeader.Status := frz_AttendanceHeader.Status::Open;
                                                    frz_AttendanceHeader.Modify();
                                                end;

                                            until EmployeeAbsenceLine.Next() = 0;
                                        if frz_AttendanceHeader.Status = frz_AttendanceHeader.Status::Open then begin
                                            if frz_DaftarGagalRelease = '' then
                                                frz_DaftarGagalRelease := frz_AttendanceHeader."No." else
                                                frz_DaftarGagalRelease := frz_DaftarGagalRelease + '|' + frz_AttendanceHeader."No.";
                                        end;
                                    end else begin
                                        if frz_DaftarGagalRelease = '' then
                                            frz_DaftarGagalRelease := frz_AttendanceHeader."No." else
                                            frz_DaftarGagalRelease := frz_DaftarGagalRelease + '|' + frz_AttendanceHeader."No.";
                                    end;
                                    //end-Andre
                                    // rec_AttendanceLine.Reset();
                                    // rec_AttendanceLine.SetRange("Document No.", frz_AttendanceHeader."No.");
                                    // if rec_AttendanceLine.FindFirst() then begin
                                    // end else begin
                                    //     Error('Lines Must be have Value');
                                    // end;
                                end;
                            until frz_AttendanceHeader.Next() = 0;
                            Message('Success to release, Data error can not be release please check this document %1', frz_DaftarGagalRelease);
                        end;
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
                        frz_ImportExcel: codeunit "Import Excel Attendance New";
                    begin
                        frz_ImportExcel.ImportExcelnya();
                    end;
                }
            }
        }

    }
    trigger OnOpenPage()
    var
        frz_CodeUnit: Codeunit "User Setup Custome";
    begin
        if frz_CodeUnit.AttendanceAdminCheck(UserId) = false then
            frz_CodeUnit.ModuleNotReady();
    end;

    trigger OnAfterGetRecord()
    var
        frz_Employee: Record Employee;
        frz_AttendanceHeader: Record "Employee Attendance Header";
    begin
        if rec."Activity Date" <> 0D then
            getNameMonth(Date2DMY(rec."Activity Date", 2)) else
            frz_Month := '';

        frz_AttendanceHeader.Reset();
        frz_AttendanceHeader.SetRange("No.", Rec."Document No.");
        if frz_AttendanceHeader.FindFirst() then
            frz_Status := Format(frz_AttendanceHeader.Status);
    end;

    var
        EmployeeName: text;
        frz_Month: Text;
        frz_MonthInteger: Integer;
        frz_Status: Text;

    local procedure getNameMonth(NoBulan: Integer)
    begin
        case NoBulan of
            1:
                frz_Month := 'January';
            2:
                frz_Month := 'February';
            3:
                frz_Month := 'March';
            4:
                frz_Month := 'April';
            5:
                frz_Month := 'May';
            6:
                frz_Month := 'June';
            7:
                frz_Month := 'July';
            8:
                frz_Month := 'August';
            9:
                frz_Month := 'September';
            10:
                frz_Month := 'October';
            11:
                frz_Month := 'November';
            12:
                frz_Month := 'December';
        end;
    end;
}

