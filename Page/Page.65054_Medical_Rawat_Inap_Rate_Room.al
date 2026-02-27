page 65054 "Medical Rawat Inap Room"
{
    Caption = 'Daily - Rate Room';
    PageType = ListPart;
    UsageCategory = Lists;
    SourceTable = "Medical Values";
    SourceTableView = where("Medical Type" = const("Rawat Inap"), "Daily rate - room" = const(true));
    DataCaptionFields = Code;
    InsertAllowed = false;
    ModifyAllowed = true;
    DeleteAllowed = false;
    // Editable = false;
    RefreshOnActivate = true;
    //DelayedInsert = true;
    //AutoSplitKey = true;

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
                    trigger OnValidate()
                    begin
                        if frz_Plafonnya > 0 then
                            rec.Plafon := frz_Plafonnya;
                        CurrPage.Update();
                    end;
                }
                field("Daily rate - room"; rec."Daily rate - room")
                {
                    ApplicationArea = All;
                    Editable = false;
                    trigger OnValidate()
                    var
                        frz_MedicalValues: Record "Medical Values";
                    begin
                        frz_MedicalValues.Reset();
                        frz_MedicalValues.SetRange("Medical Type", frz_MedicalValues."Medical Type"::"Rawat Inap");
                        frz_MedicalValues.SetRange("Daily rate - room", true);
                        frz_MedicalValues.SetFilter(Code, '<> %1', Rec.Code);
                        if frz_MedicalValues.FindFirst() then begin
                            repeat
                                frz_MedicalValues."Daily rate - room" := false;
                                frz_MedicalValues.Modify();
                            until frz_MedicalValues.Next() = 0;
                        end;
                        CurrPage.Update();
                    end;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Percentage; rec.Percentage)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Plafon; rec.Plafon)
                {
                    ApplicationArea = All;
                }
                field(Quantity; rec."Quantity 2")
                {
                    Caption = 'Quantity Slot Days';
                    ApplicationArea = All;
                    Editable = Rec."Daily rate - room";
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Add New")
            {
                Image = Add;

                ApplicationArea = all;
                trigger OnAction()
                var
                    frz_MedicalValues: Record "Medical Values";
                begin
                    frz_MedicalValues.Init();
                    frz_MedicalValues.Code := 'Daily Rate - Room';
                    frz_MedicalValues."Daily rate - room" := true;
                    frz_MedicalValues.Description := 'Daily Rate - Room';
                    frz_MedicalValues."Medical Type" := frz_MedicalValues."Medical Type"::"Rawat Inap";
                    frz_MedicalValues.Insert();
                end;
            }
        }
    }
    var
        frz_Plafonnya: Decimal;

    trigger OnAfterGetRecord()
    var
        frz_medicalValues: Record "Medical Values";
    begin
        frz_Plafonnya := 0;
        frz_medicalValues.Reset();
        frz_medicalValues.SetRange("Medical Type", frz_medicalValues."Medical Type"::"Rawat Inap");
        frz_medicalValues.SetRange("Daily rate - room", false);
        if frz_medicalValues.FindFirst() then
            frz_Plafonnya := frz_medicalValues.Plafon;
    end;
}