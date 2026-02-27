page 65064 "Comment Posted Factbox"
{
    Caption = 'Comment Factbox';
    PageType = ListPart;
    SourceTable = "Posted Approval Comment Line";
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Attachment1)
            {
                ShowCaption = false;

                field(Comment; rec.Comment)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("User ID"; rec."User ID")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Date and Time"; rec."Date and Time")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        currentFilterGroup: Integer;
        AttachmentEntry: Record "Advance Attachment Entry";
    begin
        AttachmentEntry.reset;
        AttachmentEntry.setrange("Document No.", rec."Document No.");
        // AttachmentEntry.SetRange("Document Type", AttachmentEntry."Document Type"::"Medical Reimbursement");
        NumberOfRFQ := AttachmentEntry.Count;
    end;



    var
        NumberOfRFQ: Integer;
        ApprovalCustMgt: Codeunit ApprovalCustomManagement;
}