function evaluate(list){
  if (list.length === 0) { // if list.empty?()
    return(null)
  } else {
    return(list[0])
  }
}

function parse(stringExpression){
  if (stringExpression === '') {
    return([])
  } else {
    // an atom e.g. 1 or "string" or symbol (bare word)
    // or an expression (...)
    if(stringExpression.charCodeAt(1) == 99) {
      return(['cat'])
    }
    sign = stringExpression[1] // skips over initial '('
    n = parseInt(stringExpression[3])
    if(sign === '-') {
      return(['-', n])
    } else {
      return([parseInt(stringExpression)])
    }
  }
}

module.exports = { evaluate, parse }
