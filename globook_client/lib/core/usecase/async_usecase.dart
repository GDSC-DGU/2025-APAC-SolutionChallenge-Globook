abstract class AsyncConditionUseCase<Type, Condition> {
  /// Execute the use case with a condition and return a state a result
  Future<Type> execute(Condition condition);
}

abstract class AsyncNoConditionUseCase<Type> {
  /// Execute the use case without any condition and return a state result
  Future<Type> execute();
}

