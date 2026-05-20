"""
In this module you can specify functions to be called when signals on devices are set, which should
can prevent the set from occurring when it is not safe.

These functions must match the signature in `bec_server.device_server.safety_checks.SafetyCheck`:
    `def func(devices: DeviceManagerBase, position: int | float) -> bool: ...`

That is, they must accept the device container (like the `dev` object in the BEC shell) as the first
argument and the position to be set as the second argument. The device or signal the check is
applied to is given as a string argument to the `safety_check` decorator, which registers the
function with the device server. For example:

    ```
    @safety_check("samx")
    def check_samy_in_range(devices, position):
        if abs(devices.samy.setpoint.get() - position) > 10:
            return False
        return True
    ```

Would stop samx from being set to a position more than 10 units away from the current setpoint of
samy. The device objects supplied by this container are read-only and do not permit calling `.set()`
"""

from bec_server.device_server.safety_check import safety_check
