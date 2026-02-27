tableextension 60002 Ext_ManufacturingCue extends "Manufacturing Cue"
{
    fields
    {
        field(60001; "User ID Filter DRE"; Code[50])
        {
            FieldClass = FlowFilter;
        }
        field(60002; "CTO Request"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("CTO Request Header" WHERE(Status = const("Pending Approval"),
                                                           "Approver ID" = FIELD("User ID Filter DRE")));
        }
        field(60003; "CTO Realization"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("CTO Realization Header" WHERE(Status = const("Pending Approval"),
                                                           "Approver ID" = FIELD("User ID Filter DRE")));
        }
        field(60004; "Annual Leave"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Leave Request" WHERE("Leave Type" = const(Paid),
                                                      Status = const("Pending Approval"),
                                                      "Approver ID" = FIELD("User ID Filter DRE")));
        }
        field(60005; "Medical Reimbursement"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Medical Reimbursement Header" WHERE(Status = const("Pending Approval"),
                                                      "Approver ID" = FIELD("User ID Filter DRE")));
        }
        field(60006; "Unpaid Leave"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Leave Request" WHERE("Leave Type" = const(Unpaid),
                                                      Status = const("Pending Approval"),
                                                      "Approver ID" = FIELD("User ID Filter DRE")));
        }
        field(60007; "Other Attendance"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Leave Request" WHERE("Leave Type" = const("Other Attendance"),
                                                      Status = const("Pending Approval"),
                                                      "Approver ID" = FIELD("User ID Filter DRE")));
        }
        field(60008; "Unconditional Leave"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Unconditional Leave Request" where(Status = const("Pending Approval"),
            "Approver ID" = field("User ID Filter DRE")));
        }
    }
}