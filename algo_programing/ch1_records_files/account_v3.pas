Program Accounting;
Uses Wincrt,Crt,dos;
Type
  TCompte = Record
    Code : Integer;
    Libelle : String[50];
  End;
  TDate = Record
    Day : 1..31;
    Month : 1..12;
    Year : 1971..9999;
  End;
  TEcriture = Record
    CRCompte,DBCompte : Integer;
    DateEcriture : TDate;
    Folio : Word;
    LibelleEcriture : String[255];
    MntDebit,MntCredit : Real;
  End;
  TPlanComptable = Array [1..1000] Of TCompte;
  TJournal = Array [1..5000] Of TEcriture;
  TFPLan = File Of TCompte;
  TFJournal = File Of TEcriture;
Var
  Choix : 1..2;
  FP: TFPlan;
  FJournal: TFJournal;
  Exit: Boolean;
  Res: Char;
  extrait: Text;
 (* fnFormatString this functon format a string with a givin size*)

Function fnFormatString(vStr:String;strln:Integer): String;
Var
  extentionStr: String;
  i: 1..255;
Begin
  If Length(vStr) >= strln Then
    fnFormatString := Copy(vStr,1,strln)
  Else
    extentionStr := '';
  For i:=Length(vStr) To strln Do
    Begin
      extentionStr := extentionStr+' ';
    End;
  fnFormatString := Copy(vStr,1,strln)+extentionStr;
End;
 (* fnDateToString this functon format a TDate record to string*)

Function fnDateToString(dt:TDate): String;
Var
  day,month,year: String;
Begin
  Str(dt.Day,day);
  Str(dt.Month,month);
  Str(dt.Year,year);
  fnDateToString := Concat(day,'/',month,'/',year);
End;
(* =========       Gestion Plan Comptable    ==================*)

Procedure prGestionPC(Var FP:TFPlan);
 (* ------------------------------------------- prSaisieCompte ------------------------------*)

Procedure prSaisieCompte(Var FP:TFPlan);
Var
  TmpCompte,tmp: TCompte;
  Rep: Char;
Begin
  Clrscr;
  Gotoxy(20,4);
  Writeln('Code      :');
  Gotoxy(20,6);
  Writeln('Libele    :');
  Gotoxy(40,4);
  Readln(TmpCompte.Code);
  Gotoxy(40,6);
  Readln(TmpCompte.Libelle);
  Repeat
    Gotoxy(23,10);
    Write('Voullez vous enregistrer ce compte (O/N)');
    Read(Rep);
  Until (Upcase(Rep) In ['O','N']);
  If Upcase(Rep)='O' Then
    Begin
 {$I-}
      Reset(FP);
 {$I+}
      If Ioresult<>0 Then Rewrite(FP);
      While Not Eof(FP) Do
        read(FP,tmp);
(* Atteindre fin de Fichier *)

(*
				   you can replace the line above With
					 seek(FP,FileSize(FP));
					 Or
					 SeekEof(FP);
				*)
      Write(FP,TmpCompte);
    End;
  Close(FP);
End;
Procedure prAfficherComptes(Var FP:TFPlan);
Var
  TmpCompte: TCompte;
  cde: String;
Begin
  Clrscr;
  Gotoxy(32,1);
  Writeln('PLAN COMTABLE');
  Writeln('===============================================================================');
  Writeln('=      Code Compte          |              Libelle Compte                     =');
  Writeln('===============================================================================');
 {$I-}
  Reset(FP);
 {$I+}
  If Ioresult=0 Then
    Begin
      While Not Eof(FP) Do
        Begin
          Read(FP,TmpCompte);
          Str(TmpCompte.Code,cde);
          Writeln('| ',fnFormatString(cde,24),' | ',fnFormatString(TmpCompte.Libelle,47),'|');
          Writeln('-------------------------------------------------------------------------------')
          ;
        End;
    End
  Else Writeln('Probleme Fichier : ', Ioresult);
  Close(FP);
End;
 (* ------------------------------------------- prMAJCompte ------------------------------*)

Procedure prMAJCompte(Var FP:TFPlan);
Var
  bufferComptes: TPlanComptable;
  tmp: TCompte;
  code: Integer;
  indice: 0..1000;
  nbComptes: 0..1000;
  oldLibelle,newLibelle: String[50];
  accountExist: Boolean;
