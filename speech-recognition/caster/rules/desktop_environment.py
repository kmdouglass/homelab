from dragonfly import MappingRule

from castervoice.lib.actions import Key
from castervoice.lib.ctrl.mgr.rule_details import RuleDetails
from castervoice.lib.merge.mergerule import MergeRule
from castervoice.lib.merge.state.short import R


class DesktopEnvironment(MappingRule):
    mapping = {
        "launch": R(Key("a-f2"), rdescript="Open the application launcher"),
    }


def get_rule():
    return DesktopEnvironment, RuleDetails(name="desktop envy")
