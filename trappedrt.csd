<CsoundSynthesizer>
<CsOptions>
csound -h -m128 -d -odac -B512 -b64 temp.orc temp.sco
</CsOptions>
<CsInstruments>
;============================================================================; 
;============================================================================; 
;============================================================================;
;                            == TRAPPED IN CONVERT ==                        ;
;                                Richard Boulanger                           ;
;============================================================================; 
;============================================================================; 
;                                   ORCHESTRA                                ;
;============================================================================; 
;============================================================================; 
;============================================================================;
;                            written July 1979 in music11                    ;
;                          M.I.T. Experimental Music Studio                  ; 
;                            revised June 1986 in Csound                     ;
;                                M.I.T. Media Lab                            ;
;                          revised July 1996 in SHARCsound                   ;
;                                Analog Devices Inc.                         ;
;============================================================================; 
;============================================================================; 
;=================================== HEADER =================================;
;============================================================================; 
sr     =        44100
kr     =        4410
ksmps  =        10
nchnls =        2
;============================================================================; 
;=============================== INITIALIZATION =============================;
;============================================================================; 
garvb  init     0
gadel  init     0
;============================================================================; 
;================================== INSTRUMENTS =============================;
;============================================================================; 
;==================================== IVORY =================================;
;============================================================================; 
       instr    1                            ; p6 = amp 
ifreq  =        cpspch(p5)                   ; p7 = vib rate
                                             ; p8 = glis. del time (default < 1)
aglis  expseg   1, p8, 1, p3 - p8, p9        ; p9 = freq drop factor

k1     line     0, p3, 5                     
k2     oscil    k1, p7, 1                    
k3     linseg   0, p3 * .7, p6, p3 * .3, 0   
a1     oscil    k3, (ifreq + k2) * aglis, 1     

k4     linseg   0, p3 * .6, 6, p3 * .4, 0
k5     oscil    k4, p7 * .9, 1, 1.4
k6     linseg   0, p3 * .9, p6, p3 * .1, 0
a3     oscil    k6, ((ifreq + .009) + k5) * aglis, 9, .2

k7     linseg   9, p3 * .7, 1, p3 * .3, 1
k8     oscil    k7, p7 * 1.2, 1, .7
k9     linen    p6, p3 * .5, p3, p3 * .333
a5     oscil    k9, ((ifreq + .007) + k8) * aglis, 10, .3

k10    expseg   1, p3 * .99, 3.1, p3 * .01, 3.1
k11    oscil    k10, p7 * .97, 1, .6
k12    expseg   .001, p3 * .8, p6, p3 * .2, .001
a7     oscil    k12,((ifreq + .005) + k11) * aglis, 11, .5

k13    expseg   1, p3 * .4, 3, p3 * .6, .02
k14    oscil    k13, p7 * .99, 1, .4
k15    expseg   .001, p3 *.5, p6, p3 *.1, p6 *.6, p3 *.2, p6 *.97, p3 *.2, .001
a9     oscil    k15, ((ifreq + .003) + k14) * aglis, 12, .8

k16    expseg   4, p3 * .91, 1, p3 * .09, 1
k17    oscil    k16, p7 * 1.4, 1, .2
k18    expseg   .001, p3 *.6, p6, p3 *.2, p6 *.8, p3 *.1, p6 *.98, p3 *.1, .001
a11    oscil    k18, ((ifreq + .001) + k17) * aglis, 13, 1.3

       outs     a1 + a3 + a5, a7 + a9 + a11
       endin
;============================================================================; 
;==================================== BLUE ==================================;
;============================================================================; 
       instr 2                               ; p6 = amp   
ifreq  =        cpspch(p5)                   ; p7 = reverb send factor
                                             ; p8 = lfo freq 
k1     randi    1, 30                        ; p9 = number of harmonic      
k2     linseg   0, p3 * .5, 1, p3 * .5, 0    ; p10 = sweep rate   
k3     linseg   .005, p3 * .71, .015, p3 * .29, .01
k4     oscil    k2, p8, 1,.2                   
k5     =        k4 + 2

ksweep linseg   p9, p3 * p10, 1, p3 * (p3 - (p3 * p10)), 1

kenv   expseg   .001, p3 * .01, p6, p3 * .99, .001
asig   gbuzz    kenv, ifreq + k3, k5, ksweep, k1, 15

       outs     asig, asig
garvb  =        garvb + (asig * p7) 
       endin
;============================================================================; 
;================================== VIOLET ==================================;
;============================================================================; 
       instr   3                             ; p6 = amp
ifreq  =       cpspch(p5)                    ; p7 = reverb send factor
                                             ; p8 = rand freq
