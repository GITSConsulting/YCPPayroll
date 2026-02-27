page 60061 "Editable Employee Charg. Line"
{
    PageType = List;
    SourceTable = "Employee Charging Line";

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
                    trigger
                    OnValidate()
                    begin
                        getDimName();
                    end;
                }
                field(DimName; DimName)
                {
                    ApplicationArea = all;
                    Caption = 'Name';
                    Editable = false;
                }
                field(Percentage; Rec.Percentage)
                {
                    ApplicationArea = all;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                    BlankZero = true;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    trigger
    OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        Header: Record "Employee Charging Header";
        LineKosong: Record "Employee Charging Line";
        LineAda: Record "Employee Charging Line";
    begin
        Header.Get(Rec."Document No.");
        Rec."Posting Date" := Header."Posting Date";
    end;

    trigger
    OnAfterGetRecord()
    begin
        Clear(FullName);
        Clear(DimName);
        getFullName();
        getDimName();
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

    var
        Employee: Record Employee;
        DimVal: Record "Dimension Value";
        FullName: Text[100];
        DimName: Text;
}