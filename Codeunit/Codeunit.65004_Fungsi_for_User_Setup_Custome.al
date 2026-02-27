codeunit 65004 "User Setup Custome"
{
    procedure AttendanceAdminCheck(UserNya: Code[50]): Boolean
    var
        frz_UserSetupCustome: Record "User Setup HRIS";
    begin
        frz_UserSetupCustome.SetRange("User ID", UserNya);
        if frz_UserSetupCustome.FindFirst() then
            exit(frz_UserSetupCustome."Admin Attendance");
    end;

    procedure CheckLocationCode(Usernya: Code[50]): Code[50]
    var
        frz_Employee: Record Employee;
    begin
        frz_Employee.SetRange("User ID", UserId);
        if frz_Employee.FindFirst() then
            exit(frz_Employee."Office Location Code");
    end;

    procedure GetEmployeeNo(Usernya: Code[50]): text
    var
        frz_employee: Record Employee;
        frz_employeeByAdmin: Record Employee;
        text_filter: Code[500];
        text_filteradmin: Code[500];
        text_allfilter: Code[500];
    begin
        frz_employee.Reset();
        frz_employee.SetRange("User ID", UserId);
        if frz_employee.FindFirst() then begin
            text_filter := frz_employee."No.";
        end;
        frz_employeeByAdmin.reset();
        frz_employeeByAdmin.SetRange("MSI_HRIS Admin By", UserId);
        if frz_employeeByAdmin.FindFirst() then begin
            repeat
                text_filteradmin += '|' + frz_employeeByAdmin."No.";
            until frz_employeeByAdmin.Next() = 0;
        end;
        text_allfilter := text_filter + text_filteradmin;
        exit(text_allfilter);
    end;

    procedure ModuleNotReady()
    var
        frz_payrollGenSetup: Record "Payroll General Setup";
    begin
        frz_payrollGenSetup.Reset();
        if frz_payrollGenSetup.FindFirst() then
            if frz_payrollGenSetup.Live = false then
                Error('Module not ready');
    end;

}