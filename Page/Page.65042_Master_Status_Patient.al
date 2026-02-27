page 65042 "Master Status Patient"
{
    PageType = List;
    // ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Percentage Status Patient";
    DataCaptionFields = Code;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                ShowCaption = false;
                field(Code; rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Percentage; rec.Percentage)
                {
                    ApplicationArea = All;
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
}