page 65006 "Medical Value"
{
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Medical Type Value";
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;

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
                field("Status Point Code"; rec."Status Point Code")
                {
                    Visible = munculStatus;
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        rec_MasterStatus: Record "Master Point Status";
                        e_Level: Enum "Marital Status";
                        t_statusText: Text;
                        t_IntText: Text;
                        t_LevelName: Text;
                        i_index: Integer;
                        i_OrdinalValue: Integer;
                    begin
                        rec_MasterStatus.SetRange(Code, rec."Status Point Code");
                        if rec_MasterStatus.FindFirst() then begin
                            Rec.Poin := rec_MasterStatus.Point;
                            e_Level := rec_MasterStatus.Status;

                            i_OrdinalValue := e_Level.AsInteger();  // Ordinal value = 30
                            i_index := e_Level.Ordinals.indexOf(i_OrdinalValue);  // i_index = 3
                            t_LevelName := e_Level.Names.Get(i_index); // Name = Gold

                            t_IntText := Format(rec_MasterStatus.Kid);
                            rec.Description := t_LevelName + ' - ' + t_IntText + ' Childs';
                            CurrPage.Update();
                        end;
                    end;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = all;
                }
                field(Poin; rec.Poin)
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        NotOutpatien();
                        CurrPage.Update();
                    end;
                }
                field(Amount; rec.Amount)
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        if Rec.Poin = 0 then
                            Rec."Total Amount" := Rec.Amount
                        else
                            Rec."Total Amount" := Rec.Amount * Rec.Poin;
                        CurrPage.Update();
                        CurrPage.SaveRecord();
                    end;
                }
                field("Total Amount"; rec."Total Amount")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Amount Adjustments"; rec."Amount Adjustments")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        recHeader: Record "Medical Type";
                    begin
                        recHeader.SetRange(Code, rec."Medical Type");
                        recHeader.FindFirst();
                        if recHeader.outpatient = false then begin
                            Error('Poin field required Outpation = "True" for fill this field');
                        end else begin
                            if Rec.Poin = 0 then
                                Rec."Total Amount Adjustments" := Rec."Amount Adjustments"
                            else
                                Rec."Total Amount Adjustments" := Rec."Amount Adjustments" * Rec.Poin;
                        end;
                        CurrPage.Update();
                    end;
                }
                field("Total Amount Adjustments"; rec."Total Amount Adjustments")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Note; rec.Note)
                {
                    ApplicationArea = all;
                }
                field("Status Update"; rec."Status Update")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        rec_Header: Record "Medical Type";
    begin
        muncul := true;
        rec_Header.SetRange(Code, rec."Medical Type");
        if rec_Header.FindFirst() then
            if rec_Header.outpatient = true then
                munculStatus := true else
                munculStatus := false;
    end;

    procedure NotOutpatien()
    var
        recHeader: Record "Medical Type";
    begin
        recHeader.SetRange(Code, rec."Medical Type");
        recHeader.FindFirst();
        if recHeader.outpatient = false then
            if (Rec.Poin > 0) OR (Rec.Poin < 0) then
                Error('Poin field required Outpation = "True" for fill this field');
    end;

    var
        muncul: Boolean;
        dimen: Record "Dimension Value";
        munculStatus: Boolean;
}