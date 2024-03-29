(* The package `REAP' is written for Mathematica 7 and is distributed under the
terms of GNU Public License http://www.gnu.org/copyleft/gpl.html *)




BeginPackage["REAP`RGESMTriplet`",{"REAP`RGESymbol`","REAP`RGESolver`","REAP`RGEUtilities`","REAP`RGEParameters`","REAP`RGEInitial`","MixingParameterTools`MPT3x3`",
"REAP`RGESMTriplet0N`", "REAP`RGESM`", "REAP`RGESM0N`" (* transtions to these models are possible *)
}];



(* register SMTriplet *)
RGERegisterModel["SMTriplet","REAP`RGESMTriplet`",
	`Private`GetParameters,
        `Private`SolveModel,
        {RGE\[Epsilon]->`Private`Get\[Epsilon],RGEYd->`Private`GetYd,RGEYe->`Private`GetYe,RGEM\[CapitalDelta]2->`Private`GetM\[CapitalDelta]2,RGEPoleMTop->`Private`GetPoleMTop,RGEM1Tilde->`Private`GetM1Tilde,RGECoupling->`Private`GetCoupling,RGE\[Lambda]->`Private`Get\[Lambda],RGEMe->`Private`GetMe,RGE\[Epsilon]1Max->`Private`Get\[Epsilon]1Max,RGE\[Alpha]->`Private`Get\[Alpha],RGETwistingParameters->`Private`GetTwistingParameters,RGEMixingParameters->`Private`GetMixingParameters,RGEMNu->`Private`GetM\[Nu],RGEAll->`Private`GetSolution,RGEY\[Nu]->`Private`GetY\[Nu],RGE\[Kappa]->`Private`Get\[Kappa],RGEMNur->`Private`GetM\[Nu]r,RGERawM\[Nu]r->`Private`GetRawM\[Nu]r,RGEMu->`Private`GetMu,RGE\[Epsilon]1->`Private`Get\[Epsilon]1,RGEYu->`Private`GetYu,RGEMd->`Private`GetMd,RGERawY\[CapitalDelta]->`Private`GetRawY\[CapitalDelta],RGERaw->`Private`GetRawSolution,RGERawY\[Nu]->`Private`GetRawY\[Nu],RGE\[Epsilon]Max->`Private`Get\[Epsilon]Max},
{{"SM",`Private`TransSM},{"SMTriplet",`Private`TransSMTriplet},{"SM0N",`Private`TransSM0N},{"SMTriplet0N",`Private`TransSMTriplet0N}},
        `Private`GetInitial,
        `Private`ModelSetOptions,
        `Private`ModelGetOptions
         ];


Begin["`Private`"];
Map[Needs,{"REAP`RGESymbol`","REAP`RGESolver`","REAP`RGEUtilities`","REAP`RGEParameters`","REAP`RGEInitial`","MixingParameterTools`MPT3x3`","REAP`RGESMTriplet0N`", "REAP`RGESM`", "REAP`RGESM0N`" }];

ModelName="SMTriplet";
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
(* returns the coupling constants *)
   Return[(\[Lambda][pScale]/.pSolution)[[1]]];
];

ClearAll[Get\[Lambda]];
Get\[Lambda][pScale_,pSolution_,pOpts___]:=Block[{},
(* returns the coupling constants *)
   Return[({\[Lambda][pScale],\[CapitalLambda]1[pScale],\[CapitalLambda]2[pScale],\[CapitalLambda]4[pScale],\[CapitalLambda]5[pScale],\[CapitalLambda]6[pScale],M\[CapitalDelta]2[pScale]}/.pSolution)[[1]]];
];

ClearAll[GetM\[CapitalDelta]2];
GetM\[CapitalDelta]2[pScale_,pSolution_,pOpts___]:=Block[{},
(* returns the coupling constants *)
   Return[(M\[CapitalDelta]2[pScale]/.pSolution)[[1]]];
];

(* GetM\[CapitalDelta] is not a function of SMTriplet *)
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

ClearAll[GetRawY\[CapitalDelta]];
GetRawY\[CapitalDelta][pScale_,pSolution_,pOpts___]:=Block[{},
(* returns the Yukawa coupling matrix of the down-type quarks *)
    Return[(Y\[CapitalDelta][pScale]/.pSolution)[[1]]];
];

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

ClearAll[Get\[Kappa]];
Get\[Kappa][pScale_,pSolution_,pOpts___]:=Block[{l\[Kappa]},
(* returns \[Kappa] *)
	l\[Kappa]=(\[Kappa][pScale]/.pSolution)[[1]];
        Return[l\[Kappa]];
];

(* Get\[Kappa]1 is not a function of SMTriplet *)
(* Get\[Kappa]2 is not a function of SMTriplet *)
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
GetM\[Nu][pScale_,pSolution_,pOpts___]:=Block[{l\[Kappa],lY\[Nu],lM,lY\[CapitalDelta],l\[CapitalLambda]6,lM\[CapitalDelta]2,lvu},
(* returns the mass matrix of the neutrinos *)
	{l\[Kappa],lY\[Nu],lM,lY\[CapitalDelta],l\[CapitalLambda]6,lM\[CapitalDelta]2}=({\[Kappa][pScale],Y\[Nu][pScale],M\[Nu]r[pScale],Y\[CapitalDelta][pScale],\[CapitalLambda]6[pScale],M\[CapitalDelta]2[pScale]}/.pSolution)[[1]];
	lOpts;
	Options[lOpts]=Options[RGEOptions];
	SetOptions[lOpts,RGEFilterOptions[lOpts,pOpts]];
        lvu=RGEv\[Nu]/.Options[lOpts];
	If[MatrixConditionNumber[lM]>2*Precision[lM],Print["GetM\[Nu]: The
	matrix M=", MatrixForm[lM]], " is ill-conditioned and the condition
	number is ", MatrixConditionNumber[lM]];

	Return[-lvu^2*(1/2)^2*(10^9*l\[Kappa]+2*Transpose[lY\[Nu]].(Inverse[lM]*10^9).lY\[Nu]-2 *l\[CapitalLambda]6/(lM\[CapitalDelta]2/10^9)*lY\[CapitalDelta])];
	];

ClearAll[GetMu];
GetMu[pScale_,pSolution_,pOpts___]:=Block[{lMu,lvu},
(* returns the mass matrix of the up-type quarks *)
   lOpts;
   Options[lOpts]=Options[RGEOptions];
   SetOptions[lOpts,RGEFilterOptions[lOpts,pOpts]];
   lvu=RGEvu/.Options[lOpts];
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
GetMd[pScale_,pSolution_,pOpts___]:=Block[{lMd,lvd},
(* returns the mass matrix of the down-type quarks *)
   lOpts;
   Options[lOpts]=Options[RGEOptions];
   SetOptions[lOpts,RGEFilterOptions[lOpts,pOpts]];
   lvd=RGEvd/.Options[lOpts];
   lMd=lvd/Sqrt[2]*(Yd[pScale]/.pSolution)[[1]];
   Return[lMd];
];

ClearAll[GetMe];
GetMe[pScale_,pSolution_,pOpts___]:=Block[{lMe,lvd},
(* returns the mass matrix of the charged leptons *)
   lOpts;
   Options[lOpts]=Options[RGEOptions];
   SetOptions[lOpts,RGEFilterOptions[lOpts,pOpts]];
   lvd=RGEve/.Options[lOpts];
   lMe=lvd/Sqrt[2]*(Ye[pScale]/.pSolution)[[1]];
   Return[lMe];
];

ClearAll[GetSolution];
GetSolution[pScale_,pSolution_,pOpts___]:=Block[{lg1,lg2,lg3,lYu,lYd,lYe,lM,lY\[Nu],l\[Kappa],l\[Lambda],lY\[CapitalDelta],l\[CapitalLambda]1,l\[CapitalLambda]2,l\[CapitalLambda]4,l\[CapitalLambda]5,l\[CapitalLambda]6,lM\[CapitalDelta]2},
(* returns all parameters of the SM *)
        {lg1,lg2,lg3,lYu,lYd,lYe,lY\[Nu],lY\[CapitalDelta],l\[Kappa],lM,l\[Lambda],l\[CapitalLambda]1,l\[CapitalLambda]2,l\[CapitalLambda]4,l\[CapitalLambda]5,l\[CapitalLambda]6,lM\[CapitalDelta]2}=(ParametersFunc[pScale]/.pSolution)[[1]];
	lM=GetM\[Nu]r[pScale,pSolution,pOpts];
	lY\[Nu]=GetY\[Nu][pScale,pSolution,pOpts];
        Return[{lg1,lg2,lg3,lYu,lYd,lYe,lY\[Nu],lY\[CapitalDelta],l\[Kappa],lM,l\[Lambda],l\[CapitalLambda]1,l\[CapitalLambda]2,l\[CapitalLambda]4,l\[CapitalLambda]5,l\[CapitalLambda]6,lM\[CapitalDelta]2}];
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

(* GetGWCond is not a function of SMTriplet *)
(* GetGWConditions is not a function of SMTriplet *)
(* GetVEVratio is not a function of SMTriplet *)
(* GetVEVratios is not a function of SMTriplet *)
ClearAll[ModelName0N];
ModelName0N=ModelName<>"0N";

ClearAll[Dagger];
RGEvu:=N[RGEvEW];
RGEvd:=RGEvu;
RGEv\[Nu]:=RGEvu;
RGEve:=RGEvd;

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
lM,lY,l\[Kappa] (* needed for check of too high masses *)
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
		{lM,lY\[Nu],l\[Kappa]}=({RGEMNur,RGEY\[Nu],RGE\[Kappa]}/.pInitial);
		If[(RGESearchTransition/.Options[lOpts,RGESearchTransition]), (*CHECK THIS LINE: inverted condition*)
			{lM,lY,l\[Kappa],lIntegratedOut}=RGETestMY\[Nu][Exp[lLogThresholdFactor+pBoundary],lM,lY\[Nu],l\[Kappa]];
			If[lIntegratedOut>0,
				Print["Warning: ",lIntegratedOut, " right-handed neutrinos have a mass above ", Exp[pBoundary], " GeV (",Select[Sqrt[Abs[Eigenvalues[(Dagger[RGEMNur].RGEMNur/.pInitial)]]],(#1>Exp[pBoundary])&],"). Thus they have been integrated out."];
				SetOptions[lOpts,RGEIntegratedOut->(((RGEIntegratedOut/.Options[lOpts,RGEIntegratedOut])/.{RGEIntegratedOut->0})+lIntegratedOut)];

				SetOptions[lInitial,RGEMNur->lM,RGEY\[Nu]->lY,RGE\[Kappa]->l\[Kappa]];
				RGEChangeOptions[Exp[pBoundary],RGEIntegratedOut->(RGEIntegratedOut/.Options[lOpts,RGEIntegratedOut])];
				];
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



(* definitions for the Standard Model (SM) *)

ClearAll[RGEOptions];
RGEOptions;
Options[RGEOptions]={     RGEModelVariant->"1Loop", (* different variation of the model *)
			  RGEPrecision->6, (* precision to find transitions *)
			  RGEAutoGenerated->False, (* used to find automatically generated entries *)
                        RGEMaxNumberIterations->20, (* maximum number of iterations in the loops to search transitions *)
                        RGEvEW->246, (* vev of the SM Higgs *)
                        RGEIntegratedOut->0, (* number of the integrated out neutrinos *)
			Method->StiffnessSwitching, (* option of NDSolve *)
                        RGESearchTransition->True, (* enables/disables the automatic search for transitions *)
                        RGEThresholdFactor->1 (* neutrinos are integrated out at RGEThresholdFactor*Mass *)
};

Parameters={g1,g2,g3,Yu,Yd,Ye,Y\[Nu],Y\[CapitalDelta],\[Kappa],M\[Nu]r,\[Lambda],\[CapitalLambda]1,\[CapitalLambda]2,\[CapitalLambda]4,\[CapitalLambda]5,\[CapitalLambda]6, M\[CapitalDelta]2}; (* These are the parameters of the model *)
ParameterSymbols={RGEg1,RGEg2,RGEg3,RGEYu,RGEYd,RGEYe,RGEY\[Nu],RGEY\[CapitalDelta],RGE\[Kappa],RGEMNur,RGE\[Lambda],RGE\[CapitalLambda]1,RGE\[CapitalLambda]2,RGE\[CapitalLambda]4,RGE\[CapitalLambda]5,RGE\[CapitalLambda]6, RGEM\[CapitalDelta]2};


ClearAll[Initial];
Initial={
{"GUT",{
	RGEg1->0.5787925294736758,
	RGEg2->0.5214759925514961,
	RGEg3->0.5269038649895842,
	RGEMNur->RGEGetM[RGE\[Theta]12,RGE\[Theta]13,RGE\[Theta]23,RGE\[Delta],RGE\[Delta]e,RGE\[Delta]\[Mu],RGE\[Delta]\[Tau],RGE\[CurlyPhi]1,RGE\[CurlyPhi]2,RGEMlightest,RGE\[CapitalDelta]m2atm,RGE\[CapitalDelta]m2sol,RGEMassHierarchy,RGEvu,RGEY\[Nu],RGE\[Kappa],RGEY\[CapitalDelta],RGE\[CapitalLambda]6,RGEM\[CapitalDelta]2],
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
	RGE\[Theta]12 -> 23 Degree,
	RGE\[Theta]13 -> 0 Degree, 
	RGE\[Theta]23 -> 45 Degree,
	RGE\[Delta] -> 0 Degree,
	RGE\[Delta]e -> 0 Degree,
	RGE\[Delta]\[Mu] -> 0 Degree,
	RGE\[Delta]\[Tau] -> 0 Degree,
	RGE\[CurlyPhi]1 -> 0 Degree,
	RGE\[CurlyPhi]2 -> 0 Degree, 
	RGEMlightest -> 0.05,
	RGE\[CapitalDelta]m2atm -> 5 10^-3, 
	RGE\[CapitalDelta]m2sol -> 2.2 10^-4,
	RGEY\[Nu]33 -> 0.1,
	RGEY\[Nu]Ratio -> 0.5,
	RGEY\[Nu]->RGEGetY\[Nu][RGEY\[Nu]33,RGEY\[Nu]Ratio],
	RGEYe->DiagonalMatrix[{RGEye,RGEy\[Mu],RGEy\[Tau]}],
	RGE\[Kappa]->0*IdentityMatrix[3],
	RGEY\[CapitalDelta]->0*IdentityMatrix[3],
        RGE\[Lambda]->0.5,
        RGE\[CapitalLambda]1->0.5,
        RGE\[CapitalLambda]2->0.5,
        RGE\[CapitalLambda]4->0.5,
        RGE\[CapitalLambda]5->0.5,
        RGE\[CapitalLambda]6->10^9,
        RGEM\[CapitalDelta]2->10^18
}
}
}; (* This list contains the suggestion for the initial values *)


ClearAll[RGE1Loop];
RGE1Loop:={	D[g1[t],t]==Betag1[g1[t],g2[t],g3[t],Yu[t],Yd[t],Ye[t],Y\[Nu][t],Y\[CapitalDelta][t],\[Kappa][t],M\[Nu]r[t],\[Lambda][t],\[CapitalLambda]1[t],\[CapitalLambda]2[t],\[CapitalLambda]4[t],\[CapitalLambda]5[t],\[CapitalLambda]6[t],M\[CapitalDelta]2[t]],
		D[g2[t],t]==Betag2[g1[t],g2[t],g3[t],Yu[t],Yd[t],Ye[t],Y\[Nu][t],Y\[CapitalDelta][t],\[Kappa][t],M\[Nu]r[t],\[Lambda][t],\[CapitalLambda]1[t],\[CapitalLambda]2[t],\[CapitalLambda]4[t],\[CapitalLambda]5[t],\[CapitalLambda]6[t],M\[CapitalDelta]2[t]],
		D[g3[t],t]==Betag3[g1[t],g2[t],g3[t],Yu[t],Yd[t],Ye[t],Y\[Nu][t],Y\[CapitalDelta][t],\[Kappa][t],M\[Nu]r[t],\[Lambda][t],\[CapitalLambda]1[t],\[CapitalLambda]2[t],\[CapitalLambda]4[t],\[CapitalLambda]5[t],\[CapitalLambda]6[t],M\[CapitalDelta]2[t]],
		D[Yu[t],t]==BetaYu[g1[t],g2[t],g3[t],Yu[t],Yd[t],Ye[t],Y\[Nu][t],Y\[CapitalDelta][t],\[Kappa][t],M\[Nu]r[t],\[Lambda][t],\[CapitalLambda]1[t],\[CapitalLambda]2[t],\[CapitalLambda]4[t],\[CapitalLambda]5[t],\[CapitalLambda]6[t],M\[CapitalDelta]2[t]],
		D[Yd[t],t]==BetaYd[g1[t],g2[t],g3[t],Yu[t],Yd[t],Ye[t],Y\[Nu][t],Y\[CapitalDelta][t],\[Kappa][t],M\[Nu]r[t],\[Lambda][t],\[CapitalLambda]1[t],\[CapitalLambda]2[t],\[CapitalLambda]4[t],\[CapitalLambda]5[t],\[CapitalLambda]6[t],M\[CapitalDelta]2[t]],
		D[Ye[t],t]==BetaYe[g1[t],g2[t],g3[t],Yu[t],Yd[t],Ye[t],Y\[Nu][t],Y\[CapitalDelta][t],\[Kappa][t],M\[Nu]r[t],\[Lambda][t],\[CapitalLambda]1[t],\[CapitalLambda]2[t],\[CapitalLambda]4[t],\[CapitalLambda]5[t],\[CapitalLambda]6[t],M\[CapitalDelta]2[t]],
		D[Y\[Nu][t],t]==BetaY\[Nu][g1[t],g2[t],g3[t],Yu[t],Yd[t],Ye[t],Y\[Nu][t],Y\[CapitalDelta][t],\[Kappa][t],M\[Nu]r[t],\[Lambda][t],\[CapitalLambda]1[t],\[CapitalLambda]2[t],\[CapitalLambda]4[t],\[CapitalLambda]5[t],\[CapitalLambda]6[t],M\[CapitalDelta]2[t]],
		D[Y\[CapitalDelta][t],t]==BetaY\[CapitalDelta][g1[t],g2[t],g3[t],Yu[t],Yd[t],Ye[t],Y\[Nu][t],Y\[CapitalDelta][t],\[Kappa][t],M\[Nu]r[t],\[Lambda][t],\[CapitalLambda]1[t],\[CapitalLambda]2[t],\[CapitalLambda]4[t],\[CapitalLambda]5[t],\[CapitalLambda]6[t],M\[CapitalDelta]2[t]],
		D[\[Kappa][t],t]==Beta\[Kappa][g1[t],g2[t],g3[t],Yu[t],Yd[t],Ye[t],Y\[Nu][t],Y\[CapitalDelta][t],\[Kappa][t],M\[Nu]r[t],\[Lambda][t],\[CapitalLambda]1[t],\[CapitalLambda]2[t],\[CapitalLambda]4[t],\[CapitalLambda]5[t],\[CapitalLambda]6[t],M\[CapitalDelta]2[t]],
		D[M\[Nu]r[t],t]==BetaM\[Nu]r[g1[t],g2[t],g3[t],Yu[t],Yd[t],Ye[t],Y\[Nu][t],Y\[CapitalDelta][t],\[Kappa][t],M\[Nu]r[t],\[Lambda][t],\[CapitalLambda]1[t],\[CapitalLambda]2[t],\[CapitalLambda]4[t],\[CapitalLambda]5[t],\[CapitalLambda]6[t],M\[CapitalDelta]2[t]],
		D[\[Lambda][t],t]==Beta\[Lambda][g1[t],g2[t],g3[t],Yu[t],Yd[t],Ye[t],Y\[Nu][t],Y\[CapitalDelta][t],\[Kappa][t],M\[Nu]r[t],\[Lambda][t],\[CapitalLambda]1[t],\[CapitalLambda]2[t],\[CapitalLambda]4[t],\[CapitalLambda]5[t],\[CapitalLambda]6[t],M\[CapitalDelta]2[t]],
		D[\[CapitalLambda]1[t],t]==Beta\[CapitalLambda]1[g1[t],g2[t],g3[t],Yu[t],Yd[t],Ye[t],Y\[Nu][t],Y\[CapitalDelta][t],\[Kappa][t],M\[Nu]r[t],\[Lambda][t],\[CapitalLambda]1[t],\[CapitalLambda]2[t],\[CapitalLambda]4[t],\[CapitalLambda]5[t],\[CapitalLambda]6[t],M\[CapitalDelta]2[t]],
		D[\[CapitalLambda]2[t],t]==Beta\[CapitalLambda]2[g1[t],g2[t],g3[t],Yu[t],Yd[t],Ye[t],Y\[Nu][t],Y\[CapitalDelta][t],\[Kappa][t],M\[Nu]r[t],\[Lambda][t],\[CapitalLambda]1[t],\[CapitalLambda]2[t],\[CapitalLambda]4[t],\[CapitalLambda]5[t],\[CapitalLambda]6[t],M\[CapitalDelta]2[t]],
		D[\[CapitalLambda]4[t],t]==Beta\[CapitalLambda]4[g1[t],g2[t],g3[t],Yu[t],Yd[t],Ye[t],Y\[Nu][t],Y\[CapitalDelta][t],\[Kappa][t],M\[Nu]r[t],\[Lambda][t],\[CapitalLambda]1[t],\[CapitalLambda]2[t],\[CapitalLambda]4[t],\[CapitalLambda]5[t],\[CapitalLambda]6[t],M\[CapitalDelta]2[t]],
		D[\[CapitalLambda]5[t],t]==Beta\[CapitalLambda]5[g1[t],g2[t],g3[t],Yu[t],Yd[t],Ye[t],Y\[Nu][t],Y\[CapitalDelta][t],\[Kappa][t],M\[Nu]r[t],\[Lambda][t],\[CapitalLambda]1[t],\[CapitalLambda]2[t],\[CapitalLambda]4[t],\[CapitalLambda]5[t],\[CapitalLambda]6[t],M\[CapitalDelta]2[t]],
		D[\[CapitalLambda]6[t],t]==Beta\[CapitalLambda]6[g1[t],g2[t],g3[t],Yu[t],Yd[t],Ye[t],Y\[Nu][t],Y\[CapitalDelta][t],\[Kappa][t],M\[Nu]r[t],\[Lambda][t],\[CapitalLambda]1[t],\[CapitalLambda]2[t],\[CapitalLambda]4[t],\[CapitalLambda]5[t],\[CapitalLambda]6[t],M\[CapitalDelta]2[t]],
		D[M\[CapitalDelta]2[t],t]==BetaM\[CapitalDelta]2[g1[t],g2[t],g3[t],Yu[t],Yd[t],Ye[t],Y\[Nu][t],Y\[CapitalDelta][t],\[Kappa][t],M\[Nu]r[t],\[Lambda][t],\[CapitalLambda]1[t],\[CapitalLambda]2[t],\[CapitalLambda]4[t],\[CapitalLambda]5[t],\[CapitalLambda]6[t],M\[CapitalDelta]2[t]]}; (* These are the Renormalization group equations *)

              
(* Beta Functions of the Standardmodel *)
ClearAll[Betag1, Betag2, Betag3, BetaYu, BetaYd, BetaYe, BetaY\[Nu], BetaY\[CapitalDelta], Beta\[Kappa], BetaM\[Nu]r, Beta\[Lambda], Beta\[CapitalLambda]1, Beta\[CapitalLambda]2, Beta\[CapitalLambda]4, Beta\[CapitalLambda]5, Beta\[CapitalLambda]6, BetaM\[CapitalDelta]2];

Betag1[g1_,g2_,g3_,Yu_,Yd_,Ye_,Y\[Nu]_,Y\[CapitalDelta]_,\[Kappa]_,M\[Nu]r_,\[Lambda]_,\[CapitalLambda]1_,\[CapitalLambda]2_,\[CapitalLambda]4_,\[CapitalLambda]5_,\[CapitalLambda]6_,M\[CapitalDelta]2_] :=
	47/10 * 1/(16*Pi^2) * g1^3;

Betag2[g1_,g2_,g3_,Yu_,Yd_,Ye_,Y\[Nu]_,Y\[CapitalDelta]_,\[Kappa]_,M\[Nu]r_,\[Lambda]_,\[CapitalLambda]1_,\[CapitalLambda]2_,\[CapitalLambda]4_,\[CapitalLambda]5_,\[CapitalLambda]6_,M\[CapitalDelta]2_] :=
	-5/2 * 1/(16*Pi^2) * g2^3;

Betag3[g1_,g2_,g3_,Yu_,Yd_,Ye_,Y\[Nu]_,Y\[CapitalDelta]_,\[Kappa]_,M\[Nu]r_,\[Lambda]_,\[CapitalLambda]1_,\[CapitalLambda]2_,\[CapitalLambda]4_,\[CapitalLambda]5_,\[CapitalLambda]6_,M\[CapitalDelta]2_] :=
	-7 * 1/(16*Pi^2) * g3^3;

BetaYd[g1_,g2_,g3_,Yu_,Yd_,Ye_,Y\[Nu]_,Y\[CapitalDelta]_,\[Kappa]_,M\[Nu]r_,\[Lambda]_,\[CapitalLambda]1_,\[CapitalLambda]2_,\[CapitalLambda]4_,\[CapitalLambda]5_,\[CapitalLambda]6_,M\[CapitalDelta]2_] := 1/(16*Pi^2) * (
	(3/2)*Yd.(
        + Dagger[ Yd ].Yd
	- Dagger[ Yu ].Yu
        )
	+ (
	- (1/4)*g1^2
	- (9/4)*g2^2
	- 8*g3^2
	+ 3*Tr[Dagger[ Yd ].Yd ]
	+ 3*Tr[Dagger[ Yu ].Yu ]
	+ Tr[Dagger[ Ye ].Ye ]
	+ Tr[Dagger[ Y\[Nu] ].Y\[Nu] ]
        )*Yd
	);

BetaYu[g1_,g2_,g3_,Yu_,Yd_,Ye_,Y\[Nu]_,Y\[CapitalDelta]_,\[Kappa]_,M\[Nu]r_,\[Lambda]_,\[CapitalLambda]1_,\[CapitalLambda]2_,\[CapitalLambda]4_,\[CapitalLambda]5_,\[CapitalLambda]6_,M\[CapitalDelta]2_] :=1/(16*Pi^2) * (
       (3/2)*Yu.(
       - Dagger[Yd].Yd
       + Dagger[Yu].Yu
       )
       + (
       - (17/20)*g1^2
       - (9/4)*g2^2
       - 8*g3^2
       + Tr[Dagger[Y\[Nu]].Y\[Nu]]
       + Tr[Dagger[Ye].Ye]
       + 3*Tr[Dagger[Yu].Yu]
       + 3*Tr[Dagger[Yd].Yd]
       )*Yu
       );

BetaYe[g1_,g2_,g3_,Yu_,Yd_,Ye_,Y\[Nu]_,Y\[CapitalDelta]_,\[Kappa]_,M\[Nu]r_,\[Lambda]_,\[CapitalLambda]1_,\[CapitalLambda]2_,\[CapitalLambda]4_,\[CapitalLambda]5_,\[CapitalLambda]6_,M\[CapitalDelta]2_] :=1/(16*Pi^2) * (
	(3/2)*Ye.(
        Dagger[Ye].Ye
	- Dagger[Y\[Nu]].Y\[Nu]
	+ Dagger[Y\[CapitalDelta]].Y\[CapitalDelta]
        )
	+ (
	- (9/4)*g1^2
	- (9/4)*g2^2
	+ 3*Tr[Dagger[ Yd ].Yd ]
	+ 3*Tr[Dagger[ Yu ].Yu ]
	+ Tr[Dagger[ Ye ].Ye ]
	+ Tr[Dagger[ Y\[Nu] ].Y\[Nu] ]
        )*Ye
	);

      
BetaY\[Nu][g1_,g2_,g3_,Yu_,Yd_,Ye_,Y\[Nu]_,Y\[CapitalDelta]_,\[Kappa]_,M\[Nu]r_,\[Lambda]_,\[CapitalLambda]1_,\[CapitalLambda]2_,\[CapitalLambda]4_,\[CapitalLambda]5_,\[CapitalLambda]6_,M\[CapitalDelta]2_] :=1/(16*Pi^2) * (
	(3/2)*Y\[Nu].(
        - Dagger[Ye].Ye
	+ Dagger[Y\[Nu]].Y\[Nu]
	+ Dagger[Y\[CapitalDelta]].Y\[CapitalDelta]
        )
	+ (
	- (9/20)*g1^2
	- (9/4)*g2^2
	+ Tr[Dagger[Y\[Nu]].Y\[Nu]]
	+ Tr[Dagger[Ye].Ye]
	+ 3*Tr[Dagger[Yu].Yu]
	+ 3*Tr[Dagger[Yd].Yd]
        )*Y\[Nu]
	);

BetaY\[CapitalDelta][g1_,g2_,g3_,Yu_,Yd_,Ye_,Y\[Nu]_,Y\[CapitalDelta]_,\[Kappa]_,M\[Nu]r_,\[Lambda]_,\[CapitalLambda]1_,\[CapitalLambda]2_,\[CapitalLambda]4_,\[CapitalLambda]5_,\[CapitalLambda]6_,M\[CapitalDelta]2_] :=1/(16*Pi^2) * (
	Y\[CapitalDelta].(
        (1/2) * Dagger[Y\[Nu]].Y\[Nu]
	+ (1/2) * Dagger[Ye].Ye
	+ (3/2) * Dagger[Y\[CapitalDelta]].Y\[CapitalDelta]
        )
	+ (
        (1/2) * Transpose[Y\[Nu]].Conjugate[Y\[Nu]]
	+ (1/2) * Transpose[Ye].Conjugate[Ye]
	+ (3/2) *Transpose[Y\[CapitalDelta]].Conjugate[Y\[CapitalDelta]]
        ).Y\[CapitalDelta]
	+ (
	- (9/10)*g1^2
	- (9/2)*g2^2
	+ Tr[Dagger[Y\[CapitalDelta]].Y\[CapitalDelta]]
        )*Y\[CapitalDelta]
	);


Beta\[Kappa][g1_,g2_,g3_,Yu_,Yd_,Ye_,Y\[Nu]_,Y\[CapitalDelta]_,\[Kappa]_,M\[Nu]r_,\[Lambda]_,\[CapitalLambda]1_,\[CapitalLambda]2_,\[CapitalLambda]4_,\[CapitalLambda]5_,\[CapitalLambda]6_,M\[CapitalDelta]2_] :=1/(16*Pi^2) * (
	\[Kappa].(
        (-3/2)*Dagger[Ye].Ye
	+ (1/2)*Dagger[Y\[Nu]].Y\[Nu]
	+ (3/2)*Dagger[Y\[CapitalDelta]].Y\[CapitalDelta]
        )
        + (
	- (3/2)*Transpose[Ye].Conjugate[Ye]
	+ (1/2)*Transpose[Y\[Nu]].Conjugate[Y\[Nu]]
	+ (3/2)*Transpose[Y\[CapitalDelta]].Conjugate[Y\[CapitalDelta]]
        ).\[Kappa]
	+ (
	- 3*g2^2
	+ 6*Tr[Dagger[Yu].Yu]
	+ 6*Tr[Dagger[Yd].Yd]
	+ 2*Tr[Dagger[Ye].Ye]
	+ 2*Tr[Dagger[Y\[Nu]].Y\[Nu]]
	+ \[Lambda]
        )*\[Kappa]
	);

BetaM\[Nu]r[g1_,g2_,g3_,Yu_,Yd_,Ye_,Y\[Nu]_,Y\[CapitalDelta]_,\[Kappa]_,M\[Nu]r_,\[Lambda]_,\[CapitalLambda]1_,\[CapitalLambda]2_,\[CapitalLambda]4_,\[CapitalLambda]5_,\[CapitalLambda]6_,M\[CapitalDelta]2_] := 1/(16*Pi^2) * (
	M\[Nu]r.Conjugate[Y\[Nu]].Transpose[Y\[Nu]]
	+ Y\[Nu].Dagger[Y\[Nu]].M\[Nu]r);

Beta\[Lambda][g1_,g2_,g3_,Yu_,Yd_,Ye_,Y\[Nu]_,Y\[CapitalDelta]_,\[Kappa]_,M\[Nu]r_,\[Lambda]_,\[CapitalLambda]1_,\[CapitalLambda]2_,\[CapitalLambda]4_,\[CapitalLambda]5_,\[CapitalLambda]6_,M\[CapitalDelta]2_] := 1/(16*Pi^2) * (
    6*\[Lambda]^2
    - (9/5)*g1^2*\[Lambda]
    - 9*g2^2*\[Lambda]
    + (27/50)*g1^4
    + (18/10)*g1^2*g2^2
    + (9/2)*g2^4
    + 4*\[Lambda]*(
    + 3*Tr[Dagger[Yu].Yu]
    + 3*Tr[Dagger[Yd].Yd]
    + Tr[Dagger[Ye].Ye]
    + Tr[Dagger[Y\[Nu]].Y\[Nu]]
    )
    + 12 * \[CapitalLambda]4^2
    + 8 * \[CapitalLambda]5^2
    - 8*(
    + 3*Tr[Dagger[Yu].Yu.Dagger[Yu].Yu]
    + 3*Tr[Dagger[Yd].Yd.Dagger[Yd].Yd]
    + Tr[Dagger[Ye].Ye.Dagger[Ye].Ye]
    + Tr[Dagger[Y\[Nu]].Y\[Nu].Dagger[Y\[Nu]].Y\[Nu]]
    )
    );

Beta\[CapitalLambda]1[g1_,g2_,g3_,Yu_,Yd_,Ye_,Y\[Nu]_,Y\[CapitalDelta]_,\[Kappa]_,M\[Nu]r_,\[Lambda]_,\[CapitalLambda]1_,\[CapitalLambda]2_,\[CapitalLambda]4_,\[CapitalLambda]5_,\[CapitalLambda]6_,M\[CapitalDelta]2_] := 1/(16*Pi^2) * (
    \[CapitalLambda]1 *(
    (-36/5)*g1^2
    - 24 * g2^2
    + 14 * \[CapitalLambda]1
    + 4 * \[CapitalLambda]2
    + 4 * Tr[Dagger[Y\[CapitalDelta]].Y\[CapitalDelta]]
    )
    +(108/25) * g1^4
    + 18 * g2^4
    + (72/5) * g1^2 * g2^2
    + 2 * \[CapitalLambda]2^2
    + 4 * \[CapitalLambda]4^2
    + 4 * \[CapitalLambda]5^2
    - 8 * Tr[Dagger[Y\[CapitalDelta]].Y\[CapitalDelta].Dagger[Y\[CapitalDelta]].Y\[CapitalDelta]]    
    );

Beta\[CapitalLambda]2[g1_,g2_,g3_,Yu_,Yd_,Ye_,Y\[Nu]_,Y\[CapitalDelta]_,\[Kappa]_,M\[Nu]r_,\[Lambda]_,\[CapitalLambda]1_,\[CapitalLambda]2_,\[CapitalLambda]4_,\[CapitalLambda]5_,\[CapitalLambda]6_,M\[CapitalDelta]2_] := 1/(16*Pi^2) * (
    \[CapitalLambda]2 *(
    (-36/5)*g1^2
    - 24 * g2^2
    + 12 *\[CapitalLambda]1
    + 3 * \[CapitalLambda]2
    + 4 * Tr[Dagger[Y\[CapitalDelta]].Y\[CapitalDelta]]
    )
    + 12 * g2^4
    - (144/5) * g1^2 * g2^2
    - 8 * \[CapitalLambda]5^2
    + 8 * Tr[Dagger[Y\[CapitalDelta]].Y\[CapitalDelta].Dagger[Y\[CapitalDelta]].Y\[CapitalDelta]]    
    );

Beta\[CapitalLambda]4[g1_,g2_,g3_,Yu_,Yd_,Ye_,Y\[Nu]_,Y\[CapitalDelta]_,\[Kappa]_,M\[Nu]r_,\[Lambda]_,\[CapitalLambda]1_,\[CapitalLambda]2_,\[CapitalLambda]4_,\[CapitalLambda]5_,\[CapitalLambda]6_,M\[CapitalDelta]2_] := 1/(16*Pi^2) * (
    \[CapitalLambda]4 *(
    (-9/2)*g1^2
    - (33/2) * g2^2
    + 8 *\[CapitalLambda]1
    + 2 * \[CapitalLambda]2
    + 3 * \[Lambda]
    + 4 * \[CapitalLambda]4
    +2 * (
	+ Tr[Dagger[Y\[Nu]].Y\[Nu]]
	+ Tr[Dagger[Ye].Ye]
	+ 3*Tr[Dagger[Yu].Yu]
	+ 3*Tr[Dagger[Yd].Yd]
        + Tr[Dagger[Y\[CapitalDelta]].Y\[CapitalDelta]]
        )
    )
    + 6 * g2^4
    + (27/25) * g1^4
    + 8 * \[CapitalLambda]5^2
    -4 * Tr[Dagger[Y\[CapitalDelta]].Y\[CapitalDelta].Dagger[Y\[Nu]].Y\[Nu]]
    );

Beta\[CapitalLambda]5[g1_,g2_,g3_,Yu_,Yd_,Ye_,Y\[Nu]_,Y\[CapitalDelta]_,\[Kappa]_,M\[Nu]r_,\[Lambda]_,\[CapitalLambda]1_,\[CapitalLambda]2_,\[CapitalLambda]4_,\[CapitalLambda]5_,\[CapitalLambda]6_,M\[CapitalDelta]2_] := 1/(16*Pi^2) * (
    \[CapitalLambda]5 *(
    (-9/2)*g1^2
    - (33/2) * g2^2
    + 2 *\[CapitalLambda]1
    - 2 * \[CapitalLambda]2
    + \[Lambda]
    + 8 * \[CapitalLambda]4
    +2 * (
	+ Tr[Dagger[Y\[Nu]].Y\[Nu]]
	+ Tr[Dagger[Ye].Ye]
	+ 3*Tr[Dagger[Yu].Yu]
	+ 3*Tr[Dagger[Yd].Yd]
        + Tr[Dagger[Y\[CapitalDelta]].Y\[CapitalDelta]]
        )
    )
    - (18/5) * g1^2 * g2^2
    + 4 * Tr[Dagger[Y\[CapitalDelta]].Y\[CapitalDelta].Dagger[Y\[Nu]].Y\[Nu]]
    );


Beta\[CapitalLambda]6[g1_,g2_,g3_,Yu_,Yd_,Ye_,Y\[Nu]_,Y\[CapitalDelta]_,\[Kappa]_,M\[Nu]r_,\[Lambda]_,\[CapitalLambda]1_,\[CapitalLambda]2_,\[CapitalLambda]4_,\[CapitalLambda]5_,\[CapitalLambda]6_,M\[CapitalDelta]2_] := 1/(16*Pi^2) * (
    \[CapitalLambda]6 *(
    (-27/10)*g1^2
    - (21/2) * g2^2
    + \[Lambda]
    - 4 * \[CapitalLambda]4
    + 8 * \[CapitalLambda]5
    + 2 * (
        + Tr[Dagger[Y\[Nu]].Y\[Nu]]
        + Tr[Dagger[Ye].Ye]
        + 3*Tr[Dagger[Yu].Yu]
        + 3*Tr[Dagger[Yd].Yd]
    )
    + Tr[Dagger[Y\[CapitalDelta]].Y\[CapitalDelta]]
    )
    - 2 * Tr[Dagger[Y\[CapitalDelta]].Transpose[Y\[Nu]].M\[Nu]r.Y\[Nu]]
    );


BetaM\[CapitalDelta]2[g1_,g2_,g3_,Yu_,Yd_,Ye_,Y\[Nu]_,Y\[CapitalDelta]_,\[Kappa]_,M\[Nu]r_,\[Lambda]_,\[CapitalLambda]1_,\[CapitalLambda]2_,\[CapitalLambda]4_,\[CapitalLambda]5_,\[CapitalLambda]6_,M\[CapitalDelta]2_] := 1/(16*Pi^2) * (
    M\[CapitalDelta]2 *(
    (-18/5)*g1^2
    - 12 * g2^2
    + 8 * \[CapitalLambda]1
    + 2 * \[CapitalLambda]2
    + 2 * Tr[Dagger[Y\[CapitalDelta]].Y\[CapitalDelta]]
    )
    - 4 * \[CapitalLambda]4 * \[Lambda] * RGEvu^2
    + 2 \[CapitalLambda]6*Conjugate[\[CapitalLambda]6]
    );

(* 4 \[Lambda]4 m^2 using 4 m^2 = -\[Lambda] v^2 *)


ClearAll[TransSMTriplet];
TransSMTriplet[pScale_?NumericQ,pDirection_?NumericQ,pSolution_,pToOpts_,pFromOpts_]:=Block[{lg1,lg2,lg3,lYu,lYd,lYe,lY\[Nu],lY\[CapitalDelta],lY\[Nu]Rotated,l\[Kappa],lM\[Nu]r,lM\[Nu]rRotated,l\[Lambda],l\[CapitalLambda]1,l\[CapitalLambda]2,l\[CapitalLambda]4,l\[CapitalLambda]5,l\[CapitalLambda]6,lM\[CapitalDelta]2,lIntegrateOut, lUforM,lToIntegratedOut,lFromIntegratedOut},
(* make a transition from SMTriplet to the SMTriplet *)

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
	{lg1,lg2,lg3,lYu,lYd,lYe,lY\[Nu],lY\[CapitalDelta],l\[Kappa],lM\[Nu]r,l\[Lambda],l\[CapitalLambda]1,l\[CapitalLambda]2,l\[CapitalLambda]4,l\[CapitalLambda]5,l\[CapitalLambda]6,lM\[CapitalDelta]2}=(ParametersFunc[ pScale ]/.pSolution)[[1]];
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
			l\[Kappa]+=RGEKappaMatching[lM\[Nu]rRotated,lY\[Nu]Rotated,lIntegrateOut];
			lY\[Nu]=RGEIntegrateOutY\[Nu][lY\[Nu]Rotated, lIntegrateOut];
			lM\[Nu]r=RGEIntegrateOutM[lM\[Nu]rRotated, lIntegrateOut];
	];
        Return[{RGEg1->lg1,RGEg2->lg2,RGEg3->lg3,RGEYu->lYu,RGEYd->lYd,RGEYe->lYe,RGEY\[Nu]->lY\[Nu],RGEY\[CapitalDelta]->lY\[CapitalDelta],RGE\[Kappa]->l\[Kappa],RGEMNur->lM\[Nu]r,RGE\[Lambda]->l\[Lambda],RGE\[CapitalLambda]1->l\[CapitalLambda]1,RGE\[CapitalLambda]2->l\[CapitalLambda]2,RGE\[CapitalLambda]4->l\[CapitalLambda]4,RGE\[CapitalLambda]5->l\[CapitalLambda]5,RGE\[CapitalLambda]6->l\[CapitalLambda]6,RGEM\[CapitalDelta]2->lM\[CapitalDelta]2}];
];

ClearAll[TransSM];
TransSM[pScale_?NumericQ,pDirection_?NumericQ,pSolution_,pToOpts_,pFromOpts_]:=Block[{lg1,lg2,lg3,lYu,lYd,lYe,lY\[Nu],lY\[CapitalDelta],lY\[Nu]Rotated,l\[Kappa],lM\[Nu]r,lM\[Nu]rRotated,l\[Lambda],l\[CapitalLambda]1,l\[CapitalLambda]2,l\[CapitalLambda]4,l\[CapitalLambda]5,l\[CapitalLambda]6,lM\[CapitalDelta]2,lIntegrateOut, lUforM,lToIntegratedOut,lFromIntegratedOut},
(* make a transition from SMTriplet to the SMTriplet *)

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
	{lg1,lg2,lg3,lYu,lYd,lYe,lY\[Nu],lY\[CapitalDelta],l\[Kappa],lM\[Nu]r,l\[Lambda],l\[CapitalLambda]1,l\[CapitalLambda]2,l\[CapitalLambda]4,l\[CapitalLambda]5,l\[CapitalLambda]6,lM\[CapitalDelta]2}=(ParametersFunc[ pScale ]/.pSolution)[[1]];
        l\[Lambda]+=2 l\[CapitalLambda]6*Conjugate[l\[CapitalLambda]6]/lM\[CapitalDelta]2;
        l\[Kappa]-=2 l\[CapitalLambda]6/lM\[CapitalDelta]2 * lY\[CapitalDelta];

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
             	{lM\[Nu]rRotated,lY\[Nu]Rotated}=RGERotateM[ lM\[Nu]r,lY\[Nu] ]; (*rotation matrix for lM\[Nu]r*)
		lIntegrateOut=lToIntegratedOut-lFromIntegratedOut;
			l\[Kappa]+=RGEKappaMatching[lM\[Nu]rRotated,lY\[Nu]Rotated,lIntegrateOut];
			lY\[Nu]=RGEIntegrateOutY\[Nu][lY\[Nu]Rotated, lIntegrateOut];
			lM\[Nu]r=RGEIntegrateOutM[lM\[Nu]rRotated, lIntegrateOut];
	];
        Return[{RGEg1->lg1,RGEg2->lg2,RGEg3->lg3,RGEYu->lYu,RGEYd->lYd,RGEYe->lYe,RGEY\[Nu]->lY\[Nu],RGE\[Kappa]->l\[Kappa],RGEMNur->lM\[Nu]r,RGE\[Lambda]->l\[Lambda]}];
];


ClearAll[TransSMTriplet0N];
TransSMTriplet0N[pScale_?NumericQ,pDirection_?NumericQ,pSolution_,pToOpts_,pFromOpts_]:=Block[{lg1,lg2,lg3,lYu,lYd,lYe,lY\[Nu],lY\[CapitalDelta],lY\[Nu]Rotated,l\[Kappa],lM\[Nu]r,lM\[Nu]rRotated,l\[Lambda], l\[CapitalLambda]1,l\[CapitalLambda]2,l\[CapitalLambda]4,l\[CapitalLambda]5,l\[CapitalLambda]6,lM\[CapitalDelta]2,lUforM},
(* make a transition from the SM to the SM *)

(* calculate the new parameters *)
	{lg1,lg2,lg3,lYu,lYd,lYe,lY\[Nu],lY\[CapitalDelta],l\[Kappa],lM\[Nu]r,l\[Lambda],l\[CapitalLambda]1,l\[CapitalLambda]2,l\[CapitalLambda]4,l\[CapitalLambda]5,l\[CapitalLambda]6,lM\[CapitalDelta]2}=(ParametersFunc[ pScale ]/.pSolution)[[1]];
	{lM\[Nu]rRotated,lY\[Nu]Rotated}=RGERotateM[ lM\[Nu]r,lY\[Nu] ]; (*rotation matrix for lM\[Nu]r*)

        l\[Kappa]+=RGEKappaMatching[lM\[Nu]rRotated,lY\[Nu]Rotated,Length[lM\[Nu]r]];

        Return[{RGEg1->lg1,RGEg2->lg2,RGEg3->lg3,RGEYu->lYu,RGEYd->lYd,RGEYe->lYe,RGEY\[CapitalDelta]->lY\[CapitalDelta],RGE\[Kappa]->l\[Kappa],RGE\[Lambda]->l\[Lambda],RGE\[CapitalLambda]1->l\[CapitalLambda]1,RGE\[CapitalLambda]2->l\[CapitalLambda]2,RGE\[CapitalLambda]4->l\[CapitalLambda]4,RGE\[CapitalLambda]5->l\[CapitalLambda]5,RGE\[CapitalLambda]6->l\[CapitalLambda]6,RGEM\[CapitalDelta]2->lM\[CapitalDelta]2}];
];


ClearAll[TransSM0N];
TransSM0N[pScale_?NumericQ,pDirection_?NumericQ,pSolution_,pToOpts_,pFromOpts_]:=Block[{lg1,lg2,lg3,lYu,lYd,lYe,lY\[Nu],lY\[CapitalDelta],lY\[Nu]Rotated,l\[Kappa],lM\[Nu]r,lM\[Nu]rRotated,l\[Lambda], l\[CapitalLambda]1,l\[CapitalLambda]2,l\[CapitalLambda]4,l\[CapitalLambda]5,l\[CapitalLambda]6,lM\[CapitalDelta]2,lUforM},
(* make a transition from the SM to the SM *)

(* calculate the new parameters *)
	{lg1,lg2,lg3,lYu,lYd,lYe,lY\[Nu],lY\[CapitalDelta],l\[Kappa],lM\[Nu]r,l\[Lambda],l\[CapitalLambda]1,l\[CapitalLambda]2,l\[CapitalLambda]4,l\[CapitalLambda]5,l\[CapitalLambda]6,lM\[CapitalDelta]2}=(ParametersFunc[ pScale ]/.pSolution)[[1]];
	{lM\[Nu]rRotated,lY\[Nu]Rotated}=RGERotateM[ lM\[Nu]r,lY\[Nu] ]; (*rotation matrix for lM\[Nu]r*)

        l\[Lambda]+=2 l\[CapitalLambda]6*Conjugate[l\[CapitalLambda]6]/lM\[CapitalDelta]2;
        l\[Kappa]-=2 l\[CapitalLambda]6/lM\[CapitalDelta]2 * lY\[CapitalDelta];

        l\[Kappa]+=RGEKappaMatching[lM\[Nu]rRotated,lY\[Nu]Rotated,Length[lM\[Nu]r]];
        Return[{RGEg1->lg1,RGEg2->lg2,RGEg3->lg3,RGEYu->lYu,RGEYd->lYd,RGEYe->lYe,RGE\[Kappa]->l\[Kappa],RGE\[Lambda]->l\[Lambda]}];
];



(* internal functions *)


ClearAll[ParametersFunc];
ParametersFunc[pScale_]:={g1[pScale],g2[pScale],g3[pScale],Yu[pScale],Yd[pScale],Ye[pScale],Y\[Nu][pScale],Y\[CapitalDelta][pScale],\[Kappa][pScale],M\[Nu]r[pScale],\[Lambda][pScale],\[CapitalLambda]1[pScale],\[CapitalLambda]2[pScale],\[CapitalLambda]4[pScale],\[CapitalLambda]5[pScale],\[CapitalLambda]6[pScale],M\[CapitalDelta]2[pScale]};


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
			Y\[CapitalDelta][pBoundary]==RGEY\[CapitalDelta],
			\[Kappa][pBoundary]==RGE\[Kappa],
			M\[Nu]r[pBoundary]==RGEMNur,
			\[Lambda][pBoundary]==RGE\[Lambda],
			\[CapitalLambda]1[pBoundary]==RGE\[CapitalLambda]1,
			\[CapitalLambda]2[pBoundary]==RGE\[CapitalLambda]2,
			\[CapitalLambda]4[pBoundary]==RGE\[CapitalLambda]4,
			\[CapitalLambda]5[pBoundary]==RGE\[CapitalLambda]5,
			\[CapitalLambda]6[pBoundary]==RGE\[CapitalLambda]6,
			M\[CapitalDelta]2[pBoundary]==RGEM\[CapitalDelta]2
			}//.pInitial
			];

];
End[]; (* end of `Private` *)


EndPackage[];
