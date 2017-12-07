#
# $Id: o-II.awk 1476 2011-12-05 18:44:28Z nicb $
# 
function delete_array(arr,
	i)
{
	for (i=1; i <= arr[0]; ++i)
		delete arr[i];
	delete arr[0];
}
function output_bass(at, dur, port, mod, amp, pan, instr,
	instrno)
{
	instrno = get_function_number(instr);
	
	printf("i30 %8.4f %8.4f %6.2f 25 %6.2f %6.2f 0 2 2 2 %6.2f %6.2f %d\n",
		at, dur, amp, port, mod, pan, 1-pan, instrno);
}
function output_synthetic_bass(at, dur, port, mod, amp, pan, instr,
	instrno)
{
	printf("i31 %8.4f %8.4f %6.2f 25 %6.2f %6.2f 0 2 2 2 %6.2f %6.2f\n",
		at, dur, amp, port, mod, pan, 1-pan);
}
function output_bass_line(at, end, dur, dur_rip, inc_rip, port, mod, amp,pan, info, instr,
	cur_at, cur_dur_rip, min_dur_rip)
{
	cur_at = at;
	cur_dur_rip = dur_rip;
	min_dur_rip = 1;

	printf(";************************************************************\n; %s - (%5.2f)\n;************************************************************\n",
		info, cur_dur_rip);
	while (cur_at < end)
	{
		output_bass(cur_at, dur, port, mod, amp, pan, instr);
		cur_at += cur_dur_rip;
		cur_dur_rip += inc_rip;
		cur_dur_rip = (cur_dur_rip < min_dur_rip) ? min_dur_rip : \
			cur_dur_rip;
	}

	return cur_dur_rip;
}
function output_synthetic_bass_line(at, end, dur, dur_rip, inc_rip, port, mod, amp,pan, info,
	cur_at, cur_dur_rip, min_dur_rip)
{
	cur_at = at;
	cur_dur_rip = dur_rip;
	min_dur_rip = 1;

	printf(";************************************************************\n; %s - (%5.2f)\n;************************************************************\n",
		info, cur_dur_rip);
	while (cur_at < end)
	{
		output_synthetic_bass(cur_at, dur, port, mod, amp, pan);
		cur_at += cur_dur_rip;
		cur_dur_rip += inc_rip;
		cur_dur_rip = (cur_dur_rip < min_dur_rip) ? min_dur_rip : \
			cur_dur_rip;
	}

	return cur_dur_rip;
}
function logic_termination(cur, start, end,
	result)
{
	result = 0;

	if ((start > end && cur < end) || (start < end && cur > end) ||
		(start == end))
		result = 1;

	return result;
}
function execute_basso(at, start, end, inc, file, dur, durmax_rip, durmin_rip, inc_rip, port, mod, amp, incamp, pan, info,
	cur_at, cur_global_dur, cur_dur_rip, cur_amp, flag, cur_end)
{
	cur_at = at;
	cur_global_dur = start;
	cur_end = cur_at + cur_global_dur;
	cur_dur_rip = durmax_rip;
	cur_amp = amp;
	flag = 1;
	idx = 1;

	while (1)
	{
		if (flag)
		{
			cur_dur_rip = output_bass_line(cur_at, cur_end,
			dur, cur_dur_rip, inc_rip, port, mod, cur_amp,
			pan, sprintf ("%s - %d (dur=%5.2f)", info, idx,
				cur_global_dur), file);
			cur_at += cur_global_dur;
			cur_global_dur += inc;
			cur_end = cur_at + cur_global_dur;
			cur_amp += incamp;
			flag = 0;
			++idx;
		}
		else
		{
			cur_at += cur_global_dur;
			cur_global_dur += inc;
			cur_end = cur_at + cur_global_dur;
			flag = 1;
		}
		if (logic_termination(cur_global_dur, start, end))
			break;
	}
}
function execute_synthetic_basso(at, start, end, inc, dur, durmax_rip, durmin_rip, inc_rip, port, mod, amp, incamp, pan, info,
	cur_at, cur_global_dur, cur_dur_rip, cur_amp, flag, cur_end)
{
	cur_at = at;
	cur_global_dur = start;
	cur_end = cur_at + cur_global_dur;
	cur_dur_rip = durmax_rip;
	cur_amp = amp;
	flag = 1;
	idx = 1;

	while (1)
	{
		if (flag)
		{
			cur_dur_rip = output_synthetic_bass_line(cur_at,
			cur_end, dur, cur_dur_rip, inc_rip, port, mod,
			cur_amp, pan, sprintf ("%s - %d (dur=%5.2f)", info,
				idx, cur_global_dur));
			cur_at += cur_global_dur;
			cur_global_dur += inc;
			cur_end = cur_at + cur_global_dur;
			cur_amp += incamp;
			flag = 0;
			++idx;
		}
		else
		{
			cur_at += cur_global_dur;
			cur_global_dur += inc;
			cur_end = cur_at + cur_global_dur;
			flag = 1;
		}
		if (logic_termination(cur_global_dur, start, end))
			break;
	}
}
function get_function_number(name,
	result)
{
	result = _soundin_conversion_[name];

	if (result == 0)
		printf("richiesto strumento inesistente \"%s\" alla linea %d!!!\n",
			name, NR) > "/dev/stderr";

	return result;
}
function output_voce(at, file, amp, pan, rev)
{
	printf("i1 %8.4f 3 %6.2f 200 %d %d %6.2f %6.2f\n",
		at, amp, get_function_number(file), rev, pan, 1-pan);
}
function output_voce_line(at, end, nrip, file, amp, pan, rev, info,
	cur_at, dur, rip_dur, fuzz)
{
	cur_at = at;
	dur = end - cur_at;
	rip_dur = nrip < 0 ? 0 : (dur / nrip);
	fuzz = 0.1;
	end += fuzz;

	printf(";************************************************************\n; %s - (%4.2f)\n;************************************************************\n",
		info, rip_dur);
	while (cur_at <= end)
	{
		output_voce(cur_at, file, amp, pan, rev);
		if (rip_dur)
			cur_at += rip_dur;
		else
			break;
	}
}
function execute_voce_lrip(at, start, nrip, inc, file, nripet, amp, pan, rev, info,
	cur_at, cur_global_dur, cur_dur_rip, cur_end, local_dur)
{
	cur_at = at;
	cur_global_dur = start;
	local_dur = cur_global_dur * .66;
	cur_end = cur_at + local_dur;
	idx = 1;

	while (nrip--)
	{
		output_voce_line(cur_at, cur_end, nripet, file, amp,
			pan, rev, sprintf("%s - %d (dur=%5.2f) rip. no. %d",
				info, idx, cur_global_dur, idx));
		cur_at += cur_global_dur;
		cur_global_dur += inc;
		local_dur = cur_global_dur * .66;
		cur_end = cur_at + local_dur;
		++idx;
	}

	output_voce(cur_at, file, amp, pan, rev);
}
function execute_voce_log(at, start, end, inc, incinc, file, nripet, amp, pan, rev, info,
	cur_at, cur_global_dur, cur_dur_rip, cur_end, local_dur)
{
	cur_at = at;
	cur_global_dur = start;
	local_dur = cur_global_dur * .66;
	cur_end = cur_at + local_dur;
	idx = 1;

	while (1)
	{
		output_voce_line(cur_at, cur_end, nripet, file, amp,
			pan, rev, sprintf("%s - %d (dur=%5.2f)", info, idx,
				cur_global_dur));
		cur_at += cur_global_dur;
		cur_global_dur += inc;
		local_dur = cur_global_dur * .66;
		cur_end = cur_at + local_dur;
		inc += incinc;
		++idx;
		if (logic_termination(cur_global_dur, start, end))
			break;
	}

	output_voce(cur_at, file, amp, pan, rev);
}
function execute_voce_lin(at, start, end, inc, file, nripet, amp, pan, rev, info)
{
	execute_voce_log(at, start, end, inc, 0, file, nripet, amp, pan, rev, info);
}
function execute_direct(line)
{
	print "; ********** start of direct line *******************"
	print line;
	print "; ********** end of direct line *******************"
}
function print_header()
{
	print "; created by $RCSfile: ost-II.awk,v $ $Revision: 1476 $\n;\n;";
	print "; ";
	print "; forme d'onda";
	print "; ";
	print "; forma d'onda audio default, F1 (sinusoide)";
	print "f1 0 4096 10 1";
	print "; ";
	print "; ";
	print "; P6  = Frequenza portante";
	print "; P7  = Frequenza modulante";
	print "; P8  = Indice di modulazione minimo";
	print "; P9 = Indice di modulazione massimo; ";
	print "; P10 = Inviluppo di ampiezza; ";
	print "; P11 = Inviluppo indice di modulazione;                           ";
	print "; P12 = percentuale canale sinistro";
	print "; P13 = percentuale canale destro";
	print "; ";
	print "; ************ INVILUPPO 2 ************ ";
	print "f2 0 4096 7 0 150 1 100 0.9 350 0.7 1400 0.2 1200 0.4 400 0.2 496 0";
	print "; un picco a 150";
	print "; un picco a 600";
	print "; un picco a 3200";
	print "; ";
	print "; ************ INVILUPPO 3 ************ ; ";
	print "f3 0 4097 7 0 50 0.65 154 1 205 0.3 819 0.2 1772 0.1 1096 0";
	print "; un picco a 204";
	print "; ";
	print "; ";
}
function process_soundin_string(line, returned,
	temp, temp2)
{
	returned[0] = 3;
	temp[0] = split(line, temp, /[ 	]*/);
	returned[2] = temp[2];
	temp2[0] = split(temp[3], temp2, "."); 
	returned[1] = temp2[2];

	printf ("; _soundfile_conversion_[\"%s\"] = %d\n", returned[2],
		returned[1]);
}
function initialize_soundins(\
	string, file, result, idx)
{
	file = "link.bat";

	while((getline string < file) > 0)
		if (string ~ /^ren /)
		{
			process_soundin_string(string, result);
			idx = result[2];
			_soundin_conversion_[idx]=result[1];
			delete_array(result);
		}

	close(file);
}
function initialize()
{
	print_header()
	initialize_soundins();
}
BEGIN {
	FS="|";
	initialize();
}
/^#/ {
	next;
}
$1 == "vlin" {
	execute_voce_lin($2, $3, $4, $5, $6, $7, $8, $9, $10, $11);
	next;
}
$1 == "vlog" {
	execute_voce_log($2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12);
	next;
}
$1 == "vlrip" {
	execute_voce_lrip($2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12);
	next;
}
$1 == "basso" {
	execute_basso($2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16);
}
$1 == "sbasso" {
	execute_synthetic_basso($2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15);
}
$1 == "direct" {
	execute_direct($2);
}
#
# $Log: ost-II.awk,v $
# Revision 0.9  1996/11/18 21:44:19  nicb
# added reverb to output_voce() (synced with o-II.orc 0.3)
#
# Revision 0.8  1996/10/22 18:20:31  nicb
# added synthetic bass sbasso line
# added dynamic lookup of soundfile table
#
# Revision 0.7  1996/10/17 21:28:23  nicb
# modified to fit new audio files
#
# Revision 0.6  1996/10/17 16:11:08  nicb
# added direct command
#
# Revision 0.5  1996/09/21 22:40:38  nicb
# added vlrip function
#
# Revision 0.4  1996/09/11 10:01:15  nicb
# added single lines for voce
#
# Revision 0.3  1996/09/08 20:13:48  nicb
# added inc/dec for voce
# added linear and logarithmic voice
#
# Revision 0.2  1996/09/06 09:46:30  nicb
# added bi-directional global processing and null increment special case
#
# Revision 0.1  1996/09/02 07:08:48  nicb
# microscopic mod to adapt RCSFile --> RCSfile bug
#
# Revision 0.0  1996/09/02 07:06:29  nicb
# Initial Revision
#
#
