from dragonfly import Dictation, MappingRule

from castervoice.lib.actions import Key, Text

from castervoice.lib.ctrl.mgr.rule_details import RuleDetails
from castervoice.lib.merge.additions import IntegerRefST
from castervoice.lib.merge.state.short import R


class EmacsRule(MappingRule):
    mapping = {
        "quit e max": R(Key("c-x, c-c")),
        "execute command": R(Key("a-x")),
        "execute shell command": R(Key("a-!")),
        # Files
        "open file": R(Key("c-x, c-f")),
        "save file": R(Key("c-x, c-s")),
        "save as": R(Key("c-x, c-w")),
        "save all": R(Key("c-x, s")),
        "revert to file": R(Key("c-x, c-v")),
        # Buffers
        "revert buffer": R(Key("a-x") + Text("revert-buffer")),
        "close buffer": R(Key("c-x, k")),
        "switch buffer": R(Key("c-x, b")),
        "move buffer": R(Key("c-x, o")),
        "split out": R(Key("c-x, 0")),
        "split restore": R(Key("c-x, 1")),
        "split horizontal": R(Key("c-x, 2")),
        "split vertical": R(Key("c-x, 3")),
        # Selections and editing
        "oops": R(Key("c-underscore")),
        "cancel selection": R(Key("c-g")),
        "begin selection": R(Key("c-space")),
        "cut selection": R(Key("c-w")),
        "paste": R(Key("c-y")),
        "copy": R(Key("a-w")),
        "paste number <n>": R(Key("c-x, r, i, %(n)d")),
        "forward delete": R(Key("c-delete")),
        "delete word": R(Key("a-backspace")),
        "forward delete word": R(Key("a-d")),
        "fill paragraph": R(Key("a-q")),
        # Navigation
        "word forward": R(Key("a-f")),
        "word backward": R(Key("a-b")),
        "line forward": R(Key("c-e")),
        "line backward": R(Key("c-a")),
        "paragraph forward": R(Key("a-lbrace")),
        "paragraph backward": R(Key("a-rbrace")),
        "page forward": R(Key("c-v")),
        "page backward": R(Key("a-v")),
        "document forward": R(Key("a-rangle")),
        "document backward": R(Key("a-langle")),
        "C function forward": R(Key("ac-a")),
        "C function backward": R(Key("ac-e")),
        "incremental search": R(Key("c-s")),
        "incremental reverse": R(Key("c-r")),
        "query replace": R(Key("a-percent")),
        "go to line <n>": R(Key("a-g, a-g")),
        "prior bracket": R(Key("escape:down, c-b, escape:up")),
        "next bracket": R(Key("escape:down, c-f, escape:up")),
        # Modes
        "dired": R(Key("c-x, d")),
        # Help
        "help me apropos": R(Key("c-h, a")),
        "help me key press": R(Key("c-h, k")),
        "help me function": R(Key("c-h, f")),
        "help me variable": R(Key("c-h, v")),
        # elisp
        "eval sim": R(Key("c-x, c-e")),
    }
    extras = [
        Dictation("text"),
        Dictation("mim"),
        IntegerRefST("n", 1, 1000),
    ]
    defaults = {"n": 1, "mim": ""}


def get_rule():
    return EmacsRule, RuleDetails(name="E max", executable="emacs", title="emacs")