Begin
  Clrscr;
  Gotoxy(32,4);
  Write('MISE A JOURS COMPTE');
  Gotoxy(20,6);
  Write('Code      :');
  Readln(code);
 {$I-}
  Reset(FP);
 {$I+}
  If Ioresult=0 Then
    Begin
      indice := 0;
      nbComptes := 0;
      While Not Eof(FP) Do
        Begin
          indice := indice+1;
          Read(FP,tmp);
          bufferComptes[indice] := tmp;
        End;
      nbComptes := indice;
      indice := 0;
      accountExist := False;
      While indice<nbComptes Do
        Begin
          indice := indice+1;
          If bufferComptes[indice].code=code
            Then
            Begin
              oldLibelle := bufferComptes[indice].libelle;
              accountExist := True;
            End;
        End;
      If accountExist=True Then
        Begin
          Gotoxy(20,8);
          Write('Ancienne Libelle    :',oldLibelle);
          Gotoxy(20,10);
          Write('Nouvelle Libelle    :');
          Read(newLibelle);
          indice := 0;
          While indice<nbComptes Do
            Begin
              indice := indice+1;
              If (bufferComptes[indice].code=code) Then bufferComptes[indice].libelle := newLibelle;
            End;
          Rewrite(FP);
          For indice:=1 To nbComptes Do
            Write(FP,bufferComptes[indice]);
        End
      Else
        Begin
          Gotoxy(20,20);
          Writeln('Compte du code ',code, ' est introuvable.');
        End;
    End
  Else Writeln('Probleme Fichier : ', Ioresult);
  Close(FP);
End;
 (* ------------------------------------------- prSupprimerCompte ------------------------------*)

Procedure prSupprimerCompte(Var FP:TFPlan);
Var
  bufferComptes,newBuffer: TPlanComptable;
  tmp: TCompte;
  code: Integer;
  indice,i: 0..1000;
  nbComptes: 0..1000;
  accountExist: Boolean;
Begin
  Clrscr;
  Gotoxy(32,4);
  Write('SUPPRESSION COMPTE');
  Gotoxy(20,6);
  Write('Code      :');
  Readln(code);
 {$I-}
  Reset(FP);
 {$I+}
  If Ioresult=0 Then
    Begin
      indice := 0;
      nbComptes := 0;
      While Not Eof(FP) Do
        Begin
          indice := indice+1;
          Read(FP,tmp);
          bufferComptes[indice] := tmp;
        End;
      nbComptes := indice;
      accountExist := False;
      i := 1;
      For indice:=1 To nbComptes Do
        Begin
          If bufferComptes[indice].code<>code
            Then
            Begin
              newBuffer[i] := bufferComptes[indice];
              i := i+1;
            End
          Else
            accountExist := True;
        End;
      If accountExist=True Then
        Begin
          Gotoxy(20,8);
          Write('Compte ',code, ' est supprimer.');
          Rewrite(FP);
          For indice:=1 To i-1
            Do
            Write(FP,newBuffer[indice]);
        End
      Else
        Begin
          Gotoxy(20,20);
          Writeln('Compte du code ',code, ' est introuvable.');
        End;
    End
  Else Writeln('Probleme Fichier : ', Ioresult);
  Close(FP);
End;
Var
  ChMenu: 1..5;
  quit: Boolean;
Begin
  Clrscr;
  Gotoxy(30,2);
  Writeln('Gestion plan comptable');
  Gotoxy(20,6);
  Writeln('1 : Ajoutez des comptes.');
  Gotoxy(20,8);
  Writeln('2 : Affichez la liste des comptes.');
  Gotoxy(20,10);
  Writeln('3 : Mettre a jour un compte.');
  Gotoxy(20,12);
  Writeln('4 : Supprimez un compte.');
  Gotoxy(20,14);
  Writeln('5 : Retour Menu Principal');
  Gotoxy(15,25);
  Write('Votre Choix:');
  Repeat
    Readln(ChMenu);
  Until (ChMenu In [1..5]);
  Case ChMenu Of
    1: prSaisieCompte(FP);
    2: prAfficherComptes(FP);
    3: prMAJCompte(FP);
    4: prSupprimerCompte(FP);
    5: quit := True;
  End;
End;
(* ============   Gestion Journal    ====================*)

Procedure prGestionJournal(Var FJournal:TFJournal;Var FPlan:TFPLan);
 (* ------------------------------------------- prSaisiePiece ------------------------------*)

