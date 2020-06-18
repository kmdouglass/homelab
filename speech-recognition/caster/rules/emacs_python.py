from dragonfly import Dictation, MappingRule

from castervoice.lib.actions import Key, Text

from castervoice.lib.ctrl.mgr.rule_details import RuleDetails
from castervoice.lib.merge.additions import IntegerRefST
from castervoice.lib.merge.state.short import R


class EmacsPythonRule(MappingRule):
    mapping = {
        "deactivate": R(
            Key("a-x") + Text("pyvenv-deactivate"),
            rdescript="Deactivate a Python virtual environment"
        ),
        "work on": R(
            Key("a-x") + Text("pyvenv-workon"),
            rdescript="Activate a Python virtual environment"
        ),
    }

def get_rule():
    return EmacsPythonRule, RuleDetails(name="pie max", executable="emacs", title="emacs")
