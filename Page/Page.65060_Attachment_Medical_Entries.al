page 65060 "Attachment Entries Medical"
{
    PageType = List;
    SourceTable = "Advance Attachment Entry";
    InsertAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("File Name"; Rec."File Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    trigger OnDrillDown()
                    var
                        _AppCustMgtFD: Codeunit ApprovalCustomManagement;
                    begin
                        //if (DownloadVisible) or (UnverifiedVoucher) then
                        _AppCustMgtFD.DownloadAttachment(Rec);
                    end;
                }
                field("File Type"; Rec."File Type")
                {
                    ApplicationArea = all;
                    Editable = false;
                }

            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Add File")
            {
                Visible = addVisible;
                ApplicationArea = all;
                Image = FiledPosted;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    _AppCustMgtFD: Codeunit ApprovalCustomManagement;
                begin
                    _AppCustMgtFD.ImportAttachment(DocumentType, DocumentNo);
                end;
            }
            action("Download File")
            {
                Visible = DownloadVisible;
                ApplicationArea = all;
                Image = ExportAttachment;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    _AppCustMgtFD: Codeunit ApprovalCustomManagement;
                begin
                    _AppCustMgtFD.DownloadAttachment(Rec);
                end;
            }

        }
    }

    var
        AdvanceHdr: Record "Advance Header";
        [InDataSet]
        DownloadVisible: Boolean;
        addVisible: Boolean;
        DocumentType: Text;
        DocumentNo: Code[20];
        UnverifiedVoucher: Boolean;

    procedure SetHeader(NewDocumentType: Text; NewDocumentNo: Code[20])
    var
        _ApprovalMode: Boolean;
        _AdvanceHdr: Record "Advance Header";
        _PurchReqHdr: Record "Purch. Requisition Header";
        _VendSelectHdr: Record "Vendor Selection Header";
        _ProposalHdr: Record "Proposal Header";
        _AgreementHdr: Record "Agreement Header";
        _WorkplanHdr: Record "Workplan Header";
        frz_MedicalReimbursement: Record "Medical Reimbursement Header";
        frz_medicalHeader: Record "Medical Reimbursement Header";
    begin
        DocumentType := NewDocumentType;
        DocumentNo := NewDocumentNo;

        frz_medicalHeader.Reset();
        frz_medicalHeader.SetRange("No.", DocumentNo);
        if frz_medicalHeader.FindFirst() then begin
            if frz_medicalHeader.Status = frz_medicalHeader.Status::Open then begin
                addVisible := true;
            end else
                addVisible := false;

            case true of
                (DocumentType = 'Purchase Requisition'):
                    begin
                        _PurchReqHdr.Get(DocumentNo);
                        _ApprovalMode := _PurchReqHdr.Status in [_PurchReqHdr.Status::"Pending Approval", _PurchReqHdr.Status::Released];
                    end;
                (DocumentType = 'Medical Reimbursement'):
                    begin
                        frz_MedicalReimbursement.Get(DocumentNo);
                        _ApprovalMode := frz_MedicalReimbursement.Status in [frz_MedicalReimbursement.Status::"Pending Approval", frz_MedicalReimbursement.Status::Released];
                    end;
                (DocumentType = 'Vendor Selection'):
                    begin
                        _VendSelectHdr.Get(DocumentNo);
                        _ApprovalMode := _VendSelectHdr.Status in [_VendSelectHdr.Status::"Pending Approval", _VendSelectHdr.Status::Released];
                    end;
                (DocumentType = 'Proposal'):
                    begin
                        _ProposalHdr.Get(DocumentNo);
                        _ApprovalMode := _ProposalHdr.Status in [_ProposalHdr.Status::"Pending Approval", _ProposalHdr.Status::Released];
                    end;
                (DocumentType = 'Agreement'):
                    begin
                        _AgreementHdr.Get(DocumentNo);
                        _ApprovalMode := _AgreementHdr.Status in [_AgreementHdr.Status::"Pending Approval", _AgreementHdr.Status::Released];
                    end;
                (DocumentType = 'Workplan'):
                    begin
                        _WorkplanHdr.Get(DocumentNo);
                        _ApprovalMode := _WorkplanHdr.Status in [_WorkplanHdr.Status::"Pending Approval", _WorkplanHdr.Status::Released];
                    end;
                else begin
                        _AdvanceHdr.SetFilter("Document Type", DocumentType);
                        _AdvanceHdr.SetRange("No.", DocumentNo);
                        _AdvanceHdr.FindFirst();
                        UnverifiedVoucher := (_AdvanceHdr.Status = _AdvanceHdr.Status::Released);// and (_AdvanceHdr."Verification Status" = _AdvanceHdr."Verification Status"::Unverified);
                        _ApprovalMode := (_AdvanceHdr.Status in [_AdvanceHdr.Status::"Pending Approval", _AdvanceHdr.Status::Released]);
                    end;
            end;
            DownloadVisible := _ApprovalMode and (not UnverifiedVoucher);
        end;

        // trigger OnAfterGetRecord()
        // var
        //     frz_medicalHeader: Record "Medical Reimbursement Header";
        // begin
        //     frz_medicalHeader.Reset();
        //     frz_medicalHeader.SetRange("No.", DocumentNo);
        //     if frz_medicalHeader.FindFirst() then begin
        //         if frz_medicalHeader.Status = frz_medicalHeader.Status::Open then begin
        //             Message('find');
        //             addVisible := true;
        //         end
        //         else
        //             addVisible := false;
        //     end;
    end;

}
