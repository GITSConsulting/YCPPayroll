page 60141 "Contract Editable"
{
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Position Ledger Entry";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = all;
                }
                field("Contract End Date"; Rec."Contract End Date")
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
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}