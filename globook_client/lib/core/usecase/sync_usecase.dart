abstract class SyncConditionUseCase<Type, Condition> {
  /// Execute the use case synchronously with a condition and return a state  result
  Type execute(Condition condition);
}

abstract class SyncNoConditionUseCase<Type> {
  /// Execute the use case synchronously without any condition and return a result
  Type execute();
}
