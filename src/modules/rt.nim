# RenderTemplate.nim / Version 1.0.0 (Modified)
# Unlicense license

import strutils
proc rt*(
  file: string,
  replace: varargs[
    array[0..1, string]
  ]
): string =
  var temp = readFile("./src/templates/" & file)
  for x in replace:
    temp = temp.replace("$" & x[0] & ";", x[1])
  return temp