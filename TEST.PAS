(*$W+,Locinfo+*)
uses
  //deb_link,
  aufrufst;

procedure p2;
  begin
    RunError(1);
  end;

procedure p1(a1:byte);
  var
    b:byte;
  begin
    Inc(b,2);
    Write(b);
    p2;
  end;

begin
  install_exitproc;
  install_exitproc;
  install_exitproc;
  install_exitproc;
  p1(1);
end.

