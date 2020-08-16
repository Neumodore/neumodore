abstract class UseCase<A, R> {
  Future<R> execute(A argument);
}
