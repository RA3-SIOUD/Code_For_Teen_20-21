Program strmanipulation;
Uses Wincrt,windos;
Var
  chaine,CpChaine,ch_to_insert,ch_num: String;
  position,atPosition,atDelete,nbCaracter,nb_supression: 1..256;
  x: Real;
	e:Integer;
Begin

(*
{*Longeur fn pure*}
WriteLn('longeure');
  Write('Entrez une chaine: ');
  Readln(chaine);
  Writeln('Votre chaine est de longeur: ',Length(chaine));
  Readkey;
{*Copier fn pure*}
WriteLn('copier');
  Position := 1;
  nbCaracter := 3;
  CpChaine := Copy(chaine,position,nbCaracter);
  Writeln('ch: ',chaine);
  Writeln('Copy: ',Cpchaine);
{*Insert pr side effect*}
	WriteLn('Insertion');
	WriteLn('La chaine avant l"insertion: ',chaine);
	Write('Donnez une chaine à inserer: ');Readln(ch_to_insert);
 	Write('Donnez la position de l"insertion: ');Readln(atPosition);
	Insert(ch_to_insert,chaine,atPosition);
	WriteLn('La chaine aprés l"insertion: ',chaine);
	ReadKey;

{*Delete pr side effect*}
	WriteLn('Supression');
	Writeln('La chaine avant la supression: ',chaine);
	Write('Donnez la position de la supression: ');Readln(atDelete);
	Write('Donnez le nombre de caractere à supprimer: ');Readln(nb_supression);
	Delete(chaine,atDelete,nb_supression);
	WriteLn(chaine);
	ReadKey;
	
{*str pr side effect*}
  x := 69.420;
  Writeln('x: ',x:2:3);
  Str(x,ch_num);
  Writeln('x aprés str: ',ch_num);
  Readkey;
	*)
	{*val rc side effect*}
	WriteLn('donnez une chaine numerique: ');Readln(ch_num);
	val(ch_num,x,e);
	writeln ('x apres val',x);
	ReadKey;
End.
