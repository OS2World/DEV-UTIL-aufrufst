program aufruf_d;

uses spr2_ein;

begin
  sprachtabellenkopf(
                    +'EN'
                    +'DE'
                    +''
                    +'');

  sprach_eintrag04('Stapelspeicher__',
                   'Stack memory: $',
                   'Stapelspeicher: $',
                   '',
                   '');

  sprach_eintrag04('Quelltextzeile',
                   'Source line',
                   'Quelltextzeile',
                   '',
                   '');

  sprach_eintrag04('Laufzeitfehler_',
                   'Runtime error ',
                   'Laufzeitfehler ',
                   '',
                   '');

  sprach_eintrag04('_bei_',
                   ' at $',
                   ' bei $',
                   '',
                   '');

  sprach_eintrag04('weiter_mit_Tastendruck',
                   'Press a key to quit.',
                   'Abbruch mit Tastendruck.',
                   '',
                   '');

  sprach_eintrag04('programmstart',
                   'Code base address: $',
                   'Programmanfangsadresse: $',
                   '',
                   '');

  sprach_eintrag04('Delta',
                   ' -> delta: ',
                   ' -> Differenz: ',
                   '',
                   '');

  sprach_eintrag04('erwartet_in_der_Entwicklungsumgebung',
                   ' -> excpected by compiler/IDE: $',
                   ' -> erwartet in der Entwicklungsumgebung: $',
                   '',
                   '');

{  sprach_eintrag04('',
                   '',
                   '',
                   '',
                   '');}

  schreibe_sprach_datei('AUFRUFS$.001','AUFRUFS$.002','sprach_modul','sprach_start','^string');
end.



