var { evaluate, parse } = require('./minimalisp.js')

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

  describe('with a parser', () => {
    it('parses an empty string to the empty list', () => {
      expect(parse('')).toEqual([])
    })

    it('parses the string "7" to a list containing the number 7', () => {
      expect(parse('7')).toEqual([7])
    })

    it('parses the string "-1" to a list containing the number -1', () => {
      expect(parse('-1')).toEqual([-1])
    })

    it('parses the string "\"cat\"" to a list containing a string with the word cat', () => {
      expect(parse('"cat"')).toEqual(["cat"])
    })
    
    it('parses a string "(- 1)" into a list containing a symbol and the number one', () => {
      expect(parse('(- 1)')).toEqual(['-', 1])
    })

    it('parses a string "(- 2)" into a list containing a symbol and the number two', () => {
      expect(parse('(- 2)')).toEqual(['-', 2])
    }) 
  })
})