Function fnlookUpForAccount(code:Integer;Var FPlan:TFPLan): String;
Var
  tmpCompte: TCompte;
  compteExiste: Boolean;
Begin
 {$I-}
  Reset(FPlan);
 {$I+}
  If Ioresult = 0 Then
    Begin
      compteExiste := False;
      While Not Eof(FPlan) Do
        Begin
          Read(Fplan,tmpCompte);
          If (tmpCompte.Code = code) Then
            Begin
              fnLookUpForAccount := tmpCompte.Libelle;
              compteExiste := True;
            End
        End;
    End;
  If Not compteExiste Then
    fnLookUpForAccount := 'Compte n''existe pas. Veillez l''ajouter';
  Close(FPlan);
End;
 (* ------------------------------------------- prSaisiePiece ------------------------------*)

Procedure prSaisePiece(Var FJournal:TFJournal;Var FPlan:TFPLan);
Var
  tmpEcriture,tmp: TEcriture;
  Rep: Char;
Begin
  Clrscr;
  Gotoxy(10,2);
  Writeln('          S A I S I E    P I E C E  C O M P T A B L E            ');
  Gotoxy(10,4);
  Writeln('Date de la piece   : __/__/____');
  Gotoxy(10,5);
  Writeln('Libelle Ecriture   : ________________________________________________');
  Gotoxy(10,6);
  Writeln('Compte a Debiter   : ____');
  Gotoxy(10,7);
  Writeln('Montant a Debiter  : ___________');
  Gotoxy(10,8);
  Writeln('Compte a crediter  : ____');
  Gotoxy(10,9);
  Writeln('Montant a crediter : ___________');
  With tmpEcriture.DateEcriture Do
    Begin
      Gotoxy(31,4);
      Readln(Day);
      Gotoxy(34,4);
      Readln(Month);
      Gotoxy(37,4);
      Readln(Year);
    End;
  Gotoxy(31,5);
  Readln(tmpEcriture.LibelleEcriture);
  Gotoxy(31,6);
  Readln(tmpEcriture.DBCompte);
  Gotoxy(38,6);
  Write(fnlookUpForAccount(tmpEcriture.DBCompte,FPlan));
  Gotoxy(31,7);
  Readln(tmpEcriture.MntDebit);
  Gotoxy(31,8);
  Readln(tmpEcriture.CrCompte);
  Gotoxy(38,8);
  Write(fnlookUpForAccount(tmpEcriture.CrCompte,FPlan));
  Gotoxy(31,9);
  Readln(tmpEcriture.MntCredit);
  Repeat
    Gotoxy(23,25);
    Write('Voullez vous enregistrer cette piece (O/N) ');
    Read(Rep);
  Until (Upcase(Rep) In ['O','N']);
  If Upcase(Rep)='O' Then
    Begin
 {$I-}
      Reset(FJournal);
 {$I+}
      If Ioresult<>0 Then Rewrite(FJournal);
      While Not Eof(FJournal) Do
        read(FJournal,tmp);

(*
				   Atteindre fin de Fichier
				   you can replace the line above With
					 seek(FJournal,FileSize(FJournal));
					 Or
					 SeekEof(FJournal)
				*)
      Write(FJournal,TmpEcriture);
      Close(FJournal);
    End;
End;
 (* ------------------------------------------- prModifierPiece ------------------------------*)

Procedure prModifierPiece(Var FJournal:TFJournal;Var FPlan:TFPLan);
Begin
  Writeln('prModifierPiece not yet implemented');
End;
 (* ------------------------------------------- prListerPieces ------------------------------*)

Procedure prListerPiece(Var FJournal:TFJournal;Var FPlan:TFPLan);
Var
  tmpEcriture: TEcriture;
  currentFileSize: Longint;
  compteDebit,compteCredit: String;
