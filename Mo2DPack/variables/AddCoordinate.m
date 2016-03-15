AddCoordinate[
	xNewQ_,
	xNewQTransformation_
	]:=
Module[{},

	(*Define new coordinate*)
	If[ValueQ[CoordinatesIndexes],{},CoordinatesIndexes={}];
	AppendTo[CoordinatesIndexes,(xNewQ/.{Subscript[q0, indexes__][t]-> {indexes}})];
	CoordinatesIndexes=DeleteDuplicates[CoordinatesIndexes];

	(*Relating new coordinate with model quasivelocities*)
	If[ValueQ[QuasivelocitiesTransformations],0,QuasivelocitiesTransformations={}];
	AppendTo[QuasivelocitiesTransformations,xNewQTransformation];
	QuasivelocitiesTransformations=DeleteDuplicates[QuasivelocitiesTransformations];
	QuasivelocitiesTransformations=DeleteCases[QuasivelocitiesTransformations,_Integer];
];
