// import 'package:flutter_test/flutter_test.dart';
// import 'package:wordlex/data/logic/guess_evaluator.dart';
// import 'package:wordlex/data/models/letter_status.dart';

// void main() {
//   test('all correct', () {
//     final result = GuessEvaluator.evaluate('CRANE', 'CRANE');
//     expect(result.statuses, everyElement(LetterStatus.correct));
//   });

//   test('duplicate letter handled correctly', () {
//     // AISLE has one 'E'. ERASE has two 'E's - only the correctly placed one
//     // should be marked, the extra must be absent (not present).
//     final result = GuessEvaluator.evaluate('ERASE', 'AISLE');
//     expect(result.statuses[4], LetterStatus.correct);
//   });

//   test('no letters match', () {
//     final result = GuessEvaluator.evaluate('CRANE', 'BLIMP');
//     expect(result.statuses, everyElement(LetterStatus.absent));
//   });

//   test('partial matches', () {
//     final result = GuessEvaluator.evaluate('TRACE', 'CRATE');
//     // T R A C E vs C R A T E
//     expect(result.statuses[1], LetterStatus.correct); // R
//     expect(result.statuses[2], LetterStatus.correct); // A
//     expect(result.statuses[4], LetterStatus.correct); // E
//   });
// }
