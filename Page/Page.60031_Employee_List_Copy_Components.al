page 60031 "Employee List Copy Components"
{

    PageType = List;
    //ApplicationArea = All;
    SourceTable = Employee;
    UsageCategory = Lists;
    Caption = 'Copy Components';
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;

                }
                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = all;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Proceed copy setup to selected")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Copy;
                ApplicationArea = all;

                trigger OnAction();
                var
                    SourceEmployeeSalaryComponent: Record "Employee Salary Component";
                    TargetEmployeeSalaryComponent: Record "Employee Salary Component";
                    EmployeeSource: Record Employee;
                begin
                    EmployeeSource.Get(NomorEmployee);

                    CurrPage.SetSelectionFilter(EmployeeSelected);
                    EmployeeSelected.FindFirst();
                    repeat
                        SourceEmployeeSalaryComponent.Reset();
                        SourceEmployeeSalaryComponent.SetRange("Employee No.", NomorEmployee);
                        SourceEmployeeSalaryComponent.FindSet();
                        repeat
                            TargetEmployeeSalaryComponent.Init();
                            TargetEmployeeSalaryComponent.TransferFields(SourceEmployeeSalaryComponent);
                            TargetEmployeeSalaryComponent."Employee No." := EmployeeSelected."No.";
                            TargetEmployeeSalaryComponent.Insert(true);
                        until SourceEmployeeSalaryComponent.next = 0;
                    until EmployeeSelected.next = 0;

                    Message('Salary component setup from %1 is successfully copied to %2 employee(s).',
                            EmployeeSource.FullName(), EmployeeSelected.Count());

                    CurrPage.Close();
                end;
            }
        }
    }

    var
        NomorEmployee: Code[20];
        EmployeeSelected: Record Employee;

    procedure GetEmployeeNo(EmployeeNo: Code[20])
    begin
        NomorEmployee := EmployeeNo;
    end;
}