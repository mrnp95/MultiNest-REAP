(* The package `REAP' is written for Mathematica 7 and is distributed under the
terms of GNU Public License http://www.gnu.org/copyleft/gpl.html *)




BeginPackage["REAP`RGE2HDM`",{"REAP`RGESymbol`", "REAP`RGESolver`","REAP`RGEUtilities`", "REAP`RGEParameters`","REAP`RGEInitial`","MixingParameterTools`MPT3x3`",
"REAP`RGESM`","REAP`RGE2HDM0N`"}];



(* register 2HDM *)
RGERegisterModel["2HDM","REAP`RGE2HDM`",
	`Private`GetParameters,
        `Private`SolveModel,
        {RGE\[Kappa]1->`Private`Get\[Kappa]1,RGEMd->`Private`GetMd,RGEMe->`Private`GetMe,RGERawM\[Nu]r->`Private`GetRawM\[Nu]r,RGEY\[Nu]->`Private`GetY\[Nu],RGERaw->`Private`GetRawSolution,RGE\[Alpha]->`Private`Get\[Alpha],RGEMNu->`Private`GetM\[Nu],RGECoupling->`Private`GetCoupling,RGEPoleMTop->`Private`GetPoleMTop,RGEYd->`Private`GetYd,RGEM1Tilde->`Private`GetM1Tilde,RGE\[Lambda]->`Private`Get\[Lambda],RGEMNur->`Private`GetM\[Nu]r,RGEAll->`Private`GetSolution,RGEMu->`Private`GetMu,RGERawY\[Nu]->`Private`GetRawY\[Nu],RGEMixingParameters->`Private`GetMixingParameters,RGE\[Kappa]2->`Private`Get\[Kappa]2,RGEYu->`Private`GetYu,RGETwistingParameters->`Private`GetTwistingParameters,RGEYe->`Private`GetYe},
{{"2HDM0N",`Private`Trans2HDM0N},{"MSSM",`Private`TransMSSM},{"2HDM",`Private`Trans2HDM}},
        `Private`GetInitial,
        `Private`ModelSetOptions,
        `Private`ModelGetOptions
         ];


Begin["`Private`"];
Map[Needs,{"REAP`RGESymbol`", "REAP`RGESolver`","REAP`RGEUtilities`", "REAP`RGEParameters`","REAP`RGEInitial`","MixingParameterTools`MPT3x3`","REAP`RGESM`","REAP`RGE2HDM0N`"}];

ModelName="2HDM";
ModelVariants={"1Loop"};
RGE={RGE1Loop};

ClearAll[GetRawSolution];
GetRawSolution[pScale_,pSolution_,pOpts___]:=Block[{},
(* returns all parameters of the SM *)
        Return[(ParametersFunc[pScale]/.pSolution)[[1]]];
];

ClearAll[GetRawM\[Nu]r];
GetRawM\[Nu]r[pScale_,pSolution_,pOpts___]:=Block[{lM},
(* returns the mass matrix of the heavy neutrinos *)
	lM=(M\[Nu]r[pScale]/.pSolution)[[1]];
        Return[lM];
];

ClearAll[GetRawY\[Nu]];
GetRawY\[Nu][pScale_,pSolution_,pOpts___]:=Block[{},
(* returns the Yukawa coupling matrix of the neutrinos *)
    Return[(Y\[Nu][pScale]/.pSolution)[[1]]];
];

ClearAll[GetCoupling];
GetCoupling[pScale_,pSolution_,pOpts___]:=Block[{},
(* returns the coupling constants *)
   Return[({g1[pScale],g2[pScale],g3[pScale]}/.pSolution)[[1]]];
];

ClearAll[Get\[Alpha]];
Get\[Alpha][pScale_,pSolution_,pOpts___]:=Block[{lg},
(* returns the fine structure constants *)
    lg=({g1[pScale],g2[pScale],g3[pScale]}/.pSolution)[[1]];
    Return[lg^2/(4*Pi)];
];

ClearAll[Get\[Lambda]];
Get\[Lambda][pScale_,pSolution_,pOpts___]:=Block[{},
(* returns the higgs couplings *)
   Return[({\[Lambda]1[pScale],\[Lambda]2[pScale],\[Lambda]3[pScale],\[Lambda]4[pScale],\[Lambda]5[pScale]}/.pSolution)[[1]]];
];

(* GetM\[CapitalDelta]2 is not a function of 2HDM *)
(* GetM\[CapitalDelta] is not a function of 2HDM *)
ClearAll[GetYe];
GetYe[pScale_,pSolution_,pOpts___]:=Block[{},
(* returns the Yukawa coupling matrix of the charged leptons *)
    Return[(Ye[pScale]/.pSolution)[[1]]];
];

ClearAll[GetYu];
GetYu[pScale_,pSolution_,pOpts___]:=Block[{},
(* returns the Yukawa coupling matrix of the up-type quarks *)
    Return[(Yu[pScale]/.pSolution)[[1]]];
];

ClearAll[GetYd];
GetYd[pScale_,pSolution_,pOpts___]:=Block[{},
(* returns the Yukawa coupling matrix of the down-type quarks *)
    Return[(Yd[pScale]/.pSolution)[[1]]];
];

(* GetRawY\[CapitalDelta] is not a function of 2HDM *)
ClearAll[GetY\[Nu]];
GetY\[Nu][pScale_,pSolution_,pOpts___]:=Block[{lY\[Nu],lY\[Nu]Rotated,lM,lIntegratedOut,lLenM,lMhigh,lf,lg,lMEval,lCutoff,lUp},
(* returns the Yukawa couplings of the neutrinos *)
        lOpts;
        Options[lOpts]=Options[RGEOptions];
        SetOptions[lOpts,RGEFilterOptions[lOpts,pOpts]];
        lIntegratedOut=(RGEIntegratedOut/.Options[lOpts]);

	lY\[Nu]=(Y\[Nu][pScale]/.pSolution)[[1]];

        Catch[
          If[lIntegratedOut>0,
            lCutoff=RGEGetCutoff[Exp[pScale],1];
	    lUp=RGEGetRange[][[2]];
	    If[lCutoff>Exp[lUp],
		{lMInitial,lY\[Nu]Rotated}=({RGEMNur,RGEY\[Nu]}/.RGEGetInitial[][[2]]);
		lLenM=Length[lMInitial];
		If[lLenM>Length[lM],
		            {lMInitial,lY\[Nu]Rotated}=RGERotateM[lMInitial,lY\[Nu]Rotated];
			    lY\[Nu]=Table[If[lf<=lLenM-lIntegratedOut,lY\[Nu][[lf,lg]],lY\[Nu]Rotated[[lf,lg]]],{lf,lLenM},{lg,lLenM}];
		];

		Throw[lCutoff,RGEScaleTooBig]];
            lY\[Nu]Rotated=RGEGetSolution[lCutoff,RGEY\[Nu],1];
            lM=RGEGetSolution[lCutoff,RGEMNur,1];
            lLenM=Length[lM];
            {lM,lY\[Nu]Rotated}=RGERotateM[lM,lY\[Nu]Rotated];
            lY\[Nu]=Table[If[lf<=lLenM-lIntegratedOut,lY\[Nu][[lf,lg]],lY\[Nu]Rotated[[lf,lg]]],{lf,lLenM},{lg,lLenM}];
          ];
        ,RGEScaleTooBig];
	Return[lY\[Nu]];
];

(* Get\[Kappa] is not a function of 2HDM *)
ClearAll[Get\[Kappa]1];
Get\[Kappa]1[pScale_,pSolution_,pOpts___]:=Block[{l\[Kappa]},
(* returns \[Kappa] *)
	l\[Kappa]=(\[Kappa]1[pScale]/.pSolution)[[1]];
        Return[l\[Kappa]];
];

ClearAll[Get\[Kappa]2];
Get\[Kappa]2[pScale_,pSolution_,pOpts___]:=Block[{l\[Kappa]},
(* returns \[Kappa] *)
	l\[Kappa]=(\[Kappa]2[pScale]/.pSolution)[[1]];
        Return[l\[Kappa]];
];

ClearAll[GetM\[Nu]r];
GetM\[Nu]r[pScale_,pSolution_,pOpts___]:=Block[{lM,lIntegratedOut,lLenM,lMhigh,lf,lg,lMEval,lCutoff,lUp},
(* returns the mass matrix of the heavy neutrinos *)
        lOpts;
        Options[lOpts]=Options[RGEOptions];
        SetOptions[lOpts,RGEFilterOptions[lOpts,pOpts]];
        lIntegratedOut=(RGEIntegratedOut/.Options[lOpts]);
	lM=(M\[Nu]r[pScale]/.pSolution)[[1]];
        Catch[
          If[lIntegratedOut>0,
            lCutoff=RGEGetCutoff[Exp[pScale],1];
	    lUp=RGEGetRange[][[2]];
	    If[lCutoff>Exp[lUp],
	    	lMInitial=(RGEMNur/.RGEGetInitial[][[2]]);
		lLenM=Length[lMInitial];
		If[lLenM>Length[lM],
	            lMEval=Sqrt[Sort[Abs[Eigenvalues[Dagger[lMInitial].lMInitial]],Greater]];
		    lM=Table[
				If[lf==lg, If[lf<=lLenM-lIntegratedOut,lM[[lf,lg]],lMEval[[lLenM-lf+1]] ],
					   If[(lf<=lLenM-lIntegratedOut)&&(lg<=lLenM-lIntegratedOut),lM[[lf,lg]],0]
				],
				{lf,lLenM},{lg,lLenM}
			];
		];
		Throw[lCutoff,RGEScaleTooBig]
	    ];
            lMhigh=RGEGetSolution[lCutoff,RGEMNur,1];
            lLenM=Length[lMhigh];
            lMEval=Sqrt[Sort[Abs[Eigenvalues[Dagger[lMhigh].lMhigh]],Greater]];
            lM=Table[
              If[lf==lg,If[lf<=lLenM-lIntegratedOut,lM[[lf,lg]],lMEval[[lLenM-lf+1]] ],
                        If[(lf<=lLenM-lIntegratedOut)&&(lg<=lLenM-lIntegratedOut),lM[[lf,lg]],0]
              ],
              {lf,lLenM},{lg,lLenM}];
            ];
        ,RGEScaleTooBig];
        Return[lM];
];

ClearAll[GetM\[Nu]];
GetM\[Nu][pScale_,pSolution_,pOpts___]:=Block[{l\[Kappa]1,l\[Kappa]2,lY\[Nu],lM,lM\[Nu]},
(* returns the mass matrix of the neutrinos *)
	{l\[Kappa]1,l\[Kappa]2,lY\[Nu],lM}=({\[Kappa]1[pScale],\[Kappa]2[pScale],Y\[Nu][pScale],M\[Nu]r[pScale]}/.pSolution)[[1]];
	lOpts;
	Options[lOpts]=Options[RGEOptions];
	SetOptions[lOpts,RGEFilterOptions[lOpts,pOpts]];
	If[MatrixConditionNumber[lM]>2*Precision[lM],Print["GetM\[Nu]: The matrix M=", MatrixForm[lM]], " is ill-conditioned and the condition number is ", MatrixConditionNumber[lM]];

	lM\[Nu]=-1/4*(RGEv\[Nu]^2*2*Transpose[lY\[Nu]].(Inverse[lM]*10^9).lY\[Nu]+RGEvEW^2*(l\[Kappa]1*10^9*(1/Sqrt[1+RGEtan\[Beta]^2])^2+l\[Kappa]2*10^9*(RGEtan\[Beta]/Sqrt[1+RGEtan\[Beta]^2])^2))/.Options[lOpts];
	Return[lM\[Nu]];
];

ClearAll[GetMu];
GetMu[pScale_,pSolution_,pOpts___]:=Block[{lMu,lvu,l\[Beta]},
(* returns the mass matrix of the up-type quarks *)
   lOpts;
   Options[lOpts]=Options[RGEOptions];
   SetOptions[lOpts,RGEFilterOptions[lOpts,pOpts]];
   l\[Beta]=ArcTan[RGEtan\[Beta]]/.Options[lOpts,RGEtan\[Beta]];
   lvu=N[(RGEvEW/.Options[lOpts,RGEvEW])*(RGEzu/.Options[lOpts,RGEzu]).{Cos[l\[Beta]],Sin[l\[Beta]]}];
   lMu=lvu/Sqrt[2]*(Yu[pScale]/.pSolution)[[1]];
   Return[lMu];
];

ClearAll[GetPoleMTop];
GetPoleMTop[pScale_,pSolution_,pOpts___]:=Block[{lMtop,lg3,lScale,lPrecision,lCount},
(* returns the mass matrix of the up-type quarks *)
   lPrecision=RGEPrecision/.pOpts/.RGETransition->6;
   lCountMax=RGEMaxNumberIterations/.pOpts/.RGEMaxNumberIterations->20;
   lScale=Exp[pScale];
   lg3=RGEGetSolution[lScale,RGECoupling][[3]];
   lMu=RGEGetSolution[lScale,RGEMu];
   lMtop=Re[Sqrt[Max[Eigenvalues[Dagger[lMu].lMu]]*(1+lg3^2/3/Pi)]];
   lCount=0;
   While[RGEFloor[Abs[lMtop-lScale],RGEPrecision->lPrecision]>0,
	lScale=lMtop;
	lg3=RGEGetSolution[lScale,RGECoupling][[3]];
	lMu=RGEGetSolution[lScale,RGEMu];
	lMtop=Re[Sqrt[Max[Eigenvalues[Dagger[lMu].lMu]]*(1+lg3^2/3/Pi)]];
	lCount++;
	If[lCount>lCountMax,
		Print["RGEGetsolution[pScale,RGEPoleMTop]: algorithm to search transitions does not converge. There have been ",lCount," iterations so far. Returning: ",N[Sort[lTransitions,Greater],lPrecision]];
		Return[lMtop];
            ];
	];
   Return[lMtop];
];

ClearAll[GetMd];
GetMd[pScale_,pSolution_,pOpts___]:=Block[{lMd,lvd,l\[Beta]},
(* returns the mass matrix of the down-type quarks *)
   lOpts;
   Options[lOpts]=Options[RGEOptions];
   SetOptions[lOpts,RGEFilterOptions[lOpts,pOpts]];
   l\[Beta]=ArcTan[RGEtan\[Beta]]/.Options[lOpts,RGEtan\[Beta]];
   lvd=N[(RGEvEW/.Options[lOpts,RGEvEW])*(RGEzd/.Options[lOpts,RGEzd]).{Cos[l\[Beta]],Sin[l\[Beta]]}];
   lMd=lvd/Sqrt[2]*(Yd[pScale]/.pSolution)[[1]];
   Return[lMd];
];

ClearAll[GetMe];
GetMe[pScale_,pSolution_,pOpts___]:=Block[{lMe,lvd,l\[Beta]},
(* returns the mass matrix of the charged leptons *)
   lOpts;
   Options[lOpts]=Options[RGEOptions];
   SetOptions[lOpts,RGEFilterOptions[lOpts,pOpts]];
   l\[Beta]=ArcTan[RGEtan\[Beta]]/.Options[lOpts,RGEtan\[Beta]];
   lvd=N[(RGEvEW/.Options[lOpts,RGEvEW])*Cos[l\[Beta]]];
   lMe=lvd/Sqrt[2]*(Ye[pScale]/.pSolution)[[1]];
   Return[lMe];
];

ClearAll[GetSolution];
GetSolution[pScale_,pSolution_,pOpts___]:=Block[{lg1,lg2,lg3,lYu,lYd,lYe,lM,lY\[Nu],l\[Kappa]1,l\[Kappa]2,l\[Lambda]1,l\[Lambda]2,l\[Lambda]3,l\[Lambda]4,l\[Lambda]5},
(* returns all parameters of the SM *)
        {lg1,lg2,lg3,lYu,lYd,lYe,lY\[Nu],l\[Kappa]1,l\[Kappa]2,lM,l\[Lambda]1,l\[Lambda]2,l\[Lambda]3,l\[Lambda]4,l\[Lambda]5}=(ParametersFunc[pScale]/.pSolution)[[1]];
	lM=GetM\[Nu]r[pScale,pSolution,pOpts];
	lY\[Nu]=GetY\[Nu][pScale,pSolution,pOpts];
        Return[{lg1,lg2,lg3,lYu,lYd,lYe,lY\[Nu],l\[Kappa]1,l\[Kappa]2,lM,l\[Lambda]1,l\[Lambda]2,l\[Lambda]3,l\[Lambda]4,l\[Lambda]5}];
];

ClearAll[GetM1Tilde];
GetM1Tilde[pScale_,pSolution_,pOpts___]:=Block[{lv,lM,lM\[Nu],lm1},
(* returns m1 Tilde *)
   lOpts;
   Options[lOpts]=Options[RGEOptions];
   SetOptions[lOpts,RGEFilterOptions[lOpts,pOpts]];
   lv=(RGEv\[Nu]/Sqrt[2])/.Options[lOpts];
   lM=(M\[Nu]r[pScale]/.pSolution)[[1]];
   lM\[Nu]=lv*(Y\[Nu][pScale]/.pSolution)[[1]];
   {lM,lM\[Nu]}=RGERotateM[lM,lM\[Nu]];
   lM\[Nu]=lM\[Nu][[1]];
   lm1=(lM\[Nu].Conjugate[lM\[Nu]])/lM[[1,1]];
   Return[RGEFloor[Re[lm1]][[1]]*10^9];
];

(* Get\[Epsilon]1Max is not a function of 2HDM *)
(* Get\[Epsilon]1 is not a function of 2HDM *)
(* GetGWCond is not a function of 2HDM *)
(* GetGWConditions is not a function of 2HDM *)
(* GetVEVratio is not a function of 2HDM *)
(* GetVEVratios is not a function of 2HDM *)
ClearAll[ModelName0N];
ModelName0N=ModelName<>"0N";

ClearAll[Dagger];
RGEvu:=N[RGEvEW*RGEzu.{1/Sqrt[1+RGEtan\[Beta]^2],RGEtan\[Beta]/Sqrt[1+RGEtan\[Beta]^2]}];
RGEvd:=N[RGEvEW*RGEzd.{1/Sqrt[1+RGEtan\[Beta]^2],RGEtan\[Beta]/Sqrt[1+RGEtan\[Beta]^2]}];
RGEv\[Nu]:=N[RGEvEW*RGEz\[Nu].{1/Sqrt[1+RGEtan\[Beta]^2],RGEtan\[Beta]/Sqrt[1+RGEtan\[Beta]^2]}];
RGEve:=N[RGEvEW/Sqrt[1+RGEtan\[Beta]^2]];

ClearAll[Dagger];
(*shortcuts*)
Dagger[x_] := Transpose[Conjugate[x]];

ClearAll[GetParameters];
GetParameters[]:= Block[{},
(* returns the parameters of the model *)
   Return[ParameterSymbols];
];

ClearAll[ModelSetOptions];
ModelSetOptions[pOpts_]:= Block[{},
(* sets the options of the model *)
    SetOptions[RGEOptions,RGEFilterOptions[RGEOptions,pOpts]];
];

ClearAll[ModelGetOptions];
ModelGetOptions[]:= Block[{},
(* returns the options *)
   Return[Options[RGEOptions]];
];

ClearAll[GetInitial];
GetInitial[pOpts___]:=Block[{lSuggestion,lIndexSuggestion,lInitial,lParameters,lParameterRepl},
(* returns the suggested initial values *)
   lOpts;
   Options[lOpts]=Options[RGEOptions];
   SetOptions[lOpts,RGEFilterOptions[lOpts,pOpts]];
   lSuggestion=(RGESuggestion/.pOpts)/.{RGESuggestion->"*"};
   lIndexSuggestion=1;
   While[lIndexSuggestion<=Length[Initial] && !StringMatchQ[Initial[[lIndexSuggestion,1]],lSuggestion],	lIndexSuggestion++ ];
   lInitial=Initial[[ lIndexSuggestion,2 ]];
   lParameters=ParameterSymbols/.pOpts/.lInitial/.pOpts/.lInitial/.pOpts/.lInitial/.Options[lOpts];
   Return[Table[ParameterSymbols[[li]]->lParameters[[li]], {li,Length[ParameterSymbols]}]];
   ];

ClearAll[SolveModel];
SolveModel[{pUp_?NumericQ,pUpModel_,pUpOptions_},{pDown_?NumericQ,pDownModel_,pDownOptions_},pDirection_?NumericQ,pBoundary_?NumericQ,pInitial_,pNDSolveOpts_,pOpts___]:=Block[{lSolution, (* contains the solution *)
lInitial, (* initial values in the format needed by NDSolve *)
lODE, (* RGE and lInitial *)
lAddedModels, (* number of added models *)
lIntegratedOut, (* # of neutrinos integrated out *)
lAlreadyIntegratedOut, (* # of neutrinos already inetgrated out *)
lTransition, (* transition to be added *)
lIndexModel, (* variant of the model *)
lM,lY,l\[Kappa]1,l\[Kappa]2,l\[Kappa],l\[Nu] (* needed for check of too high masses *)
},
(* solves the model; returns the solution, the new scale and the number of added models *)
(* exceptions: too many iterations --> RGETooManyIterations
               \[Nu] mass above cutoff --> RGE\[Nu]MassAboveCutoff 
*)
(* solve differential equation *)
	lOpts;
	lAddModelOpts;
        Options[lOpts]=Options[RGEOptions];
        SetOptions[lOpts,RGEFilterOptions[lOpts,pOpts]];
        lLogThresholdFactor=Log[(RGEThresholdFactor/.Options[lOpts,RGEThresholdFactor])];
	lInitial;
	Options[lInitial]=pInitial;
	If[Length[(RGEMNur/.pInitial)]>0,
		{lM,lY\[Nu],l\[Kappa]1,l\[Kappa]2}=({RGEMNur,RGEY\[Nu],RGE\[Kappa]1,RGE\[Kappa]2}/.pInitial);
		l\[Nu]=RGEz\[Nu]/.Options[lOpts];
		l\[Kappa]=l\[Nu].{l\[Kappa]1,l\[Kappa]2};
		{lM,lY,l\[Kappa],lIntegratedOut}=RGETestMY\[Nu][Exp[lLogThresholdFactor+pBoundary],lM,lY\[Nu],l\[Kappa]];
		{l\[Kappa]1,l\[Kappa]2}={l\[Kappa]*l\[Nu][[1]],l\[Kappa]*l\[Nu][[2]]};
		If[lIntegratedOut>0,
			Print["Warning: ",lIntegratedOut, " right-handed neutrinos have a mass above ", Exp[pBoundary], " GeV (",Select[Sqrt[Abs[Eigenvalues[(Dagger[RGEMNur].RGEMNur/.pInitial)]]],(#1>Exp[pBoundary])&],"). Thus they have been integrated out."];
			SetOptions[lOpts,RGEIntegratedOut->(((RGEIntegratedOut/.Options[lOpts,RGEIntegratedOut])/.{RGEIntegratedOut->0})+lIntegratedOut)];

			SetOptions[lInitial,RGEMNur->lM,RGEY\[Nu]->lY,RGE\[Kappa]1->l\[Kappa]1,RGE\[Kappa]2->l\[Kappa]2];
			RGEChangeOptions[Exp[pBoundary],RGEIntegratedOut->(RGEIntegratedOut/.Options[lOpts,RGEIntegratedOut])];
		];
	];
	If[Length[RGEMNur/.Options[lInitial]]==0,
		lTransition=RGEGetCutoff[(Exp[pUp]+Exp[pDown])/2];
		RGEDelModel[(Exp[pUp]+Exp[pDown])/2];
		Options[lAddModelOpts]=RGEFilterOptions[RGEOptions,pOpts];
		SetOptions[lAddModelOpts,RGEFilterOptions[lAddModelOpts,RGEAutoGenerated->ModelName]];
		Options[lAddModelOpts]=Options[lAddModelOpts]~Union~{RGEAutoGenerated->ModelName};
		RGEAddEFT[ModelName0N, RGECutoff->lTransition,RGEFilterOptions[RGEOptions,Options[lAddModelOpts]]];
                RGESetModelOptions[ModelName0N,Options[RGEOptions]];
		{lSolution,lTransition,lAddedModels}=(RGEGetSolveModel[ModelName0N])[{pUp,pUpModel,pUpOptions},{pDown,pDownModel,pDownOptions},pDirection,pBoundary,Options[lInitial],pNDSolveOpts,Sequence[pOpts]];
		Return[{lSolution,lTransition,lAddedModels}];
	];
		
	
	lNDSolveOpts;
	Options[lNDSolveOpts]=Options[NDSolve];
	SetOptions[lNDSolveOpts,RGEFilterOptions[NDSolve,Options[RGEOptions]]];
	SetOptions[lNDSolveOpts,RGEFilterOptions[NDSolve,pOpts]];
	SetOptions[lNDSolveOpts,RGEFilterOptions[NDSolve,Sequence[pNDSolveOpts]]];
	
	lInitial=SetInitial[pBoundary,Options[lInitial]];
	lIndexModel=Flatten[ Position[ModelVariants,(RGEModelVariant/.Options[lOpts])] ][[ 1 ]];
	lODE=RGE[[lIndexModel]]/.Options[lOpts];
        lSolution=NDSolve[lODE ~Join~ lInitial, Parameters,{t,pDown,pUp}, Sequence[Options[lNDSolveOpts]]];
     
(* search transitions *)
        lAddedModels=0;
        lAlreadyIntegratedOut=RGEIntegratedOut/.Options[lOpts,RGEIntegratedOut] /. {RGEIntegratedOut->0};
        lPrecision=RGEPrecision/.Options[lOpts,RGEPrecision];
        lIntegratedOut=0;
(* check whether transitions should not be searched for *)
        If[!(RGESearchTransition/.Options[lOpts,RGESearchTransition]),Return[{lSolution,pDown,lAddedModels}]];
        lDownOpts;
        If[pDownModel!="",
            Options[lDownOpts]=RGEGetModelOptions[pDownModel][[1,2]],
	    Options[lDownOpts]={RGEIntegratedOut->0}
        ];
        SetOptions[lDownOpts,RGEFilterOptions[lDownOpts,pDownOptions]];
(* check whether there can not be any transitions *)
        lLengthM\[Nu]=Length[(M\[Nu]r[pUp]/.lSolution)[[1]] ];

(* to do *)
(*        If[(pDownModel==ModelName0N),If[(lLengthM\[Nu]-(RGEIntegratedOut/.Options[lOpts,RGEIntegratedOut])<=1),Return[{lSolution,pDown,lAddedModels}]]];
        If[(pDownModel==ModelName),If[(RGEIntegratedOut/.Options[lDownOpts,RGEIntegratedOut])-(RGEIntegratedOut/.Options[lOpts,RGEIntegratedOut])<=1,Return[{lSolution,pDown,lAddedModels}]]];
*)
         lMTransitions=RGESearchTransitions[(GetRawM\[Nu]r[#1,lSolution])&, pUp,pUp,pDown,Sequence[Options[lOpts]]];
          
         If[Length[lMTransitions]>0,
             lThreshold=N[lLogThresholdFactor+Max[lMTransitions],lPrecision];
             lMTransitions=N[(Select[lMTransitions,(#1>=lThreshold)&])+lLogThresholdFactor,lPrecision];
             While[Length[lMTransitions]>0,
                 lTransition=First[lMTransitions];
                 lDegeneracy=Length[Select[lMTransitions,(Chop[#1-lTransition,10^(-lPrecision)]==0)&]];
                 lMTransitions=Sort[Select[lMTransitions ,(Chop[#1-lTransition,10^(-lPrecision)]!=0)&],Greater];
                 lIntegratedOut+=lDegeneracy;		 
		 If[lIntegratedOut<lLengthM\[Nu],
			Options[lAddModelOpts]=RGEFilterOptions[RGEOptions,pOpts];
			SetOptions[lAddModelOpts,RGEFilterOptions[lAddModelOpts,RGEIntegratedOut->lIntegratedOut+lAlreadyIntegratedOut,RGEAutoGenerated->True]];
			Options[lAddModelOpts]=Options[lAddModelOpts]~Union~{RGEIntegratedOut->lIntegratedOut+lAlreadyIntegratedOut,RGEAutoGenerated->True};
			RGEAddEFT[ModelName,RGECutoff->Exp[lTransition],RGEFilterOptions[RGEOptions,Options[lAddModelOpts]]],
                        RGESetModelOptions[ModelName0N,Options[RGEOptions]];
			Options[lAddModelOpts]=RGEFilterOptions[RGEOptions,pOpts];
			SetOptions[lAddModelOpts,RGEFilterOptions[lAddModelOpts,RGEAutoGenerated->True]];
			Options[lAddModelOpts]=Options[lAddModelOpts]~Union~{RGEAutoGenerated->True};
			RGEAddEFT[ModelName0N,RGECutoff->Exp[lTransition],RGEFilterOptions[RGEOptions,Options[lAddModelOpts]]]
		 ];
		 lAddedModels++;
		],
	lThreshold=pDown;
	];
	Return[{lSolution,lThreshold,lAddedModels}];    
];


(* definitions for the Minimal Supersymmetric Standard Model (MSSM) *)

ClearAll[RGEOptions];
RGEOptions;
Options[RGEOptions]={   RGEModelVariant->"1Loop", (* different variations of a model can be set here *)
			  RGEAutoGenerated->False, (* used to find automatically generated entries *)
			RGEzu->{0,1}, (* options used to distinguish between different 2HD models *)
			RGEzd->{1,0},
			RGEz\[Nu]->{0,1},
			RGEPrecision->6, (* precision to find transitions *)
                        RGEMaxNumberIterations->20, (* maximum number of iterations in the loops to search transitions *)
                        RGEvEW->246, (* vev of the SM Higgs *)
                        RGEtan\[Beta]->50, (* tan \[Beta]=v2/v1 *)  
                        RGEIntegratedOut->0, (* number of the integrated out neutrinos *)
			RGE\[Lambda]1->0.75, (* initial value for \[Lambda]1 *)
			RGE\[Lambda]2->0.75, (* initial value for \[Lambda]2 *)
			RGE\[Lambda]3->0.2, (* initial value for \[Lambda]3 *)
			RGE\[Lambda]4->0.2, (* initial value for \[Lambda]4 *)
			RGE\[Lambda]5->0.25, (* initial value for \[Lambda]5 *)
			Method->StiffnessSwitching, (* option of NDSolve *)
			RGESearchTransition->True, (* enables/disables the automatic search for transitions *)
                        RGEThresholdFactor->1(* neutrinos are integrated out at RGEThresholdFactor*Mass *)
			}; (* options of the model *)

                        
Parameters={g1,g2,g3,Yu,Yd,Ye,Y\[Nu],\[Kappa]1,\[Kappa]2,M\[Nu]r,\[Lambda]1,\[Lambda]2,\[Lambda]3,\[Lambda]4,\[Lambda]5};
ParameterSymbols={RGEg1,RGEg2,RGEg3,RGEYu,RGEYd,RGEYe,RGEY\[Nu],RGE\[Kappa]1,RGE\[Kappa]2,RGEMNur,RGE\[Lambda]1,RGE\[Lambda]2,RGE\[Lambda]3,RGE\[Lambda]4,RGE\[Lambda]5};

(* initial values of MSSM *)
ClearAll[Initial];
Initial={
{"GUT",{
	RGEg1->0.5828902259929809,
	RGEg2->0.5264896882619359,
	RGEg3->0.5269038670286043,
	RGE\[Kappa]1->0*IdentityMatrix[3],
	RGE\[Kappa]2->0*IdentityMatrix[3],
	RGEYe->DiagonalMatrix[{RGEye,RGEy\[Mu],RGEy\[Tau]}],
	RGEMNur->RGEGetM[RGE\[Theta]12,RGE\[Theta]13,RGE\[Theta]23,RGE\[Delta],RGE\[Delta]e,RGE\[Delta]\[Mu],RGE\[Delta]\[Tau],RGE\[CurlyPhi]1,RGE\[CurlyPhi]2,RGEMlightest,RGE\[CapitalDelta]m2atm,RGE\[CapitalDelta]m2sol,RGEMassHierarchy,RGEv\[Nu],RGEY\[Nu]],
	RGE\[Lambda]1->0.75,
	RGE\[Lambda]2->0.75,
	RGE\[Lambda]3->0.2,
	RGE\[Lambda]4->0.2,
	RGE\[Lambda]5->0.25,
	RGEYd->RGEGetYd[RGEyd,RGEys,RGEyb,RGEq\[Theta]12,RGEq\[Theta]13,RGEq\[Theta]23,RGEq\[Delta],RGEq\[Delta]e,RGEq\[Delta]\[Mu],RGEq\[Delta]\[Tau],RGEq\[CurlyPhi]1,RGEq\[CurlyPhi]2],
	RGEYu->DiagonalMatrix[{RGEyu,RGEyc,RGEyt}],
	RGEq\[Theta]12 -> 12.5216 Degree,
	RGEq\[Theta]13 -> 0.219376 Degree, 
	RGEq\[Theta]23 -> 2.48522 Degree,
	RGEq\[Delta] -> 353.681 Degree,
	RGEq\[CurlyPhi]1 -> 0 Degree,
	RGEq\[CurlyPhi]2 -> 0 Degree, 
	RGEq\[Delta]e -> 0 Degree,
	RGEq\[Delta]\[Mu] -> 0 Degree,
	RGEq\[Delta]\[Tau] -> 0 Degree,
	RGEyu -> 0.94*10^-3*Sqrt[2]/RGEvu,
	RGEyc -> 0.272*Sqrt[2]/RGEvu,
	RGEyt -> 84*Sqrt[2]/RGEvu,
	RGEyd -> 1.94*10^-3*Sqrt[2]/RGEvd,
	RGEys -> 38.7*10^-3*Sqrt[2]/RGEvd,
	RGEyb -> 1.07*Sqrt[2]/RGEvd,
	RGEye -> 0.49348567*10^-3*Sqrt[2]/RGEve,
	RGEy\[Mu] -> 104.15246*10^-3*Sqrt[2]/RGEve,
	RGEy\[Tau] -> 1.7706*Sqrt[2]/RGEve,
	RGEMassHierarchy -> "n",
	RGE\[Theta]12 -> 15 Degree,
	RGE\[Theta]13 -> 0 Degree, 
	RGE\[Theta]23 -> 45 Degree,
	RGE\[Delta] -> 0 Degree,
	RGE\[Delta]e -> 0 Degree,
	RGE\[Delta]\[Mu] -> 0 Degree,
	RGE\[Delta]\[Tau] -> 0 Degree,
	RGE\[CurlyPhi]1 -> 0 Degree,
	RGE\[CurlyPhi]2 -> 0 Degree, 
	RGEMlightest -> 0.03,
	RGE\[CapitalDelta]m2atm -> 6 10^-3, 
	RGE\[CapitalDelta]m2sol -> 3.6 10^-4,
	RGEY\[Nu]33 -> 0.5,
	RGEY\[Nu]Ratio -> 0.1,
	RGEY\[Nu]->RGEGetY\[Nu][RGEY\[Nu]33,RGEY\[Nu]Ratio]
}
},
{"MZ",{
	RGEg1->RGEgMZ[1],
	RGEg2->RGEgMZ[2],
	RGEg3->RGEgMZ[3],
	RGEMNur->RGEGetM[RGE\[Theta]12,RGE\[Theta]13,RGE\[Theta]23,RGE\[Delta],RGE\[Delta]e,RGE\[Delta]\[Mu],RGE\[Delta]\[Tau],RGE\[CurlyPhi]1,RGE\[CurlyPhi]2,RGEMlightest,RGE\[CapitalDelta]m2atm,RGE\[CapitalDelta]m2sol,RGEMassHierarchy,RGEv\[Nu],RGEY\[Nu]],
	RGE\[Kappa]1->0*IdentityMatrix[3],
	RGE\[Kappa]2->0*IdentityMatrix[3],
	RGEYe->DiagonalMatrix[{RGEye,RGEy\[Mu],RGEy\[Tau]}],
	RGE\[Lambda]1->0.75,
	RGE\[Lambda]2->0.75,
	RGE\[Lambda]3->0.2,
	RGE\[Lambda]4->0.2,
	RGE\[Lambda]5->0.25,
	RGEYd->RGEGetYd[RGEyd,RGEys,RGEyb,RGEq\[Theta]12,RGEq\[Theta]13,RGEq\[Theta]23,RGEq\[Delta],RGEq\[Delta]e,RGEq\[Delta]\[Mu],RGEq\[Delta]\[Tau],RGEq\[CurlyPhi]1,RGEq\[CurlyPhi]2],
	RGEYu->DiagonalMatrix[{RGEyu,RGEyc,RGEyt}],
	RGEq\[Theta]12 -> 12.7652 Degree, 
	RGEq\[Theta]13 -> 0.170675 Degree,
	RGEq\[Theta]23 -> 2.14069 Degree,
	RGEq\[Delta] -> 0 Degree,
	RGEq\[CurlyPhi]1 -> 0 Degree,
	RGEq\[CurlyPhi]2 -> 0 Degree, 
	RGEq\[Delta]e -> 0 Degree,
	RGEq\[Delta]\[Mu] -> 0 Degree,
	RGEq\[Delta]\[Tau] -> 0 Degree,
	RGEyu -> 2.33*10^-3*Sqrt[2]/RGEvu,
	RGEyc -> 0.677*Sqrt[2]/RGEvu,
	RGEyt -> 181*Sqrt[2]/RGEvu,
	RGEyd -> 4.69*10^-3*Sqrt[2]/RGEvd,
	RGEys -> 93.4*10^-3*Sqrt[2]/RGEvd,
	RGEyb -> 3.00*Sqrt[2]/RGEvd,
	RGEye -> 0.48684727*10^-3*Sqrt[2]/RGEve,
	RGEy\[Mu] -> 0.10275138*Sqrt[2]/RGEve,
	RGEy\[Tau] -> 1.7467*Sqrt[2]/RGEve,
	RGEMassHierarchy -> "n",
	RGE\[Theta]12 -> 33 Degree,
	RGE\[Theta]13 -> 0 Degree, 
	RGE\[Theta]23 -> 45 Degree,
	RGE\[Delta] -> 0 Degree,
	RGE\[Delta]e -> 0 Degree,
	RGE\[Delta]\[Mu] -> 0 Degree,
	RGE\[Delta]\[Tau] -> 0 Degree,
	RGE\[CurlyPhi]1 -> 0 Degree,
	RGE\[CurlyPhi]2 -> 0 Degree, 
	RGEMlightest -> 0.05,
	RGE\[CapitalDelta]m2atm -> 2.5 10^-3, 
	RGE\[CapitalDelta]m2sol -> 8 10^-5,
	RGEY\[Nu]33 -> 0.5,
	RGEY\[Nu]Ratio -> 0.1,
	RGEY\[Nu]->RGEGetY\[Nu][RGEY\[Nu]33,RGEY\[Nu]Ratio]
	}
}
}; (* a list containing suggestions for initial values *)

ClearAll[RGE1Loop];
RGE1Loop:={	D[g1[t],t]==Betag1[g1[t],g2[t],g3[t],Yu[t],Yd[t],Ye[t],Y\[Nu][t],\[Kappa]1[t],\[Kappa]2[t],M\[Nu]r[t],\[Lambda]1[t],\[Lambda]2[t],\[Lambda]3[t],\[Lambda]4[t],\[Lambda]5[t]],
		D[g2[t],t]==Betag2[g1[t],g2[t],g3[t],Yu[t],Yd[t],Ye[t],Y\[Nu][t],\[Kappa]1[t],\[Kappa]2[t],M\[Nu]r[t],\[Lambda]1[t],\[Lambda]2[t],\[Lambda]3[t],\[Lambda]4[t],\[Lambda]5[t]],
		D[g3[t],t]==Betag3[g1[t],g2[t],g3[t],Yu[t],Yd[t],Ye[t],Y\[Nu][t],\[Kappa]1[t],\[Kappa]2[t],M\[Nu]r[t],\[Lambda]1[t],\[Lambda]2[t],\[Lambda]3[t],\[Lambda]4[t],\[Lambda]5[t]],
		D[Yu[t],t]==BetaYu[g1[t],g2[t],g3[t],Yu[t],Yd[t],Ye[t],Y\[Nu][t],\[Kappa]1[t],\[Kappa]2[t],M\[Nu]r[t],\[Lambda]1[t],\[Lambda]2[t],\[Lambda]3[t],\[Lambda]4[t],\[Lambda]5[t]],
		D[Yd[t],t]==BetaYd[g1[t],g2[t],g3[t],Yu[t],Yd[t],Ye[t],Y\[Nu][t],\[Kappa]1[t],\[Kappa]2[t],M\[Nu]r[t],\[Lambda]1[t],\[Lambda]2[t],\[Lambda]3[t],\[Lambda]4[t],\[Lambda]5[t]],
		D[Ye[t],t]==BetaYe[g1[t],g2[t],g3[t],Yu[t],Yd[t],Ye[t],Y\[Nu][t],\[Kappa]1[t],\[Kappa]2[t],M\[Nu]r[t],\[Lambda]1[t],\[Lambda]2[t],\[Lambda]3[t],\[Lambda]4[t],\[Lambda]5[t]],
		D[Y\[Nu][t],t]==BetaY\[Nu][g1[t],g2[t],g3[t],Yu[t],Yd[t],Ye[t],Y\[Nu][t],\[Kappa]1[t],\[Kappa]2[t],M\[Nu]r[t],\[Lambda]1[t],\[Lambda]2[t],\[Lambda]3[t],\[Lambda]4[t],\[Lambda]5[t]],
		D[\[Kappa]1[t],t]==Beta\[Kappa]1[g1[t],g2[t],g3[t],Yu[t],Yd[t],Ye[t],Y\[Nu][t],\[Kappa]1[t],\[Kappa]2[t],M\[Nu]r[t],\[Lambda]1[t],\[Lambda]2[t],\[Lambda]3[t],\[Lambda]4[t],\[Lambda]5[t]],
		D[\[Kappa]2[t],t]==Beta\[Kappa]2[g1[t],g2[t],g3[t],Yu[t],Yd[t],Ye[t],Y\[Nu][t],\[Kappa]1[t],\[Kappa]2[t],M\[Nu]r[t],\[Lambda]1[t],\[Lambda]2[t],\[Lambda]3[t],\[Lambda]4[t],\[Lambda]5[t]],
		D[M\[Nu]r[t],t]==BetaM\[Nu]r[g1[t],g2[t],g3[t],Yu[t],Yd[t],Ye[t],Y\[Nu][t],\[Kappa]1[t],\[Kappa]2[t],M\[Nu]r[t],\[Lambda]1[t],\[Lambda]2[t],\[Lambda]3[t],\[Lambda]4[t],\[Lambda]5[t]],
		D[\[Lambda]1[t],t]==Beta\[Lambda]1[g1[t],g2[t],g3[t],Yu[t],Yd[t],Ye[t],Y\[Nu][t],\[Kappa]1[t],\[Kappa]2[t],M\[Nu]r[t],\[Lambda]1[t],\[Lambda]2[t],\[Lambda]3[t],\[Lambda]4[t],\[Lambda]5[t]],
		D[\[Lambda]2[t],t]==Beta\[Lambda]2[g1[t],g2[t],g3[t],Yu[t],Yd[t],Ye[t],Y\[Nu][t],\[Kappa]1[t],\[Kappa]2[t],M\[Nu]r[t],\[Lambda]1[t],\[Lambda]2[t],\[Lambda]3[t],\[Lambda]4[t],\[Lambda]5[t]],
		D[\[Lambda]3[t],t]==Beta\[Lambda]3[g1[t],g2[t],g3[t],Yu[t],Yd[t],Ye[t],Y\[Nu][t],\[Kappa]1[t],\[Kappa]2[t],M\[Nu]r[t],\[Lambda]1[t],\[Lambda]2[t],\[Lambda]3[t],\[Lambda]4[t],\[Lambda]5[t]],
		D[\[Lambda]4[t],t]==Beta\[Lambda]4[g1[t],g2[t],g3[t],Yu[t],Yd[t],Ye[t],Y\[Nu][t],\[Kappa]1[t],\[Kappa]2[t],M\[Nu]r[t],\[Lambda]1[t],\[Lambda]2[t],\[Lambda]3[t],\[Lambda]4[t],\[Lambda]5[t]],
		D[\[Lambda]5[t],t]==Beta\[Lambda]5[g1[t],g2[t],g3[t],Yu[t],Yd[t],Ye[t],Y\[Nu][t],\[Kappa]1[t],\[Kappa]2[t],M\[Nu]r[t],\[Lambda]1[t],\[Lambda]2[t],\[Lambda]3[t],\[Lambda]4[t],\[Lambda]5[t]]
};


(* Beta functions of the 2HDM *)
ClearAll[Betag1, Betag2, Betag3, BetaYu, BetaYd, BetaYe, BetaY\[Nu], Beta\[Kappa]1, Beta\[Kappa]2, BetaM\[Nu]r, Beta\[Lambda]1,Beta\[Lambda]2,Beta\[Lambda]3,Beta\[Lambda]4,Beta\[Lambda]5];

(* 1 loop contributions *)

Betag1[g1_,g2_,g3_,Yu_,Yd_,Ye_,Y\[Nu]_,\[Kappa]1_,\[Kappa]2_,M\[Nu]r_,\[Lambda]1_,\[Lambda]2_,\[Lambda]3_,\[Lambda]4_,\[Lambda]5_] :=
	(21/5) * 1/(16*Pi^2) * g1^3;

Betag2[g1_,g2_,g3_,Yu_,Yd_,Ye_,Y\[Nu]_,\[Kappa]1_,\[Kappa]2_,M\[Nu]r_,\[Lambda]1_,\[Lambda]2_,\[Lambda]3_,\[Lambda]4_,\[Lambda]5_] :=
	(-3) * 1/(16*Pi^2) * g2^3;

Betag3[g1_,g2_,g3_,Yu_,Yd_,Ye_,Y\[Nu]_,\[Kappa]1_,\[Kappa]2_,M\[Nu]r_,\[Lambda]1_,\[Lambda]2_,\[Lambda]3_,\[Lambda]4_,\[Lambda]5_] :=
	(-7) * 1/(16*Pi^2) * g3^3;


BetaYd[g1_,g2_,g3_,Yu_,Yd_,Ye_,Y\[Nu]_,\[Kappa]1_,\[Kappa]2_,M\[Nu]r_,\[Lambda]1_,\[Lambda]2_,\[Lambda]3_,\[Lambda]4_,\[Lambda]5_] := Block[{li},
	Return[1/(16*Pi^2) * (
          Yd.(
          + 3/2*Dagger[Yd].Yd
	  + (1/2-2*RGEzu.RGEzd)*Dagger[Yu].Yu
          )
          + (
          - (1/4)*g1^2
	  - 9/4*g2^2
	  - 8*g3^2
	  + RGEzd.{Tr[Dagger[Ye].Ye]+3 Tr[Dagger[Yd].Yd],3 Tr[Dagger[Yd].Yd]}
	  + RGEzd.RGEz\[Nu]*Tr[Dagger[Y\[Nu]].Y\[Nu]]
	  + 3 RGEzd.RGEzu* Tr[Dagger[Yu].Yu]
          )*Yd
          )]
	  ];

BetaYu[g1_,g2_,g3_,Yu_,Yd_,Ye_,Y\[Nu]_,\[Kappa]1_,\[Kappa]2_,M\[Nu]r_,\[Lambda]1_,\[Lambda]2_,\[Lambda]3_,\[Lambda]4_,\[Lambda]5_] := Block[{li},
	Return[1/(16*Pi^2) * (
          Yu.(
          + 3/2*Dagger[Yu].Yu
	  + (1/2-2*RGEzu.RGEzd)*Dagger[Yd].Yd
          )
          + (
          - (17/20)*g1^2
	  - 9/4*g2^2
	  - 8*g3^2
	  + RGEzu.{Tr[Dagger[Ye].Ye]+3 Tr[Dagger[Yu].Yu],3 Tr[Dagger[Yu].Yu]}
	  + RGEzu.RGEz\[Nu]*Tr[Dagger[Y\[Nu]].Y\[Nu]]
	  + 3 RGEzu.RGEzd* Tr[Dagger[Yd].Yd]
          )*Yu
          )]
	  ];

BetaYe[g1_,g2_,g3_,Yu_,Yd_,Ye_,Y\[Nu]_,\[Kappa]1_,\[Kappa]2_,M\[Nu]r_,\[Lambda]1_,\[Lambda]2_,\[Lambda]3_,\[Lambda]4_,\[Lambda]5_] := Block[{li},
	  Return[1/(16*Pi^2) * (
          Ye.(
          + 3/2*Dagger[Ye].Ye
	  + (1/2-2*(RGEz\[Nu].{1,0}))*Dagger[Y\[Nu]].Y\[Nu]
          )
          + (
          - (9/4)*g1^2
	  - 9/4*g2^2
          + Tr[Dagger[Ye].Ye]
	  + (RGEz\[Nu].{1,0})* Tr[Dagger[Y\[Nu]].Y\[Nu]]
	  + 3*(RGEzd.{1,0})* Tr[Dagger[Yd].Yd]
	  + 3*(RGEzu.{1,0})* Tr[Dagger[Yu].Yu]
          )*Ye
          )]
	  ];

BetaY\[Nu][g1_,g2_,g3_,Yu_,Yd_,Ye_,Y\[Nu]_,\[Kappa]1_,\[Kappa]2_,M\[Nu]r_,\[Lambda]1_,\[Lambda]2_,\[Lambda]3_,\[Lambda]4_,\[Lambda]5_] := Block[{li},
	 Return[1/(16*Pi^2) * (
          Y\[Nu].(
          + 3/2*Dagger[Y\[Nu]].Y\[Nu]
	  + (1/2-2*(RGEz\[Nu].{1,0}))*Dagger[Ye].Ye
          )
          + (
          - (9/20)*g1^2
	  - 9/4*g2^2
	  +
	 RGEz\[Nu].{Tr[Dagger[Ye].Ye]+Tr[Dagger[Y\[Nu]].Y\[Nu]],Tr[Dagger[Y\[Nu]].Y\[Nu]]}
	 + 3 RGEz\[Nu].RGEzd Tr[Dagger[Yd].Yd]
	 + 3 RGEz\[Nu].RGEzu Tr[Dagger[Yu].Yu]
          )*Y\[Nu]
          )]
	  ];

BetaM\[Nu]r[g1_,g2_,g3_,Yu_,Yd_,Ye_,Y\[Nu]_,\[Kappa]1_,\[Kappa]2_,M\[Nu]r_,\[Lambda]1_,\[Lambda]2_,\[Lambda]3_,\[Lambda]4_,\[Lambda]5_] := 1/(16*Pi^2) * (
          M\[Nu]r.Conjugate[Y\[Nu]].Transpose[Y\[Nu]]
	  + Y\[Nu].Dagger[Y\[Nu]].M\[Nu]r);


Beta\[Kappa]1[g1_,g2_,g3_,Yu_,Yd_,Ye_,Y\[Nu]_,\[Kappa]1_,\[Kappa]2_,M\[Nu]r_,\[Lambda]1_,\[Lambda]2_,\[Lambda]3_,\[Lambda]4_,\[Lambda]5_] := 1/(16*Pi^2) * (
		 + (-3/2)*(\[Kappa]1.Dagger[Ye].Ye+Transpose[Ye].Conjugate[Ye].\[Kappa]1)
		 + (
		 + 2* Tr[Dagger[Ye].Ye]
		 + (RGEz\[Nu].{1,0})*2*Tr[Dagger[Y\[Nu]].Y\[Nu]]
		 + (RGEzu.{1,0})*6* Tr[Dagger[Yu].Yu]
		 + (RGEzd.{1,0})*6* Tr[Dagger[Yd].Yd]
		 + \[Lambda]1
		 - 3*g2^2
		 )*\[Kappa]1
		 + Conjugate[\[Lambda]5]*\[Kappa]2
	);


Beta\[Kappa]2[g1_,g2_,g3_,Yu_,Yd_,Ye_,Y\[Nu]_,\[Kappa]1_,\[Kappa]2_,M\[Nu]r_,\[Lambda]1_,\[Lambda]2_,\[Lambda]3_,\[Lambda]4_,\[Lambda]5_] := 1/(16*Pi^2) * (
		 + (1/2)*(\[Kappa]2.Dagger[Ye].Ye+Transpose[Ye].Conjugate[Ye].\[Kappa]2)
		 + (
		 + (RGEz\[Nu].{0,1})*2*Tr[Dagger[Y\[Nu]].Y\[Nu]]
		 + (RGEzu.{0,1})*6* Tr[Dagger[Yu].Yu]
		 + (RGEzd.{0,1})*6* Tr[Dagger[Yd].Yd]
		 + \[Lambda]2
		 - 3*g2^2
		 )*\[Kappa]2
		 + \[Lambda]5*\[Kappa]1
	);

Beta\[Lambda]1[g1_,g2_,g3_,Yu_,Yd_,Ye_,Y\[Nu]_,\[Kappa]1_,\[Kappa]2_,M\[Nu]r_,\[Lambda]1_,\[Lambda]2_,\[Lambda]3_,\[Lambda]4_,\[Lambda]5_] := 1/(16*Pi^2) * (
		 + 6 * \[Lambda]1^2
		 + 8 * \[Lambda]3^2
		 + 6 * \[Lambda]3 * \[Lambda]4
		 + \[Lambda]5^2
		 - 3 *\[Lambda]1 * (3*g2^2 +3/5*g1^2)
		 + 3 * g2^4
		 + 3/2 * (3/5 *g1^2 + g2^2)^2
		 + 4 \[Lambda]1 * (
		 + Tr[Dagger[Ye].Ye]
		 + (RGEz\[Nu].{1,0}) Tr[Dagger[Y\[Nu]].Y\[Nu]]
		 + 3*(RGEzd.{1,0}) Tr[Dagger[Yd].Yd]
		 + 3*(RGEzu.{1,0}) Tr[Dagger[Yu].Yu]
		 )
		 - 8 * (
		 + Tr[Dagger[Ye].Ye.Dagger[Ye].Ye]
		 + (RGEz\[Nu].{1,0})* Tr[Dagger[Y\[Nu]].Y\[Nu].Dagger[Y\[Nu]].Y\[Nu]]
		 + 3 * (RGEzd.{1,0})* Tr[Dagger[Yd].Yd.Dagger[Yd].Yd]
		 + 3 * (RGEzu.{1,0})* Tr[Dagger[Yu].Yu.Dagger[Yu].Yu]
		 )
	);


Beta\[Lambda]2[g1_,g2_,g3_,Yu_,Yd_,Ye_,Y\[Nu]_,\[Kappa]1_,\[Kappa]2_,M\[Nu]r_,\[Lambda]1_,\[Lambda]2_,\[Lambda]3_,\[Lambda]4_,\[Lambda]5_] := 1/(16*Pi^2) * (
		 + 6 * \[Lambda]2^2
		 + 8 * \[Lambda]3^2
		 + 6 * \[Lambda]3 * \[Lambda]4
		 + \[Lambda]5^2
		 - 3 *\[Lambda]2 * (3*g2^2 +3/5*g1^2)
		 + 3 * g2^4
		 + 3/2 * (3/5 *g1^2 + g2^2)^2
		 + 4 \[Lambda]2 * (
		 + (RGEz\[Nu].{0,1}) Tr[Dagger[Y\[Nu]].Y\[Nu]]
		 + 3*(RGEzd.{0,1}) Tr[Dagger[Yd].Yd]
		 + 3*(RGEzu.{0,1}) Tr[Dagger[Yu].Yu]
		 )
		 - 8 * (
		 + (RGEz\[Nu].{0,1})* Tr[Dagger[Y\[Nu]].Y\[Nu].Dagger[Y\[Nu]].Y\[Nu]]
		 + 3 * (RGEzd.{0,1})* Tr[Dagger[Yd].Yd.Dagger[Yd].Yd]
		 + 3 * (RGEzu.{0,1})* Tr[Dagger[Yu].Yu.Dagger[Yu].Yu]
		 )
	);


Beta\[Lambda]3[g1_,g2_,g3_,Yu_,Yd_,Ye_,Y\[Nu]_,\[Kappa]1_,\[Kappa]2_,M\[Nu]r_,\[Lambda]1_,\[Lambda]2_,\[Lambda]3_,\[Lambda]4_,\[Lambda]5_] := 1/(16*Pi^2) * (
		 + (\[Lambda]1 + \[Lambda]2) * (3*\[Lambda]3+\[Lambda]4)
		 + 4 * \[Lambda]3^2
		 + 2 * \[Lambda]4^2
		 + 1/2 * \[Lambda]5^2
		 - 3*\[Lambda]3 * (3*g2^2 +3/5* g1^2)
		 +9/4 * g2^4
		 +27/100 *g1^4
		 -9/10*g1^2*g2^2
		 +4 \[Lambda]3*(
		 + Tr[Dagger[Ye].Ye]
		 +Tr[Dagger[Y\[Nu]].Y\[Nu]]
		 +3*Tr[Dagger[Yd].Yd]
		 +3*Tr[Dagger[Yu].Yu]
		 )
		 -4* (
		 + (RGEz\[Nu].{0,1})*Tr[Dagger[Ye].Ye.Dagger[Y\[Nu]].Y\[Nu]]
		 + 3 *((RGEzd.{1,0})*(RGEzu.{0,1})+(RGEzd.{0,1})*(RGEzu.{1,0})) *Tr[Dagger[Yd].Yd.Dagger[Yu].Yu]
		 )
	);

Beta\[Lambda]4[g1_,g2_,g3_,Yu_,Yd_,Ye_,Y\[Nu]_,\[Kappa]1_,\[Kappa]2_,M\[Nu]r_,\[Lambda]1_,\[Lambda]2_,\[Lambda]3_,\[Lambda]4_,\[Lambda]5_] := 1/(16*Pi^2) * (
		 + 2*(\[Lambda]1 + \[Lambda]2) * \[Lambda]4
		 + 4* (2*\[Lambda]3+\[Lambda]4)*\[Lambda]4
		 + 8* \[Lambda]5^2
		 -3*\[Lambda]4 * (3g2^2+3/5*g1^2)
		 +9/5*g1^2*g2^2
		 +4 \[Lambda]4*(
		 + Tr[Dagger[Ye].Ye]
		 +Tr[Dagger[Y\[Nu]].Y\[Nu]]
		 +3*Tr[Dagger[Yd].Yd]
		 +3*Tr[Dagger[Yu].Yu]
		 )
		 -4* (
		 + (RGEz\[Nu].{0,1})*Tr[Dagger[Ye].Ye.Dagger[Y\[Nu]].Y\[Nu]]
		 + 3 *((RGEzd.{1,0})*(RGEzu.{0,1})+(RGEzd.{0,1})*(RGEzu.{1,0})) *Tr[Dagger[Yd].Yd.Dagger[Yu].Yu]
		 )
	);


Beta\[Lambda]5[g1_,g2_,g3_,Yu_,Yd_,Ye_,Y\[Nu]_,\[Kappa]1_,\[Kappa]2_,M\[Nu]r_,\[Lambda]1_,\[Lambda]2_,\[Lambda]3_,\[Lambda]4_,\[Lambda]5_] := 1/(16*Pi^2) * (
             + \[Lambda]5 * (
	     + \[Lambda]1
	     + \[Lambda]2
	     + 8*\[Lambda]3
	     + 12*\[Lambda]4
	     -6*(3/5*g1^2+3g2^2)
	     +2*(
	     +Tr[Dagger[Ye].Ye]
	     +Tr[Dagger[Y\[Nu]].Y\[Nu]]
	     +3*Tr[Dagger[Yd].Yd]
	     +3*Tr[Dagger[Yu].Yu]
	     )
	     )
	
	);
	



(* transition functions *)


ClearAll[Trans2HDM];
Trans2HDM[pScale_?NumericQ,pDirection_?NumericQ,pSolution_,pToOpts_,pFromOpts_]:=Block[{lg1,lg2,lg3,lYu,lYd,lYe,lY\[Nu],lY\[Nu]Rotated,l\[Kappa]1,l\[Kappa]2,lM\[Nu]r,l\[Lambda]1,l\[Lambda]2,l\[Lambda]3,l\[Lambda]4,l\[Lambda]5,lM\[Nu]rRotated,lIntegrateOut, lUforM,lToIntegratedOut,lFromIntegratedOut},
(* make a transition from the 2HDM to the 2HDM *)

(* evaluate the options *)
(* evaluate IntegratedOut in pToOpts and pFromOpts *)
        lToOpts;
        Options[lToOpts]=Options[RGEOptions];
        SetOptions[lToOpts,RGEFilterOptions[lToOpts,pToOpts]];
	lToIntegratedOut=RGEIntegratedOut/.Options[lToOpts,RGEIntegratedOut];
        lFromOpts;
        Options[lFromOpts]=Options[RGEOptions];
        SetOptions[lFromOpts,RGEFilterOptions[lFromOpts,pFromOpts]];
	lFromIntegratedOut=RGEIntegratedOut/.Options[lFromOpts,RGEIntegratedOut];

(* calculate the new parameters *)
	{lg1,lg2,lg3,lYu,lYd,lYe,lY\[Nu],l\[Kappa]1,l\[Kappa]2,lM\[Nu]r,l\[Lambda]1,l\[Lambda]2,l\[Lambda]3,l\[Lambda]4,l\[Lambda]5}=(ParametersFunc[ pScale ]/.pSolution)[[1]];
	{lM\[Nu]rRotated,lY\[Nu]Rotated}=RGERotateM[ lM\[Nu]r,lY\[Nu] ]; (*rotation matrix for lM\[Nu]r*)

	If[lFromIntegratedOut>lToIntegratedOut,
		   (* Print["The model ", RGEGetModel[Exp[pScale]], " at the
		   scale ", Exp[pScale]," pretends to have more particles, but
		   new particles can not be added:
		   ",lFromIntegratedOut,"->",lToIntegratedOut, " Thus the model
		   is changed."]; *)
		   RGEChangeOptions[Exp[pScale],RGEIntegratedOut->lFromIntegratedOut];
		   lToIntegratedOut=lFromIntegratedOut;
		   (*Throw[{lFromIntegratedOut,lToIntegratedOut},RGECanNotAddNewParticles];*)
	   ];
	If[lToIntegratedOut>lFromIntegratedOut,
		lIntegrateOut=lToIntegratedOut-lFromIntegratedOut;
                
			l\[Kappa]1+=(RGEz\[Nu]/.Options[lFromOpts,RGEz\[Nu]])[[1]]*RGEKappaMatching[lM\[Nu]rRotated,lY\[Nu]Rotated,lIntegrateOut];
			l\[Kappa]2+=(RGEz\[Nu]/.Options[lFromOpts,RGEz\[Nu]])[[2]]*RGEKappaMatching[lM\[Nu]rRotated,lY\[Nu]Rotated,lIntegrateOut];
			lY\[Nu]=RGEIntegrateOutY\[Nu][lY\[Nu]Rotated, lIntegrateOut];
			lM\[Nu]r=RGEIntegrateOutM[lM\[Nu]rRotated, lIntegrateOut];
	];

	Return[{RGEg1->lg1,RGEg2->lg2,RGEg3->lg3,RGEYu->lYu,RGEYd->lYd,RGEYe->lYe,RGEY\[Nu]->lY\[Nu],RGE\[Kappa]1->l\[Kappa]1,RGE\[Kappa]2->l\[Kappa]2,RGEMNur->lM\[Nu]r,RGE\[Lambda]1->l\[Lambda]1,RGE\[Lambda]2->l\[Lambda]2,RGE\[Lambda]3->l\[Lambda]3,RGE\[Lambda]4->l\[Lambda]4,RGE\[Lambda]5->l\[Lambda]5}];
];


ClearAll[Trans2HDM0N];
Trans2HDM0N[pScale_?NumericQ,pDirection_?NumericQ,pSolution_,pToOpts_,pFromOpts_]:=Block[{lg1,lg2,lg3,lYu,lYd,lYe,lY\[Nu],lY\[Nu]Rotated,l\[Kappa]1,l\[Kappa]2,lM\[Nu]r,l\[Lambda]1,l\[Lambda]2,l\[Lambda]3,l\[Lambda]4,l\[Lambda]5,lM\[Nu]rRotated, lUforM},
(* make a transition from the 2HDM to the 2HDM w/o heavy neutrinos *)

(* evaluate IntegratedOut in pToOpts and pFromOpts *)
        lToOpts;
        Options[lToOpts]=Options[RGEOptions];
        SetOptions[lToOpts,RGEFilterOptions[lToOpts,pToOpts]];
        lFromOpts;
        Options[lFromOpts]=Options[RGEOptions];
        SetOptions[lFromOpts,RGEFilterOptions[lFromOpts,pFromOpts]];
(* calculate the new parameters *)
	{lg1,lg2,lg3,lYu,lYd,lYe,lY\[Nu],l\[Kappa]1,l\[Kappa]2,lM\[Nu]r,l\[Lambda]1,l\[Lambda]2,l\[Lambda]3,l\[Lambda]4,l\[Lambda]5}=(ParametersFunc[ pScale ]/.pSolution)[[1]];
	{lM\[Nu]rRotated,lY\[Nu]Rotated}=RGERotateM[ lM\[Nu]r,lY\[Nu] ]; (*rotation matrix for lM\[Nu]r*)

	l\[Kappa]1+=(RGEz\[Nu]/.Options[lFromOpts,RGEz\[Nu]])[[1]]*RGEKappaMatching[lM\[Nu]rRotated,lY\[Nu]Rotated,Length[lM\[Nu]r]];
	l\[Kappa]2+=(RGEz\[Nu]/.Options[lFromOpts,RGEz\[Nu]])[[2]]*RGEKappaMatching[lM\[Nu]rRotated,lY\[Nu]Rotated,Length[lM\[Nu]r]];

	Return[{RGEg1->lg1,RGEg2->lg2,RGEg3->lg3,RGEYu->lYu,RGEYd->lYd,RGEYe->lYe,RGE\[Kappa]1->l\[Kappa]1,RGE\[Kappa]2->l\[Kappa]2,RGE\[Lambda]1->l\[Lambda]1,RGE\[Lambda]2->l\[Lambda]2,RGE\[Lambda]3->l\[Lambda]3,RGE\[Lambda]4->l\[Lambda]4,RGE\[Lambda]5->l\[Lambda]5}];
];


ClearAll[TransMSSM];
TransMSSM[pScale_?NumericQ,pDirection_?NumericQ,pSolution_,pToOpts_,pFromOpts_]:=Block[{lg1,lg2,lg3,lYu,lYd,lYe,lM\[Nu]r,lY\[Nu],l\[Kappa]1,l\[Kappa]2,l\[Lambda]1,l\[Lambda]2,l\[Lambda]3,l\[Lambda]4,l\[Lambda]5},
(* make a transition from the SM to the SM *)
(* exceptions: try to add new particles --> CanNotAddNewParticles
*)
        lToOpts;
        Options[lToOpts]=Options[RGEGetModelOptions["MSSM"][[1,2]]];
        SetOptions[lToOpts,RGEFilterOptions[lToOpts,pToOpts]];
        lFromOpts;
        Options[lFromOpts]=Options[RGEOptions];
        SetOptions[lFromOpts,RGEFilterOptions[lFromOpts,pFromOpts]];

(* calculate the new parameters *)
	{lg1,lg2,lg3,lYu,lYd,lYe,lY\[Nu],l\[Kappa]1,l\[Kappa]2,lM\[Nu]r,l\[Lambda]1,l\[Lambda]2,l\[Lambda]3,l\[Lambda]4,l\[Lambda]5}=(ParametersFunc[ pScale ]/.pSolution)[[1]];
	l\[Beta]=N[ArcTan[RGEtan\[Beta]]]/.Options[lToOpts,RGEtan\[Beta]];

	lcb=1/Sqrt[1+RGEtan\[Beta]^2]/.Options[lFromOpts,RGEtan\[Beta]];
	lsb=RGEtan\[Beta]/Sqrt[1+RGEtan\[Beta]^2]/.Options[lFromOpts,RGEtan\[Beta]];
	lTocb=1/Sqrt[1+RGEtan\[Beta]^2]/.Options[lToOpts,RGEtan\[Beta]];
	lTosb=RGEtan\[Beta]/Sqrt[1+RGEtan\[Beta]^2]/.Options[lToOpts,RGEtan\[Beta]];

	lu=(RGEzu/.Options[lFromOpts,RGEzu]).{lcb,lsb}/lTosb;
	ld=(RGEzd/.Options[lFromOpts,RGEzd]).{lcb,lsb}/lTocb;
	l\[Nu]=(RGEz\[Nu]/.Options[lFromOpts,RGEz\[Nu]]).{lcb,lsb}/lTosb;
	le=lcb/lTocb;
	
	Return[{RGEg1->lg1,RGEg2->lg2,RGEg3->lg3,RGEYu->lYu*lu,RGEYd->lYd*ld,RGEYe->lYe*le,RGE\[Kappa]->(l\[Kappa]1+l\[Kappa]2)*(l\[Nu])^2,RGEY\[Nu]->lY\[Nu]*l\[Nu],RGEM->lM}];
];



(* internal functions *)


ClearAll[ParametersFunc];
ParametersFunc[pScale_]:={g1[pScale],g2[pScale],g3[pScale],Yu[pScale],Yd[pScale],Ye[pScale],Y\[Nu][pScale],\[Kappa]1[pScale],\[Kappa]2[pScale],M\[Nu]r[pScale],\[Lambda]1[pScale],\[Lambda]2[pScale],\[Lambda]3[pScale],\[Lambda]4[pScale],\[Lambda]5[pScale]};

ClearAll[SetInitial];
SetInitial[pBoundary_?NumericQ,pInitial_]:=Block[{},
(* sets the initial values *)
   Return[		{g1[pBoundary]==RGEg1,
			g2[pBoundary]==RGEg2,
			g3[pBoundary]==RGEg3,
			Yu[pBoundary]==RGEYu,
			Yd[pBoundary]==RGEYd,
			Ye[pBoundary]==RGEYe,
			Y\[Nu][pBoundary]==RGEY\[Nu],
			\[Kappa]1[pBoundary]==RGE\[Kappa]1,
			\[Kappa]2[pBoundary]==RGE\[Kappa]2,
			M\[Nu]r[pBoundary]==RGEMNur,
			\[Lambda]1[pBoundary]==RGE\[Lambda]1,
			\[Lambda]2[pBoundary]==RGE\[Lambda]2,
			\[Lambda]3[pBoundary]==RGE\[Lambda]3,
			\[Lambda]4[pBoundary]==RGE\[Lambda]4,
			\[Lambda]5[pBoundary]==RGE\[Lambda]5
			}//.pInitial
			];
];

End[]; (* end of `Private`*)


EndPackage[];
