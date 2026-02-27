page 65025 "Shift Schedules"
{
    PageType = List;
    Caption = 'Shift Guard';
    // ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Shift Schedules";
    SourceTableView = where("Type Shift" = const("Shift Guard"));
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
                field("Effective Date"; rec."Effective Date")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        frz_CodeUnitMonth: Codeunit "Month Picker";
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
                        frz_ShiftSchedule: Record "Shift Schedules";
                        frz_CU_CheckUserID: Codeunit "Check UserID";
                        Employeenya: Record Employee;
                        frz_CodeUnitMonth: Codeunit "Month Picker";
                    begin
                        frz_CU_CheckUserID.CheckUserIDnya(rec."Employee No.");
                        rec.TestField("Effective Date");

                        frz_ShiftSchedule.Reset();
                        frz_ShiftSchedule.SetRange("Type Shift", rec."Type Shift"::"Shift Guard");
                        frz_ShiftSchedule.SetFilter("Entry No.", '<> %1', rec."Entry No.");
                        if frz_ShiftSchedule.FindFirst() then
                            repeat
                                if (rec."Employee No." = frz_ShiftSchedule."Employee No.") and (Date2DMY(rec."Effective Date", 3) = frz_ShiftSchedule.Year)
                                and (frz_CodeUnitMonth.getNameMonth(Date2DMY(rec."Effective Date", 2)) = frz_ShiftSchedule.Month) then
                                    Error('Same line already exist');
                            until frz_ShiftSchedule.Next = 0;

                        Employeenya.Reset();
                        Employeenya.SetRange("No.", rec."Employee No.");
                        Employeenya.SetRange("MSI_HRIS Type Shift", Employeenya."MSI_HRIS Type Shift"::"Shift Guard");
                        if not Employeenya.FindFirst then
                            Error('This employee set type shift not equal to %1', format(Employeenya."MSI_HRIS Type Shift"::"Shift Guard"));
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
                    Caption = 'Shift Sore';
                }
                field("Shift-2"; rec."Base Calendar Shift-2")
                {
                    ApplicationArea = all;
                    Caption = 'Shift Malam';
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
        Rec."Type Shift" := rec."Type Shift"::"Shift Guard";
    end;
}