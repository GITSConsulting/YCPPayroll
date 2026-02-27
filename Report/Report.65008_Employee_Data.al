report 65008 "Employee Data"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './Report/Report.65008_Employee_Data.rdlc';
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
            column(Division_Code; divisionName) { }
            column(d_EffectiveDate; d_EffectiveDate) { }
            column(Birth_Date; "Birth Date") { }
            column(Gender; Gender) { }
            column(Status; Status) { }
            column(MSI_HRIS_Marital_Status; "MSI_HRIS Marital Status") { }
            column(Address; Address + ' ' + "Address 2") { }
            column(Phone_No_; "Phone No." + t_PhoneMobile) { }
            column(Phone_No_1; "Phone No.") { }
            column(Mobile_Phone_No_; "Mobile Phone No.") { }
            column(MSI_HRIS_Bank_Code_1; "MSI_HRIS Bank Code 1") { }
            column(Nomor_Rekening_Bank; "Nomor Rekening Bank") { }
            column(Nama_Pemilik_Rekening; "Nama Pemilik Rekening") { }
            column(MSI_HRIS_NPWP_No_; "MSI_HRIS NPWP No.") { }
            column(Bank_Branch_No_; "Bank Branch No.") { }
            column(E_Mail; "E-Mail") { }
            column(t_NameBank; t_NameBank) { }
            dataitem("Employee Salary Component"; "Employee Salary Component")
            {
                DataItemLink = "Employee No." = field("No.");
                column(Employee_No_; "Employee No.") { }
                column(Allowance_Component_Name; "Allowance Component Name") { }
            }
            trigger OnAfterGetRecord()
            var
                rec_PositionLedger: Record "Position Ledger Entry";
                rec_BankAccount: Record "Bank Account";
                DimensionValue_2: Record "Dimension Value";
                PayrollGeneralSetup: Record "Payroll General Setup";
            begin
                // get department
                PayrollGeneralSetup.Get();
                DimensionValue_2.Reset();
                DimensionValue_2.SetRange(Code, "MSI_HRIS Department");
                DimensionValue_2.SetRange("Dimension Code", PayrollGeneralSetup.Department);
                if DimensionValue_2.FindFirst() then
                    divisionName := DimensionValue_2.Name;

                // get contract date
                rec_PositionLedger.Reset();
                rec_PositionLedger.SetRange("Employee No.", "No.");
                if rec_PositionLedger.FindFirst() then
                    d_EffectiveDate := rec_PositionLedger."Contract Start Date";

                t_PhoneMobile := ' / ' + "Mobile Phone No.";

                // get bank account
                rec_BankAccount.Reset();
                rec_BankAccount.SetRange("No.", "MSI_HRIS Bank Code 1");
                if rec_BankAccount.FindFirst() then begin
                    t_NameBank := rec_BankAccount.Name + ' ' + rec_BankAccount."Name 2";
                end;
            end;
        }
    }
    var
        Tanggal: Date;
        CompanyInformation: Record "Company Information";
        TotalGaji: Decimal;
        d_EffectiveDate: Date;
        t_PhoneMobile: Text;
        t_NameBank: Text;
        divisionName: Text;

    trigger OnPreReport()
    begin
        CompanyInformation.CalcFields(Picture);
    end;

}