k3     expseg  1, p3 * .5, 30 ,p3 * .5, 2            
k4     expseg  10, p3 *.7, p8, p3 *.3, 6         
k8     linen   p6, p3 * .333, p3, p3 * .333
k13    line    0, p3, -1

k14    randh   k3, k4, .5
a1     oscil   k8, ifreq + (p5 * .05) + k14 + k13, 1, .1

k1     expseg  1, p3 * .8, 6, p3 *.2, 1
k6     linseg  .4, p3 * .9, p8 * .96, p3 * .1, 0
k7     linseg  8, p3 * .2, 10, p3 * .76, 2

kenv2  expseg  .001, p3 * .4, p6 * .99, p3 * .6, .0001
k15    randh   k6, k7
a2     buzz    kenv2, ifreq + (p5 * .009) + k15 + k13, k1, 1, .2

kenv1  linen   p6, p3 * .25, p3, p3 * .4
k16    randh   k4 * 1.4, k7 * 2.1, .2
a3     oscil   kenv1, ifreq + (p5 * .1) + k16 + k13, 16, .3

amix   =       a1 + a2 + a3
       outs    a1 + a3, a2 + a3
garvb  =       garvb + (amix * p7)
       endin
;============================================================================; 
;==================================== BLACK =================================;
;============================================================================; 
       instr   4                             ; p6 = amp 
ifreq  =       cpspch(p5)                    ; p7 = filtersweep strtfreq
                                             ; p8 = filtersweep endfreq
k1     expon   p7, p3, p8                    ; p9 = bandwidth
anoise rand    8000                          ; p10 = reverb send factor 
a1     reson   anoise, k1, k1 / p9, 1            
k2     oscil   .6, 11.3, 1, .1               
k3     expseg  .001,p3 * .001, p6, p3 * .999, .001   
a2     oscil   k3, ifreq + k2, 15

       outs   (a1 * .8) + a2, (a1 * .6) + (a2 * .7)
garvb  =      garvb + (a2 * p10)
       endin
;============================================================================; 
;==================================== GREEN =================================;
;============================================================================; 
        instr  5                             ; p6 = amp    
ifreq   =      cpspch(p5)                    ; p7 = reverb send factor
                                             ; p8 = pan direction 
k1     line    p9, p3, 1                     ; ... (1.0 = L -> R, 0.1 = R -> L)
k2     line    1, p3, p10                    ; p9 = carrier freq  
k4     expon   2, p3, p12                    ; p10 = modulator freq
k5     linseg  0, p3 * .8, 8, p3 * .2, 8     ; p11 = modulation index
k7     randh   p11, k4                       ; p12 = rand freq                  
k6     oscil   k4, k5, 1, .3    

kenv1  linen   p6, .03, p3, .2     
a1     foscil  kenv1, ifreq + k6, k1, k2, k7, 1

kenv2  linen   p6, .1, p3, .1
a2     oscil   kenv2, ifreq * 1.001, 1

amix   =       a1 + a2
kpan   linseg  int(p8), p3 * .7, frac(p8), p3 * .3, int(p8)
       outs    amix * kpan, amix * (1 - kpan)
garvb  =       garvb + (amix * p7)
       endin
;============================================================================; 
;================================== COPPER ==================================;
;============================================================================; 
        instr  6                             ; p5 = FilterSweep StartFreq
ifuncl  =      8                             ; p6 = FilterSweep EndFreq
                                             ; p7 = bandwidth
k1      phasor p4                            ; p8 = reverb send factor
k2      table  k1 * ifuncl, 19               ; p9 = amp       
anoise  rand   8000                        
k3      expon  p5, p3, p6                         
a1      reson  anoise, k3 * k2, k3 / p7, 1

kenv    linen  p9, .01, p3, .05
asig    =      a1 * kenv

        outs   asig, asig
garvb   =      garvb + (asig * p8)
        endin
;============================================================================; 
;==================================== PEWTER ================================;
;============================================================================; 
       instr   7                             ; p4 = amp
ifuncl =       512                           ; p5 = freq
ifreq  =       cpspch(p5)                    ; p6 = begin phase point        
                                             ; p7 = end phase point
a1     oscil   1, ifreq, p10                 ; p8 = ctrl osc amp (.1 -> 1)   
k1     linseg  p6, p3 * .5, p7, p3 * .5, p6  ; p9 = ctrl osc func      
a3     oscili  p8, ifreq + k1, p9            ; p10 = main osc func (f2 or f3)
a4     phasor  ifreq                         ; ...(function length must be 512!) 
a5     table   (a4 + a3) * ifuncl, p10       ; p11 = reverb send factor    