Begin
  Clrscr;
 {$I-}
  Reset(FJournal);
 {$I+}
  If Ioresult=0 Then
    Begin
      currentFileSize := Filesize(FJournal);
      Gotoxy(10,2);
      Writeln('           J O U R N A L    C O M P T A B L E            ');
      Writeln('Taille de Fichier',currentFileSize);
      Writeln('===============================================================================');
      Writeln('| #  Date | Cpt Debit | CptCredit | Libelle                  | Debit   |Credit|');
      Writeln('===============================================================================');
      While Not Eof(FJournal) Do
        Begin
          Read(FJournal,tmpEcriture);
          With tmpEcriture Do
            Begin
              Write(Filepos(FJournal): 3, ' ');
              Write(fnFormatString(fnDateToString(DateEcriture),10));
              Writeln('            ',fnFormatString(LibelleEcriture,40));
              Str(DBCompte,compteDebit);
              Write('             ',fnFormatString(compteDebit,10));
              Write('           ');
              Write(fnFormatString(fnlookUpForAccount(DBCompte,FPlan),25));
              Writeln(MntDebit:10:3);
              Write('                         ');
              Str(CRCompte,compteCredit);
              Write(fnFormatString(compteCredit,10));
              Write('   ');
              Write(fnFormatString(fnlookUpForAccount(CRCompte,FPlan),25));
              Writeln('     ',MntCredit:10:3);
            End;
        End;
    End
  Else Writeln('Probleme Fichier : ', Ioresult);
  Close(FJournal);
End;
 (* ------------------------------------------- prExtraitCompte ------------------------------*)

Procedure prExtraitCompte(Var FJournal:TFJournal;Var FPlan:TFPLan; Var extrait:Text);
Var
  code: Integer;
  tmpecriture: tecriture;
Begin
  Clrscr;
  Writeln('E X T R A I T    D E    C O M P T E');
  Gotoxy(10,4);
  Write('CODE: ');
  Gotoxy(17,4);
  Read(code);
  If fnlookupforaccount(code,fplan)<>'Compte n''existe pas. Veillez l''ajouter' Then
    Begin
 {$I-}
      Reset(fjournal);
 {$I+}
      If Ioresult<>0 Then
        Writeln('Probleme de fichier Erreur Num: ',Ioresult)
      Else
        Begin
          Rewrite(extrait);
          Writeln(extrait,'<!DOCTYPE html><body> <table><thead><span>',code,'</span><span>',
                  fnlookupforaccount(code,fplan),'</span></thead><tbody>');
          While Not Eof(fjournal) Do
            Begin
              read(fjournal,tmpecriture);
              If (tmpecriture.dbcompte =code) Or (tmpecriture.crcompte=code) Then
                Begin
                  Write(extrait,'<tr><td>',tmpecriture.dateecriture.day:2,'/',tmpecriture.
                        dateecriture.Month:2,'/',tmpecriture.dateecriture.Year:4,'</td><td>',
                        tmpecriture.LibelleEcriture,'</td>');
                  If tmpEcriture.DbCompte=Code Then
                    Writeln(extrait,'<td>',TmpEcriture.MNTDebit:10:3,'</td><td></td>')
                  Else
                    Writeln(extrait,'<td></td><td>',TmpEcriture.MNTCredit:10:3,'</td>')
                End;
            End;
          Writeln(extrait,'</tr></tbody></table></body></html>');
          Close(extrait);
        End
    End
  Else
    Writeln('Compte n"existe pas');
  Close(Fjournal);
End;
 {****prExportToCSV exports all record of journal to CSV file****}

Procedure prExportToCSV(Var Fjournal:TFjournal; Var Fplan:TFplan);
Var
  strCode: String;
  vCSV: Text;
  tmpEcriture: tEcriture;
  code: Integer;
Begin
  Clrscr;
  Writeln('E X P O R T    T O    C S V');
  Gotoxy(10,4);
  Write('CODE: ');
  Gotoxy(17,4);
  read(code);
  If fnlookupforaccount(code,fplan)<>'Compte n''existe pas. Veillez l''ajouter' Then
    Begin
      Str(code,strCode);
      Assign(vCSV,strCode+fnlookupforaccount(code,fplan)+'.csv');
 {$I+}
      Reset (fjournal);
 {$I-}
      If Ioresult<>0 Then
        Writeln('Probleme de fichier Erreur Num: ',Ioresult)
      Else
        Begin
          Rewrite (vCSV);
          Writeln(vCSV,'Date;libele;Mnt_Debit;Mnt_Credit');
          While Not (Eof(fjournal)) Do
            Begin
              read (fjournal,tmpecriture);
              If (tmpecriture.dbcompte =code) Or (tmpecriture.crcompte=code) Then
                Begin
                  With tmpEcriture Do
                    Begin
										if DbCompte=code then 
                      Writeln(vCSV,fnDateToString(DateEcriture),';',LibelleEcriture,';',MntDebit: 7:3,';','')
											else
											Writeln(vCSV,fnDateToString(DateEcriture),';',LibelleEcriture,';','',';',MntCredit:7:3);
                    End;
                End;
            End;
          Close(vCSV);
        End;
    End;
  Close (fjournal);
