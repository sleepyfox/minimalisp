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
    sign = stringExpression[1]
    if(sign === '-') {
      return(['-', 1])
    } else {
      return([parseInt(stringExpression)])
    }
  }
}

module.exports = { evaluate, parse }
