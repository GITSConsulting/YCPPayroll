pageextension 65006 "Reimbursement List Ext" extends "Reimbursement List"
{
    layout
    {
    }

    trigger OnOpenPage()
    var
        _Employee: Record Employee;
    begin
        _Employee.SetRange("User ID", UserId);
        if _Employee.FindFirst() then
            if _Employee."Employee Type" = _Employee."Employee Type"::Staff then
                Error('You do not have permission to open this page');
    end;
}