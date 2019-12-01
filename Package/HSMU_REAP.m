(* ::Package:: *)

(* ::Input::Initialization:: *)
BeginPackage["HSMUFeb28`"]
Needs["REAP`RGEMSSM`"]
Needs["REAP`RGEPlotUtilities`"]
Needs["MixingParameterTools`MPT3x3`"]


inp::usage="inp[M2_,Delta_,A21_,B32_,Ph1_,Ph2_]"
Mnu::usage="Mnu[mu_]"
Ye::usage="Ye[mu_]"
MixingPars::usage="MixingPars[mu_]"
MixingParsLogScale::usage="MixingParsLogScale[x_]"
NuMasses::usage="NuMasses[mu_]"
NuMassesLogScale::usage="NuMassesLogScale[x_]"
Xaxis::usage="Xaxis[t_]"
\[Theta]12::usage="\[Theta]12[t_]"
\[Theta]13::usage="\[Theta]13[t_]"
\[Theta]23::usage="\[Theta]23[t_]"
\[Delta]::usage="\[Delta][t_]"
\[CurlyPhi]1::usage="\[CurlyPhi]1[t_]"
\[CurlyPhi]2::usage="\[CurlyPhi]2[t_]"
m1::usage="m1[t_]"
m2::usage="m2[t_]"
m3::usage="m3[t_]"
\[CapitalDelta]m2sol::usage="\[CapitalDelta]m2sol[t_]"
\[CapitalDelta]m2atm::usage="\[CapitalDelta]m2atm[t_]"
\[Xi]::usage="\[Xi][t_]"
Yu::usage="Yu[mu_]"
Yd::usage="Yd[mu_]"
QuarkMixPars::usage="QuarkMixPars[mu_]"
q\[Theta]12::usage="q\[Theta]12[t_]"
q\[Theta]13::usage="q\[Theta]13[t_]"
q\[Theta]23::usage="q\[Theta]23[t_]"
q\[Delta]::usage="q\[Delta][t_]"
xal::usage="xal[Mal_,Mw_]"
yal::usage="yal[Mal_,Mw_]"
Tal::usage="Tal[Mal_,Mw_]"
maker::usage="maker[dim_]"
Begin["`Private`"]

