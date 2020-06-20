from dragonfly import Choice, MappingRule

from castervoice.lib.actions import Key, Text
from castervoice.lib.ctrl.mgr.rule_details import RuleDetails
from castervoice.lib.merge.mergerule import MergeRule
from castervoice.lib.merge.state.short import R


class DesktopEnvironment(MappingRule):
    """Rules for working with the desktop environment, including the application launcher.

    In normal circumstances, one could use the StartApp action from Dragonfly to handle launching
    applications. However, this is not possible when running Dragonfly from inside a container
    because Dragonfly assumes that it has access to the host file system. So instead applications
    are launched through the launcher of the desktop environment.

    """
    mapping = {
        "houston": R(Key("a-f2"), rdescript="Open the application launcher"),
        "launch [<application>]": R(
            Key("alt:down, f2/25, alt:up") + Text("%(application)s") + Key("enter"),
            rdescript="Open %(application)s"
        ),
    }

    extras = [
        Choice(
            "application",
            {
                "firefox": "firefox",
                "emacs": "emacsclient -c",
                "termie": "exo-open --launch TerminalEmulator"
            }
        ),
    ]

    defaults = {"application": ""}


def get_rule():
    return DesktopEnvironment, RuleDetails(name="desktop envy")
