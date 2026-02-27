page 60008 "Employee Salary Components"
{
    PageType = ListPart;
    //ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Employee Salary Component";
    DelayedInsert = true;
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Line No."; Rec."Line No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                    visible = false;
                }
                field("Indirect Income"; Rec."Indirect Income")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Allowance Component Code"; Rec."Allowance Component Code")
                {
                    ApplicationArea = all;
                }
                field("Deduction Component Code"; Rec."Deduction Component Code")
                {
                    ApplicationArea = all;
                }
                field("Apply Allowance To Old"; Rec."Apply Allowance To Old")
                {
                    ApplicationArea = all;
                }
                field("Apply Deduction To Old"; Rec."Apply Deduction To Old")
                {
                    ApplicationArea = all;
                }
                field("Allowance Component Name"; Rec."Allowance Component Name")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Deduction Component Name"; Rec."Deduction Component Name")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Copy this setup")
            {
                ApplicationArea = all;
                trigger
                OnAction()
                var
                    EmployeeSalaryComponent: Record "Employee Salary Component";
                    EmployeeListCopy: Page "Employee List Copy Components";
                    EmployeeTanpaYangDicopy: Record Employee;
                begin
                    Rec.FindSet();

                    EmployeeTanpaYangDicopy.Reset();
                    EmployeeTanpaYangDicopy.SetFilter("No.", '<>%1', Rec."Employee No.");
                    EmployeeTanpaYangDicopy.FindSet();

                    EmployeeListCopy.GetEmployeeNo(Rec."Employee No.");
                    EmployeeListCopy.SetTableView(EmployeeTanpaYangDicopy);
                    EmployeeListCopy.Run();
                end;
            }
        }
    }

    trigger
    OnAfterGetRecord()
    begin
        Rec.SetCurrentKey("Line No.", "Indirect Income");
    end;
}