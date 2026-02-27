codeunit 60006 "Check and Adjust Expired CTO"
{
    trigger OnRun()
    var
        StrPanjang: Text;
    begin
        CTOLedgerEntry.Reset();
        //CTOLedgerEntry.SetRange("Document No.", CTORequestHeader."No.");
        CTOLedgerEntry.SetRange("CTO Type", CTOLedgerEntry."CTO Type"::Request);
        CTOLedgerEntry.SetRange("Entry Type", CTOLedgerEntry."Entry Type"::Positive);
        CTOLedgerEntry.SetFilter("Request Expired Date", '<=%1', Today);
        CTOLedgerEntry.SetRange(Reversed, false);
        CTOLedgerEntry.SetRange(Expired, false);
        CTOLedgerEntry.SetRange(Used, false);
        if CTOLedgerEntry.FindSet() then begin
            CTOLedgerEntry.ModifyAll(Expired, true);
            //repeat


            //    StrPanjang := StrPanjang + CTOLedgerEntry."Employee No." + '(' +
            //    format(CTOLedgerEntry."Day Balance") + ')';
            //    StrPanjang := StrPanjang + '-';
            //until CTOLedgerEntry.Next() = 0;
            //CTOLedgerEntry.ModifyAll(Expired, true);
        end;

        //Error(StrPanjang);

        //repeat
        //    CTOLedgerEntry.Expired := true;
        //    CTOLedgerEntry.Modify();
        //until CTOLedgerEntry.Next() = 0;


        //CTORequestHeader.Reset();
        //CTORequestHeader.SetRange(Status, CTORequestHeader.Status::Released);
        //CTORequestHeader.SetFilter("Expired Date", '<=%1', Today);
        //if CTORequestHeader.FindSet() then
        //repeat
        //CTORequestHeader.Expired := true;
        //CTORequestHeader.Modify();



        //until CTORequestHeader.Next() = 0;
    end;

    var
        CTORequestHeader: Record "CTO Request Header";
        CTOLedgerEntry: Record "CTO Ledger Entry";
}