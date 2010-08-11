module GraphFunctions

  def random_colour
    format( "%06X", rand(16777216))
  end

  def nilcomp(a,b)
    return 0 if (a.nil? && b.nil?)
    return -1 if (a.nil?)
    return 1 if (b.nil?)
    return a <=> b
  end

end