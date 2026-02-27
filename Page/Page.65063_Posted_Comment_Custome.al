page 65063 "Post Approval Comments"
{
    Caption = 'Approval Comments';
    SourceTable = "Posted Approval Comment Line";
    Editable = false;
    PageType = List;
    UsageCategory = Lists;
    // ApplicationArea = all;
    AutoSplitKey = true;
    MultipleNewLines = true;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Comment; rec.Comment)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the comment. You can enter a maximum of 250 characters, both numbers and letters.';
                    trigger OnValidate()

                    begin
                        rec."User ID" := UserId;
                        rec."Document No." := docNo;
                        rec."Date and Time" := CreateDateTime(Today, Time);
                        rec."Table ID" := TableID;
                        rec."HRIS_CARE Undo Comment" := true;
                    end;
                }
                field("User ID"; rec."User ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the ID of the user who created this approval comment.';
                    Editable = false;
                    // trigger OnDrillDown()
                    // var
                    //     UserMgt: Codeunit "User Management";
                    // begin
                    //     UserMgt.DisplayUserInformation(rec."User ID");
                    // end;
                    trigger OnValidate()

                    begin
                        rec."User ID" := UserId;
                    end;
                }
                field("Date and Time"; rec."Date and Time")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the date and time when the comment was made.';
                }
                field("Entry No."; rec."Entry No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the entry, as assigned from the specified number series when the entry was created.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group("prosess")
            {
                action(Comments)
                {
                    // Visible = OpenApprovalEntriesExistForCurrUser;
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
                        frz_getComment.RunApprovalCommentsPage2(docNo, TableID);
                    end;
                }
            }
        }
    }

    // trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    // begin
    //     // "Workflow Step Instance ID" := WorkflowStepInstanceID;
    // end;

    var
        WorkflowStepInstanceID: Guid;
        docNo: Code[50];
        TableID: Integer;

    // procedure SetWorkflowStepInstanceID(NewWorkflowStepInstanceID: Guid)
    // begin
    //     WorkflowStepInstanceID := NewWorkflowStepInstanceID;
    // end;

    procedure getPostedDoc(frz_DocNo: Code[50]; TableIDnya: integer)
    begin
        docNo := frz_DocNo;
        TableID := TableIDnya;
    end;
}

