(*$W+,S-,I-*)
(*&Use32+*)

unit aufrufst{apel};
(* 2001.03.30..2001.06.26  Veit Kannegieser *)
(* 2001.07.15              Mehrfachinstallation *)

interface

procedure install_exitproc;
procedure remove_exitproc;

implementation

(*$IFDEF VirtualPascal*)

uses
  Dos,
  spr2_aus,
  Strings,
  VpUtils,
  VpSysLow;

(*$I AUFRUFS$.002 *)
(*$I AUFRUFS$.001 *)

const
  org_exit1             :pointer=nil;
  org_exit2             :pointer=nil;

var
  logfilename           :string;
  logfile               :text;

procedure WriteLn2(const s:string);
  begin
    InOutRes:=0;
    WriteLn(Output,s);
    InOutRes:=0;
    WriteLn(logfile,s);
    InOutRes:=0;
  end;

procedure Write2(const s:string);
  begin
    InOutRes:=0;
    Write(Output,s);
    InOutRes:=0;
    Write(logfile,s);
    InOutRes:=0;
  end;

procedure aufrufstaple_anzeige;
  var
    (*$IFDEF DPMI32*)
    delta,
    (*$ENDIF DPMI32*)
    stapel_min,
    stapel_max,
    eip_,
    ebp_                :word;

    modul               :string;
    zeile               :longint;

    y,m,d,o,hh,mm,ss,s1 :word;

  begin

    remove_exitproc;

    if ErrorAddr=Nil then Exit;

    Append(logfile);
    if IOResult<>0 then
      Rewrite(logfile);

    WriteLn2('');

    InOutRes:=0;
    WriteLn(logfile,'============== ',ParamStr(0),' ==============');
    InOutRes:=0;
    if Assigned(CmdLine) then
      WriteLn(logfile,StrEnd(CmdLine)+1);
    InOutRes:=0;
    GetDate(y,m,d,o);
    GetTime(hh,mm,ss,s1);
    WriteLn(logfile,Int2StrZ(y,4)+'.'+Int2StrZ(m,2)+'.'+Int2StrZ(d,2)+' '
                   +Int2StrZ(hh,2)+'.'+Int2StrZ(mm,2));
    InOutRes:=0;

    asm (*$Alters EAX*)
      mov eax,fs:[4]
      mov stapel_min,eax
      mov eax,fs:[8]
      mov stapel_max,eax

      mov ebp_,ebp
    end;

    WriteLn2(textz_Laufzeitfehler_^+Int2Str(ExitCode)
            +textz__bei_^+Int2Hex(Ofs(ErrorAddr^),8)
            +' TID='+Int2Str(GetThreadID));
    (*$IFDEF DPMI32*)
    delta:=$401000-code_base;
    if delta<>0 then
      begin
        Write2(textz_programmstart^+Int2Hex(code_base,8)+textz_delta^);
        if delta<0 then
          WriteLn2('-$'+Int2Hex(-delta,8))
        else
          WriteLn2('+$'+Int2Hex(+delta,8));
        WriteLn2(textz_erwartet_in_der_Entwicklungsumgebung^+Int2Hex(Ofs(ErrorAddr^)+delta,8));
      end;
    (*$ENDIF*)

    WriteLn2(textz_Stapelspeicher__^+Int2Hex(stapel_min,8)+'..$'+Int2Hex(stapel_max,8));

    WriteLn2('EBP       MemL[EBP] MemL[EBP+4] EIP       '+textz_Quelltextzeile^);

    Write2('                                $');
    eip_:=Ofs(GetLocationInfo(ErrorAddr,modul,zeile)^);
    if eip_=0 then
      WriteLn2(Int2Hex(Ofs(ErrorAddr^),8))
    else
      WriteLn2(Int2Hex(eip_,8)+' '+modul+'#'+Int2Str(zeile));

    repeat
      Write2( '$'+Int2Hex(ebp_,8)
            +' $'+Int2Hex(MemL[ebp_],8)
            +' $'+Int2Hex(MemL[ebp_+4],8));

      eip_:=MemL[ebp_+4]-(4+1);

      eip_:=Ofs(GetLocationInfo(Ptr(eip_),modul,zeile)^);
      if eip_<>0 then
        Write2('   $'+Int2Hex(eip_,8)+' '+modul+'#'+Int2Str(zeile));

      WriteLn2('');

      ebp_:=MemL[ebp_]

    until (ebp_<stapel_min) or (stapel_max<ebp_);

    Write(textz_weiter_mit_Tastendruck^);
    SysReadKey;
    WriteLn;

    WriteLn(logfile);
    InOutRes:=0;
    Close(logfile)

  end;

procedure install_exitproc;
  begin
    if org_exit1=nil then
      begin
        org_exit1:=ExitProc;
        ExitProc:=@aufrufstaple_anzeige;
      end
    else if org_exit2=nil then
      begin
        org_exit2:=ExitProc;
        ExitProc:=@aufrufstaple_anzeige;
      end;
  end;

procedure remove_exitproc;
  begin

    if (ExitProc=@aufrufstaple_anzeige)
    or (ExitProc=nil) then
      begin

        if org_exit2<>nil then
          begin
            ExitProc:=org_exit2;
            org_exit2:=nil;
          end
        else if org_exit1<>nil then
          begin
            ExitProc:=org_exit1;
            org_exit1:=nil;
          end;

      end;
  end;


begin
  setze_sprachzeiger(@sprach_modul,@sprach_start);

  logfilename:=GetEnv('ERROR_LOG');
  if logfilename='' then
    begin
      logfilename:=ParamStr(0);
      while (logfilename<>'') and (not (logfilename[Length(logfilename)] in ['/','\'])) do
        SetLength(logfilename,Pred(Length(logfilename)));
      logfilename:=logfilename+'ERROR.LOG';
    end;

  Assign(logfile,logfilename);

  if (logfilename<>'OFF') and (logfilename<>'0') then
    install_exitproc;


(*$ENDIF VirtualPascal*)
end.

