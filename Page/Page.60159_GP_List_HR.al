page 60159 "GP List HR"
{
    Caption = 'GP List';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Advance Header";
    SourceTableView = where("Document Type" = const("General Payment"), "Voucher Type" = const(" "));
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        AdvanceHeader: Record "Advance Header";
                        GeneralPayment: page "General Payment";
                    begin
                        Clear(GeneralPayment);
                        AdvanceHeader.Reset();
                        AdvanceHeader.SetRange("Document Type", AdvanceHeader."Document Type"::"General Payment");
                        AdvanceHeader.SetRange("No.", Rec."No.");
                        AdvanceHeader.SetRange("Voucher Type", AdvanceHeader."Voucher Type"::" ");
                        if AdvanceHeader.FindFirst() then begin
                            GeneralPayment.SetRecord(AdvanceHeader);
                            GeneralPayment.Run();
                        end;
                    end;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Journal Description"; Rec."Journal Description")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}