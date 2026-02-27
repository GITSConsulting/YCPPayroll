page 60004 "HRIS Role Center"
{
    PageType = RoleCenter;
    //ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(RoleCenter)
        {
            part(HeadLineRC; "Headline RC HRIS")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        area(Sections)
        {
            group("HRIS - Payroll")
            {
                action("Employees")
                {

                    ApplicationArea = all;
                    RunObject = page "Employee List HR";
                }
                action("Allowance Components")
                {
                    ApplicationArea = all;
                    RunObject = page "Allowance Component List";
                }
                action("Deduction Components")
                {
                    ApplicationArea = all;
                    RunObject = page "Deduction Component List";
                }
                action("Leave Requests")
                {
                    ApplicationArea = all;
                    RunObject = page "Leave Request Menu";
                }
                action("Setup")
                {
                    ApplicationArea = all;
                    RunObject = page "MSI Payroll Setup";
                }
                action("Reports")
                {
                    ApplicationArea = all;
                    RunObject = page Reports;
                }
                /*
                action("Troubleshoot")
                {
                    ApplicationArea = all;
                    RunObject = page Troubleshoot;
                }*/

                //action("CSV File Bukti Potong Final")
                //{
                //    ApplicationArea = all;
                //RunObject = page Reports;
                //}
            }
        }
    }

}