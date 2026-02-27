page 65015 "Posted Uncon Leave Request"
{
    PageType = Card;
    Caption = 'Posted Others Paid Leave Request';
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Posted Unco Leave Request";
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
                field(EmployeeFullName; rec."Employee Name")
                {
                    Caption = 'Employee Name';
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Paid Leave Type"; rec."Leave Type Code")
                {
                    ApplicationArea = all;
                }
                field("Employee No. Replacement"; Rec."Employee No. Replacement")
                {
                    Caption = 'My Replacement During Leave';
                    ApplicationArea = all;
                }
                field(EmployeeReplacementName; EmployeeReplacementName)
                {
                    Editable = false;
                    ApplicationArea = all;
                    Caption = 'Employee Replacement Name';
                }
                field("Posting Date"; rec."Posting Date")
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
                    frz_CU_EmailUndo: Codeunit "Email Undo";
                    LeaveMgt: Codeunit "Unconditional Leave Manage";
                begin
                    frz_CU_EmailUndo.cekKomennye(rec."No.");
                    LeaveMgt.undoPostedLeaveRequest(Rec);
                    frz_CU_EmailUndo.SendEmailUnconditional(rec."No.");
                    CurrPage.Update();
                end;
            }
            action(Comments)
            {
                Visible = gVisibleUndo;
                Caption = 'Comments Undo';
                Image = Comment;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                trigger OnAction()
                var
                    frz_getComment: Codeunit getComment;
                begin
                    frz_getComment.RunApprovalCommentsPage(Rec."No.", 60021);
                end;
            }
            action("Print Unconditional Leave Request")
            {
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ApplicationArea = all;
                trigger OnAction()
                var
                    UncoHeader: Record "Posted Unco Leave Request";
                begin
                    CurrPage.SetSelectionFilter(UncoHeader);
                    Report.run(Report::"Posted Unconditional Leave", true, false, UncoHeader);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        frz_Employee: Record Employee;
    begin
        frz_Employee.reset;
        frz_Employee.SetRange("No.", rec."Employee No. Replacement");
        if frz_Employee.FindFirst() then begin
            EmployeeReplacementName := frz_Employee.FullName();
        end;
    end;

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