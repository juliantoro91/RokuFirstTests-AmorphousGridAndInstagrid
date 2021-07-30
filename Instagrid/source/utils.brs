sub GetPosition(id as Integer, itemsInRow as Integer) as Object
    position=[]
    position.Push(id\itemsInRow)
    position.Push(id mod itemsInRow)
    return position
end sub

sub DecodePosition(id as Object, itemsInRow as Integer) as Integer
    return id[0]*itemsInRow + id[1]
end sub