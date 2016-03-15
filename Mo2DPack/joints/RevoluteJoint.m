RevoluteJoint[
	body1_,
	node1_, 
	body2_,
	node2_,
	torque_:0] :=
Module[{bodyM,nodeM,bodyS,nodeS},

	(*Master and slave bodies*)
	If[body1<body2,bodyM=body1;nodeM=node1;bodyS=body2;nodeS=node2,bodyM=body2;nodeM=node2;bodyS=body1;nodeS=node1];

	(*Variable elimination*)
	Subscript[q0,"N",bodyS,2(nodeS-1)+1][t_]=Subscript[q0,"N",bodyM,2(nodeM-1)+1][t];
	Subscript[q0,"N",bodyS,2(nodeS-1)+2][t_]=Subscript[q0,"N",bodyM,2(nodeM-1)+2][t];
	Subscript[q1,"N",bodyS,2(nodeS-1)+1][t_]=Subscript[q1,"N",bodyM,2(nodeM-1)+1][t];
	Subscript[q1,"N",bodyS,2(nodeS-1)+2][t_]=Subscript[q1,"N",bodyM,2(nodeM-1)+2][t];

	If[TrueQ[torque==0],

	(*-TRUE-*)
	QuasivelocitiesIndexes=DeleteCases[QuasivelocitiesIndexes,{"R",bodyM,bodyS}];
	ConstraintEquations=DeleteCases[ConstraintEquations,Subscript[q1,"R",bodyM,bodyS][t]-(Subscript[q1,"B",bodyS,3][t]-Subscript[q1,"B",bodyM,3][t])];
	ConstraintEquations=DeleteCases[ConstraintEquations,_Integer];
	Quiet@If[ValueQ[Subscript[fa,"R",bodyM,bodyS][t]],Unset[Subscript[fa,"R",bodyM,bodyS][t]]];
	Quiet@If[ValueQ[Subscript[fi,"R",bodyM,bodyS][t]],Unset[Subscript[fi,"R",bodyM,bodyS][t]]];,

	(*-FALSE-*)
	(*Define new quasivelocity*)
	If[ValueQ[QuasivelocitiesIndexes],{},QuasivelocitiesIndexes={}];
	AppendTo[QuasivelocitiesIndexes,
	{"R",bodyM,bodyS}];
	QuasivelocitiesIndexes=DeleteDuplicates[QuasivelocitiesIndexes];

	(*Revolute Joint constraint equation*)
	If[ValueQ[ConstraintEquations],0,ConstraintEquations={}];
	AppendTo[ConstraintEquations,
	Subscript[q1,"R",bodyM,bodyS][t]-(Subscript[q1,"B",bodyS,3][t]-Subscript[q1,"B",bodyM,3][t])];
	ConstraintEquations=DeleteDuplicates[ConstraintEquations];
	ConstraintEquations=DeleteCases[ConstraintEquations,_Integer];

	(*Generalized active and inertia forces associated to joint torque*)
	Subscript[fa,"R",bodyM,bodyS][t]=Sign[body2-body1]torque;
	Subscript[fi,"R",bodyM,bodyS][t]=0;
	];
];