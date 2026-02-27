page 65074 "Shift Schedules Helper"
{
    PageType = List;
    Caption = 'Shift Office Helper';
    // ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Shift Schedules";
    SourceTableView = where("Type Shift" = const("Shift Office Helper"));
    RefreshOnActivate = true;
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Week"; rec."Effective Date")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        frz_CodeUnitMonth: Codeunit "Month Picker";
                        frz_ShiftSchedule: Record "Shift Schedules";
                    begin

                        rec.Year := Date2DMY(rec."Effective Date", 3);
                        rec.Month := frz_CodeUnitMonth.getNameMonth(Date2DMY(rec."Effective Date", 2));
                        CurrPage.Update();
                    end;
                }
                field("Employee No."; rec."Employee No.")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        frz_CU_CheckUserID: Codeunit "Check UserID";
                        Employeenya: Record Employee;
                    begin
                        frz_CU_CheckUserID.CheckUserIDnya(rec."Employee No.");
                        Employeenya.Reset();
                        Employeenya.SetRange("No.", rec."Employee No.");
                        Employeenya.SetRange("MSI_HRIS Type Shift", Employeenya."MSI_HRIS Type Shift"::"Shift Office Helper");
                        if not Employeenya.FindFirst then
                            Error('This employee set type shift not equal to %1', format(Employeenya."MSI_HRIS Type Shift"::"Shift Office Helper"));
                        CurrPage.Update();
                    end;
                }
                field(Month; rec.Month)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Year; rec.Year)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Shift-1"; rec."Base Calendar Shift-1")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Shift-2"; rec."Base Calendar Shift-2")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Working Start"; rec."Working Start")
                {
                    ApplicationArea = all;
                }
                field("Working Out"; rec."Working Out")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        frz_CodeUnit: Codeunit "User Setup Custome";
    begin
        if frz_CodeUnit.AttendanceAdminCheck(UserId) = false then
            frz_CodeUnit.ModuleNotReady();
    end;

    trigger OnInsertRecord(boleean: Boolean): Boolean
    begin
        Rec."Type Shift" := rec."Type Shift"::"Shift Office Helper";
    end;
}