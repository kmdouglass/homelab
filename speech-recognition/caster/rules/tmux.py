from dragonfly import MappingRule

from castervoice.lib.actions import Key

from castervoice.lib.ctrl.mgr.rule_details import RuleDetails
from castervoice.lib.merge.state.short import R


class TmuxRule(MappingRule):
    mapping = {
        "pane close": R(Key("c-b, x")),
        "pane split vertical": R(Key("c-b, percent")),
        "pane split horizontal": R(Key("c-b, quote")),
        "window move": R(Key("c-b, p")),
        "window rename": R(Key("c-b, comma")),
    }


_executables = [
    "xfce4-terminal",
]


def get_rule():
    return TmuxRule, RuleDetails(name="tee mux", executable=_executables, title="Terminal")
