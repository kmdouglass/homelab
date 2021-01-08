from dragonfly import Dictation, MappingRule

from castervoice.lib.actions import Key, Text

from castervoice.lib.ctrl.mgr.rule_details import RuleDetails
from castervoice.lib.merge.additions import IntegerRefST
from castervoice.lib.merge.state.short import R


class TerminalRule(MappingRule):
    mapping = {
        "yikes": R(Key("c-c"), rdescript="Cancel the current command"),
        "erase screen": R(Key("c-l"), rdescript="Clear the terminal screen"),
        "line forward": R(Key("c-e"), rdescript="Line forward"),
        "line backward": R(Key("c-a"), rdescript="Line backward"),
        "search backward": R(Key("c-r"), rdescript="reverse-i-search"),
        "pseudo": Text("sudo "),
        # Work-specific rules
        "see dee picks for dee": R(Text("cd ~/src/pix4d") + Key("enter")),
    }


_executables = [
    "xfce4-terminal",
]


def get_rule():
    return TerminalRule, RuleDetails(name="terminal", executable=_executables, title="Terminal")