kenv   linen   p4, p3 * .4, p3, p3 * .5            
asig   =       kenv * ((a1 + a5) * .2)                  

       outs    asig, asig
garvb  =       garvb + (asig * p11)                      
       endin
;============================================================================; 
;==================================== RED ===================================;
;============================================================================; 
       instr   8                             ; p4 = amp
ifuncl =       16                            ; p5 = FilterSweep StartFreq
                                             ; p6 = FilterSweep EndFreq
k1     expon   p5, p3, p6                    ; p7 = bandwidth 
k2     line    p8, p3, p8 * .93              ; p8 = cps of rand1
k3     phasor  k2                            ; p9 = cps of rand2
k4     table   k3 * ifuncl, 20               ; p10 = reverb send factor     
anoise rand    8000                          
aflt1  reson   anoise, k1, 20 + (k4 * k1 / p7), 1        

k5     linseg  p6 * .9, p3 * .8, p5 * 1.4, p3 * .2, p5 * 1.4
k6     expon   p9 * .97, p3, p9
k7     phasor  k6
k8     tablei  k7 * ifuncl, 21
aflt2  reson   anoise, k5, 30 + (k8 * k5 / p7 * .9), 1

abal   oscil   1000, 1000, 1                  
a3     balance aflt1, abal
a5     balance aflt2, abal

k11    linen   p4, .15, p3, .5
a3     =       a3 * k11
a5     =       a5 * k11

k9     randh   1, k2
aleft  =       ((a3 * k9) * .7) + ((a5 * k9) * .3)     
k10    randh   1, k6
aright =       ((a3 * k10) * .3)+((a5 * k10) * .7)
       outs    aleft, aright
garvb  =       garvb + (a3 * p10)
endin
;============================================================================; 
;==================================== SAND ==================================;
;============================================================================; 
        instr  9                             ; p4 = delay send factor    
ifreq   =      cpspch(p5)                    ; p5 = freq     
                                             ; p6 = amp 
k2      randh  p8, p9, .1                    ; p7 = reverb send factor 
k3      randh  p8 * .98, p9 * .91, .2        ; p8 = rand amp     
k4      randh  p8 * 1.2, p9 * .96, .3        ; p9 = rand freq    
k5      randh  p8 * .9, p9 * 1.3     

kenv    linen  p6, p3 *.1, p3, p3 * .8                        

a1      oscil  kenv, ifreq + k2, 1, .2             
a2      oscil  kenv * .91, (ifreq + .004) + k3, 2, .3
a3      oscil  kenv * .85, (ifreq + .006) + k4, 3, .5
a4      oscil  kenv * .95, (ifreq + .009) + k5, 4, .8

amix    =      a1 + a2 + a3 + a4

        outs   a1 + a3, a2 + a4
garvb   =      garvb + (amix * p7)
gadel   =      gadel + (amix * p4)
        endin
;============================================================================; 
;==================================== TAUPE =================================;
;============================================================================; 
        instr  10                            
ifreq   =      cpspch(p5)                    ; p5 = freq     
                                             ; p6 = amp 
k2      randh  p8, p9, .1                    ; p7 = reverb send factor 
k3      randh  p8 * .98, p9 * .91, .2        ; p8 = rand amp     
k4      randh  p8 * 1.2, p9 * .96, .3        ; p9 = rand freq    
k5      randh  p8 * .9, p9 * 1.3     

kenv    linen  p6, p3 *.1, p3, p3 * .8                        

a1      oscil  kenv, ifreq + k2, 1, .2             
a2      oscil  kenv * .91, (ifreq + .004) + k3, 2, .3
a3      oscil  kenv * .85, (ifreq + .006) + k4, 3, .5
a4      oscil  kenv * .95, (ifreq + .009) + k5, 4, .8

amix    =      a1 + a2 + a3 + a4

        outs   a1 + a3, a2 + a4
garvb   =      garvb + (amix * p7)
        endin
;============================================================================; 
;==================================== RUST ==================================;
;============================================================================; 
       instr   11                            ; p4 = delay send factor
ifreq  =       cpspch(p5)                    ; p5 = freq             
                                             ; p6 = amp
k1     expseg  1, p3 * .5, 40, p3 * .5, 2    ; p7 = reverb send factor
k2     expseg  10, p3 * .72, 35, p3 * .28, 6
k3     linen   p6, p3* .333, p3, p3 * .333
k4     randh   k1, k2, .5
a4     oscil   k3, ifreq + (p5 * .05) + k4, 1, .1