End;
 (* prSupprimerEcriture to delete ecriture *)

Procedure prSupprimerEcriture(Var FJournal:TFJournal;Var FPlan:TFPLan);
Var
  currentFileSize, position: Longint;
  tmpEcriture: TEcriture;
  bufferEcriture,newBuffer: Array[1..1000] Of TEcriture;
  indice,i: 0..1000;
  nbEcritures: 0..1000;
  ecritureExist: Boolean;
Begin
  Clrscr;
 {$I-}
  Reset(FJournal);
 {$I+}
  If Ioresult=0 Then
    Begin
      currentFileSize := Filesize(FJournal);
      Gotoxy(10,2);
      Writeln('           S U P P R E S S I O N    E C R I T U R E             ');
      Writeln('Nobre d''ecritures :',currentFileSize:5);
      Write('Numero d''ecriture a supprimer :');
      Readln(position);
      i := 0;
      While Not Eof(FJournal) Do
        Begin
          i := i+1;
          read(FJournal,tmpEcriture);
          bufferEcriture[i] := tmpEcriture;
        End;
      nbEcritures := i;
      For indice:=1 To nbEcritures Do
        Begin
          If indice<>position Then newBuffer[indice] := bufferEcriture[indice];
        End;
 (* rewrite the Buffer again*)
      Gotoxy(20,8);
      Write('Ecriture Numero: ',position, ' est supprimer.');
      Rewrite(FJournal);
      For indice:=1 To nbEcritures-1
        Do
        Write(FJournal,newBuffer[indice]);
    End
  Else
    Writeln('File Error Numero:',Ioresult);
End;
Var
  ChMenu: 1..5;
  quit: Boolean;
Begin
  Clrscr;
  Gotoxy(30,2);
  Writeln('Journal comptable');
  Gotoxy(20,6);
  Writeln('1 : Saisie Piece Comptable.');
  Gotoxy(20,8);
  Writeln('2 : Liste des Pieces Comptable.');
  Gotoxy(20,10);
  Writeln('3 : Modifier Piece Comptable.');
  Gotoxy(20,12);
  Writeln('4 : Extrait de Compte.');
  Gotoxy(20,14);
  Writeln('5 : Supprimer Ecriture.');
  Gotoxy(20,16);
  Writeln('6 : Export to CSV');
  Gotoxy(20,18);
  Writeln('7 : Retour au menu principale ');
  Gotoxy(15,25);
  Write('Votre Choix:');
  Repeat
    Readln(ChMenu);
  Until (ChMenu In [1..7]);
  Case ChMenu Of
    1: prSaisePiece(FJournal,FPlan);
    2: prListerPiece(FJournal,FPlan);
    3: prModifierPiece(FJournal,FPlan);
    4: prExtraitCompte(FJournal,FPlan,extrait);
    5: prSupprimerEcriture(FJournal,FPlan);
    6: prExportToCSV (fjournal,Fplan);
    7: quit := True;
  End;
End;
(*Main Program*)
Begin
  Assign(extrait,'extrait.html');
  Assign(FP,'PlanComptable.dat');
  Assign(FJournal,'Journal.dat');
  Exit := False;
  Repeat
(*Main Loop*)
    Clrscr;
    Gotoxy(32,2);
    Write('Comptabilite');
    Gotoxy(20,6);
    Write('1: Gestion plan comptable.');
    Gotoxy(20,8);
    Write('2: Gestion des ecritures.');
    Gotoxy(20,10);
    Write('3: Quit.');
    Repeat
      Gotoxy(23,25);
      Write('Veillez Choisir  [ 1 , 2 , 3 ] :');
      Read(Choix);
    Until choix In [1..3];
    Case Choix Of
      1 : prGestionPC(FP);
      2 : prGestionJournal(FJournal,FP);
      3 : Clrscr;
    End;
    Repeat
      Gotoxy(23,25);
      Write('Voullez vous quitter? [ O / N]   :');
      Read(Res);
    Until (Upcase(Res) In ['O','N']);
    If Upcase(Res)='O' Then
      Exit := True;
  Until (Exit);
End.