inp[M2_,Delta_,A21_,B32_,Ph1_,Ph2_]:=Module[{c},c=Array[{},7];gm2=M2;a21=A21;b32=B32;ph1=Ph1;
ph2=Ph2;
RGEReset[];
ClearAll[MZ,GUT,tanb,cutoff];
MZ=91.1876;
GUT=10^14;
tanb= 55;
cutoff= 2000;(*SUSY scale*)
RGEAdd["MSSM0N", RGEModelVariant-> "2Loop", RGEtan\[Beta]->tanb];
RGEAdd["SM0N", RGECutoff-> cutoff,RGEvEW-> 246];
RGESetInitial[MZ, 
RGEq\[Delta]->68.92506047087859`Degree ,
RGEm-> 125,
RGE\[Lambda]-> 0.12909808976138543`,
RGEg1->0.46147575247254274`,
RGEg2->0.6519077648635868`,
RGEg3->1.219777963704922`,
RGEq\[Theta]12-> 13.023003721421098` Degree,
RGEq\[Theta]13-> 0.20110859903870226` Degree,
RGEq\[Theta]23-> 2.3612660651557302` Degree,
RGEyd-> 0.000016211716446715967`,
RGEys-> 0.000327683630305961`,
RGEyb->0.016441669871492082`,
RGEye->2.797211832653518`*^-6,
RGEy\[Mu]->0.0005905096657731417`,
RGEy\[Tau]->0.010038444293532633`,
RGEyu-> 7.933393154775898`*^-6,
RGEyc-> 0.003667757125179003`,
RGEyt-> 0.9893746100992263`,
RGEq\[CurlyPhi]1->0,RGEq\[CurlyPhi]2->0,RGEq\[Delta]e-> 0,RGEq\[Delta]\[Mu]-> 0,RGEq\[Delta]\[Tau]-> 0,RGE\[CurlyPhi]1->0,RGE\[CurlyPhi]2->0,RGE\[Delta]e-> 0,RGE\[Delta]\[Mu]-> 0,RGE\[Delta]\[Tau]-> 0
];
RGESolve[MZ, 10^14];
ClearAll[gh,gw,gc,yup,ydown,ylep,theta12,theta13,theta23,del];
gh=RGEGetSolution[GUT, RGECoupling][[1]]// Chop;
gw=RGEGetSolution[GUT, RGECoupling][[2]]// Chop;
gc=RGEGetSolution[GUT, RGECoupling][[3]]// Chop;
(yup=RGEGetSolution[GUT, RGEYu]);
(ydown=RGEGetSolution[GUT, RGEYd]);
(ylep=RGEGetSolution[GUT, RGEYe]);
CKMParameters[yup,ydown];
theta12= CKMParameters[yup,ydown][[1,1]];
theta13= CKMParameters[yup,ydown][[1,2]];
theta23= CKMParameters[yup,ydown][[1,3]];
(*del= CKMParameters[yup,ydown][[1,4]];
del=11;*)
gm1= gm2 Sqrt[1-a21];
gm3=gm2 Sqrt[1+ b32];
RGEAdd["MSSM0N",RGEtan\[Beta]->tanb, RGEModelVariant-> "2Loop"];
RGEAdd["SM0N",RGECutoff->cutoff];
RGESetInitial[GUT,
RGEg1->gh,
RGEg2->gw,
RGEg3->gc,
RGEYu-> yup,
RGEYd->ydown,
RGEYe->ylep,
RGE\[Theta]12-> theta12,RGE\[Theta]13-> theta13,RGE\[Theta]23-> theta23,
RGE\[Delta]-> Delta,
RGE\[CurlyPhi]1->ph1 ,RGE\[CurlyPhi]2->ph2 ,
RGE\[Delta]e-> 0,RGE\[Delta]\[Mu]-> 0,RGE\[Delta]\[Tau]-> 0,
RGEMlightest-> gm1,RGE\[CapitalDelta]m2atm-> gm3^2-gm2^2,RGE\[CapitalDelta]m2sol-> gm2^2-gm1^2
];
RGESolve[MZ,10^14];

g2cut=RGEGetSolution[cutoff, RGECoupling][[2]]// Chop;
Mwino=400;
ratio=1.44;
mstau=2000;
selec=ratio*mstau;
th12=\[Theta]12[Log[10,cutoff]] Degree;
phi1= \[CurlyPhi]1[Log[10,cutoff]]Degree;
phi2= \[CurlyPhi]2[Log[10,cutoff]]Degree;
mcom=((m1[Log[10,cutoff]]+ m2[Log[10,cutoff]]+m3[Log[10,cutoff]])* 10^(-9))/3;
Dm21= (4 mcom^2 ((Sin[th12]^2 Cos[2 phi2]-Cos[th12]^2 Cos[2 phi1])Tal[ selec,Mwino]+ (Cos[th12]^2 Cos[2 phi2]-Sin[th12]^2 Cos[2 phi1])(Tal[ cutoff,Mwino]+Tal[cutoff,Mwino])/2 )) 10^(18);
delm21= (4 mcom^2 (-Sin[th12]^2+Cos[th12]^2) (-Tal[ selec,Mwino] +(Tal[ cutoff,Mwino]+Tal[cutoff,Mwino])/2)) 10^18;
Dmsol=\[CapitalDelta]m2sol[Log[10,MZ]]+Dm21;
Dm32= (4 mcom^2 (-Tal[selec,Mwino]Sin[th12]^2 Cos[2 phi2] + (1- Cos[th12]^2 Cos[2 phi1])(Tal[ cutoff,Mwino]+Tal[cutoff,Mwino])/2 )) 10^18;
delm32= (4 mcom^2 (Sin[th12]^2) (-Tal[ selec,Mwino] +(Tal[ cutoff,Mwino]+Tal[cutoff,Mwino])/2)) 10^18;
Dmatm=\[CapitalDelta]m2atm[Log[10,MZ]]+Dm32;

c12=Cos[\[Theta]12[Log[10,MZ]]Degree];
s12=Sin[\[Theta]12[Log[10,MZ]]Degree];
c13=Cos[\[Theta]13[Log[10,MZ]]Degree];
s13=Sin[\[Theta]13[Log[10,MZ]]Degree];
c23=Cos[\[Theta]23[Log[10,MZ]]Degree];
s23=Sin[\[Theta]23[Log[10,MZ]]Degree];
zm1= m1[Log[10,MZ]];
zm2= m2[Log[10,MZ]];
zm3= m3[Log[10,MZ]];
zmee =Abs[zm1* c12^2*c13^2 + zm2* s12^2*c13^2*Exp[2 I(\[CurlyPhi]2[Log[10,MZ]]-\[CurlyPhi]1[Log[10,MZ]]) ] + zm3*s13^2*Exp[2 I(\[Delta][Log[10,MZ]]+\[CurlyPhi]1[Log[10,MZ]]) ]];
zme = Sqrt[zm1^2* c12^2*c13^2 + zm2^2* s12^2*c13^2 + zm3^2*s13^2];
Utau1=Abs[s12 s23-c12 s13 c23  Exp[ I \[Delta][Log[10,MZ]]]];
Umu1=Abs[-s12 c23-c12 s13 s23  Exp[ I \[Delta][Log[10,MZ]]]];
Utau2=Abs[-c12 s23-s12 s13 c23  Exp[ I \[Delta][Log[10,MZ]]]];
Umu2=Abs[c12 c23-s12 s13 s23  Exp[ I \[Delta][Log[10,MZ]]]];

c[[1]]=\[Theta]12[Log[10,MZ]];
c[[2]]=\[Theta]13[Log[10,MZ]];
c[[3]]=\[Theta]23[Log[10,MZ]];
c[[4]]=Dmatm;
c[[5]]=Dmsol;
c[[6]]=\[Delta][Log[10,MZ]];
c[[7]]=zmee;
(*c[[6]]=m1[Log[10,MZ]];
c[[7]]=m2[Log[10,MZ]];
c[[8]]=m3[Log[10,MZ]];*)
(*Print["Subscript[\[Theta], 12](Subscript[M, Z])=",\[Theta]12[Log[10,MZ]],"\[Degree]"];
Print["Subscript[\[Theta], 13](Subscript[M, Z])=",\[Theta]13[Log[10,MZ]],"\[Degree]"];
Print["Subscript[\[Theta], 23](Subscript[M, Z])=",\[Theta]23[Log[10,MZ]],"\[Degree]"];
Print["Subscript[\[CapitalDelta]m^2, atm](Subscript[M, Z])=",\[CapitalDelta]m2atm[Log[10,MZ]],"eV^2"];
Print["Subscript[\[CapitalDelta]m^2, sol](Subscript[M, Z])=",\[CapitalDelta]m2sol[Log[10,MZ]],"eV^2"];
Print["Subscript[m, 1](Subscript[M, Z])=",m1[Log[10,MZ]],"eV"];
Print["Subscript[m, 2](Subscript[M, Z])=",m2[Log[10,MZ]],"eV"];
Print["Subscript[m, 3](Subscript[M, Z])=",m3[Log[10,MZ]],"eV"];
Print["Sin^2 Subscript[\[Theta], 12](Subscript[M, Z])=",Sin[\[Theta]12[Log[10,MZ]]Degree]^2];
Print["Sin^2 Subscript[\[Theta], 13](Subscript[M, Z])=",Sin[\[Theta]13[Log[10,MZ]]Degree]^2];
Print["Sin^2 Subscript[\[Theta], 23](Subscript[M, Z])=",Sin[\[Theta]23[Log[10,MZ]]Degree]^2];*)
c];
Mnu[mu_]:=RGEGetSolution[mu,RGEMNu]//Chop;
Ye[mu_]:=RGEGetSolution[mu,RGEYe]//Chop;
(*ClearAll[MixingPars,MixingParsLogScale,NuMasses,NuMassesLogScale];*)

MixingPars[mu_]:=MNSParameters[Mnu[mu],Ye[mu]][[1]];
MixingParsLogScale[x_]:=MixingPars[10^x];
NuMasses[mu_]:=MNSParameters[Mnu[mu],Ye[mu]][[2]];
NuMassesLogScale[x_]:=NuMasses[10^x];

(*ClearAll[Xaxis,\[Theta]12,\[Theta]13,\[Theta]23,\[Delta],\[CurlyPhi]1,\[CurlyPhi]2,m1,m2,m3,\[CapitalDelta]m2sol,\[CapitalDelta]m2atm,\[Xi]]*)

Xaxis[t_]:= 10^t;
\[Theta]12[t_]:=MixingParsLogScale[t][[1]]/Degree;
\[Theta]13[t_]:=MixingParsLogScale[t][[2]]/Degree;
\[Theta]23[t_]:=MixingParsLogScale[t][[3]]/Degree;
\[Delta][t_]:=MixingParsLogScale[t][[4]]/Degree;
\[CurlyPhi]1[t_]:=MixingParsLogScale[t][[8]]/Degree;
\[CurlyPhi]2[t_]:=MixingParsLogScale[t][[9]]/Degree;
m1[t_]:=NuMassesLogScale[t][[1]];
m2[t_]:=NuMassesLogScale[t][[2]];
m3[t_]:=NuMassesLogScale[t][[3]];
\[CapitalDelta]m2sol[t_]:=m2[t]^2-m1[t]^2;
\[CapitalDelta]m2atm[t_]:=m3[t]^2-m2[t]^2;
\[Xi][t_]:= \[CapitalDelta]m2sol[t]/\[CapitalDelta]m2atm[t];
Yu[mu_]:=RGEGetSolution[mu,RGEYu]//Chop;
Yd[mu_]:=RGEGetSolution[mu,RGEYd]//Chop;
QuarkMixPars[mu_]:=CKMParameters[Yu[mu],Yd[mu]][[1]];
QuarkMixParsLogScale[x_]:= QuarkMixPars[10^x];
q\[Theta]12[t_]:=QuarkMixParsLogScale[t][[1]]/Degree;
q\[Theta]13[t_]:=QuarkMixParsLogScale[t][[2]]/Degree;
q\[Theta]23[t_]:=QuarkMixParsLogScale[t][[3]]/Degree;
q\[Delta][t_]:=QuarkMixParsLogScale[t][[4]]/Degree;
xal[Mal_,Mw_]:= Mal/Mw;
yal[Mal_,Mw_]:= 1- xal[Mal,Mw]^2;
Tal[Mal_,Mw_]:=(g2cut^2/(32 Pi^2))((xal[cutoff,Mw]^2- xal[Mal,Mw]^2)/(yal[cutoff,Mw]yal[Mal,Mw])+((yal[Mal,Mw]^2-1)/yal[Mal,Mw]^2)Log[xal[Mal,Mw]^2]-((yal[cutoff,Mw]^2-1)/yal[cutoff,Mw]^2)Log[xal[cutoff,Mw]^2])

(*Tal[cutoff,Mwino];
Tal[ selec,Mwino];*)
(**)

End[]

EndPackage[]
