pageextension 60033 MSIHRIS_PaymentJnl extends "Payment Journal"
{
    layout
    {
        moveafter("Debit Amount"; "Account No.")
        moveafter("Credit Amount"; "Debit Amount")

        modify("Debit Amount")
        {
            Visible = true;
            ApplicationArea = all;
        }
        modify("Credit Amount")
        {
            Visible = true;
            ApplicationArea = all;
        }
        modify("Document Date")
        {
            Visible = false;
            ApplicationArea = all;
        }
        modify("Document Type")
        {
            Visible = false;
            ApplicationArea = all;
        }
        modify("External Document No.")
        {
            Visible = false;
            ApplicationArea = all;
        }
        modify("Recipient Bank Account")
        {
            Visible = false;
            ApplicationArea = all;
        }
        modify("Currency Code")
        {
            Visible = false;
            ApplicationArea = all;
        }
        modify("Payment Reference")
        {
            Visible = false;
            ApplicationArea = all;
        }
        modify(Amount)
        {
            Visible = false;
            ApplicationArea = all;
        }
        modify("Bal. Account Type")
        {
            Visible = false;
            ApplicationArea = all;
        }
        modify("Bal. Account No.")
        {
            Visible = false;
            ApplicationArea = all;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Visible = true;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = true;
        }
    }
}