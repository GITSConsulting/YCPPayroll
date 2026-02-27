query 60002 "THR Ledger and Employee Joined"
{
    QueryType = Normal;

    elements
    {
        dataitem(Employee; Employee)
        {
            DataItemTableFilter = Status = const(Active);
            column(No_; "No.")
            {

            }
            column(First_Name; "First Name")
            {

            }

            dataitem(THR_Ledger_Entry; "THR Ledger Entry")
            {
                DataItemLink = "Employee No." = Employee."No.";
                DataItemTableFilter = OBAL = const(false);

                column(Entry_No_; "Entry No.")
                {

                }
                column(THR_Amount; "THR Amount")
                {

                }
                column(Disbursement_Type; "Disbursement Type")
                {

                }
                column(Payroll_Ledger_Entry_No_; "Payroll Ledger Entry No.")
                {

                }
                column(Posting_Date; "Posting Date")
                {

                }
            }
        }
    }

    var
        myInt: Integer;

    trigger OnBeforeOpen()
    begin

    end;
}