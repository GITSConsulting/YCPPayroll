page 60018 "Career Entries"
{
    PageType = ListPart;
    UsageCategory = Lists;
    //ApplicationArea = All;
    SourceTable = "Position Ledger Entry";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Editable = false;
    RefreshOnActivate = true;
    //DelayedInsert = true;
    //AutoSplitKey = true;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Effective Date"; format(Rec."Contract Start Date", 0, '<Day> <Month Text> <Year>'))
                {
                    Caption = 'Contract Start Date';
                    ApplicationArea = All;
                }
                field("Contract End Date"; format(Rec."Contract End Date", 0, '<Day> <Month Text> <Year>'))
                {
                    ApplicationArea = all;
                }
                field("Resign Date"; format(Rec."Resign Date", 0, '<Day> <Month Text> <Year>'))
                {
                    Caption = 'Resign/Termination Date';
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Add New")
            {
                Image = Add;

                ApplicationArea = all;
                trigger OnAction()
                begin
                    AddModifyContract.setRecord(Rec."Employee No.", true, 0);
                    AddModifyContract.Run();
                    CurrPage.Update();
                end;
            }
            action("Modify")
            {
                Image = Edit;

                ApplicationArea = all;
                trigger OnAction()
                var
                    HiringInfo: Record "Position Ledger Entry";
                begin
                    HiringInfo.Reset();
                    HiringInfo.SetRange("Employee No.", Rec."Employee No.");
                    HiringInfo.FindLast();

                    if (HiringInfo."Employee No." <> Rec."Employee No.") and
                        (HiringInfo."Entry No." <> Rec."Entry No.") then
                        Error('You can only modify the newest contract.');

                    AddModifyContract.setRecord(Rec."Employee No.", false, Rec."Entry No.");
                    AddModifyContract.Run();
                    CurrPage.Update();
                end;
            }
            action("Delete")
            {
                Image = Delete;

                ApplicationArea = all;
                trigger OnAction()
                var
                    StrConfirm: Text;
                    HiringInfo: Record "Position Ledger Entry";
                    ContractDetail: Record "Contract Detail";
                begin
                    StrConfirm := 'Are you sure to delete this contract (' +
                    format(Rec."Contract Start Date", 0, '<Day> <Month Text> <Year>') + ' until ' +
                    format(Rec."Contract End Date", 0, '<Day> <Month Text> <Year>') + ') ?';

                    HiringInfo.SetRange("Employee No.", Rec."Employee No.");
                    HiringInfo.FindLast();
                    if (Rec."Employee No." <> HiringInfo."Employee No.") and
                        (Rec."Entry No." <> HiringInfo."Entry No.") then
                        Error('For deleting record, you have to do it from the latest.');

                    if not confirm(StrConfirm) then exit;

                    ContractDetail.Reset();
                    ContractDetail.SetRange("Employee No.", Rec."Employee No.");
                    ContractDetail.SetRange("Hiring Information Entry No.", Rec."Entry No.");
                    if ContractDetail.FindSet() then
                        ContractDetail.DeleteAll();

                    HiringInfo.Reset();
                    HiringInfo.SetRange("Employee No.", Rec."Employee No.");
                    HiringInfo.SetRange("Entry No.", Rec."Entry No.");
                    HiringInfo.FindFirst();
                    HiringInfo.Delete();

                    Message('Record deleted.');

                    CurrPage.Update();
                end;
            }
            action("Input Resign/Termination Date")
            {
                Image = RemoveContacts;

                ApplicationArea = all;
                trigger
                OnAction()
                var
                    InputResignDate: Page "Input Resign Date";
                    CekHiring: Record "Position Ledger Entry";
                begin
                    CekHiring.Get(Rec."Employee No.", Rec."Entry No.");
                    InputResignDate.setRecord(Rec."Employee No.", Rec."Entry No.");
                    InputResignDate.Run();

                    CurrPage.Update();
                end;
            }
        }
    }

    trigger
    OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Career Transition" := Rec."Career Transition"::"New Hired";
    end;

    var
        AddModifyContract: Page "Add-Modify Contract";
}