k5     linseg  .4, p3 * .9, 26, p3 * .1, 0
k6     linseg  8, p3 * .24, 20, p3 * .76, 2
k7     linen   p6, p3 * .5, p3, p3 * .46
k8     randh   k5, k6, .4
a3     oscil   k7, ifreq + (p5 * .03) + k8, 14, .3

k9     expseg  1, p3 * .7, 50, p3 * .3, 2
k10    expseg  10, p3 * .3, 45, p3 * .7, 6
k11    linen   p6, p3 * .25, p3, p3 * .25
k12    randh   k9, k10, .5
a2     oscil   k11, ifreq + (p5 * .02) + k12, 1, .1

k13    linseg  .4, p3 * .6, 46, p3 * .4, 0
k14    linseg  18, p3 * .1, 50, p3 * .9, 2
k15    linen   p6, p3 * .2, p3, p3 * .3
k16    randh   k13, k14, .8
a1     oscil   k15, ifreq + (p5 * .01) + k16, 14, .3

amix   =       a1 + a2 + a3 + a4
       outs    a1 + a3, a2 + a4
garvb  =       garvb + (amix * p7)
gadel  =       gadel + (amix * p4)
       endin
;============================================================================; 
;==================================== TEAL ==================================;
;============================================================================; 
       instr   12                            ; p6 = amp
ifreq  =       octpch(p5)                    ; p7 = FilterSweep StartFreq
ifuncl =       8                             ; p8 = FilterSweep PeakFreq
                                             ; p9 = bandwdth
k1     linseg  0, p3 * .8, 9, p3 * .2, 1     ; p10 = reverb send factor
k2     phasor  k1                         
k3     table   k2 * ifuncl, 22                    
k4     expseg  p7, p3 * .7, p8, p3 * .3, p7 * .9    

anoise rand    8000                      

aflt   reson   anoise, k4, k4 / p9, 1
kenv1  expseg  .001, p3 *.1, p6, p3 *.1, p6 *.5, p3 *.3, p6 *.8, p3 *.5,.001
a3     oscil   kenv1, cpsoct(ifreq + k3) + aflt * .8, 1

       outs    a3,(a3 * .98) + (aflt * .3)
garvb  =       garvb + (anoise * p10)
       endin
;============================================================================; 
;==================================== FOAM ==================================;
;============================================================================; 
       instr   13                            ; p6 = amp
ifreq  =       octpch(p5)                    ; p7 = vibrato rate
                                             ; p8 = glis. factor
k1     line    0, p3, p8
k2     oscil   k1, p7, 1                         
k3     linseg  0, p3 * .7, p6, p3 * .3, 1             
a1     oscil   k3, cpsoct(ifreq + k2), 1
              
k4     linseg  0, p3 * .6, p8 * .995, p3 * .4, 0
k5     oscil   k4, p7 * .9, 1, .1
k6     linseg  0, p3 * .9, p6, p3 * .1, 3
a2     oscil   k6, cpsoct((ifreq + .009) + k5), 4, .2

k7     linseg  p8 * .985, p3 * .7, 0, p3 * .3, 0
k8     oscil   k7, p7 * 1.2, 1, .7
k9     linen   p6, p3 * .5, p3, p3 * .333
a3     oscil   k6, cpsoct((ifreq + .007) + k8), 5, .5

k10    expseg  1, p3 * .8, p8, p3 * .2, 4
k11    oscil   k10, p7 * .97, 1, .6
k12    expseg  .001, p3 * .99, p6 * .97, p3 * .01, p6 * .97
a4     oscil   k12, cpsoct((ifreq + .005) + k11), 6, .8

k13    expseg  .002, p3 * .91, p8 * .99, p3 * .09, p8 * .99
k14    oscil   k13, p7 * .99, 1, .4
k15    expseg  .001, p3 *.5, p6, p3 *.1, p6 *.6, p3 *.2, p6 *.97, p3 *.2, .001
a5     oscil   k15, cpsoct((ifreq + .003) + k14), 7, .9

k16    expseg  p8 * .98, p3 * .81, .003, p3 * .19, .003
k17    oscil   k16, p7 * 1.4, 1, .2
k18    expseg  .001, p3 *.6, p6, p3 *.2, p6 *.8, p3 *.1, p6 *.98, p3 *.1, .001
a6     oscil   k18, cpsoct((ifreq + .001) + k17), 8, .1

       outs    a1 + a3 + a5, a2 + a4 + a6
       endin
;============================================================================; 
;==================================== SMEAR =================================;
;============================================================================; 
        instr  98
asig    delay  gadel, .08
        outs   asig, asig
gadel   =      0
        endin
;============================================================================; 
;==================================== SWIRL =================================;
;============================================================================; 
       instr   99                            ; p4 = panrate
