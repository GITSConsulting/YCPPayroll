page 65059 "Medical Attachment Factbox"
{
    Caption = 'Documents Attached';
    PageType = ListPart;
    SourceTable = "Advance Attachment Entry";
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Attachment1)
            {
                ShowCaption = false;

                field("File Name"; rec."File Name")
                {
                    ApplicationArea = all;
                    trigger OnDrillDown()
                    var
                        _AppCustMgtFD: Codeunit ApprovalCustomManagement;
                    begin
                        _AppCustMgtFD.DownloadAttachment(Rec);
                    end;
                }
                field("File Type"; rec."File Type")
                {
                    ApplicationArea = all;
                }
                // field(Documents1; NumberOfRFQ)
                // {
                //     ApplicationArea = All;
                //     Caption = 'Documents';
                //     StyleExpr = TRUE;
                //     ToolTip = 'Specifies the number of attachments.';

                //     trigger OnDrillDown()
                //     begin
                //         ApprovalCustMgt.UploadAttachment('Vendor Selection', Rec."Document No.");
                //     end;
                // }
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