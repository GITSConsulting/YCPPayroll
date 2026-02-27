codeunit 65011 "Attachment Medical"
{
    procedure UploadAttachment(DocumentType: Text; DocumentNo: Code[20]);
    var
        _AdvanceAttchEntry: Record "Advance Attachment Entry";
        _AttachEntries: Page "Attachment Entries Medical";
    begin
        _AdvanceAttchEntry.FILTERGROUP(8);
        _AdvanceAttchEntry.SETFILTER("Document Type", DocumentType);
        _AdvanceAttchEntry.SETRANGE("Document No.", DocumentNo);
        _AdvanceAttchEntry.FILTERGROUP(6);
        _AttachEntries.SETTABLEVIEW(_AdvanceAttchEntry);
        _AttachEntries.SetHeader(DocumentType, DocumentNo);
        _AttachEntries.RUNMODAL;
    end;
}