query 60003 "Component and Allowance"
{
    QueryType = Normal;

    elements
    {
        dataitem(Allowance_Component; "Allowance Component")
        {
            DataItemTableFilter = "Allowance Type" = filter(Fix | "Non Fix");
            column(Kode; Kode)
            {

            }
            column(Name; Name)
            {

            }
            dataitem(Employee_Salary_Component; "Employee Salary Component")
            {
                DataItemLink = "Allowance Component Code" = Allowance_Component.Kode;

                column(Allowance_Component_Code; "Allowance Component Code")
                {

                }
                column(Employee_No_; "Employee No.")
                {

                }
                dataitem(Detailed_Payroll_Ledger_Entry; "Detailed Payroll Ledger Entry")
                {
                    DataItemLink = "Employee No." = Employee_Salary_Component."Employee No.";
                    DataItemTableFilter = Type = const(Allowance), "Allowance Type" = filter(Fix | "Non Fix");

                    column(Allowance_Type; "Allowance Type")
                    {

                    }
                    column(Posting_Date; "Posting Date")
                    {

                    }
                    column(Amount; Amount)
                    {

                    }
                }
            }
        }
    }
}