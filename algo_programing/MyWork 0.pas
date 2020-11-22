Program StringTrim;
uses WinCrt;
var
str1,str2,str_trim:String;
function fnTrim(vstring:string):string;
var
tmpString:string; 
i:integer;
isSpace:Boolean;
begin 
    tmpString:='';
    isSpace:=false;
    if vString[1]=#32 Then
        isSpace:=true;
    for i:= 1 to length(vstring) do
    begin
    if (vString[i]<>#32) Then    
    Begin 
    	tmpstring:=tmpString+vString[i];
    	isSpace:=false;
    End;
    if (vString[i]=#32)  and (isSpace=false)then 
    begin 
    	tmpString:=tmpString+vString[i];
    	isSpace:=true;
    End;
    fnTrim:=tmpString;
End;
end;

{********Main Program*****s****}
begin 
str1:='      Ali   va       a l''ecole   .   Le temps fait    beau     .';
str2:='Ali   va       a l''ecole   .   Le temps fait    beau     .';
writeln('str1:',str1);
writeln('str1 trimmed:',fnTrim(str1));
writeln('str2:',str2);
writeln('str2 trimmed:',fnTrim(str2));
End.