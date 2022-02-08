import { evaluate } from './minimalisp.js'

describe('A LISP interpreter', () => {
  it('an empty list evaluates to null', () => {
    // Design: chose null to stand in for NIL
    expect(evaluate([])).toEqual(null)
  })

  it('The number one evaluates to itself', () => {
    // Design: chose JS arrays to represent lists
    expect(evaluate([1])).toEqual(1)
  })
})
