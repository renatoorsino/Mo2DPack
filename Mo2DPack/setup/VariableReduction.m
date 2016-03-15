VariableReduction=Function[{},

	Coordinates=Function[{t},Evaluate[DeleteCases[DeleteCases[DeleteDuplicates[Subscript[q0,##][t]&@@@CoordinatesIndexes],_Integer],_Real]]];

	Quasivelocities=Function[{t},Evaluate[DeleteCases[DeleteDuplicates[Subscript[q1,##][t]&@@@QuasivelocitiesIndexes],_Integer]]];

	GeneralizedForcesModel=Flatten[({((Subscript[f,"A",##][t]&)@@#1)->Total[Subscript[fa,##][t]&@@@#2],((Subscript[f,"I",##][t]&)@@#1)->Total[Subscript[fi,##][t]&@@@#2]})&@@@Reap[Sow[#1,{#2}]&@@@MapThread[{#1,#2}&,{QuasivelocitiesIndexes,Subscript[q1,##][t]&@@@QuasivelocitiesIndexes/.{Subscript[q1, indexes__][t]-> {indexes}}}],Except[_Integer],{#1,#2}&][[2]]];

	ConstraintEquations=DeleteDuplicates[DeleteCases[DeleteCases[ConstraintEquations,_Integer],_Real]];
	HolonomicConstraintEquations=DeleteDuplicates[DeleteCases[DeleteCases[HolonomicConstraintEquations,_Integer],_Real]];
	QuasivelocitiesTransformations=DeleteDuplicates[DeleteCases[DeleteCases[QuasivelocitiesTransformations,_Integer],_Real]];

	ExplicitQuasivelocitiesTransformations=Flatten@Solve[(#==0)&/@QuasivelocitiesTransformations,DeleteCases[Subscript[q0,##]'[t]&@@@CoordinatesIndexes,_Integer]];

	ParametersIndexes=(#[[2]]&/@ParameterReplace)/.(Subscript[a,indexes__]^2->List[indexes]);
	VariableCoordinatesIndexes=(Coordinates[t])/.(Subscript[q0,indexes__][t]-> List[indexes]);
	VariableQuasivelocitiesIndexes=(Quasivelocities[t])/.(Subscript[q1,indexes__][t]-> List[indexes]);

];