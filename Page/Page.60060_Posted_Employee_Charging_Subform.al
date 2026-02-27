page 60060 "Posted Employee Charg. Subform"
{
    PageType = ListPart;
    //ApplicationArea = All;
    //UsageCategory = Documents;
    SourceTable = "Posted Employee Charging Line";
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                ShowCaption = false;
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                }
                field(FullName; FullName)
                {
                    Caption = 'Employee Name';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = all;
                }
                field(DimName; DimName)
                {
                    ApplicationArea = all;
                    Caption = 'Name';
                    Editable = false;
                }
                field("Global Dimension 7 Code"; Rec."Global Dimension 7 Code")
                {
                    ApplicationArea = all;
                    trigger
                    OnValidate()
                    begin
                        getDimName7();
                    end;
                }
                field(DimName7; DimName7)
                {
                    ApplicationArea = all;
                    Caption = 'Name';
                    Editable = false;
                }

                field(Percentage; Rec.Percentage)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    trigger
    OnAfterGetRecord()
    begin
        Clear(FullName);
        Clear(DimName);
        getFullName();
        getDimName();
        getDimName7();
    end;

    trigger
    OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(FullName);
        Clear(DimName);
    end;

    trigger
    OnDeleteRecord(): Boolean
    begin
        Clear(FullName);
        Clear(DimName);
        getFullName();
        getDimName();
        CurrPage.Update();
    end;

    procedure getFullName()
    begin
        if Employee.Get(Rec."Employee No.") then
            FullName := Employee.FullName()
        else
            FullName := '';
    end;

    procedure getDimName()
    begin
        DimVal.Reset();
        DimVal.SetRange("Global Dimension No.", 1);
        DimVal.SetRange(Code, Rec."Global Dimension 1 Code");
        if DimVal.FindFirst() then
            DimName := DimVal.Name
        else
            DimName := '';
    end;

    procedure getDimName7()
    begin
        DimVal.Reset();
        DimVal.SetRange("Global Dimension No.", 7);
        DimVal.SetRange(Code, Rec."Global Dimension 7 Code");

        if DimVal.FindFirst() then
            DimName7 := DimVal.Name
        else
            DimName7 := '';
    end;

    var
        Employee: Record Employee;
        DimVal: Record "Dimension Value";
        FullName: Text[100];
        DimName: Text;
        DimName7: Text;
}