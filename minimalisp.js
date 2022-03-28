function evaluate(list){
  if (list.length === 0) { // if list.empty?()
    return(null)
  } else {
    return(list[0])
  }
}

function parse(stringExpression){
  // let firstChar = Stringexpression.charCodeAt(0),
  //     type = determineType(firstChar);
      
  // switch (type) {
  // case 'string':
  // case 'number':
  // case 'expression':
  // }
  
  if (stringExpression === '') {
    return([])
  } else {
    // an atom e.g. 1 or "string" or symbol (bare word)
    // or an expression (...)
    if(stringExpression.charCodeAt(1) == 99) { // TODO: Start with factoring this out into a switch above
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
