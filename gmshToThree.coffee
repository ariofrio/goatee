module.exports = gmshToThree = (msh) ->
  three =
    metadata: formatVersion: 3
    vertices: []
    faces: []

    materials: []
    normals: []
    colors: []
    uvs: []
  
  lines = msh.split '\n'
  section = null
  countDone = no
  for line, i in lines
    if line.indexOf('$End') == 0
      unless line[4..] == section
        throw "end of section #{line[4..]}, but current section is #{section}"
      section = null
    else if line.indexOf('$') == 0
      if section?
        throw "starting section #{line[1..]}, but already in section #{section}"
      section = line[1..]
    else
      switch section
        when 'MeshFormat'
          unless line == '2.2 0 8'
            throw "unsupported mesh format '#{line}', expected '2.2 0 8'"
        else
          # FIXME: Verify support for Comment sections.
          if not countDone
            countDone = yes
          else
            switch section
              when 'Nodes'
                parts = line.split(' ')
                # By the way, the plus sign converts a string "12" into the
                # number 12.
                three.vertices.push +parts[1]
                three.vertices.push +parts[2]
                three.vertices.push +parts[3]
              when 'Elements'
                parts = line.split(' ')
                numberOfTags = +parts[2]
                switch +parts[1]
                  when 2 # triangle
                    three.faces.push 0
                    # <bai> andresj: sounds like your vertices are just in the
                    # wrong order. flip 'em and your faces will flip too. or if
                    # you have normals, those might be reversed too
                    three.faces.push +parts[numberOfTags + 5] - 1
                    three.faces.push +parts[numberOfTags + 4] - 1
                    three.faces.push +parts[numberOfTags + 3] - 1
                  when 3 # quadrangle
                    three.faces.push 1
                    three.faces.push +parts[numberOfTags + 6] - 1
                    three.faces.push +parts[numberOfTags + 5] - 1
                    three.faces.push +parts[numberOfTags + 4] - 1
                    three.faces.push +parts[numberOfTags + 3] - 1
                  else
                    # ignored, haha!

  three
