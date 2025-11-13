import std/[os, syncio, sequtils, strutils, parseopt]
import webui

var line: int = 0
var path: string

for kind, key, val in getopt():
  case kind
  of cmdArgument: path = key
  of cmdLongOption, cmdShortOption:
    case key
    of "slide", "s":
      line = val.parseInt() - 1
    of "help", "h":
      echo """
Usage:

  show [options] path

  The path must be to a plain text file with each line
  in the format:
    Large Bold Words _ small faint words 

Options:

  -s:<int> --slide:<int>  Start at the given slide/line.
      """
      quit()
  of cmdEnd: assert(false)

proc getLines(path: string): seq[string] =
  try:
    result = path.lines().toSeq()
  except:
    stderr.write getCurrentExceptionMsg()
    exit()

let window = newWindow()

let lines = getLines(path)

window.bind("primary") do (e: Event): discard
window.bind("secondary") do (e: Event): discard

proc setContent =
  window.run("setContent('$1')" % lines[line].encode)

window.bind("") do (e: Event):
  if e.eventType == EventsConnected:
    setContent()

window.bind("next") do (e: Event):
  line = min(line + 1, lines.high)
  setContent()

window.bind("prev") do (e: Event):
  line = max(line - 1, lines.low)
  setContent()

window.rootFolder = currentSourcePath().parentDir()
window.show("index.html")

wait()
