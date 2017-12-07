; $Id: o-II.orc 68 2014-02-18 23:49:56Z nicb $
;
; ***************************************
;     o-II.orc
; ***************************************
; 
; 

	sr=48000
	kr=48000
	ksmps=1
	nchnls=2

	instr 1
	irevmax=12
	irevstep=1/irevmax
	irevsend=p7*irevstep
	irevdirect=1-irevsend
	iamp=ampdb(p4)/ampdbfs(0)
	ibase=cpspch(8.00)
	ilpan=p8*iamp
	irpan=p9*iamp
asig	soundin	p6
	aoutl=asig*ilpan
	aoutr=asig*irpan
	outs	aoutl*irevdirect,aoutr*irevdirect
	gal=aoutl*irevsend
	gar=aoutr*irevsend
	endin

	instr 30
	iamp=ampdb(p4)
	iamppercento=iamp/ampdbfs(0)
print iamp,iamppercento
asig	soundin p14

	outs	asig*iamppercento*p12,asig*iamppercento*p13
	endin

	instr 31

	; inviluppo audio

	iamp=ampdb(p4)
print iamp
kamp	oscil1i	0,iamp,p3,p10

	; picco di deviazione

kodev	oscil1i 0,p9,p3,p11
kdev	=kodev+p8

	; oscillatore fm

afm	foscili	kamp,p5,p6,p7,kdev,1
	outs	afm*p12,afm*p13
	endin

	instr 99
	irevscale=0.4
arl	reverb2	gal*irevscale,0.4,0.6
arr	reverb2	gar*irevscale,0.4,0.6
	outs arl,arr
	gal=0
	gar=0
	endin

;
; $Log: o-II.orc,v $
; Revision 0.3  1996/11/18 21:43:17  nicb
; added reverb
;
; Revision 0.2  1996/10/22 18:24:44  nicb
; added instr 31
;
; Revision 0.1  1996/10/17 21:33:48  nicb
; added soundin driver to bass line
;
; Revision 0.0  1996/09/02 07:12:03  nicb
; Initial Revision
;
;
