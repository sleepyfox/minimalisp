var eval = (list) => {
  if (list.length === 0) { // if list.empty?()
    return(null)
  } else {
    return(1)
  }
}

describe('A LISP interpreter', () => {
  it('The number one evaluates to itself', () => {
    expect(eval([1])).toEqual(1)
  })

  it('an empty list evaluates to null', () => {
    // Design: chose null to stand in for NIL
    // Design: chose JS arrays to represent lists
    expect(eval([])).toEqual(null)
  })
})
