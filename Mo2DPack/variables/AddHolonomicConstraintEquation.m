AddHolonomicConstraintEquation[newconstraintequation_]:=
Module[{},
	If[ValueQ[HolonomicConstraintEquations],0,HolonomicConstraintEquations={}];
	AppendTo[HolonomicConstraintEquations,newconstraintequation];
	HolonomicConstraintEquations=DeleteDuplicates[HolonomicConstraintEquations];
	HolonomicConstraintEquations=DeleteCases[HolonomicConstraintEquations,_Integer];
];