from dragonfly import Choice, Dictation, IntegerRef, MappingRule

from castervoice.lib.actions import Key, Text

from castervoice.lib.ctrl.mgr.rule_details import RuleDetails
from castervoice.lib.merge.state.short import R


class EmacsRule(MappingRule):
    mapping = {
        "e max quit": R(Key("c-x, c-c")),
        "command execute": R(Key("a-x")),
        "shell command execute": R(Key("a-!")),
        # Buffers
        "file open": R(Key("c-x, c-f")),
        "file save": R(Key("c-x, c-s")),
        "file save as": R(Key("c-x, c-w")),
        "file save all": R(Key("c-x, s")),
        "file revert": R(Key("a-x") + Text("revert-buffer")),
        "file close": R(Key("c-x, k")),
        "file switch": R(Key("c-x, b")),
        "file move": R(Key("c-x, o")),
        # Windows
        "pane close": R(Key("c-x, 0")),
        "pane expand": R(Key("c-x, 1")),
        "pane split horizontal": R(Key("c-x, 2")),
        "pane split vertical": R(Key("c-x, 3")),
        # Selections and editing
        "oops": R(Key("c-underscore")),
        "selection cancel": R(Key("c-g")),
        "selection begin": R(Key("c-space")),
        "selection cut": R(Key("c-w")),
        "selection copy": R(Key("a-w")),
        "paste": R(Key("c-y")),
        "paste number <n>": R(Key("c-x, r, i, %(n)d")),
        "delete word forward": R(Key("a-d")),
        "delete word backward": R(Key("a-backspace")),
        "paragraph wrap": R(Key("a-q")),
        "paragraph unwrap": R(Key("a-x") + Text("unfill-paragraph") + Key("enter")),
        # Navigation
        "word forward": R(Key("a-f")),
        "word backward": R(Key("a-b")),
        "line forward": R(Key("c-e")),
        "line backward": R(Key("c-a")),
        "paragraph forward": R(Key("a-lbrace")),
        "paragraph backward": R(Key("a-rbrace")),
        "page forward": R(Key("c-v")),
        "page backward": R(Key("a-v")),
        "file forward": R(Key("a-rangle")),
        "file backward": R(Key("a-langle")),
        "search forward": R(Key("c-s")),
        "search backward": R(Key("c-r")),
        "replace forward": R(Key("a-percent")),
        "go to line [<line_num>]": R(Key("a-g, a-g") + Text("%(line_num)s")),
        "bracket forward": R(Key("escape:down, c-f, escape:up")),
        "bracket backward": R(Key("escape:down, c-b, escape:up")),
        # Help
        "help me <help_item>": R(Key("c-h") + Key("%(help_item)s")),
        # elisp
        "eval sim": R(Key("c-x, c-e")),
        # Modes
        "dear ed": R(Key("c-x, d"), rdescript="Launch dired"),
        "maj it": R(Key("c-x, g"), rdescript="Launch magit"),
    }
    extras = [
        Choice(
            "help_item",
            {
                "apropos": "a",
                "key press": "k",
                "function": "f",
                "variable": "v"
            }
        ),
        IntegerRef("line_num", 1, 9999),
        IntegerRef("n", 1, 1000),
    ]
    defaults = {"line_num": "", "n": 1}


def get_rule():
    return EmacsRule, RuleDetails(name="E max", executable="emacs", title="emacs")
