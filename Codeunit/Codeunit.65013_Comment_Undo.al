codeunit 65014 getComment
{
    procedure RunApprovalCommentsPage(var DocNo: Code[50]; TableID: integer)
    var
        ApprovalComments: Page "Comments Custome";
        frz_CommentPosted: Record "Comment Custome";
    begin
        frz_CommentPosted.Reset();
        frz_CommentPosted.SetRange("Document No.", DocNo);
        ApprovalComments.SetTableView(frz_CommentPosted);
        ApprovalComments.getPostedDoc(DocNo, TableID);
        ApprovalComments.Run;
    end;

    procedure RunApprovalCommentsPage2(var DocNo: Code[50]; TableID: integer)
    var
        ApprovalComments: Page "Comments Custome";
        frz_CommentPosted: Record "Comment Custome";
    begin
        frz_CommentPosted.Reset();
        frz_CommentPosted.SetRange("Document No.", DocNo);
        ApprovalComments.SetTableView(frz_CommentPosted);
        ApprovalComments.getPostedDoc(DocNo, TableID);
        ApprovalComments.Run;
    end;
}