[31m        Error aiken::blueprint::address::parameterized[0m

  [31m×[0m I couldn't compute the address of the given validator because it's
  [31m│[0m parameterized by 2 parameter(s)!
[36m  help: [0mI can only compute addresses of validators that are fully applied.
        For example, a spend validator must have exactly 3 arguments: a
        datum, a redeemer and a context. If it has more, they need to be
        provided beforehand and applied directly to the validator.
        
        Applying parameters change the validator's compiled code, and thus
        the address. This is why I need you to apply parameters first using
        the blueprint apply command.

