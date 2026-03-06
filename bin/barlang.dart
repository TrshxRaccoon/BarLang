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
List<Map<String, int>> loopStack = [];
void main(List<String> args) {

  if (args.isEmpty) {
    print("Fuck you");
    return;
  }

  var lines = File(args[0]).readAsLinesSync();

  for (int lineIndex = 0; lineIndex < lines.length; lineIndex++) {
    var line = lines[lineIndex];
    if (line.trim().isEmpty) continue;

    int leftBar = 0;
    int midSpace = 0;
    int rightBar = 0;

    int i = 0;

    while (i < line.length && line[i] == "|") {
      leftBar++;
      i++;
    }

    while (i < line.length && line[i] == " ") {
      midSpace++;
      i++;
    }

    while (i < line.length && line[i] == "|") {
      rightBar++;
      i++;
    }

    int? jump = execute(leftBar, midSpace, rightBar, lineIndex);
    if (jump != null) {
      lineIndex = jump;
    }
  }
}

int? execute(int left, int value, int right, int lineIndex) {

  switch(left) {

    case 1: // create
      vars[value] = 0;
      break;

    case 2: // set
      vars[value] = right;
      break;

    case 3: // print
      print(vars[value] ?? 0);
      break;

    case 4: // add
      vars[value] = (vars[value] ?? 0) + right;
      break;

    case 5: // subtract
      vars[value] = (vars[value] ?? 0) - right;
      break;

    case 6: // multiply
      vars[value] = (vars[value] ?? 0) * right;
      break;

    case 7: // divide
      if (right != 0) {
        vars[value] = (vars[value] ?? 0) ~/ right;
      }
      break;

    case 8: // loop start
      loopStack.add({
        "line": lineIndex,
        "var": value
      });
      break;

    case 9: // loop end
      if (loopStack.isNotEmpty) {
        var loop = loopStack.last;
        int loopVar = loop["var"]!;
        int startLine = loop["line"]!;

        if ((vars[loopVar] ?? 0) > 0) {
          return startLine - 1;
        } else {
          loopStack.removeLast();
        }
      }
      break;

    case 10: // if var == 0 jump forward N lines
      if ((vars[value] ?? 0) == 0) {
        return lineIndex + right;
      }
      break;

  }
  return null;
}