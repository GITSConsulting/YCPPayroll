page 65002 "Medical Slot Employee"
{
    Caption = 'Medical Balance Employee';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = Employee;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; rec."No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("First Name"; rec."First Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
            part(Subform; "Medical Slot")
            {
                SubPageLink = "Employee No." = FIELD("No.");
                UpdatePropagation = Both;
                ApplicationArea = all;
            }
            group("Total Amount")
            {
                ShowCaption = false;
                field("Total Medical Amount"; rec."Total Medical Amount")
                {
                    Caption = 'Total Medical Claim Allowed';
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
        }
    }
}