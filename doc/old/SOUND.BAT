gawk -f o-II.awk ostinato.dat > ostinato.sco

rem csound -dho ostinato.s48 o-II.orc ostinato.sco

csound -Wo ostinato.wav o-II.orc ostinato.sco

rem csound -x o-II.xtr -dho ostinato.s48 o-II.orc ostinato.sco

rem csound -x o-II.xtr -Wo  ostinato.wav o-II.orc ostinato.sco  
