# If Supported

This grouping of extensions all relate to applying some logic if that platform supports it, otherwise it does nothing.

The purpose of these are as convenient way to apply these without adding compiler conditions everywhere.

Each extension should only apply the thing it is wrapping with minimal other logic.

Naming conventions should mirror what they are wrapping to make seeing them in auto complete easier, e.g.
	`.keyboardType(.numberPad)` -> `.keyboardTypeNumberPadIfSupported()`
