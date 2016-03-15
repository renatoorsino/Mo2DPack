SetDirectory["/Users/renatoorsino/PPGEM-USP/Packages/Mo2DPack/"]
<<setup.m
SetDirectory["/Users/renatoorsino/PPGEM-USP/Packages/Mo2DPack/examples/quick-return"]

Initialize[]
RigidBody[0, 4, {{1, 1}, {0, 0}}, 0, 0]
RigidBody[1, 1, {{1, 1}, {0, 0}}, Subscript[m, 1], 0]
RigidBody[2, 2, {{1, 2}, {1/2, 0}}, Subscript[m, 2], Subscript[\[CapitalIota], 2]]
RigidBody[3, 2, {{1, 2}, {1/2, 0}}, Subscript[m, 3], Subscript[\[CapitalIota], 3]]
RigidBody[4, 2, {{1, 2}, {0, 0}}, Subscript[m, 4], Subscript[\[CapitalIota], 4]]
BaseBody[0, {
	Subscript[q0, "N", 0, 1] == 0,
	Subscript[q0, "N", 0, 2] == 0,
	Subscript[q0, "N", 0, 3] == 0,
	Subscript[q0, "N", 0, 4] == 0.3, 
	Subscript[q0, "N", 0, 5] == 0,
	Subscript[q0, "N", 0, 6] == 0.8,
	Subscript[q0, "N", 0, 7] == 0.001,
	Subscript[q0, "N", 0, 8] == 0.8
	}]
PrismaticJoint[0, 3, 4, 1, 1, 0]
RevoluteJoint[1, 1, 2, 1, 0]
RevoluteJoint[2, 2, 3, 2, 0]
RevoluteJoint[0, 1, 3, 1, 0]
RevoluteJoint[0, 2, 4, 1, Subscript[u, 1][t]]
PrismaticRevoluteJoint[3, 1, 2, 4, 2, 0, 0]
AddCoordinate[
	Subscript[q0, 1][t], 
	Subscript[q0, 1]'[t] - Subscript[q1, "B", 4, 3][t]
	]
VariableReduction[]
DynamicModel[]


Subscript[T,"SI"] = 16.0;
ParametersList = {
	g -> 9.8, 
	Subscript[m, 1] -> 1., 
	Subscript[m, 2] -> 0.2 , 
	Subscript[\[CapitalIota], 2] -> 0.2 0.1^2/12, 
	Subscript[m, 3] -> 0.4, 
	Subscript[\[CapitalIota], 3] -> 0.2 0.5^2/12, 
	Subscript[m, 4] -> 0.2, 
	Subscript[\[CapitalIota], 4] -> 0.2 0.1^2/3
	};
InitialConditions = {
	Subscript[q0, "N", 1, 1][0] == 0.8, 
	Subscript[q0, "N", 1, 2][0] == 0.8, 
	Subscript[q0, "N", 2, 3][0] == 0.15, 
	Subscript[q0, "N", 2, 4][0] == 0.6, 
	Subscript[q0, "N", 4, 3][0] == 0.1, 
	Subscript[q0, "N", 4, 4][0][0] == 0.4, 
   	Subscript[q0, 1][0] == 0
	};
InverseSimulation[
	"SI", 
	Subscript[T,"SI"], 
	ParametersList, 
	InitialConditions, 
	{{1}}, 
	{\[Pi]/2 # &}, {1, 1}, 
	{Subscript[u, 1]}, {"Discrete", 500}
	]
AnimationS1[t_] = Animation[t];

SP[1, 1] = SPlot[
	Subscript[q1, "P", 0, 1, "SI"][t], 
	{t, 0, Subscript[T,"SI"]}, 
	{"t (s)", "\!\(\*SubscriptBox[\!\(\*SuperscriptBox[\(q\), \(\[LeftAngleBracket]1 \[RightAngleBracket]\)]\), \(P, 0, 1, SI\)]\) (m/s)"}, 
	"", 
	{}
	];
SP[1, 2] = SPlot[
	Subscript[q1, "B", 3, 3, "SI"][t], 
	{t, 0, Subscript[T,"SI"]}, 
	{"t (s)", "\!\(\*SubscriptBox[\!\(\*SuperscriptBox[\(q\), \(\[LeftAngleBracket]1 \[RightAngleBracket]\)]\), \(B, 3, 3, SI\)]\) (rad/s)"}, 
	"", 
	{}
	];	
SP[1, 3] = SPlot[
	Subscript[q0, 1, "SI"][t], 
	{t, 0, Subscript[T,"SI"]}, 
	{"t (s)", "\!\(\*SubscriptBox[\!\(\*SuperscriptBox[\(q\), \(\[LeftAngleBracket]0 \[RightAngleBracket]\)]\), \(1, SI\)]\) (rad)"}, 
	"", 
	{}
	];		
SP[1, 4] = SPlot[
	Subscript[u, 1, "SI"][t], 
	{t, 0, Subscript[T,"SI"]}, 
	{"t (s)", "\!\(\*SubscriptBox[u, \(1, SI\)]\) (N.m)"}, 
	"Torque provided by the actuator", 
	{}
	];		
SP[1, 5] = SPlot[
	Norm[D[ConstraintEquations, t] /. InitialCoordinates /. KinematicSimulationR2], 
	{t, 0, Subscript[T,"SI"]}, 
	{"t (s)", "\[LeftDoubleBracketingBar] \!\(\*SuperscriptBox[OverscriptBox[\(q\), \(_\)], \(\[LeftAngleBracket]2\[RightAngleBracket]\)]\)\!\(\*SubscriptBox[\(\[RightDoubleBracketingBar]\), \(SI\)]\)"}, 
  	"Violation of the second order constraint invariants", 
  	{}
  	];
Export["fig060203I" <> ToString[#] <> ".png", SP[1, #], ImageResolution -> 288] & /@ Range[5]
