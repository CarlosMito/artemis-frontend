enum Scheduler { dpmSolverMultistep, ddim, kEuler, kEulerAncestral, pndm, klms }

extension ParseToString on Scheduler {
  String toReplicateAPI() {
    // This method was coded based on the API available value
    // for the [scheduler] parameter in Replicate API
    Map<Scheduler, String> exceptions = {Scheduler.dpmSolverMultistep: "DPMSolverMultistep"};

    if (exceptions.containsKey(this)) {
      return exceptions[this]!;
    }

    if (RegExp(r"[A-Z]").hasMatch(name)) {
      RegExp exp = RegExp(r"(?<=[a-z])[A-Z]");
      return name.replaceAllMapped(exp, (Match m) => ("_${m.group(0)!}")).toUpperCase();
    }

    return name.toUpperCase();
  }
}

extension EnumByReplicateName on Iterable<Scheduler> {
  Scheduler byReplicateName(String replicateName) {
    for (var value in this) {
      if (value.toReplicateAPI() == replicateName) return value;
    }
    throw ArgumentError.value(replicateName, "name", "No enum value with that name");
  }
}
