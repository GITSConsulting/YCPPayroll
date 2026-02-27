page 65075 "Clock Schedule"
{
    DelayedInsert = true;
    PageType = List;
    SourceTable = "clock schedule";
    UsageCategory = Lists;
    AutoSplitKey = true;
    MultipleNewLines = true;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Starting Date"; rec."Starting Date")
                {
                    ApplicationArea = BasicHR;
                }
                field("Ending Date"; rec."Ending Date")
                {
                    ApplicationArea = BasicHR;
                }
                field("Working Start"; rec."Working Start")
                {
                    ApplicationArea = BasicHR;
                }
                field("Working Out"; rec."Working Out")
                {
                    ApplicationArea = BasicHR;
                }
                field("Total Time Duration"; rec."Total Time Duration")
                {
                    Caption = 'Total time to go home early';
                    ApplicationArea = BasicHR;
                    Editable = false;
                }
                field("Total Time"; rec."Total Time Hours")
                {
                    ApplicationArea = BasicHR;
                    Editable = false;
                }
                field("Total Time Minutes"; rec."Total Time Minutes")
                {
                    ApplicationArea = BasicHR;
                    Editable = false;
                }
            }
        }
        // area(factboxes)
        // {
        //     systempart(Control1900383207; Links)
        //     {
        //         ApplicationArea = RecordLinks;
        //         Visible = false;
        //     }
        //     systempart(Control1905767507; Notes)
        //     {
        //         ApplicationArea = Notes;
        //         Visible = true;
        //     }
        // }
    }
}

