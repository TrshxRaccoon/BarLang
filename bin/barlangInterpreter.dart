/*
* This thing is getting slightly complex lol im gonna keep all the definitions here so its easier to recall.
* | -> create var
* || -> set var
* ||| -> print var
* |||| -> add to var an int
* ||||| -> dec from var an int
* |||||| -> mul to var an int
* ||||||| -> div from var an int
* for loops:
* |||||||| -> loop start
* ||||||||| -> loop end
* FUCK I FORGOT READ FROM VAR (POSSIBLY ||||)
*/

import 'dart:io';

Map<int, int> vars = {};
List<Map<String, int>> activeLoops = [];
void main(List<String> args) {

  if (args.isEmpty) {
    print("Fuck you");
    return;
  }

  var allLines = File(args[0]).readAsLinesSync();

  for (int lineIndex = 0; lineIndex < allLines.length; lineIndex++) {
    var currentLine = allLines[lineIndex];
    if (currentLine.trim().isEmpty) continue;

    int leftBar = 0;
    int midSpace = 0;
    int rightBar = 0;

    int i = 0;

    while (i < currentLine.length && currentLine[i] == "|") {
      leftBar++;
      i++;
    }

    while (i < currentLine.length && currentLine[i] == " ") {
      midSpace++;
      i++;
    }

    while (i < currentLine.length && currentLine[i] == "|") {
      rightBar++;
      i++;
    }

    int? jump = interpret(leftBar, midSpace, rightBar, lineIndex);
    if (jump != null) {
      lineIndex = jump;
    }
  }
}

int? interpret(int instructionSet, int variableValue, int setValue, int lineIndex) {

  switch(instructionSet) {

    case 1: // create var
      vars[variableValue] = 0;
      break;

    case 2: // set var
      vars[variableValue] = setValue;
      break;

    case 3: // print var
      print(vars[variableValue] ?? 0);
      break;

    case 4: // add int to var
      vars[variableValue] = (vars[variableValue] ?? 0) + setValue;
      break;

    case 5: // subtract int from var
      vars[variableValue] = (vars[variableValue] ?? 0) - setValue;
      break;

    case 6: // multiply int to var
      vars[variableValue] = (vars[variableValue] ?? 0) * setValue;
      break;

    case 7: // divide int from var
      if (setValue != 0) {
        vars[variableValue] = (vars[variableValue] ?? 0) ~/ setValue;
      }
      break;

    case 8: // loop start till var > 0
      activeLoops.add({
        "line": lineIndex,
        "var": variableValue
      });
      break;

    case 9: // loop end
      if (activeLoops.isNotEmpty) {
        var loop = activeLoops.last;
        int loopVar = loop["var"]!;
        int startLine = loop["line"]!;

        if ((vars[loopVar] ?? 0) > 0) {
          return startLine - 1;
        } else {
          activeLoops.removeLast();
        }
      }
      break;

    case 10: // if var == 0 jump forward N lines
      if ((vars[variableValue] ?? 0) == 0) {
        return lineIndex + setValue;
      }
      break;

  }
  return null;
}