AddConstraintEquation[newconstraintequation_]:= 
Module[{},
	If[ValueQ[ConstraintEquations],0,ConstraintEquations={}];
	AppendTo[ConstraintEquations,newconstraintequation];
	ConstraintEquations=DeleteDuplicates[ConstraintEquations];
	ConstraintEquations=DeleteCases[ConstraintEquations,_Integer];
];

