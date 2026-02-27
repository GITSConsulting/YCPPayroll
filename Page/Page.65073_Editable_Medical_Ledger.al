page 65073 "MR Ledger Entries Editable"
{
    caption = 'Medical Reimbursement Ledger Entries';
    PageType = List;
    // ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Medical Reim Ledger Entries";
    // InsertAllowed = false;
    // DeleteAllowed = false;
    // ModifyAllowed = false;
    // Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry Type"; rec."Entry Type")
                {
                    ApplicationArea = all;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                }
                field("Medical Value"; rec."Medical Value")
                {
                    ApplicationArea = all;
                }
                field("Medical Type"; rec."Medical Type")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = all;
                }
                field("Day Balance"; Rec."Quantity 2")
                {
                    ApplicationArea = all;
                }
                field("Daily rate - room"; rec."Daily rate - room")
                {
                    ApplicationArea = all;
                }
                field("Request Approval Date"; Rec."Request Approval Date")
                {
                    ApplicationArea = all;
                }
                field("Request Expired Date"; Rec."Request Expired Date")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field(Amount; rec.Amount)
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
            action("Edit Field dari Quantity ke Quantity 2")
            {
                ApplicationArea = all;
                Image = Add;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = visiblenya;
                trigger OnAction()
                var
                    MedicalLedger: Record "Medical Reim Ledger Entries";
                    MedicalLine: Record "Medical Reimbursement Line";
                    MedicalLinePosted: Record "Posted MR Line";
                    MedicalValuesPosted: Record "Medical Values";
                begin
                    MedicalLedger.Reset();
                    if MedicalLedger.FindFirst() then
                        repeat
                            MedicalLedger."Quantity 2" := MedicalLedger.Day;
                            MedicalLedger.Modify();
                        until MedicalLedger.Next() = 0;

                    MedicalLinePosted.Reset();
                    if MedicalLinePosted.FindFirst() then
                        repeat
                            MedicalLinePosted."Quantity 2" := MedicalLinePosted.Day;
                            MedicalLinePosted.Modify();
                        until MedicalLinePosted.Next() = 0;

                    if MedicalValuesPosted.FindFirst() then
                        repeat
                            MedicalValuesPosted."Quantity 2" := MedicalValuesPosted.Quantity;
                            MedicalValuesPosted.Modify();
                        until MedicalValuesPosted.Next() = 0;
                end;
            }
            action("Delete All Attendance")
            {
                ApplicationArea = all;
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = visiblenya;
                trigger OnAction()
                var
                    attendance: Record "Employee Attendance Header";
                    attendanceLine: Record "Employee Absence Line";
                begin

                    if attendance.FindFirst() then
                        repeat
                            attendanceLine.Reset();
                            attendanceLine.SetRange("Document No.", attendance."No.");
                            if attendanceLine.FindFirst() then
                                attendanceLine.DeleteAll();

                            attendance.Delete();
                        until attendance.Next() = 0;

                    Message('Delete Success');
                end;
            }
        }
    }
    var
        frz_CodeUnit: Codeunit "User Setup Custome";
        visiblenya: Boolean;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        visiblenya := frz_CodeUnit.AttendanceAdminCheck(UserId);
    end;
}