page 65033 "Posted Other Attendance"
{
    PageType = Card;
    // ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Posted Leave Request";
    SourceTableView = where("Leave Type" = const("Other Attendance"));
    DataCaptionFields = "No.";
    Editable = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field("Employee Name"; rec."Employee Name")
                {
                    Caption = 'Employee Name';
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Leave Type Code"; rec."Leave Type Code")
                {
                    ApplicationArea = all;
                }
                group(Period)
                {
                    field("Starting Date"; Rec."Starting Date")
                    {
                        ApplicationArea = all;
                        ShowCaption = false;
                    }
                    field("Ending Date"; Rec."Ending Date")
                    {
                        ApplicationArea = all;
                        ShowCaption = false;
                    }
                }
                field("Total Number of Days"; Rec."Total Number of Days")
                {
                    ApplicationArea = all;
                }
                group("* Note for 0,5 day leave request, please tick below option :")
                {
                    field("Leave-1"; rec."Leave-1")
                    {
                        Caption = 'Leave taken in the morning';
                        ApplicationArea = all;
                    }
                    field("Leave-2"; rec."Leave-2")
                    {
                        Caption = 'Leave taken in the afternoon';
                        ApplicationArea = all;
                    }
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field(Reversed; Rec.Reversed)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Undo Request")
            {
                ApplicationArea = All;
                Image = Undo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = gVisibleUndo;

                trigger OnAction()
                var
                    LeaveMgt: Codeunit "Leave Management";
                    frz_CU_EmailUndo: Codeunit "Email Undo";
                begin
                    frz_CU_EmailUndo.cekKomennye(rec."No.");
                    // LeaveMgt.undoPostedLeaveRequest(Rec);
                    rec.Reversed := true;
                    Message('Undo successfull for posted leave %1', Rec."No.");
                    CurrPage.Update();
                    frz_CU_EmailUndo.SendEmailLeave(rec."No.");
                end;
            }
            action("Other Attendance")
            {
                Image = Print;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger OnAction()
                var
                    LeaveHeader: Record "Posted Leave Request";
                begin
                    CurrPage.SetSelectionFilter(LeaveHeader);
                    Report.run(Report::"Posted Paid Leave Request", true, false, LeaveHeader);
                end;
            }
            action(Comments)
            {
                // Visible = OpenApprovalEntriesExistForCurrUser;
                Caption = 'Comments Undo';
                Image = Comment;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                Visible = gVisibleUndo;
                trigger OnAction()
                var
                    frz_getComment: Codeunit getComment;
                begin
                    frz_getComment.RunApprovalCommentsPage(Rec."No.", 60021);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        _Employee: Record Employee;
    begin
        gVisibleUndo := false;
        _Employee.SetRange("User ID", USERID);
        if _Employee.FindFirst() then begin
            if _Employee."Division Code" = 'HR' then
                gVisibleUndo := true
            else
                gVisibleUndo := false;
        end;
    end;


    var
        Employee: Record Employee;
        EmployeeReplacement: Record Employee;
        EmployeeName: Text;
        EmployeeReplacementName: Text;
        gVisibleUndo: Boolean;
}