k1     oscil   .5, p4, 1
k2     =       .5 + k1
k3     =       1 - k2
asig   reverb  garvb, 2.1
       outs    asig * k2, (asig * k3) * (-1)
garvb  =       0
       endin
;============================================================================; 
;============================================================================; 
;============================================================================; 
;============================================================================; 
</CsInstruments>
<CsScore>
;============================================================================;
;============================================================================;
;                            == TRAPPED IN CONVERT ==                        ;
;                                Richard Boulanger                           ;
;============================================================================; 
;============================================================================; 
;                                     SCORE                                  ;
;============================================================================; 
;================================= PARAMETERS ===============================;
;============================================================================; 
; i1:  p6=amp,p7=vibrat,p8=glisdeltime (default < 1),p9=frqdrop              ;
; i2:  p6=amp,p7=rvbsnd,p8=lfofrq,p9=num of harmonics,p10=sweeprate          ;
; i3:  p6=amp,p7=rvbsnd,p8=rndfrq                                            ;
; i4:  p6=amp,p7=fltrswp:strtval,p8=fltrswp:endval,p9=bdwth,p10=rvbsnd       ;
; i5:  p6=amp,p7=rvbatn,p8=pan:1.0,p9=carfrq,p10=modfrq,p11=modndx,p12=rndfrq;
; i6:  p5=swpfrq:strt,p6=swpfrq:end,p7=bndwth,p8=rvbsnd,p9=amp               ;
; i7:  p4=amp,p5=frq,p6=strtphse,p7=endphse,p8=ctrlamp(.1-1),p9=ctrlfnc      ;
;             p10=audfnc(f2,f3,f14,p11=rvbsnd                                ;
; i8:  p4=amp,p5=swpstrt,p6=swpend,p7=bndwt,p8=rnd1:cps,p9=rnd2:cps,p10=rvbsnd;
; i9:  p4=delsnd,p5=frq,p6=amp,p7=rvbsnd,p8=rndamp,p9=rndfrq                 ;
; i10: p4=0,p5=frq,p6=amp,p7=rvbsnd,p8=rndamp,p9=rndfrq                      ;
; i11: p4=delsnd,p5=frq,p6=amp,p7=rvbsnd                                     ;
; i12: p6=amp,p7=swpstrt,p8=swppeak,p9=bndwth,p10=rvbsnd                     ;
; i13: p6=amp,p7=vibrat,p8=dropfrq                                           ;
; i98: p2=strt,p3=dur                                                        ;
; i99: p4=pancps                                                             ;
;============================================================================; 
;========================= FUNCTIONS ========================================;
;============================================================================; 
f1   0  8192  10   1
f2   0  512   10   10  8   0   6   0   4   0   1
f3   0  512   10   10  0   5   5   0   4   3   0   1
f4   0  2048  10   10  0   9   0   0   8   0   7   0  4  0  2  0  1
f5   0  2048  10   5   3   2   1   0
f6   0  2048  10   8   10  7   4   3   1
f7   0  2048  10   7   9   11  4   2   0   1   1
f8   0  2048  10   0   0   0   0   7   0   0   0   0  2  0  0  0  1  1
f9   0  2048  10   10  9   8   7   6   5   4   3   2  1
f10  0  2048  10   10  0   9   0   8   0   7   0   6  0  5
f11  0  2048  10   10  10  9   0   0   0   3   2   0  0  1
f12  0  2048  10   10  0   0   0   5   0   0   0   0  0  3
f13  0  2048  10   10  0   0   0   0   3   1
f14  0  512   9    1   3   0   3   1   0   9  .333   180
f15  0  8192  9    1   1   90 
f16  0  2048  9    1   3   0   3   1   0   6   1   0
f17  0  9     5   .1   8   1
f18  0  17    5   .1   10  1   6  .4
f19  0  16    2    1   7   10  7   6   5   4   2   1   1  1  1  1  1  1  1
f20  0  16   -2    0   30  40  45  50  40  30  20  10  5  4  3  2  1  0  0  0
f21  0  16   -2    0   20  15  10  9   8   7   6   5   4  3  2  1  0  0
f22  0  9    -2   .001 .004 .007 .003 .002 .005 .009 .006
;============================================================================; 
;========================= SECTION I: 78 SECONDS  ===========================;
;============================================================================; 
i1   0.0    24.12   0      11.057   200    0.001  17.8   0.99
i1   1.0    21.76   0      11.049   240    0.001  10.2   0.99
i1   3.6    17.13   0      11.082   390    0.001  11.3   0.99
i1   6.2    15.02   0      11.075   460    0.001  10.5   0.99
i1   8.4    13.85   0      11.069   680    0.001  13.8   0.99
i99  22.0   7.5     5
i2   22.0   4       0      9.029    600    0.6    23     10     0.52
i2   22.13  4       0      9.01     600    0.5    20     6      0.66
i1   26.5   5.6     0      12.019   500    4.0    5.8    0.98
i1   26.51  6.1     0      12.004   550    5.0    5.5    0.98
i1   26.52  5.4     0      12.026   600    5.2    5.6    0.98
i1   26.55  5       0      12.031   660    4.5    5.7    0.98
i99  31.3   0.7     22
i4   31.3   1       0      13.045   2200   6000   7000   30     0.5
i99  32.0   4       11
i2   32.0   4       0      14.107   900    0.4    19     13     0.21
i2   32.14  4       0      11.023   750    0.7    21     9      0.19
i2   32.19  4       0      11.029   589    0.97   20     10     0.22
i4   35.0   1       0      12.029   1000   4600   6500   33     0.6
i99  36.0   10      7
i3   36.0   7.6     0      13.087   800    0.8    57
i1   39.31  8.1     0      10.024   519    3.0    3.1    0.002
i1   39.32  8       0      10.031   520    5.1    3.7    0.001
i1   39.35  7.9     0      10.042   557    3.4    3.5    0.003
i1   39.37  7.86    0      10.050   547    4.2    3.3    0.004
i99  46.0   7.3     2
i5   46.0   0.9     0      4.09     3500   0.2    0.1    3      10   12  27
i5   49.2   1.1     0      3.07     4500   0.1    1.0    5      3    16  30
i99  53.3   9.6     5
i6   53.3   8.5     0.81   3000     17     10     0.6    1.6
i98  62.9   15.1
i99  62.9   15.1    3
i9   62.9   2.9     0.4    4.113    600    0.2    6.2    320
i9   62.93  2.85    0.43   4.115    640    0.23   6.1    300
i9   67.1   7.9     0.2    5.004    700    0.4    4.5    289
i9   67.14  7.78    0.17   5.007    700    0.43   4.4    280
s
;============================================================================; 
;========================= SECTION II: 49 SECONDS ===========================;
;============================================================================; 
i98  0      48.5
i99  0      4.5     1
i9   0      5       0.4    10.01    1200   0.2    28     39
i9   0      5       0.3    9.119    1200   0.4    29     37
i3   0.5    6.5     0      12.067   600    0.6    47
i99  4.5    2       7
i6   4.5    4.3     17     6000     9000   100    0.4    0.9
i99  6.5    9.9     0.7
i7   6.5    3.2     9999   5.023    0.2    0.7    0.6    2      3    0.12
i7   8      1.9     9800   5.039    0.01   0.9    1      3      2    0.23
i7   9      3.8     9900   10.001   0.99   0.1    0.3    3      2    0.12
i3   9.1    5.5     0      10.017   900    0.5    67
i7   9.2    2.5     9890   5.052    0.1    1.0    0.7    2      3    0.23
i8   11     4.6     4      20       8000   590    2      9.9    0.6
i8   15.5   3.1     3      50       4000   129    8      2.6    0.3
i8   16.2   4.3     2      10000    9000   200    12     17.9   1
i99  16.4   10.3    0.3
i7   16.4   3.5     8000   5.019    0.2    0.7    0.5    2      3    0.1
i7   19.3   6.4     8000   5.041    0.01   0.9    1      3      2    0.1
i9   20.2   4       0.4    9.021    1000   0.2    4      100
i9   21     4.2     0.4    9.099    1100   0.4    4      167
i9   21.1   8       0.4    9.043    1000   0.6    4      210
i9   21.25  5       0.4    9.062    1200   0.9    5      200
i99  26.7   5.3     11
i9   26.7   1.9     0.5    4.114    3100   0.1    5.9    300
i9   29.1   2.1     0.1    5.013    2900   0.2    4.2    390
i99  32     6.2     0.28
i9   32     9.1     0.34   5.051    2300   0.5    3.8    420
i9   32.1   9.0     0.4    5.0517   2500   0.4    4      430
i2   34.2   5       0      9.029    1900   0.3    23     10     0.42
i2   34.23  5       0      9.01     2100   0.2    20     6      0.29
i2   36     5       0      13.027   3500   0.5    27     9      0.38
i2   36.05  5       0      12.119   3399   0.1    21     3      0.30
i2   36.12  5       0      13.018   3709   0.4    17     12     0.33
i99  38.2   10.8    2
i2   38.2   7.3     0      8.062    5900   0.4    19     13     0.26
i2   38.4   7       0      7.077    4730   0.6    26     21     0.23
i4   38.9   3.1     0      10.001   2600   2000   3000   46     0.3
i4   39.7   2.3     0      9.0119   1200   1000   2000   50     0.2
s
;============================================================================; 
;========================= SECTION III: 56 SECONDS ==========================;
;============================================================================; 
i98  0      42
i99  0      42      0.0618
i9   0      7       0.6    11.031   1100   0.2    30     40
i9   0.1    7       0.2    11.042   1100   0.9    26     37
i9   0.3    6.2     0.9    11.049   1105   0.1    32     29
i9   0.6    5.8     0.4    11.021   1110   0.6    41     34
i11  3.7    8       0.2    5.02     2200   0.2
i13  7.0    4.5     0.4    11.064   1500   40.0   7
i9   9.3    9       0.8    7.098    1300   0.3    33     27
i9   9.8    7       0.2    7.087    1400   0.7    39     31
i2   10.9   4       0.2    8.113    5000   0.9    45     20     1
i11  12     5       0.2    4.101    3300   0.3
i2   12.9   5       0.2    9.108    5900   0.4    59     14     0.6
i8   15     4.7     2.5    8600     8900   900    13     11.1   0.7
i11  17.9   7       0.4    4.091    3000   0.1
i9   22     7       0.6    10.031   1000   0.2    30     40
i9   22.1   7       0.2    10.042   1000   0.9    26     37
i9   22.3   6.2     0.9    10.049   1005   0.1    32     29
i9   22.6   5.8     0.4    10.021   1010   0.6    41     34
i11  25.2   5.3     0.3    5.111    2500   0.2
i11  26.9   5.1     0.2    4.093    2330   0.1
i13  27.1   4       0.4    12.064   2000   40     7
i13  28.9   4       0.4    11.117   2000   30.0   5
i9   29.3   9       0.8    8.098    1000   0.3    33     27
i9   30.8   7       0.2    8.087    1200   0.7    39     31
i9   31.2   7.2     0.9    8.071    1400   0.9    29     40
i2   32.9   5       0.9    8.113    5000   0.8    45     20     1
i8   33.1   7       2      5000     6000   1000   17     15     0.3
i2   33.3   6       0.9    7.097    5100   0.5    51     18     0.3
i11  34     5       0.3    4.111    2000   0.5
i8   34.5   6       2      3000     100    500    8.3    9.8    0.1
i2   34.9   6       0.9    9.108    2900   0.4    59     14     0.4
i2   35     5       0.9    8.042    2800   0.6    39     20     0.3
i11  36.1   5       0.5    3.119    1200   0.4
i11  36.8   7       0.2    5.118    1800   0.4
i11  38     6       0.2    4.031    2000   0.2
i11  39     4       0.3    6.003    1300   0.1
i99  42     3.6     8.3
i4   42     1       9.6    13.061   3000   8000   20     10     0.9
i4   42     0.99    9.6    13.013   3110   6000   30     6      0.3
i4   42     1.01    9.6    12.119   2999   10000  25     15     0.7
i5   43     1.1     9.6    3.106    2500   0.4    1.0    8      3    17  34
i5   43.1   1       9.6    4.034    2500   0.2    0.1    2      7    19  29
i99  45.6   4.9     3.2
i5   45.6   3       3.2    4.022    2300   0.3    1.0    11     4    20  37
i5   46.1   2.4     3.2    3.049    2400   0.2    0.1    5      8    19  27
i99  50.5   5.5     8.3
i4   50.5   0.7     11     11.059   3000   7000   40     9      0.9
i4   50.5   0.7     11     10.038   3000   10000  20     20     0.7
i4   50.5   0.71    11     13.077   3000   9500   25     5      0.8
i4   50.52  0.64    11     12.016   3000   8500   18     14     0.5
i5   51     1.5     11     4.011    2000   0.1    1.0    3      11   13  28
i5   51     1.5     11     3.106    2000   0.4    0.1    7      5    15  34
s
;============================================================================; 
;========================= SECTION IV: 100 SECONDS  =========================;
;============================================================================; 
;========================= VARIABLE TEMPO ===================================;
t 0 60 40 60 45 30 49 40 52 90 55 100 58 160 59 200 61 230 65 270 78 40
;============================================================================;
i99  0      1       2.8
i4   0      1       6.8    12.013   3700   9000   40     17     0.5
i4   0.01   1       6.8    12.061   3501   8500   30     20     0.3
i4   0.02   1       6.8    11.119   3399   7780   32     22     0.8
i4   0.03   1       6.8    12.042   3010   8600   41     27     0.45
i99  1      3.4     9.8
i12  1      3       6.8    5.06     1000   100    7000   16     0.2
i12  1.03   2.9     6.8    5.02     1000   60     6000   30     0.2
i99  4.4    3.6     4.8
i12  4.4    2.6     6.8    11.09    2000   1000   200    5      0.1
i99  8      2.1     7
i4   8      0.9     11     10.013   3000   9000   40     17     0.9
i4   8.1    0.9     11     10.061   3001   8500   30     20     0.8
i4   8.2    0.9     11     10.119   2999   7780   32     22     0.7
i99  10.1   1.1     21
i12  10.1   0.6     11     11.02    1000   1500   300    4      0.2
i99  11.2   6.8     2
i10  11.2   6       0      4.092    3000   0.3    6.9    200
i10  11.2   10      0      4.113    3000   0.1    7.2    278
i12  13     1.6     0.3    10.01    3000   2000   500    5.2    0.2
i10  13     1.6     0.4    9.012    3000   0.3    21     31
i4   15     0.7     0.4    13.023   5000   9000   40     17     0.9
i4   15     0.7     0.4    13.081   5001   8500   30     20     0.3
i4   15     0.7     0.4    13.019   4999   7780   32     22     0.7
i4   15     0.7     0.4    13.079   4550   9699   50     30     0.5
i4   15.7   1       0.4    9.013    1101   9000   40     17     0.9
i4   15.7   1       0.4    10.051   1051   8500   30     20     0.6
i4   15.7   1       0.4    7.119    1111   7780   32     22     0.2
i4   15.7   1       0.4    8.099    1100   10000  100    27     0.8
i12  17     2       0.4    9.02     3000   3000   1000   4      0.3
i99  18     3       9.3
i10  18     5       0      11.09    900    0.4    23     33
i10  18.1   5       0      11.08    900    0.4    20     40
i10  18.3   5       0      11.073   900    0.4    30     27
i10  18.6   5       0      11.068   900    0.4    33     33
i10  19     10      0      11.001   500    0.8    8      200
i10  20     9       0      11.022   500    0.8    9      300
i10  20.4   8.6     0      11.091   500    0.8    5      223
i99  21     56      0.15
i10  21     18      0      11.115   500    0.8    6.4    311
i10  21.6   17.4    0      12.041   500    0.8    7      276
i10  21.9   2.9     0      5.002    2000   0.3    4.1    200
i10  25.3   3.5     0      5.031    2300   0.5    3.6    160
i10  30.9   3.9     0      5.017    2500   0.7    3      100
i10  36.3   6.1     0      4.097    1770   0.8    4      200
i10  42     34.09   0      4.0017   6000   0.19   4.1    310
i8   45     26.9    0.79   190      500    11     1.9    2.7    0.1
i8   49     22.9    0.80   10000    8000   300    11     12.6   0.2
i8   52     19.1    0.85   7000     10000  16     4.1    4.8    0.3
i8   55     16.9    0.91   500      190    10     2.9    1.3    0.2
i8   58     13.9    0.98   40       9000   379    33     19     0.1
i8   60     12.9    0.99   3600     11000  19     17     22     0.3
i8   61     11.9    1.01   2000     3000   30     4      18.8   0.2
i99  77     23      0.09
i4   77     1.7     0.3    13.079   850    9699   50     30     0.8
i10  77.1   2.14    0      13.03    600    0.5    60     26
i10  77.6   2.3     0      13.02    800    0.6    62     24
i10  78.3   9.9     0      5.004    900    0.2    4.1    160
i10  78.7   9.8     0      5.001    800    0.3    1.4    220
i2   80.4   9       0      7.077    930    0.8    26     21     0.23
i2   80.7   8       0      8.077    830    0.7    24     19     0.13
i4   81.9   1.9     0.7    11.079   950    7699   40     20     0.7
i4   82     2.8     0.5    10.079   850    5699   60     40     0.5
i10  82.11  5.3     0      3.053    1800   0.1    4.0    210
i10  82.14  3.8     0      4.048    1100   0.2    71     33
i10  82.32  3.1     0      5.049    1000   0.2    68     27
i10  82.06  2.9     0      5.051    900    0.2    72     31
i10  84.04  9.9     0      4.003    1800   0.1    4.1    160
i10  84.06  9.8     0      4.002    1900   0.3    1.4    220
i10  84.618 9.8     0      5.005    900    0.4    4.1    180
e
;============================================================================; 
;======================= TOTAL TIME: 283 SECONDS ============================;
;============================================================================; 

</CsScore>
</CsoundSynthesizer>
