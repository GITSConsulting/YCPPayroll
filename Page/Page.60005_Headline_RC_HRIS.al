page 60005 "Headline RC HRIS"
{
    PageType = HeadlinePart;
    //ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Headline RC HRIS";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            group(Control2)
            {
                field(GreetingText; GreetingText)
                {
                    ApplicationArea = all;
                }
            }
            group(Control4)
            {
                field(DocumentationText; DocumentationText)
                {
                    ApplicationArea = all;
                }

            }
        }
    }


    var
        GreetingText: Text[250];
        DocumentationText: Text[250];
        //HeadlineManagement: Codeunit "Headline Management";
        DefaultFieldsVisible: Boolean;
        UserGreetingVisible: Boolean;

    trigger OnOpenPage();
    var
        Uninitialized: Boolean;
    begin

        if not Rec.Get() then
            if Rec.WritePermission() then begin
                Rec.Init();
                Rec.Insert();
            end else
                Uninitialized := true;

        if not Uninitialized and Rec.WritePermission() then begin
            Rec."Workdate for computations" := WorkDate();
            Rec.Modify();
            //HeadlineManagement.ScheduleTask(Codeunit::"Headline RC HRIS");
        end;

        //HeadlineManagement.GetUserGreetingText(GreetingText);
        DocumentationText := StrSubstNo(DocumentationText, ProductName.Short());

        if Uninitialized then
            ComputeDefaultFieldsVisibility();
        Commit();
    end;

    local procedure ComputeDefaultFieldsVisibility()
    var
        ExtensionHeadlinesVisible: Boolean;
    begin
        OnIsAnyExtensionHeadlineVisible(ExtensionHeadlinesVisible);
        DefaultFieldsVisible := not ExtensionHeadlinesVisible;
        //UserGreetingVisible := HeadlineManagement.ShouldUserGreetingBeVisible();
    end;

    [IntegrationEvent(false, false)]
    local procedure OnIsAnyExtensionHeadlineVisible(var ExtensionHeadlinesVisible: Boolean)
    begin
    end;
}