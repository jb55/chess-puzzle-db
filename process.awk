BEGIN {
  FS=""
  OFS="\t"
}

{
  if (/^[a-z]\)/) {
    state = "name"
    row[0] = ""
    row[1] = ""
    row[2] = ""
  } 
  else if (/^\[/) {
    state = "solution"
  }
  else if (state == "name") {
    if ($0 ~ /^([wW]hite|[bB]lack) [mM]ates [iI]n [0-9]+\.?[[:space:]]*$/) {
      row[0] = $0
      state = "name"
    }
    else if ($0 ~ /^([wW]hite|[bB]lack) [mM]ates [iI]n [0-9]+\.?.*/) {
      # this might have name at end
      ok = match($0, /^(([wW]hite|[bB]lack) [mM]ates [iI]n [0-9]+\.?)[[:space:]]*(.*)/, arr)
      if (ok == 0) {
        print "WAT:", $0
      }
      else if (arr[3] ~ /^[[:space:]]*$/) {
        state = "name"
        row[0] = arr[3]
      }
      else {
        row[0] = arr[1]
        row[1] = arr[3]
        state = "fen"
      }
    }
    else {
      row[1] = $0
      state = "fen"
    }
  }
  else if (state == "fen") {
    row[2] = $0
    state = "solution"
  } 
  else if (state == "solution") {
    match($0, /^[[:space:]]*1?\.*(.*)$/, sol)
    print row[0], row[1], row[2], sol[1]
    state = "none"
  }
}
