page 60075 "CTO Realization List"
{
    PageType = List;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "CTO Realization Header";
    CardPageId = "CTO Realization";
    Editable = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field(NamaEmployee; Rec.NamaEmployee(Rec."Employee No."))
                {
                    Caption = 'Employee Name';
                    ApplicationArea = all;
                }
                field("Posting Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = all;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = all;
                }
                field("Total Number of Days"; Rec."Total Number of Days")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field("Approver ID"; Rec."Approver ID")
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
            rec.SetFilter("Employee No.", frz_CodeUnit.GetEmployeeNo(UserId));
    end;
}