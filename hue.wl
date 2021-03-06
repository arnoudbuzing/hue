BeginPackage["hue`"];

Begin["Private`"];

hueip = "http://192.168.1.75"

baseurl = URLBuild[{hueip, "api"}]

(*
result=URLExecute[
HTTPRequest[baseurl,<|Method\[Rule]"POST","Body"\[Rule]ExportString[<|\
"devicetype"\[Rule]"wolfram#wolfram"|>,"JSON"]|>
],"RawJSON"]
*)

(*
username=First[result]["success","username"]
*)

lightsbaseurl = URLBuild[{baseurl, username, "lights"}]

LightsInformation[] := Dataset[URLExecute[lightsbaseurl, "RawJSON"]]

lightsinfo = LightsInformation[]

lightsnumbers = Keys[lightsinfo]

LightsInformation[n_Integer] := 
 Dataset[URLExecute[URLBuild[{lightsbaseurl, ToString[n]}], "RawJSON"]]

LightsInformation[1]

ChangeLights[n_Integer, hue_Integer /; 0 <= hue <= 65535] := 
 ChangeLights[n, hue, 255, 255]

ChangeLights[n_Integer, hue_Integer /; 0 <= hue <= 65535, 
  sat_Integer /; 0 <= sat <= 255, bri_Integer /; 0 <= bri <= 255] := 
 Dataset[
  URLExecute[
   HTTPRequest[
    URLBuild[{lightsbaseurl, ToString[n], "state"}],
    <|Method -> "PUT", 
     "Body" -> 
      ExportString[<|"on" -> True, "hue" -> hue, "sat" -> sat, 
        "bri" -> bri|>, "JSON"]|>
    ],
   "RawJSON"]
  ]

ChangeLights[3, 0]

ChangeLights[3, 0, 100, 100]

ChangeLights[n_Integer, color : (_RGBColor | _GrayLevel | _Hue)] := 
 Module[{hue},
  hue = ColorConvert[color, "Hue"];
  ChangeLights[n, Round[65535 First[hue]], Round[255 hue[[2]]], 
   Round[255 Last[hue]]]
  ]

ChangeLights[3, Blue]

ChangeLights[All, color : (_RGBColor | _GrayLevel | _Hue)] := 
 Table[ChangeLights[ToExpression[i], color], {i, 
   Normal[lightsnumbers]}]

ChangeLights[All, Green]

ChangeLights[All, Purple]

ImageResize[
 Import["C:\\Users\\arnoudb\\Downloads\\IMG_20170711_184413.jpg"], 500]

ChangeLights[All, White]

ChangeLights[All, Black]

ChangeLights[All, White]

ChangeLights[All, Hue[0]]

ChangeLights[All, Hue[0, 0.5, 0.4]]

ChangeLights[All, First[\!\(\*
ColorSetterBox[RGBColor[1., 1., 0.], "Swatch"]\)]]
