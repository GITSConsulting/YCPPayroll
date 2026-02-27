page 60129 "Posted CTO Request"
{
    Caption = 'Posted Request of Compensatory Time Off';
    PageType = Card;
    //ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Posted CTO Request Header";
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(GENERAL)
            {
                field("No."; Rec."No.")
                {
                    Style = Unfavorable;
                    StyleExpr = Merah;
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                    Style = Unfavorable;
                    StyleExpr = Merah;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    Style = Unfavorable;
                    StyleExpr = Merah;
                    ApplicationArea = all;
                }
                field(EmpName; EmpName)
                {
                    Style = Unfavorable;
                    StyleExpr = Merah;
                    Caption = 'Employee Name';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("CTO Balance"; Rec."CTO Balance")
                {
                    Caption = 'CTO Balance For This Document';
                    Style = Unfavorable;
                    StyleExpr = Merah;
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Approver ID"; Rec."Approver ID")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Approval Date"; Rec."Approval Date")
                {
                    Editable = false;
                    ApplicationArea = all;
                    Style = Unfavorable;
                    StyleExpr = Merah;
                }
                field("Expired Date"; Rec."Expired Date")
                {
                    Style = Unfavorable;
                    StyleExpr = Merah;

                    ApplicationArea = all;
                    Editable = false;
                }
                field(Expired; Rec.Expired)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
            group("PROJECTED BALANCE")
            {
                field("Projected Calculated"; Rec."Projected Calculated")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Projected CTO Balance Calculated';
                }
                field("Projected CTO Balance"; Rec."Projected CTO Balance")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
            part(Subform; "Posted CTO Request Subform")
            {
                Caption = 'Lines';
                SubPageLink = "Document No." = field("No.");
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Undo")
            {
                Image = Undo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                PromotedOnly = true;
                trigger
                OnAction()
                var
                    LeaveMgt: Codeunit "Leave Management";
                    frz_CU_EmailUndo: Codeunit "Email Undo";
                begin
                    frz_CU_EmailUndo.cekKomennye(rec."No.");
                    LeaveMgt.UndoCTOBalance(Rec);
                    frz_CU_EmailUndo.SendEmailCTO(rec."No.");
                end;
            }
            // fadhil
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
                trigger OnAction()
                var
                    frz_getComment: Codeunit getComment;
                begin
                    frz_getComment.RunApprovalCommentsPage(Rec."No.", 60021);
                end;
            }
            action("Print CTO")
            {
                Image = Print;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ApplicationArea = all;
                trigger OnAction()
                var
                    CTOHeader: Record "Posted CTO Request Header";
                begin
                    CurrPage.SetSelectionFilter(CTOHeader);
                    Report.run(Report::"Posted CTO Form", true, false, CTOHeader);
                end;
            }
        }
    }

    var
        EmpName: Text;
        Merah: Boolean;


    trigger
    OnAfterGetRecord()
    begin
        if Rec."Employee No." <> '' then
            EmpName := Rec.NamaEmployee(Rec."Employee No.");

        if Rec.Expired then begin
            Merah := true;
        end else begin
            Merah := false;
        end;
    end;
}