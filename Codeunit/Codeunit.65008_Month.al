codeunit 65008 "Month Picker"
{
    procedure getNameMonth(NoBulan: Integer): Text
    var
        frz_Month: Text;
    begin
        case NoBulan of
            1:
                exit('January');
            2:
                exit('February');
            3:
                exit('March');
            4:
                exit('April');
            5:
                exit('May');
            6:
                exit('June');
            7:
                exit('July');
            8:
                exit('August');
            9:
                exit('September');
            10:
                exit('October');
            11:
                exit('November');
            12:
                exit('December');
        end;
    end;
}