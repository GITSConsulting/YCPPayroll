page 65021 "Master Point Status"
{
    Caption = 'Master Point Status';
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Master Point Status";
    // ApplicationArea = All;
    UsageCategory = Administration;
    // CardPageId = "Medical Value Card";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(MyGroup)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = all;
                }
                field(Status; rec.Status)
                {
                    ApplicationArea = all;
                }
                field(Kid; rec.Kid)
                {
                    ApplicationArea = all;
                }
                field(Point; rec.Point)
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
}