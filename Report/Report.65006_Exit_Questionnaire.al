report 65006 "Exit Questionnaire"
{
    UsageCategory = ReportsAndAnalysis;
    // ApplicationArea = All;
    RDLCLayout = './Report/Report.65006_Exit_Questionnaire.rdlc';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem(Employee; Employee)
        {
            column(LogoCompany; CompanyInformation.Picture) { }
            column(No_; "No.") { }
            column(First_Name; "First Name") { }
            column(Last_Name; "Last Name") { }
            column(Job_Title; "Job Title") { }
            column(Office_Location_Code; "Office Location Code") { }
            column(Employment_Date; "Employment Date") { }
            column(ID_No_; "ID No.") { }
            column(Division_Code; "Division Code") { }
            column(d_EffectiveDate; d_EffectiveDate) { }
            column(Supervisor_ID; "Supervisor ID") { }
            column(t_NameSupervisor; t_NameSupervisor) { }
            dataitem("Employee Salary Component"; "Employee Salary Component")
            {
                DataItemLink = "Employee No." = field("No.");
                column(Employee_No_; "Employee No.") { }
                column(Allowance_Component_Name; "Allowance Component Name") { }
            }
            trigger OnAfterGetRecord()
            var
                rec_PositionLedger: Record "Position Ledger Entry";
                rec_userSetup: Record Employee;
            begin
                // get tanggal join
                rec_PositionLedger.SetRange("Employee No.", "No.");
                if rec_PositionLedger.FindFirst() then
                    d_EffectiveDate := rec_PositionLedger."Contract Start Date";
                //get name employee supervisor
                rec_userSetup.SetRange("User ID", "Supervisor ID");
                if rec_userSetup.FindFirst() then
                    t_NameSupervisor := rec_userSetup.FullName();
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Filter")
                {
                    // field(Tanggal; Tanggal)
                    // {
                    //     ApplicationArea = All;
                    //     Caption = 'Posting Date';
                    // }
                }
            }
        }
    }

    var
        Tanggal: Date;
        CompanyInformation: Record "Company Information";
        TotalGaji: Decimal;
        d_EffectiveDate: date;
        t_NameSupervisor: Text;

    trigger
    OnPreReport()
    begin
        CompanyInformation.CalcFields(Picture);
    end;

}