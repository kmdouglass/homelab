from dragonfly import Choice, Dictation, MappingRule

from castervoice.lib.actions import Key, Text

from castervoice.lib.ctrl.mgr.rule_details import RuleDetails
from castervoice.lib.merge.additions import IntegerRefST
from castervoice.lib.merge.state.short import R


class TerminalRule(MappingRule):
    mapping = {
        "cat": Text("cat "),
        "change mode [<mode_flags>]": Text("chmod %(mode_flags)s"),
        "erase screen": R(Key("c-l"), rdescript="Clear the terminal screen"),
        "line forward": R(Key("c-e"), rdescript="Line forward"),
        "line backward": R(Key("c-a"), rdescript="Line backward"),
        "list": Text("ls "),
        "make directory": R(Text("mkdir ")),
        "move": Text("mv "),
        "search backward": R(Key("c-r"), rdescript="reverse-i-search"),
        "pseudo": Text("sudo "),
        "see dee [<where>]": Text("cd %(where)s"),
        "yikes": R(Key("c-c"), rdescript="Cancel the current command"),
        # Work-specific rules
        "see dee picks for dee": R(Text("cd ~/src/pix4d") + Key("enter")),
    }

    extras = [
        Choice(
            "where",
            {
                "up": "../",
            }
        ),
        Choice(
            "mode_flags",
            {
                "exy": "+x",
            }
        ),
    ]

    defaults = {"mode_flags": "", "where": ""}


_executables = [
    "xfce4-terminal",
]


def get_rule():
    return TerminalRule, RuleDetails(name="terminal", executable=_executables, title="Terminal")
