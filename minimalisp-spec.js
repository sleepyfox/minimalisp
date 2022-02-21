import { evaluate } from './minimalisp.js'

describe('A LISP interpreter', () => {
  describe('with an evaluator', () => {
    it('it evaluates an empty list to null', () => {
      // Design: chose null to stand in for NIL
      expect(evaluate([])).toEqual(null)
    })

    it('it evaluates a list containing one to the number 1', () => {
      // Design: chose JS arrays to represent lists
      expect(evaluate([1])).toEqual(1)
    })

    it('it evaluates a list containing four to the number 4', () => {
      expect(evaluate([4])).toEqual(4)
    })
  })
})
