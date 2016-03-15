SetDirectory["/Users/renatoorsino/PPGEM-USP/Packages/Mo2DPack/"]
<< setup.m

Initialize[]
RigidBody[1,1,{{1,1},{0,0}},Subscript[Overscript[m, _], 1],Subscript[Overscript[m, _], 1] Subscript[Overscript[r, _], 1]^2,{Overscript[g, _] Sin[\[Phi]],-Overscript[g, _] Cos[\[Phi]]}]
RigidBody[2,1,{{1,1},{0,0}},Subscript[Overscript[m, _], 2],1/2 Subscript[Overscript[m, _], 2] Subscript[Overscript[r, _], 2]^2,{Overscript[g, _] Sin[\[Phi]],-Overscript[g, _] Cos[\[Phi]]}]
AddCoordinate[Subscript[q0, 1][t], Subscript[q0, 1]'[t]-Subscript[q1, 1][t]]
AddQuasivelocity[Subscript[q1, 1][t]]
AddConstraintEquation/@{
	Subscript[q1, "N",1,2][t],
	Subscript[q1, "N",1,1][t]+Subscript[q1, "B",1,3][t] Subscript[Overscript[r, _], 1],
	Subscript[q1, "N",1,1][t]-Subscript[q1, "N",2,1][t]+Cos[Overscript[\[Phi], _]-Subscript[q0, 1][t]] Subscript[q1, "B",1,3][t] Subscript[Overscript[r, _], 1]-Cos[Overscript[\[Phi], _]-Subscript[q0, 1][t]] Subscript[q1, "B",2,3][t] Subscript[Overscript[r, _], 2],
	Subscript[q1, "N",1,2][t]-Subscript[q1, "N",2,2][t]+Sin[Overscript[\[Phi], _]-Subscript[q0, 1][t]] Subscript[q1, "B",1,3][t] Subscript[Overscript[r, _], 1]-Sin[Overscript[\[Phi], _]-Subscript[q0, 1][t]] Subscript[q1, "B",2,3][t] Subscript[Overscript[r, _], 2],
	-Subscript[q1, "N",1,1][t]+Subscript[q1, "N",2,1][t]+Cos[Overscript[\[Phi], _]-Subscript[q0, 1][t]] Subscript[q1, 1][t] (Subscript[Overscript[r, _], 1]-Subscript[Overscript[r, _], 2])
	};
VariableReduction[]
DynamicModel[]

Transpose@ConstraintMatrix[{}] //FullSimplify //MatrixForm
RI = {
	Subscript[q1,indexes__]-> Subscript[q1,indexes][t],
	Subscript[q1,indexes__]'-> Subscript[q1,indexes]'[t],
	Subscript[q0,indexes__]-> Subscript[q0,indexes][t]
	};
SD=FullSimplify[Solve[(#==0)& /@ Join[DynamicEquations[RI], D[ConstraintEquations,t]] 
	/. ExplicitQuasivelocitiesTransformations /. {Subscript[q0, 1][t]-> \[Theta],Subscript[q0, 1]'[t]-> 0,Subscript[q1, 1][t]-> 0,Subscript[q1, 1]'[t]-> 0},
	Join[Complement[D[Quasivelocities[t],t],{Subscript[q1, 1]'[t]}],{Subscript[Overscript[m, _], 2]}]]
	];
SD[[2]] // TableForm


St=5.;
Sm={0,8/67,1/2,1,5};

(Sa[#]=Join[
	{Subscript[Overscript[r, _], 1]-> 1.,Subscript[Overscript[r, _], 2]-> 0.3,Overscript[g, _]-> 9.8,Subscript[Overscript[m, _], 1]->0.670,Subscript[Overscript[m, _], 2]-> 0.670 #,Overscript[\[Phi], _]->ArcSin[0.8],\[Phi]->ArcSin[0.8]},
	Flatten @ NDSolve[{(Sin[\[Theta][\[Phi]]]==(Subscript[m, 2]/Subscript[m, 1]+1)(Sin[\[Phi]]-3 Sin[\[Theta][\[Phi]]]+2 Cos[\[Theta][\[Phi]]-\[Phi]] Sin[\[Phi]]))/.{Subscript[m, 2]/Subscript[m, 1]->#},
		\[CapitalTheta]'[\[Phi]]==\[Theta][\[Phi]],\[CapitalTheta][0]==0,\[Theta][0]== 0},{\[Theta]},{\[Phi],0,2\[Pi]}]
])&/@Sm;

SicN=Join[{Subscript[q0, 1][0]== (\[Theta][\[Phi]]/.Sa[8/67]/.{\[Phi]->ArcSin[0.8]})+\[Pi]/6},
	(#== 0)&/@Join[Complement[Coordinates[0],{Subscript[q, 1][0]}],Quasivelocities[0]]];

NSD=DeleteCases[(SD[[2]]/.{\[Theta]-> \[Theta][\[Phi]]}/.Sa[8/67]/.{\[Phi]->ArcSin[0.8]}),a_Real-> b_Real];

ForwardSimulation["$2",St,Sa[8/67],SicN,{1,1}]