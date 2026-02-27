page 60066 "Get Overtime"
{
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Overtime Header";
    Editable = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Reference Date"; Rec."Reference Date")
                {
                    ApplicationArea = all;
                }
                field("Overtime Start Date"; Rec."Overtime Start Date")
                {
                    ApplicationArea = all;
                }
                field("Overtime End Date"; Rec."Overtime End Date")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Show Document")
            {
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = all;

                trigger
                OnAction()
                var
                    PageOvertime: page Overtime;
                begin
                    PageOvertime.SetRecord(Rec);
                    PageOvertime.Run();
                end;
            }
        }
    }
}