page 60153 "Role Center Procurement - HR"
{
    PageType = RoleCenter;
    layout
    {
        area(RoleCenter)
        {
            part(HeadLine; "Headline RC Business Manager")
            {
                ApplicationArea = all;
            }
            group("MyGroup")
            {
                part(CueFinUser; "Cue Procurement")
                {
                    ApplicationArea = all;
                }
                part(PowerBIPart; "Power BI Embedded Report Part")
                {
                    AccessByPermission = TableData "Power BI User Configuration" = I;
                    ApplicationArea = Basic, Suite;
                }
                part(HRCue; "HRIS Cue")
                {
                    ApplicationArea = all;
                }
                part(ApprovalMonitoring; "HR Approval Monitoring")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(Sections)
        {
            group("Human Resources IS")
            {
                action("HR - Monthly Payroll")
                {
                    ApplicationArea = all;
                    RunObject = page "Employee List HR";
                }
                action("HR - 13th Salary (THR)")
                {
                    ApplicationArea = all;
                    RunObject = page "THR List";
                }
                action("HR - Year End PPh Calculation")
                {
                    ApplicationArea = all;
                    RunObject = page "Employee List PPh Akhir Tahun";
                }
                action("HR - Allowance Components")
                {
                    ApplicationArea = all;
                    RunObject = page "Allowance Component List";
                }
                action("HR - Deduction Components")
                {
                    ApplicationArea = all;
                    RunObject = page "Deduction Component List";
                }
                action("HR - Leave Management")
                {
                    ApplicationArea = all;
                    RunObject = page "Leave Request Menu";
                }
                action("HR - Medical Reimbursement")
                {
                    ApplicationArea = all;
                    RunObject = page "Medical Reimbursement Menu";
                }
                action("HR - Medical Master")
                {
                    ApplicationArea = all;
                    RunObject = page "Medical List";
                }
                action("HR - Status Point")
                {
                    ApplicationArea = all;
                    RunObject = page "Master Point Status";
                }
                action("HR - Attendance")
                {
                    ApplicationArea = all;
                    RunObject = page "Attendance Menu";
                }
                action("HR - Overtime")
                {
                    ApplicationArea = all;
                    RunObject = page "Overtime Menu";
                }
                action("HR - Employee Chargings")
                {
                    ApplicationArea = all;
                    RunObject = page "Employee Chargings Menu";
                }
                action("HR - Summaries of Monthly Payroll")
                {
                    ApplicationArea = all;
                    RunObject = page "Payroll Processed Entries";
                }
                action("HR - Severance")
                {
                    ApplicationArea = all;
                    RunObject = page "Employee Severance List";
                }
                //action("HR - Summaries of Severances & Unused Leaves")
                //{
                //    ApplicationArea = all;
                //    RunObject = page "Sum. Of Severance-Unused Leave";
                //}
                action("HR - Setup")
                {
                    ApplicationArea = all;
                    RunObject = page "MSI Payroll Setup";
                }
                action("HR - Base Calendar")
                {
                    ApplicationArea = all;
                    RunObject = page "Base Calendar List";
                }
                action("HR - Employee")
                {
                    ApplicationArea = all;
                    RunObject = page "Employee List";
                }
            }
            group("Finance Request")
            {
                action("Travel Advance")
                {
                    RunObject = page "Travel Advance List";
                    ApplicationArea = all;
                }
                action("Settlement Travel Advance")
                {
                    RunObject = page "Settlement Travel Adv. List";
                    ApplicationArea = all;
                }
                action("Project Advance")
                {
                    RunObject = page "Project Advance List";
                    ApplicationArea = all;
                }
                action("Settlement Project Advance")
                {
                    RunObject = page "Settlement Project Adv. List";
                    ApplicationArea = all;
                }
                action("General Advance")
                {
                    RunObject = page "General Advance List";
                    ApplicationArea = all;
                }
                action("Settlement General Advance")
                {
                    RunObject = page "Settlement General Adv. List";
                    ApplicationArea = all;
                }
                action("Travel Authorization")
                {
                    RunObject = page "Travel Authorization List";
                    ApplicationArea = all;
                }
                action("Reimbursement")
                {
                    RunObject = page "Reimbursement List";
                    ApplicationArea = all;
                }
                action("General Payment")
                {
                    RunObject = page "General Payment List";
                    ApplicationArea = all;
                }
            }
            group(Procurement)
            {
                action("Purchase Requisition")
                {
                    RunObject = page "Purchase Requisition List";
                    ApplicationArea = all;
                }
                action("Purchase Quotes")
                {
                    ApplicationArea = all;
                    RunObject = Page "Purchase Quotes";
                }
                action("Vendor Selection")
                {
                    RunObject = page "Vendor Selection List";
                    ApplicationArea = all;
                }
                action("Purchase Order")
                {
                    ApplicationArea = all;
                    RunObject = Page "Purchase Order List";
                }
                action("Purchase Credit Memo")
                {
                    ApplicationArea = all;
                    RunObject = Page "Purchase Credit Memos";
                }
                action(Vendors)
                {
                    ApplicationArea = all;
                    RunObject = Page "Vendor List";
                }
            }
        }
        area(Processing)
        {
            action("Document Management")
            {
                ApplicationArea = all;
                RunObject = page "File Document List";
            }
            action("Document Monitoring")
            {
                ApplicationArea = all;
                RunObject = page "Document Monitoring";
            }
            action("Request Monitoring")
            {
                RunObject = page "Request Monitoring";
                ApplicationArea = all;
            }
        }
    }

    var
        gVisible: Boolean;
}