function evaluate(list){
  if (list.length === 0) { // if list.empty?()
    return(null)
  } else {
    return(list[0])
  }
}

function parse(stringExpression){
  return([])
}

export { evaluate, parse }
